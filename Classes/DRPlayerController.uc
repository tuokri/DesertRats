class DRPlayerController extends ROPlayerController
    config(Game_DesertRats_Client);

var bool RoundEnd;
var bool MatchEnd;
var bool Ducking;

var MusicTrackStruct PendingSong;

var AudioComponent StingerComp;

var(Sounds) SoundCue AxisWinTheme;
var(Sounds) SoundCue AlliesWinTheme;

var DRAudioManager AudioManager;


simulated event PreBeginPlay()
{
    super.PreBeginPlay();

    if (Role < ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
    {
        AudioManager = new(self) class'DRAudioManager';
        if (AudioManager != None)
        {
            AudioManager.InitSoundClassVolumes();
        }
        else
        {
            `warn("ERROR! Unable to create AudioManager!");
        }
    }
}

simulated event PostBeginPlay()
{
    local AudioDevice Audio;

    super(GamePlayerController).PostBeginPlay();

    if( WorldInfo.NetMode != NM_DedicatedServer )
    {
        BulletImpactDecalManager = Spawn(class'DecalManager', self,, vect(0,0,0), rot(0,0,0));
        BulletImpactDecalManager.MaxActiveDecals = MaxBulletImpactDecals;
    }

    Audio = class'Engine'.static.GetAudioDevice();

    if ( Audio != None )
    {
        Audio.InitSoundClassVolumes();
        MaxConcurrentHearSounds = Audio.MaxChannels * SoundChannelToHearSoundsRatio;

        if( MaxConcurrentHearSounds < 2 )
        {
            MaxConcurrentHearSounds = 1;
        }
        else if( MaxConcurrentHearSounds > Audio.MaxChannels)
        {
            MaxConcurrentHearSounds = Audio.MaxChannels + 1; // +1 for our music hax AudioComponent
        }
    }

    // We have no way to intercept changes in ROUISceneSettings, so we have to just keep checking
    SetTimer(1.0, true, 'CheckForVolumeChanges');

    SetTimer(120.0, false, 'StartMusicFix');

    if ( OutsideMapWithSteam() )
    {
        CheckWorkshopSubscriptions();
    }

    if( Role < ROLE_Authority )
        ServerUpdatePlayerFOV(PlayerFOV, MyHud.SizeX, MyHud.SizeY);
}

function StartMusicFix()
{
    // Sometimes the music just cuts off entirely for an unknown reason.
    // Clients can restart it with the RestartMusic command, but
    // since people won't know how to do that, let's just try this.

    SetTimer(30.0, true, 'RestartMusic');
}

function float UserVolumeSetting()
{
    local AudioDevice Audio;
    Audio = class'Engine'.static.GetAudioDevice();

    if (Audio == none)
    {
        return 0.2;
    }

    return Audio.AkMusicVolume;
}

function CheckForVolumeChanges()
{
    if (WorldInfo.MusicComp != none)
    {
        // Don't change the volume if it's currently ducked
        if (WorldInfo.MusicComp.VolumeMultiplier != UserVolumeSetting() && !Ducking)
        {
            `dr("Volume does not match user settings, updating now",'M');

            // If the VolumeMultiplier is 0 we have to call PlayMusic so it can do FadeIn
            if (WorldInfo.MusicComp.VolumeMultiplier <= 0)
            {
                WorldInfo.CurrentMusicTrack.FadeInVolumeLevel = UserVolumeSetting();
                PlayMusic();
            }

            WorldInfo.MusicComp.VolumeMultiplier = UserVolumeSetting();
        }
    }

    if (StingerComp != none)
    {
        StingerComp.VolumeMultiplier = UserVolumeSetting();
    }
}

function DelayClearMusicComp()
{
    WorldInfo.MusicComp = none;
}

function UpdateCurrentMoraleMusicTrack()
{
    `dr("",'M');

    if (WorldInfo.MusicComp != none)
    {
        UpdateMoraleMusicTrack(WorldInfo.CurrentMusicTrack);
    }
}

function UpdateMoraleMusicTrack(MusicTrackStruct NewMusicTrack)
{
    local AudioComponent AC;

    if (MatchEnd)
    {
        `dr("Match over, clearing",'M');
        Ducking = true;
        WorldInfo.MusicComp.FadeOut(0.9, 0.0);
        SetTimer(1.0, false, 'DelayClearMusicComp');
        return;
    }

    `dr(""$ NewMusicTrack.TheSoundCue,'M');

    if (WorldInfo.MusicComp == none)
    {
        AC = GetPooledAudioComponent(NewMusicTrack.TheSoundCue, none, false, false);

        AC.bIsMusic = true;
        AC.bUseOwnerLocation = true;
        AC.PitchMultiplier = 1.0;
        AC.VolumeMultiplier = 1.0;
        AC.bWasOccluded = false;
        AC.OcclusionCheckInterval = 0.f;

        WorldInfo.MusicComp = AC;
    }
    // This is run AFTER we close the Round End screen and about to spawn in a new round
    else if (RoundEnd)
    {
        `dr("Round over, restarting",'M');

        // We don't need this atm since the round winning MoraleTransitionUp cue stops the background music
        // WorldInfo.MusicComp.FadeOut(0.9, 0.0);
        // SetTimer(1.0, false, 'DelayClearMusicComp');
    }
    else
    {
        Ducking = true;
        WorldInfo.MusicComp.FadeOut(0.9, 0.0);
    }

    RoundEnd = false;

    if (WorldInfo.CurrentMusicTrack != NewMusicTrack)
    {
        `dr("Setting new track",'M');
        WorldInfo.CurrentMusicTrack = NewMusicTrack;
    }

    SetTimer(1.0, false, 'PlayMusic');
}

function PlayMusic()
{
    `dr("",'M');

    Ducking = false;
    WorldInfo.MusicComp.VolumeMultiplier = UserVolumeSetting();
    WorldInfo.MusicComp.SoundCue = WorldInfo.CurrentMusicTrack.TheSoundCue;
    WorldInfo.MusicComp.FadeIn(0.0, WorldInfo.CurrentMusicTrack.FadeInVolumeLevel);
}

function PlayStinger(SoundCue StingerCue)
{
    `dr("",'M');

    StingerComp.VolumeMultiplier = UserVolumeSetting();
    StingerComp.SoundCue = StingerCue;
    StingerComp.Play();
}

// If for some reason the music bugs out the client can restart it with this command
exec function RestartMusic()
{
    if (WorldInfo.MusicComp == none || Ducking || RoundEnd || MatchEnd || UserVolumeSetting() < 0.01)
    {
        `dr("Not Running",'M');
        return;
    }

    if (WorldInfo.MusicComp.SoundCue == none || WorldInfo.MusicComp.VolumeMultiplier < UserVolumeSetting())
    {
        `dr("Performing Music Fix",'M');

        WorldInfo.MusicComp.VolumeMultiplier = UserVolumeSetting();
        WorldInfo.MusicComp.SoundCue = WorldInfo.CurrentMusicTrack.TheSoundCue;
        WorldInfo.MusicComp.FadeIn(0.0, WorldInfo.CurrentMusicTrack.FadeInVolumeLevel);
    }
    else
    {
        `dr("Not Performing",'M');
    }
}

