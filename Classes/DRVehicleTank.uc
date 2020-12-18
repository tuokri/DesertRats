class DRVehicleTank extends ROVehicleTank
    abstract;

// TODO: Let's not do this for now.
simulated function SpawnExternallyVisibleSeatProxies()
{
}

simulated function PostBeginPlay()
{
    `drtrace;
    super.PostBeginPlay();
    `drtrace;
}
