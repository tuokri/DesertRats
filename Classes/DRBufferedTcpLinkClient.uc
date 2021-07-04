class DRBufferedTcpLinkClient extends DRBufferedTcpLink;

var int Retries;
var bool bRetryOnClosed;

// Must store reference to "owner" in order to start
// Open() cancellation timer in case the Open() call fails.
// When Open() call fails, it will block and spam the log
// with errors. Timers in this class will also not work
// while the call to Open() is blocking.
var DRGameInfo OwnerGame;

final function ResolveServer()
{
    `log("resolving: " $ `BALANCE_STATS_HOST,, self.name);
    Resolve(`BALANCE_STATS_HOST);
}

event PostBeginPlay()
{
    super.PostBeginPlay();

    bRetryOnClosed = True;
    ResolveServer();
}

event Resolved(IpAddr Addr)
{
    local int BoundPort;

    `log(`BALANCE_STATS_HOST $ " resolved to " $ IpAddrToString(Addr),, self.name);
    Addr.Port = `BALANCE_STATS_PORT;

    BoundPort = BindPort();
    if (BoundPort == 0)
    {
        `log("failed to bind port",, self.name);
        Retry();
        return;
    }

    `log("bound to port: " $ BoundPort,, self.name);

    if (!Open(Addr))
    {
        `log("failed to open connection, retrying in 5 seconds",, self.name);
        Retry();
    }
}

event ResolveFailed()
{
    `log("unable to resolve, retrying in 5 seconds " $ `BALANCE_STATS_HOST,, self.name);
    Retry();
}

event Opened()
{
    `log("connection opened",, self.name);
    bAcceptNewData = True;
}

event Closed()
{
    if (bRetryOnClosed)
    {
        `log("connection closed unexpectedly, retrying in 5 seconds",, self.name);
        Retry();
    }
    else
    {
        `log("connection closed",, self.name);
        bAcceptNewData = False;
    }
}

function bool Close()
{
    bRetryOnClosed = False;
    return super.Close();
}

function bool SendBufferedData(string Text)
{
    Text $= LF;
    return super.SendBufferedData(Text);
}

function Tick(float DeltaTime)
{
    DoBufferQueueIO();
    super.Tick(DeltaTime);
}

final function Retry()
{
    if (Retries > `MAX_RESOLVE_RETRIES)
    {
        `log("max retries exceeded (" $ `MAX_RESOLVE_RETRIES $ ")",, self.name);
        Close();
        return;
    }
    Retries++;
    SetTimer(5.0, False, 'ResolveServer');
    OwnerGame.SetCancelOpenLinkTimer(7.0);
}

DefaultProperties
{
    TickGroup=TG_DuringAsyncWork
}