reliable client function MatchWon(byte WinningTeam, byte WinCondition, optional bool bUseCapturesForTieBreaking, optional int NorthTeamPointsTotal, optional int SouthTeamPointsTotal,
                                optional int NorthRemainingReinforcements, optional int SouthRemainingReinforcements, optional int NorthTotalObjectivesCaptured,
                                optional int SouthTotalObjectivesCaptured, optional int RoundTime, optional int NorthFastestWinTime, optional int SouthFastestWinTime,
                                optional float NorthRoundScore, optional float SouthRoundScore, optional int NorthTotalTime, optional int SouthTotalTime,
                                optional byte NorthReachedObjectiveIndex, optional byte SouthReachedObjectiveIndex, optional int NorthEnemiesKilled,
                                optional int SouthEnemiesKilled, optional int NorthEnemiesRemaining, optional int SouthEnemiesRemaining, optional float RoundToMatchWinDelay,
                                optional float FadeOutDuration)
{
    if (WorldInfo.NetMode == NM_DedicatedServer)
    {
        return;
    }

    if (RoundToMatchWinDelay == 0.f)
    {
        MatchEnd = true;
        UpdateCurrentMoraleMusicTrack();

        if (WinningTeam == `AXIS_TEAM_INDEX)
        {
            PlayStinger(AxisWinTheme);
        }
        else if (WinningTeam == `ALLIES_TEAM_INDEX)
        {
            PlayStinger(AlliesWinTheme);
        }

        ShowMatchWinScreen(WinningTeam, WinCondition, bUseCapturesForTieBreaking, NorthTeamPointsTotal, SouthTeamPointsTotal, NorthRemainingReinforcements,
                            SouthRemainingReinforcements, NorthTotalObjectivesCaptured, SouthTotalObjectivesCaptured, RoundTime,
                            NorthFastestWinTime, SouthFastestWinTime, NorthRoundScore, SouthRoundScore, NorthTotalTime,
                            SouthTotalTime, NorthReachedObjectiveIndex, SouthReachedObjectiveIndex, NorthEnemiesKilled,
                            SouthEnemiesKilled, NorthEnemiesRemaining, SouthEnemiesRemaining );
    }
    else
    {
        if (FadeOutDuration > 0)
        {
            StartRoundPreEndEffects(FadeOutDuration, RoundToMatchWinDelay);
        }
        else
        {
            SetTimer(RoundToMatchWinDelay, false, 'DelayedMatchWon');
        }

        StoredMatchWinInfo.WinningTeam = WinningTeam;
        StoredMatchWinInfo.WinCondition = WinCondition;
        StoredMatchWinInfo.bUseCapturesForTieBreaking = bUseCapturesForTieBreaking;
        StoredMatchWinInfo.NorthTeamPointsTotal = NorthTeamPointsTotal;
        StoredMatchWinInfo.SouthTeamPointsTotal = SouthTeamPointsTotal;
        StoredMatchWinInfo.NorthRemainingReinforcements = NorthRemainingReinforcements;
        StoredMatchWinInfo.SouthRemainingReinforcements = SouthRemainingReinforcements;
        StoredMatchWinInfo.NorthTotalObjectivesCaptured = NorthTotalObjectivesCaptured;
        StoredMatchWinInfo.SouthTotalObjectivesCaptured = SouthTotalObjectivesCaptured;
        StoredMatchWinInfo.RoundTime = RoundTime;
        StoredMatchWinInfo.NorthFastestWinTime = NorthFastestWinTime;
        StoredMatchWinInfo.SouthFastestWinTime = SouthFastestWinTime;
        StoredMatchWinInfo.NorthRoundScore = NorthRoundScore;
        StoredMatchWinInfo.SouthRoundScore = SouthRoundScore;
        StoredMatchWinInfo.NorthTotalTime = NorthTotalTime;
        StoredMatchWinInfo.SouthTotalTime = SouthTotalTime;
        StoredMatchWinInfo.NorthReachedObjectiveIndex = NorthReachedObjectiveIndex;
        StoredMatchWinInfo.SouthReachedObjectiveIndex = SouthReachedObjectiveIndex;
        StoredMatchWinInfo.NorthEnemiesKilled = NorthEnemiesKilled;
        StoredMatchWinInfo.SouthEnemiesKilled = SouthEnemiesKilled;
        StoredMatchWinInfo.NorthEnemiesRemaining = NorthEnemiesRemaining;
        StoredMatchWinInfo.SouthEnemiesRemaining= SouthEnemiesRemaining;
    }
}

function DelayedMatchWon()
{
    MatchEnd = true;
    UpdateCurrentMoraleMusicTrack();

    if (CurrentAfterActionReportScene != none)
    {
        LocalPlayer(Player).ViewportClient.UIController.SceneClient.CloseScene(CurrentAfterActionReportScene);
        CurrentAfterActionReportScene = none;
    }

    if (StoredMatchWinInfo.WinningTeam == `AXIS_TEAM_INDEX)
    {
        PlayStinger(AxisWinTheme);
        SetTimer(AxisWinTheme.GetCueDuration(),, 'ClearWaitingForVictoryMusicToEnd');
    }
    else if (StoredMatchWinInfo.WinningTeam == `ALLIES_TEAM_INDEX)
    {
        PlayStinger(AlliesWinTheme);
        SetTimer(AlliesWinTheme.GetCueDuration(),, 'ClearWaitingForVictoryMusicToEnd');
    }

    ShowMatchWinScreen(StoredMatchWinInfo.WinningTeam, StoredMatchWinInfo.WinCondition, StoredMatchWinInfo.bUseCapturesForTieBreaking,
                        StoredMatchWinInfo.NorthTeamPointsTotal, StoredMatchWinInfo.SouthTeamPointsTotal, StoredMatchWinInfo.NorthRemainingReinforcements,
                        StoredMatchWinInfo.SouthRemainingReinforcements, StoredMatchWinInfo.NorthTotalObjectivesCaptured,
                        StoredMatchWinInfo.SouthTotalObjectivesCaptured, StoredMatchWinInfo.RoundTime, StoredMatchWinInfo.NorthFastestWinTime,
                        StoredMatchWinInfo.SouthFastestWinTime, StoredMatchWinInfo.NorthRoundScore, StoredMatchWinInfo.SouthRoundScore,
                        StoredMatchWinInfo.NorthTotalTime, StoredMatchWinInfo.SouthTotalTime, StoredMatchWinInfo.NorthReachedObjectiveIndex,
                        StoredMatchWinInfo.SouthReachedObjectiveIndex, StoredMatchWinInfo.NorthEnemiesKilled, StoredMatchWinInfo.SouthEnemiesKilled,
                        StoredMatchWinInfo.NorthEnemiesRemaining, StoredMatchWinInfo.SouthEnemiesRemaining );
}

reliable client function ClientCloseTeamWinScreen()
{
    `dr("",'M');

    super.ClientCloseTeamWinScreen();

    RoundEnd = true;
}

reliable client function SetNewMoraleMusicTrack(MusicTrackStruct NewMusicTrack, optional float WaitTime)
{
    NewMusicTrack.FadeInVolumeLevel = UserVolumeSetting();

    UpdateMoraleMusicTrack(NewMusicTrack);
}

simulated function UpdateMusicVolume(float NewVolume, optional float TransitionTime)
{
    if (WorldInfo.MusicComp != none && WorldInfo.CurrentMusicTrack.TheSoundCue != none)
    {
        if (TransitionTime <= 0)
        {
            TransitionTime = 0.001;
        }

        `dr("Adjusting volume to" @ NewVolume,'M');

        WorldInfo.MusicComp.AdjustVolume(TransitionTime, NewVolume);
    }
}

reliable client function DuckMoraleMusic(float StartDuckFadeLength, float DuckVolumeModifier, float DuckDuration)
{
    local float UsedDuration, MusicVolume;

    `dr("",'M');

    Ducking = true;

    UsedDuration = FMax(DuckDuration /*(DuckDuration - 0.5)*/, 0.01);

    MusicVolume = UserVolumeSetting() * DuckVolumeModifier;

    UpdateMusicVolume(MusicVolume, StartDuckFadeLength);

    ClearTimer('ClearMoraleMusicDuck');

    SetTimer(UsedDuration, false, 'ClearMoraleMusicDuck');
}

simulated function ClearMoraleMusicDuck()
{
    `dr("",'M');

    Ducking = false;

    UpdateMusicVolume(UserVolumeSetting(), 0.5);
}
/*
function HitThisCommon(ROTriggerRadio ROTR, optional ROVehicle ROV = none, optional int SeatIndex = -1)
{
    local ROGameReplicationInfo ROGRI;
    local int PawnTeam, SupportToRequest;
    local float RadioDelay;
    local bool bIsVehicle, bSpotBecameInvalid;
    local ROTeamInfo ROTI;
    local Actor ActualTalker;
    local ROPlayerReplicationInfo ROPRIForBroadcast;

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);

    bIsVehicle = ROV != none;
    PawnTeam = Pawn.GetTeamNum();
    SupportToRequest = SavedArtyType;

    ActualTalker = (bIsVehicle) ? ROV : ROTR;
    ROPRIForBroadcast = (ROTR != none) ? ROPlayerReplicationInfo(PlayerReplicationInfo) : none;

    RadioDelay = 10.0;

    if ( WorldInfo != none && WorldInfo.GRI != none && ROTeamInfo(WorldInfo.GRI.Teams[PawnTeam]) != none && ROTeamInfo(WorldInfo.GRI.Teams[PawnTeam]).SavedArtilleryCoords == vect(-999999.0,-999999.0,-999999.0) )
    {
        bSpotBecameInvalid = true;
    }
    `drtrace;

    if ( ROGRI.bArtilleryAvailable[PawnTeam] == 1 && !bSpotBecameInvalid )
    {
        if (SupportToRequest == 2)
        {
            ROGameInfo(WorldInfo.Game).BroadcastLocalizedVoiceCom(`VOICECOM_Ability3Confirm, Pawn, SeatIndex, ActualTalker, ROPRIForBroadcast, true, PawnTeam);

            SetTimer(10, false, 'ServerBombingRun');
            ReceiveLocalizedMessage(class'ROLocalMessageAirSupport', ROMSG_BomberConfirmed,,, self);
        }
        else if (SupportToRequest == 1)
        {
            ReceiveLocalizedMessage(class'ROLocalMessageArtillery', 3,,, self);
            ROGameInfo(WorldInfo.Game).BroadcastLocalizedVoiceCom(`VOICECOM_Ability2Confirm, Pawn, SeatIndex, ActualTalker, ROPRIForBroadcast, true, PawnTeam);
            SetTimer(8, false, 'ServerArtyStrike');
        }
        else
        {
            ReceiveLocalizedMessage(class'ROLocalMessageArtillery', 3,,, self);
            ROGameInfo(WorldInfo.Game).BroadcastLocalizedVoiceCom(`VOICECOM_Ability1Confirm, Pawn, SeatIndex, ActualTalker, ROPRIForBroadcast, true, PawnTeam);
            SetTimer(8, false, 'ServerArtyStrike');
        }

        SetTimer(10, false, 'ResetCommanderMadeRequest');
        DelayedClearRadioCallin(RadioDelay);
    }
    else
    {
        ClientSetArtyMarkStatusBits(0);

        ROTI = ROTeamInfo(PlayerReplicationInfo.Team);

        if ( ROTI != none )
        {
            ROTI.SetCommanderHasMadeRequest(false);
        }

        DelayedClearRadioCallin(8.5);

        if ( ROGRI.TotalStrikes[PawnTeam] >= ROGRI.ArtilleryStrikeLimit[PawnTeam] )
        {
            ReceiveLocalizedMessage(class'ROLocalMessageArtillery', ROAMSG_OutOfStrikes,,,ROV);
        }
        else
        {
            if( SupportToRequest == 2 )
            {
                ReceiveLocalizedMessage(class'ROLocalMessageAirSupport', ROMSG_BomberDenied,,,ROV);
            }
            else
            {
                ReceiveLocalizedMessage(class'ROLocalMessageArtillery', ROAMSG_StrikeDenied,,,ROV);
            }
        }
    }

    SetTimer(35, false, 'ResetArtyMarkStatusBitTimerDelegate');
}

simulated function AttemptRequestAerialRecon(optional ROTriggerRadio RadioUsed)
{
    `dr("",'CMDA');

    if (Pawn == none || ROMapInfo(WorldInfo.GetMapInfo()) == none)
    {
        return;
    }

    if( ROPlayerReplicationInfo(PlayerReplicationInfo) == none || ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none || !ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.bIsTeamLeader )
    {
        return;
    }

    bRadioCallinProgress = true;

    ServerRequestAerialRecon(RadioUsed);
}

reliable protected server function ServerRequestAerialRecon(optional ROTriggerRadio RadioUsed)
{
    local ROTeamInfo ROTI;
    local int Team;

    if( Pawn == none )
    {
        ClientClearRadioCallin();
        return;
    }

    Team = GetTeamNum();

    switch ( Team )
    {
        case `AXIS_TEAM_INDEX:
            ROTI = ROTeamInfo(WorldInfo.GRI.Teams[`AXIS_TEAM_INDEX]);
            break;

        case `ALLIES_TEAM_INDEX:
            ROTI = ROTeamInfo(WorldInfo.GRI.Teams[`ALLIES_TEAM_INDEX]);
            break;

        default:
            ClientClearRadioCallin();
            return;
    }

    if( RadioUsed == none || VSizeSq(Pawn.Location - RadioUsed.Location) > 10000 )
    {
        ClientClearRadioCallin();
        return;
    }

    AerialReconRadio = RadioUsed;

    if( ROVehicleBase(Pawn) != none )
    {
        ROGameInfo(WorldInfo.Game).BroadcastLocalizedVoiceCom(`VOICECOM_CallForReconPlane, Pawn, , , , true, Team, ROPlayerReplicationInfo(PlayerReplicationInfo).SquadIndex);
    }
    else
    {
        ROGameInfo(WorldInfo.Game).HandleBattleChatterEvent(Pawn, `BATTLECHATTER_CallForReconPlane);
    }

    if(ROPlayerReplicationInfo(PlayerReplicationInfo) == none
        || ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none
        || !ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.bIsTeamLeader
        || ROTI == none
        || ROTI.NextAerialReconTime < WorldInfo.GRI.RemainingTime)
    {
        SetTimer(9.0f, false, 'ReconPlaneDenied');
        return;
    }
    else
    {
        SetTimer(9.0f, false, 'ReconPlaneOnTheWay');
    }

    NotifyCommanderAbilityRequested(3, 9.f);
}

function SpawnAerialRecon()
{
    local Sequence GameSeq;
    local array<SequenceObject> AerialReconSeqEvents;
    local Actor AerialReconBaseActor;
    local int Team, i;
    local float ReconDuration;
    local ROTeamInfo ROTI;

    Team = GetTeamNum();

    if( Team > `ALLIES_TEAM_INDEX )
        return;

    ROTI = ROTeamInfo(WorldInfo.GRI.Teams[Team]);

    GameSeq = WorldInfo.GetGameSequence();
    if ( GameSeq != none )
    {
        GameSeq.FindSeqObjectsByClass(class'ROSeqEvent_AerialRecon', true, AerialReconSeqEvents);

        for (i = 0; i < AerialReconSeqEvents.Length; i++)
        {
            AerialReconBaseActor = ROSeqEvent_AerialRecon(AerialReconSeqEvents[i]).TriggerRecon(Team, false, ReconDuration);

            if (AerialReconBaseActor != none)
            {
                if (DRGameInfoTerritories(WorldInfo.Game) != none)
                {
                    DRGameInfoTerritories(WorldInfo.Game).SpawnAerialReconPlane(AerialReconBaseActor, ReconDuration, self);
                }
                else
                {
                    AerialReconBaseActor = none;
                }

                break;
            }
        }
    }

    if( AerialReconBaseActor == none )
    {
        ROTI.NextAerialReconTime = WorldInfo.GRI.RemainingTime;
    }

    BroadcastLocalizedTeamMessage(GetTeamNum(), class'ROLocalMessageGameRedAlert', RORAMSG_ReconEnRoute);
}

simulated function AttemptRequestArtillery(ROTriggerRadio RadioUsed, byte ArtyType)
{
    local ROPlayerReplicationInfo ROPRI;
    ROPRI = ROPlayerReplicationInfo(PlayerReplicationInfo);

    if ( ROPRI == none || ROPRI.RoleInfo == none || !ROPRI.RoleInfo.bIsTeamLeader )
    {
        return;
    }

    bRadioCallinProgress = true;

    SavedArtyType = ArtyType;

    `dr("ArtyType" @ ArtyType,'CMDA');

    ServerRequestArtillery(RadioUsed, ArtyType);
}

reliable protected server function ServerRequestArtillery(ROTriggerRadio RadioUsed, byte ArtyType)
{
    local ROPlayerReplicationInfo ROPRI;
    local ROTeamInfo ROTI;

    ROPRI = ROPlayerReplicationInfo(PlayerReplicationInfo);

    if ( ROPRI == none || ROPRI.RoleInfo == none || !ROPRI.RoleInfo.bIsTeamLeader )
    {
        ClientClearRadioCallin();
        return;
    }

    ROTI = ROTeamInfo(PlayerReplicationInfo.Team);

    if ( ROTI != none )
    {
        ROTI.SetCommanderHasMadeRequest(true);
        SetSpotterIndexByDamageType(ArtyType, ROTI.SelectedArtyIndex);
    }

    SavedArtyType = ArtyType;

    if ( RadioUsed != none )
    {
        RadioUsed.RequestArty(Pawn, ArtyType);
    }
    else if ( ROPRI.RoleInfo.bCanBeTankCrew )
    {
        VehicleRequestArty();
    }
}

reliable protected server function ServerArtyStrike()
{
    local ROGameReplicationInfo ROGRI;
    local vector SpawnLocation, MyGravity;
    local ROArtillerySpawner Spawner;
    local PlayerController C;
    local ROTeamInfo ROTI;
    local int CachedArtyTime;
    local int TeamNum;

    `dr("",'CMDA');

    if (ROPlayerReplicationInfo(PlayerReplicationInfo) == none || ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none || Pawn == none )
    {
        return;
    }

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);
    ROTI = ROTeamInfo(PlayerReplicationInfo.Team);

    TeamNum = GetTeamNum();

    MyGravity.X = 0.0;
    MyGravity.Y = 0.0;
    MyGravity.Z = PhysicsVolume.GetGravityZ();

    if (SavedArtyType < 1)
    {
        CachedArtyTime = ROGRI.NextAbilityOneTime[TeamNum];
        ROGRI.NextAbilityOneTime[TeamNum] = WorldInfo.GRI.RemainingTime - GetNextAbilityDelay(1);
    }
    else
    {
        CachedArtyTime = ROGRI.NextAbilityTwoTime[TeamNum];
        ROGRI.NextAbilityTwoTime[TeamNum] = WorldInfo.GRI.RemainingTime - GetNextAbilityDelay(2);
    }

    ROGRI.bArtilleryAvailable[TeamNum] = 0;
    ROGRI.TotalStrikes[TeamNum]++;

    if (ROTI != none)
    {
        ROTI.ArtyStrikeLocation = ROTI.SavedArtilleryCoords;
    }

    SpawnLocation = ROTI.SavedArtilleryCoords;
    SpawnLocation.Z = ROGameReplicationInfo(WorldInfo.GRI).ArtySpawn.Z;

    Spawner = Spawn(class'WWArtillerySpawner',self,, SpawnLocation, rotator(MyGravity));

    if (Spawner != none)
    {
        Spawner.OriginalArtyLocation = ROTI.SavedArtilleryCoords;
        Spawner.CachedArtyTime = CachedArtyTime;
        Spawner.SpawnTeam = TeamNum;
    }

    `dr("Created" @ Spawner, 'CMDA');

    foreach WorldInfo.AllControllers(class'PlayerController', C)
    {
        if (C != none && C.GetTeamNum() == TeamNum )
        {
            C.ReceiveLocalizedMessage(class'ROLocalMessageGameRedAlert', RORAMSG_ArtilleryStrike);
        }
    }
}

reliable protected server function ServerBombingRun()
{
    local ROGameReplicationInfo ROGRI;
    local vector TargetLocation, SpawnLocation;
    local vector2D StrikeDirection;
    local ROCarpetBomberAircraft Aircraft;
    local PlayerController C;
    local ROTeamInfo ROTI;
    local int SpawnedCnt;

    `dr("",'CMDA');

    if (ROPlayerReplicationInfo(PlayerReplicationInfo) == none || ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none || Pawn == none)
    {
        return;
    }

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);
    ROTI = ROTeamInfo(PlayerReplicationInfo.Team);

    ROGRI.NextAbilityThreeTime[GetTeamNum()] = WorldInfo.GRI.RemainingTime - GetNextAbilityDelay(3);
    ROGRI.bArtilleryAvailable[GetTeamNum()] = 0;
    ROGRI.TotalStrikes[GetTeamNum()]++;

    if ( ROTI != none )
    {
        ROTI.ArtyStrikeLocation = ROTI.SavedArtilleryCoords;
        ROTI.StrikeDirection = ROTI.SavedStrikeDirection;

        TargetLocation = ROTI.SavedArtilleryCoords;
        StrikeDirection = ROTI.SavedStrikeDirection;
    }

    // SpawnLocation = GetBestAircraftSpawnLoc(TargetLocation, WWMapInfo(WorldInfo.GetMapInfo()).SovietBomberHeightOffset, class'WWCarpetBomberAircraft', StrikeDirection);

    TargetLocation.Z = SpawnLocation.Z;
    if( ROTI.StrikeDirection == vect2D(0,0) )
        ROTI.StrikeDirection = StrikeDirection;

    Aircraft = Spawn(class'WWCarpetBomberAircraft',self,, SpawnLocation, rotator(TargetLocation - SpawnLocation));

    if ( Aircraft == none )
    {
        return;
    }
    else
    {
        Aircraft.TargetLocation = ROTI.ArtyStrikeLocation;
        Aircraft.SetDropPoint();
        Aircraft.SetOffset(1);
        SpawnedCnt++;
    }

    Aircraft = Spawn(class'WWCarpetBomberAircraft',self,, SpawnLocation, rotator(TargetLocation - SpawnLocation));

    if ( Aircraft == none )
    {
        return;
    }
    else
    {
        Aircraft.TargetLocation = ROTI.ArtyStrikeLocation;
        Aircraft.InboundDelay += 1;
        Aircraft.SetDropPoint();
        Aircraft.SetOffset(2);
        SpawnedCnt++;
    }

    if( SpawnedCnt == 0 )
        return;

    foreach WorldInfo.AllControllers(class'PlayerController', C)
    {
        if (C != none && C.GetTeamNum() == GetTeamNum())
        {
            C.ReceiveLocalizedMessage(class'ROLocalMessageGameRedAlert', RORAMSG_BombingRun);
        }
    }
}

simulated function AttemptRequestAntiAir(ROTriggerRadio RadioUsed)
{
    if (Pawn == none || ROMapInfo(WorldInfo.GetMapInfo()) == none)
    {
        return;
    }

    if (ROPlayerReplicationInfo(PlayerReplicationInfo) == none || ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none || !ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.bIsTeamLeader)
    {
        return;
    }

    `dr("",'CMDA');

    bRadioCallinProgress = true;

    ServerRequestAntiAirNew(RadioUsed);
}

reliable server function ServerRequestAntiAirNew(ROTriggerRadio RadioUsed)
{
    if (RadioUsed != none)
    {
        RadioUsed.RequestAntiAir(Pawn);
    }
}

function HandleRequestAntiAir(ROTriggerRadio ROTR)
{
    local ROGameReplicationInfo ROGRI;
    local int TimeTilNextUse;
    local int PawnTeam;

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);
    PawnTeam = Pawn.GetTeamNum();

    if (ROGRI.bAntiAirAvailable[PawnTeam] == 1)
    {
        DelayedClearRadioCallin(12.5);

        ReceiveLocalizedMessage(class'ROLocalMessageAirSupport', ROMSG_AntiAirConfirmed,,, self);
        ROGameInfo(WorldInfo.Game).BroadcastLocalizedVoiceCom(`VOICECOM_Ability3Confirm, Pawn, , ROTR, , true, PawnTeam);

        ServerEnableAntiAir();
    }
    else
    {
        TimeTilNextUse = ROGRI.RemainingTime - ROGRI.NextAbilityThreeTime[PawnTeam];

        DelayedClearRadioCallin(10.0);

        if ( TimeTilNextUse >= 20 )
        {
            ReceiveLocalizedMessage(class'ROLocalMessageAirSupport', ROMSG_AntiAirTryLater,,,ROTR);
        }
        else if ( TimeTilNextUse >= 0 )
        {
            ReceiveLocalizedMessage(class'ROLocalMessageAirSupport', ROMSG_AntiAirTrySoon,,,ROTR);
        }
        else
        {
            ReceiveLocalizedMessage(class'ROLocalMessageAirSupport', ROMSG_AntiAirDenied,,,ROTR);
        }
    }
}

reliable protected server function ServerEnableAntiAir()
{
    local ROGameReplicationInfo ROGRI;
    local PlayerController C;

    if (ROPlayerReplicationInfo(PlayerReplicationInfo) == none || ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none || Pawn == none)
    {
        return;
    }

    `dr("",'CMDA');

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);
    ROGRI.NextAbilityThreeTime[GetTeamNum()] = WorldInfo.GRI.RemainingTime - GetNextAbilityDelay(3);
    ROGRI.bAntiAirAvailable[GetTeamNum()] = 0;

    // Spawn(class'WWFighterPlaneManager', self,, GetSAMSpawnLoc());

    foreach WorldInfo.AllControllers(class'PlayerController', C)
    {
        if (C != none && C.GetTeamNum() == GetTeamNum())
        {
            C.ReceiveLocalizedMessage(class'ROLocalMessageGameRedAlert', RORAMSG_SAMStrike);
        }
    }
}
*/
function CheckPickup(out ROPawn P, out ROWeapon SwapWeapon, class<Inventory> ItemClass)
{
    `drtrace;
    /*
    local int IsAmmoPickup;

    if ( ROInventoryManager(P.InvManager).IsPickupCausingWeaponSwap(ItemClass, ActorAimedAt, SwapWeapon, IsAmmoPickup) )
    {
        if( P.InvManager.PendingWeapon != SwapWeapon )
        {
            ReceiveLocalizedMessage(class'DRLocalMessageGamePickup', ItemClass.default.InvIndex + class'DRLocalMessageGamePickup'.const.ROMSG_PickupSwap,PlayerReplicationInfo,,SwapWeapon);
        }
    }
    else
    {
        if ( IsAmmoPickup < 1 )
        {
            if( ROInventoryManager(P.InvManager).HandlePickupQuery(ItemClass, SwapWeapon, true) )
                ReceiveLocalizedMessage(class'WWLocalMessageGamePickup', ItemClass.default.InvIndex,PlayerReplicationInfo);
        }
        else
        {
            ReceiveLocalizedMessage(class'DRLocalMessageGamePickup', ItemClass.default.InvIndex + class'DRLocalMessageGamePickup'.const.ROMSG_PickupAmmo, PlayerReplicationInfo);
        }
    }
    */
}

function UsePickup(class<Inventory> ItemClass)
{
    local Inventory Inv;
    local bool bWasAmmo;
    local int DesiredClips, NewClips;
    local EROInventoryCategory AmmoCategory;

    for ( Inv = ROInventoryManager(Pawn.InvManager).InventoryChain; Inv != None; Inv = Inv.Inventory )
    {
        if ( ROWeapon(Inv) != None && class<ROWeapon>(ItemClass) != none && ROWeapon(Inv).InvIndex == ItemClass.default.InvIndex )
        {
            if (RODroppedPickup(ActorAimedAt) != none)
            {
                if( class<ROWeapon>(ItemClass).default.WeaponClassType == ROWCT_Melee )
                {
                    break;
                }

                if(ROWeapon(Inv).Category == ROIC_Grenade)
                {
                    AmmoCategory = ROIC_Grenade;
                }
                else
                {
                    AmmoCategory = ROIC_Ammo;
                }

                DesiredClips = ROWeapon(RODroppedPickup(ActorAimedAt).Inventory).GetTotalAmmoCount() / ROWeapon(Inv).default.MaxAmmoCount;
                NewClips = Min((ROInventoryManager(Pawn.InvManager).CategoryLimits[AmmoCategory] - ROInventoryManager(Pawn.InvManager).CategoryCounts[AmmoCategory]) * ROWeapon(Inv).AmmoClass.default.ClipsPerSlot, DesiredClips);
                NewClips = Min(NewClips, ROWeapon(Inv).MaxNumPrimaryMags - ROWeapon(Inv).AmmoArray.length);

                if( NewClips <= 0)
                {
                    `drtrace;
                    // ReceiveLocalizedMessage(class'DRLocalMessageGamePickup', class'DRLocalMessageGamePickup'.const.ROMSG_PickupAmmoFail + ItemClass.default.InvIndex);
                    SetTimer(0.5, false, 'FindActorAimedAt');
                    bWasAmmo = true;
                    break;
                }

                ROWeapon(Inv).GiveClips(NewClips);
                RODroppedPickup(ActorAimedAt).PickedUpBy(Pawn);
            }
            else if (ROPickupFactory(ActorAimedAt) != none)
            {
                if(!ROPickupFactory(ActorAimedAt).CanBeUsed(Pawn))
                {
                    break;
                }

                DesiredClips = (ROWeapon(Inv).default.MaxAmmoCount * ROWeapon(Inv).default.InitialNumPrimaryMags) / ROWeapon(Inv).default.MaxAmmoCount;
                NewClips = Min((ROInventoryManager(Pawn.InvManager).CategoryLimits[AmmoCategory] - ROInventoryManager(Pawn.InvManager).CategoryCounts[AmmoCategory]) * ROWeapon(Inv).AmmoClass.default.ClipsPerSlot, DesiredClips);

                if( NewClips <= 0)
                {
                    `drtrace;
                    // ReceiveLocalizedMessage(class'DRLocalMessageGamePickup', class'DRLocalMessageGamePickup'.const.ROMSG_PickupAmmoFail + ItemClass.default.InvIndex);
                    SetTimer(0.5, false, 'FindActorAimedAt');
                    bWasAmmo = true;
                    break;
                }

                ROWeapon(Inv).RefillAmmo();
                ROPickupFactory(ActorAimedAt).PickedUpBy(Pawn);
            }
            `drtrace;
            // ReceiveLocalizedMessage(class'WWLocalMessageGamePickup', class'WWLocalMessageGamePickup'.const.ROMSG_PickedupAmmo + ItemClass.default.InvIndex);
            bWasAmmo = true;
            break;
        }
    }
    if ( Pawn.bCanPickupInventory && WorldInfo.Game.PickupQuery(Pawn, ItemClass, ActorAimedAt) )
    {
        if ( !bWasAmmo )
        {
            if (RODroppedPickup(ActorAimedAt) != none)
            {
                if( class<ROWeapon>(ItemClass).default.WeaponClassType == ROWCT_Melee )
                {
                    ROPawn(Pawn).TossWeapon(ROWeapon(Inv));
                }
                RODroppedPickup(ActorAimedAt).GiveTo(Pawn);
                `drtrace;
                // ReceiveLocalizedMessage(class'WWLocalMessageGamePickup', class'WWLocalMessageGamePickup'.const.ROMSG_Pickedup + ItemClass.default.InvIndex);
            }
            else if (ROPickupFactory(ActorAimedAt) != none && ROPickupFactory(ActorAimedAt).CanBeUsed(Pawn)) // Fix CLBIT-102 - Nate.
            {
                ROPickupFactory(ActorAimedAt).GiveTo(Pawn);
                `drtrace;
                // ReceiveLocalizedMessage(class'WWLocalMessageGamePickup', class'WWLocalMessageGamePickup'.const.ROMSG_Pickedup + ItemClass.default.InvIndex);

                for ( Inv = ROInventoryManager(Pawn.InvManager).InventoryChain; Inv != None; Inv = Inv.Inventory )
                {
                    if ( ROWeapon(Inv) != None && class<ROWeapon>(ROPickupFactory(ActorAimedAt).InventoryType) != none && ROWeapon(Inv).InvIndex == ROPickupFactory(ActorAimedAt).InventoryType.default.InvIndex )
                    {
                        ROWeapon(Inv).RefillAmmo();
                        ROWeapon(Inv).GiveInitialAmmo();
                        break;
                    }
                }
                ROPickupFactory(ActorAimedAt).SetRespawn();
            }
            ActorAimedAt = none;
        }
    }
}

reliable protected server function ServerJoinSquad(int NewSquadIndex, optional bool bViaInvite)
{
    if (ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.RoleType == RORIT_Tank)
    {
        return;
    }
    else
    {
        super.ServerJoinSquad(NewSquadIndex, bViaInvite);
    }
}
/*
simulated function FindUsableActor()
{
    super.FindUsableActor();

    if (bInVehicleRange && ActorAimedAt.IsA('WWVehicleTank') && ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.RoleType != RORIT_Tank && !ActorAimedAt.IsA('WWVehicleStaticATGun'))
    {
        bInVehicleRange = false;
    }
}
*/
function PlayAnnouncerSound(byte VoxType, byte Team, byte VOXIndex, optional byte SubIndex, optional vector PlayLocation, optional Actor Speaker, optional int SeatIndex)
{
    if (VoxType == EROAVT_Radio)
    {
        super.PlayAnnouncerSound(VoxType, Team, VOXIndex, SubIndex, PlayLocation, Speaker, SeatIndex);
    }
}

function TriggerHint(int HintID, optional bool bTriggerDead) {}
/*
function InitialiseCCMs()
{
    local ROCharacterPreviewActor ROCPA, CPABoth;
    local ROCharCustMannequin TempCCM;

    if( WorldInfo.NetMode == NM_DedicatedServer )
        return;

    if( ROCCC == none )
    {
        ROCCC = Spawn(class'ROCharCustController');

        if( ROCCC != none )
            ROCCC.ROPCRef = self;
    }

    foreach WorldInfo.DynamicActors(class'ROCharacterPreviewActor', ROCPA)
    {
        if( ROCPA.OwningTeam == EOT_Both )
        {
            CPABoth = ROCPA;
        }
        else if( AllCCMs[ROCPA.OwningTeam] == none )
        {
            AllCCMs[ROCPA.OwningTeam] = Spawn(class'DRCharCustMannequin', self,, ROCPA.Location, ROCPA.Rotation);
        }
    }

    if( AllCCMs[0] == none || AllCCMs[1] == none )
    {
        if( CPABoth != none )
            TempCCM = Spawn(class'DRCharCustMannequin', self,, CPABoth.Location, CPABoth.Rotation);
        else
        {
            TempCCM = Spawn(class'DRCharCustMannequin', self, , vect(0,0,100));
        }

        TempCCM.SetOwningTeam(EOT_Both);

        if( AllCCMs[0] == none )
            AllCCMs[0] = TempCCM;

        if( AllCCMs[1] == none )
            AllCCMs[1] = TempCCM;
    }
}
*/
simulated function CreateVoicePacks(byte TeamIndex)
{
    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        AnnouncerPacks[`AXIS_TEAM_INDEX] = new(Outer) AllAnnouncerPacks[`AXIS_TEAM_INDEX];
        AnnouncerPacks[`ALLIES_TEAM_INDEX] = new(Outer) AllAnnouncerPacks[`ALLIES_TEAM_INDEX];
    }
}

function RightLeftLean()
{
    ServerLeanLeft(bWantsToLeanLeft);
}

function LeftRightLean()
{
    ServerLeanRight(bWantsToLeanRight);
}

exec function LeanRight()
{
    if (Pawn != None)
    {
        if (ROPawn(Pawn) != None)
        {
            ROPawn(Pawn).LeanRight();
        }
    }

    ServerLeanRight(True);
}

exec function LeanLeft()
{
    if (Pawn != None)
    {
        if (ROPawn(Pawn) != None)
        {
            ROPawn(Pawn).LeanLeft();
        }
    }


    ServerLeanLeft(True);
}

exec function LeanRightReleased()
{
    if (Pawn != None)
    {
        if (ROPawn(Pawn) != None)
        {
            ROPawn(Pawn).LeanRightReleased();
        }
    }

    ServerLeanRight(false);
}

exec function LeanLeftReleased()
{
    if (Pawn != None)
    {
        if (ROPawn(Pawn) != None)
        {
            ROPawn(Pawn).LeanLeftReleased();
        }
    }

    ServerLeanLeft(False);
}

reliable protected server function ServerLeanRight(bool leanstate)
{
    bWantsToLeanRight = leanstate;

    if( Pawn != none )
    {
        if( ROPawn(Pawn) != none )
        {
            if (leanstate)
            {
                ROPawn(Pawn).LeanRight();
            }
            else
            {
                ROPawn(Pawn).LeanRightReleased();
                bWantsToLeanRight = false;

                if( bWantsToLeanLeft )
                {
                    SetTimer(0.2f, false, 'RightLeftLean');
                }
            }
        }
        else if ( leanstate && ROVWeap_TankTurret(ROWeaponPawn(Pawn).MyVehicleWeapon) != none )
        {
            bWantsToLeanRight = false;
            ROVWeap_TankTurret(ROWeaponPawn(Pawn).MyVehicleWeapon).IncrementRange();
        }
        // TODO: Add bHasTransferCase or something similar instead of class equivalency check.
        else if (leanstate && DRVehicle_Willys(Pawn) != None)
        {
            bWantsToLeanLeft = false;
            // DRVehicle_Willys(Pawn).ShiftTransferCase(ETCR_High);
            ROVehicleSimTreaded(DRVehicle_Willys(Pawn).SimObj).GearArray[DRVehicle_Willys(Pawn).OutputGear].AccelRate += 0.25;
        }
    }
}

reliable protected server function ServerLeanLeft(bool leanstate)
{
    bWantsToLeanLeft = leanstate;

    if( Pawn != none )
    {
        if( ROPawn(Pawn) != none )
        {
            if (leanstate)
            {
                ROPawn(Pawn).LeanLeft();
            }
            else
            {
                ROPawn(Pawn).LeanLeftReleased();

                if( bWantsToLeanRight )
                {
                    SetTimer(0.2f, false, 'LeftRightLean');
                }
            }
        }
        else if ( leanstate && ROVWeap_TankTurret(ROWeaponPawn(Pawn).MyVehicleWeapon) != none )
        {
            bWantsToLeanLeft = false;
            ROVWeap_TankTurret(ROWeaponPawn(Pawn).MyVehicleWeapon).DecrementRange();
        }
        // TODO: Add bHasTransferCase or something similar instead of class equivalency check.
        else if (leanstate && DRVehicle_Willys(Pawn) != None)
        {
            bWantsToLeanLeft = false;
            // DRVehicle_Willys(Pawn).ShiftTransferCase(ETCR_Low);
            ROVehicleSimTreaded(DRVehicle_Willys(Pawn).SimObj).GearArray[DRVehicle_Willys(Pawn).OutputGear].AccelRate -= 0.25;
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef(RELEASE)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function DumpScriptTrace()
{
    ScriptTrace();
}

exec function BlowupVehicles(optional bool bHitAmmo = false, optional int DeadVehicleType = 999)
{
    ServerBlowUpVehicles(bHitAmmo, DeadVehicleType);
}

private reliable server function ServerBlowUpVehicles(optional bool bHitAmmo = false,
    optional int DeadVehicleType = 999)
{
    local ROVehicle ROV;

    ForEach AllActors(class'ROVehicle', ROV)
    {
        ROV.bHitAmmo = bHitAmmo;

        ROV.BlowupVehicle();

        // Useless? Is set in ROV.BlowupVehicle()?
        if (DeadVehicleType != 999)
        {
            ROV.DeadVehicleType = DeadVehicleType;
        }
    }
}

private reliable server function DoAddBotsDR(int Num, optional int NewTeam = -1, optional bool bNoForceAdd)
{
    local ROAIController ROBot;
    local byte ChosenTeam;
    local byte SuggestedTeam;
    local ROPlayerReplicationInfo ROPRI;
    local ROGameInfo ROGI;

    ROGI = ROGameInfo(WorldInfo.Game);

    // do not add bots during server travel
    if( ROGI.bLevelChange )
    {
        return;
    }

    while (Num > 0 && ROGI.NumBots + ROGI.NumPlayers < ROGI.MaxPlayers)
    {
        // Create a new Controller for this Bot
        ROBot = ROGI.Spawn(ROGI.AIControllerClass);

        // Assign the bot a Player ID
        ROBot.PlayerReplicationInfo.PlayerID = ROGI.CurrentID++;

        // Suggest a team to put the AI on
        if ( ROGI.bBalanceTeams || NewTeam == -1 )
        {
            if ( ROGI.GameReplicationInfo.Teams[`AXIS_TEAM_INDEX].Size - ROGI.GameReplicationInfo.Teams[`ALLIES_TEAM_INDEX].Size <= 0
                && ROGI.BotCapableNorthernRolesAvailable() )
            {
                SuggestedTeam = `AXIS_TEAM_INDEX;
            }
            else if( ROGI.BotCapableSouthernRolesAvailable() )
            {
                SuggestedTeam = `ALLIES_TEAM_INDEX;
            }
            // If there are no roles available on either team, don't allow this to go any further
            else
            {
                ROBot.Destroy();
                return;
            }
        }
        else if (ROGI.BotCapableNorthernRolesAvailable() || ROGI.BotCapableSouthernRolesAvailable())
        {
            SuggestedTeam = NewTeam;
        }
        else
        {
            ROBot.Destroy();
            return;
        }

        // Put the new Bot on the Team that needs it
        ChosenTeam = ROGI.PickTeam(SuggestedTeam, ROBot);
        // Set the bot name based on team
        ROGI.ChangeName(ROBot, ROGI.GetDefaultBotName(ROBot, ChosenTeam, ROTeamInfo(ROGI.GameReplicationInfo.Teams[ChosenTeam]).NumBots + 1), false);

        ROGI.JoinTeam(ROBot, ChosenTeam);

        ROBot.SetTeam(ROBot.PlayerReplicationInfo.Team.TeamIndex);

        // Have the bot choose its role
        if( !ROBot.ChooseRole() )
        {
            ROBot.Destroy();
            continue;
        }

        ROBot.ChooseSquad();

        // GRIP BEGIN
        // Remove. Debugging purpose only.
        ROPRI = ROPlayerReplicationInfo(ROBot.PlayerReplicationInfo);
        if( ROPRI.RoleInfo.bIsTankCommander )
        {
            ROGI.ChangeName(ROBot, ROPRI.GetHumanReadableName()$" (TankAI)", false);
        }
        // GRIP END

        if ( ROTeamInfo(ROBot.PlayerReplicationInfo.Team) != none && ROTeamInfo(ROBot.PlayerReplicationInfo.Team).ReinforcementsRemaining > 0 )
        {
            // Spawn a Pawn for the new Bot Controller
            ROGI.RestartPlayer(ROBot);
        }

        if ( ROGI.bInRoundStartScreen )
        {
            ROBot.AISuspended();
        }

        // Note that we've added another Bot
        if( !bNoForceAdd )
            ROGI.DesiredPlayerCount++;

        ROGI.NumBots++;
        Num--;
        ROGI.UpdateGameSettingsCounts();
    }
}

exec function AddBotsDR(int Num, optional int NewTeam = -1, optional bool bNoForceAdd)
{
    DoAddBotsDR(Num, NewTeam, bNoForceAdd);
}

exec function SetSFXVolume(float NewVolume)
{
    AudioManager.UpdateVolume(NewVolume, EAC_SFX);
}

/*
simulated exec function DisableRagdoll()
{
    ROPawn(Pawn).DisableRagdoll();
}

simulated exec function EnableRagdoll()
{
    ROPawn(Pawn).EnableRagdoll();
}
*/

exec function ForceAerialRecon()
{
    ServerForceAerialRecon();
}

reliable private server function ServerForceAerialRecon()
{
    local Sequence GameSeq;
    local ROGameReplicationInfo ROGRI;
    local float ReconDuration;
    local array<SequenceObject> AerialReconSeqEvents;
    local int i;
    local int Team;
    local Actor AerialReconBaseActor;

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);
    GameSeq = WorldInfo.GetGameSequence();
    Team = GetTeamNum();

    if (GameSeq != None)
    {
        // find any Level Loaded events that exist
        GameSeq.FindSeqObjectsByClass(class'ROSeqEvent_AerialRecon', True, AerialReconSeqEvents);

        // activate them
        for (i = 0; i < AerialReconSeqEvents.Length; i++)
        {
            AerialReconBaseActor = ROSeqEvent_AerialRecon(
                AerialReconSeqEvents[i]).TriggerRecon(Team, ROGRI.bReverseRolesAndSpawns, ReconDuration);

            if (AerialReconBaseActor != None)
            {
                ROGameInfo(WorldInfo.Game).SpawnAerialReconPlane(AerialReconBaseActor, ReconDuration, self);
                break;
            }
        }
    }
}

exec function ForceStukaStrike(optional bool bAircraftPOV = False,
    optional int Altitude = 0, optional int PayloadDropHeight = 0,
    optional int AngleOfDive = 0)
{
    DoTestStukaStrike(bAircraftPOV, Altitude, PayloadDropHeight, AngleOfDive);
}

exec function ForceStrafingRun(int PitchRate, int Altitude, int DistanceToTarget)
{
    ServerForceStrafingRun(PitchRate, Altitude, DistanceToTarget);
}

reliable private server function ServerForceStrafingRun(int PitchRate, int Altitude, int Distance)
{
    local DRStrafingRunAircraft Aircraft;
    local ROTeamInfo ROTI;
    local rotator FlightRot;
    local vector TargetLocation;

    Aircraft = Spawn(class'DRStrafingRunAircraft', self,,
        Pawn.Location + MakeVector(Distance, 0, Altitude), Pawn.Rotation);

    ROTI = ROTeamInfo(PlayerReplicationInfo.Team);

    if ( ROTI != none )
    {
        ROTI.ArtyStrikeLocation = ROTI.SavedArtilleryCoords;
    }

    if( ROTI.ArtyStrikeLocation != vect(-999999.0,-999999.0,-999999.0) )
        TargetLocation = ROTI.ArtyStrikeLocation;
    else
        TargetLocation = Pawn.Location;

    FlightRot = rotator(Normal(TargetLocation - Aircraft.Location));
    FlightRot.Roll = 0;
    Aircraft.SetRotation(FlightRot);

    Aircraft.PitchRate = PitchRate;
}

reliable private server function DoTestStukaStrike(bool bAircraftPOV,
    int Altitude, int PayloadDropHeight, int AngleOfDive)
{
    local int SpawnAltitude;
    local vector TargetLocation;
    local vector SpawnLocation;
    local class<DRDiveBomberAircraft> AircraftClass;
    local DRDiveBomberAircraft Aircraft;
    local ROTeamInfo ROTI;
    local DRMapInfo DRMI;

    if ( ROPlayerReplicationInfo(PlayerReplicationInfo) == none ||
         ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none ||
         Pawn == none )
    {
        return;
    }

    ROTI = ROTeamInfo(PlayerReplicationInfo.Team);

    if ( ROTI != none )
    {
        ROTI.ArtyStrikeLocation = ROTI.SavedArtilleryCoords;
    }

    if( ROTI.ArtyStrikeLocation != vect(-999999.0,-999999.0,-999999.0) )
        TargetLocation = ROTI.ArtyStrikeLocation;
    else
        TargetLocation = Pawn.Location;

    AircraftClass = class'DRDiveBomberAircraft';

    DRMI = DRMapInfo(WorldInfo.GetMapInfo());

    if (Altitude > 0)
    {
        SpawnAltitude = Altitude;
    }
    else
    {
        SpawnAltitude = AircraftClass.default.Altitude;
    }

    SpawnAltitude += TargetLocation.Z + DRMI.DiveBomberHeightOffset;

    SpawnLocation = GetBestAircraftSpawnLoc(TargetLocation, SpawnAltitude, AircraftClass);

    TargetLocation.Z = SpawnLocation.Z;

    Aircraft = Spawn(AircraftClass,self,, SpawnLocation, rotator(TargetLocation - SpawnLocation));

    if ( Aircraft == none )
    {
        `log("Error Spawning Support Aircraft");
    }
    else
    {
        if (PayloadDropHeight > 0)
        {
            Aircraft.PayloadDropHeight = PayloadDropHeight;
        }

        if (AngleOfDive > 0)
        {
            Aircraft.AngleOfDive = AngleOfDive;
        }

        Aircraft.TargetLocation = ROTI.ArtyStrikeLocation;
        Aircraft.CalculateTrajectory();
        Aircraft.SetDropPoint();
    }

    if (bAircraftPOV)
    {
        SetViewTarget(Aircraft);
    }

    //? KillsWithCurrentNapalm = 0; // Reset Napalm Kills as We call it in!!!
}

// Temporary Bren 3rd person left hand debugging.
simulated exec function SetLeftHandYaw(float YawValue)
{
    local DRWeapAttach_Bren_LMG Bren;

    Bren = DRWeapAttach_Bren_LMG(ROPawn(Pawn).CurrentWeaponAttachment);
    if (Bren != None)
    {
        Bren.SetLeftHandYaw(YawValue);
    }
}

function vector MakeVector(float X, float Y, float Z)
{
    local vector V;

    V.X = X;
    V.Y = Y;
    V.Z = Z;

    return V;
}

simulated exec function SetScopePosition(float X, float Y, float Z)
{
    ROSniperWeapon(Pawn.Weapon).ScopePosition = MakeVector(X, Y, Z);
}

exec function SetScopeZ(float NewScopeZ)
{
    ROSniperWeapon(Pawn.Weapon).ScopeLenseMIC.SetScalarParameterValue('v_position', NewScopeZ);
}

simulated exec function SetShoulderedPosition(float X, float Y, float Z)
{
    ROWeapon(Pawn.Weapon).ShoulderedPosition = MakeVector(X, Y, Z);
}

simulated exec function SetSightPitch(int RangeIndex, int NewSightPitch)
{
    ROWeapon(Pawn.Weapon).SightRanges[RangeIndex].SightPitch = NewSightPitch;
    ROWeapon(Pawn.Weapon).SightIndexUpdated();
}

simulated exec function SetSightSlideOffset(int RangeIndex, float NewSightSlideOffset)
{
    ROWeapon(Pawn.Weapon).SightRanges[RangeIndex].SightSlideOffset = NewSightSlideOffset;
    ROWeapon(Pawn.Weapon).SightIndexUpdated();
}

simulated exec function SetSightPositionOffset(int RangeIndex, float NewSightPositionOffset)
{
    ROWeapon(Pawn.Weapon).SightRanges[RangeIndex].SightPositionOffset = NewSightPositionOffset;
    ROWeapon(Pawn.Weapon).SightIndexUpdated();
}

simulated exec function SetAddedPitch(int RangeIndex, int NewAddedPitch)
{
    ROWeapon(Pawn.Weapon).SightRanges[RangeIndex].AddedPitch = NewAddedPitch;
    ROWeapon(Pawn.Weapon).SightIndexUpdated();
}

exec function SetPlayerViewOffset(float X, float Y, float Z)
{
    ROWeapon(Pawn.Weapon).PlayerViewOffset = MakeVector(X, Y, Z);
}

exec function SetIronsightPosX(float NewX)
{
    ROWeapon(Pawn.Weapon).IronSightPosition.X = NewX;
    ROWeapon(Pawn.Weapon).PlayerViewOffset.X = NewX;
}

// Helper function for working out a nice ironsight position when changing the weapon zoom FoV
exec function SetIronsightPosY(float NewY)
{
    ROWeapon(Pawn.Weapon).IronSightPosition.Y = NewY;
    ROWeapon(Pawn.Weapon).PlayerViewOffset.Y = NewY;
}

// Helper function for working out a nice ironsight position when changing the weapon zoom FoV
exec function SetIronsightPosZ(float NewZ)
{
    ROWeapon(Pawn.Weapon).IronSightPosition.Z = NewZ;
    ROWeapon(Pawn.Weapon).PlayerViewOffset.Z = NewZ;
}

exec function SetISFocusDepth(float NewDepth)
{
    ROWeapon(Pawn.Weapon).ISFocusDepth = NewDepth;
}

exec function SetISFocusBlendRadius(float NewRadius)
{
    ROWeapon(Pawn.Weapon).ISFocusBlendRadius = NewRadius;
}

exec function SetSightRot(int SightRot)
{
    ROWeapon(Pawn.Weapon).SightRotController.SetSkelControlStrength( 1.0f , 0.0f );
    ROWeapon(Pawn.Weapon).SightRotController.BoneRotation.Pitch = SightRot * -1;
}

exec function SetSightSlide(float SlideLoc)
{
    ROWeapon(Pawn.Weapon).SightSlideController.SetSkelControlStrength( 1.0f , 0.0f );
    ROWeapon(Pawn.Weapon).SightSlideController.BoneTranslation.X = SlideLoc;
}

exec function SetSightZ(float NewZ)
{
    ROWeapon(Pawn.Weapon).IronSightPosition.Z = NewZ;
    ROWeapon(Pawn.Weapon).PlayerViewOffset.Z = NewZ;
}

exec function Camera(name NewMode)
{
    ServerCamera(NewMode);
}

reliable server function ServerCamera(name NewMode)
{
    if (NewMode == '1st')
    {
        NewMode = 'FirstPerson';
    }
    else if (NewMode == '3rd')
    {
        NewMode = 'ThirdPerson';
    }
    else if (NewMode == 'free')
    {
        NewMode = 'FreeCam';
    }
    else if (NewMode == 'fixed')
    {
        NewMode = 'Fixed';
    }

    SetCameraMode(NewMode);

    if (PlayerCamera != None)
    {
        `dr("CameraStyle=" $ PlayerCamera.CameraStyle);
    }
}

exec function ListMats()
{
    local int i;

    if (self.Pawn.Mesh.Materials.length == 0)
    {
        `dr("Materials list is empty!",'M');
        return;
    }

    for (i = 0; i < self.Pawn.Mesh.Materials.length; i++)
    {
        `dr("MIC" @ i @ MaterialInstanceConstant(self.Pawn.mesh.Materials[i]).Parent,'M');
    }
}

exec function BleedTest()
{
    ROPawn(self.Pawn).PlayerHitZones[5].ZoneBleedingStatus = ROBS_Slow;
    ROPawn(self.Pawn).PlayerHitZones[5].bBleeding = true;
    ROPawn(self.Pawn).BleedingInstigator = self;
    ROPawn(self.Pawn).LastTakeHitInfo.DamageType = class'RODamageType';
    ROPawn(self.Pawn).StartBleeding();
}

exec function ShowProxies()
{
    local ROVehicle ROV;
    local int i;

    ROV = ROVehicle(Pawn);

    if (ROV == none && ROWeaponPawn(Pawn) != none)
    {
        ROV = ROWeaponPawn(Pawn).MyVehicle;
    }

    for (i = 0; i < ROV.SeatProxies.Length; i++)
    {
        ROV.SeatProxies[i].ProxyMeshActor.HideMesh(false);
        ROV.ChangeCrewCollision(true, i);
    }
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    super.DisplayDebug(HUD, out_YL, out_YPos);

    if (WorldInfo.MusicComp != none)
    {
        HUD.Canvas.SetDrawColor(0,255,0);
        HUD.Canvas.DrawText("MUSIC VOLUME:" @ WorldInfo.MusicComp.VolumeMultiplier @ " FadeInTargetVolume:" @  WorldInfo.MusicComp.FadeInTargetVolume @ "CurrentVolumeMultiplier" @  WorldInfo.MusicComp.CurrentVolumeMultiplier, FALSE);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4, out_YPos);
        HUD.Canvas.SetDrawColor(0,255,0);
        HUD.Canvas.DrawText("MUSIC VOLUME SETTING :" @ UserVolumeSetting(), FALSE);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4, out_YPos);

        if (WorldInfo.CurrentMusicTrack.TheSoundCue != none)
        {
            HUD.Canvas.SetDrawColor(0,255,0);
            HUD.Canvas.DrawText("MUSIC TRACK:" @ WorldInfo.CurrentMusicTrack.TheSoundCue @ "INDEX:" @ DRTeamInfo(WorldInfo.GRI.Teams[self.GetTeamNum()]).TrackIndex, FALSE);
            out_YPos += out_YL;
            HUD.Canvas.SetPos(4, out_YPos);
        }
        else
        {
            HUD.Canvas.SetDrawColor(255,0,0);
            HUD.Canvas.DrawText("MUSIC TRACK: NONE", FALSE);
            out_YPos += out_YL;
            HUD.Canvas.SetPos(4, out_YPos);
        }
    }
    else
    {
        HUD.Canvas.SetDrawColor(255,0,0);
        HUD.Canvas.DrawText("NULL WORLD MUSIC COMP", FALSE);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4, out_YPos);
    }

    if (StingerComp != none)
    {
        HUD.Canvas.SetDrawColor(0,255,0);
        HUD.Canvas.DrawText("STINGER VOLUME:" @ StingerComp.VolumeMultiplier @ " FadeInTargetVolume:" @ StingerComp.FadeInTargetVolume @ "CurrentVolumeMultiplier" @ StingerComp.CurrentVolumeMultiplier, FALSE);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4, out_YPos);

        if (StingerComp.SoundCue != none)
        {
            HUD.Canvas.SetDrawColor(0,255,0);
            HUD.Canvas.DrawText("STINGER TRACK:" @ StingerComp.SoundCue, FALSE);
            out_YPos += out_YL;
            HUD.Canvas.SetPos(4, out_YPos);
        }
        else
        {
            HUD.Canvas.SetDrawColor(255,0,0);
            HUD.Canvas.DrawText("STINGER TRACK: NONE", FALSE);
            out_YPos += out_YL;
            HUD.Canvas.SetPos(4, out_YPos);
        }
    }
    else
    {
        HUD.Canvas.SetDrawColor(255,0,0);
        HUD.Canvas.DrawText("NULL STINGER COMP", FALSE);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4, out_YPos);
    }

    HUD.Canvas.SetDrawColor(0,255,0);
    HUD.Canvas.DrawText("ROUNDEND:" @ RoundEnd, FALSE);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4, out_YPos);

    HUD.Canvas.SetDrawColor(0,255,0);
    HUD.Canvas.DrawText("MATCHEND:" @ MatchEnd, FALSE);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4, out_YPos);

    HUD.Canvas.SetDrawColor(0,255,0);
    HUD.Canvas.DrawText("DUCKING:" @ Ducking, FALSE);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4, out_YPos);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`endif
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

DefaultProperties
{
    TeamSelectSceneTemplate       = DRUISceneTeamSelect'DR_UI.UIScene.DRUIScene_TeamSelect'
    // UnitSelectSceneTemplate=     WWUISceneUnitSelect'WinterWar_UI.UIScene.WWUIScene_UnitSelect'
    // CharacterSceneTemplate=          WWUISceneCharacter'WinterWar_UI.UIScene.WWUIScene_Character'
    // AfterActionReportSceneTemplate=  WWUISceneAfterActionReport'WinterWar_UI.UIScene.WWUIScene_AfterAction'
    StoreSceneTemplate            = None

    Begin Object Class=AudioComponent name=StingerComponent
        OcclusionCheckInterval=0.1
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
    End Object
    StingerComp=StingerComponent

    // NorthTeamVoicePacks[0]=class'WWVoicePack_FIN_1'
    // NorthTeamVoicePacks[1]=class'WWVoicePack_FIN_2'
    // NorthTeamVoicePacks[2]=class'WWVoicePack_FIN_3'

    // SouthTeamVoicePacks[0]=class'WWVoicePack_RUS_1'
    // SouthTeamVoicePacks[1]=class'WWVoicePack_RUS_2'
    // SouthTeamVoicePacks[2]=class'WWVoicePack_RUS_3'

    // AllAnnouncerPacks[`AXIS_TEAM_INDEX]= class'WWVoicePack_FIN_C'
    // AllAnnouncerPacks[`ALLIES_TEAM_INDEX]=   class'WWVoicePack_RUS_C'

    // AxisWinTheme=SoundCue'WinterWar_AUD_MUS.FIN.F_Victory_Cue'
    // AlliesWinTheme=SoundCue'WinterWar_AUD_MUS.SOV.R_Victory_Cue'

    RoundEnd=false
    MatchEnd=false
    Ducking=false

    NorthWinTheme=  none
    NorthLossTheme= none
    SouthWinTheme=  none
    SouthLossTheme= none
    NorthRoundWinTheme= none
    NorthRoundLostTheme=none
    SouthRoundWinTheme= none
    SouthRoundLostTheme=none
}
