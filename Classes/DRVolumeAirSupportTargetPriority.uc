class DRVolumeAirSupportTargetPriority extends Volume;

function vector GetPriorityTarget(int CallingTeamIndex)
{
    local vector Target;
    local DRVehicleTank Tank;
    // local DRVehicleTransport Transport;

    foreach TouchingActors(class'DRVehicleTank', Tank)
    {
        if (Tank.Team != CallingTeamIndex)
        {
            // Check Tank velocity. Ignore fast moving.
            // Check Tank type. Heavier is prioritized.
        }
    }

    /*
    foreach TouchingActors(class'DRVehicleTransport', Transport)
    {
        if (Transport.Team != CallingTeamIndex)
        {
            // Check Transport velocity. Ignore fast moving.
            // Check Transport type. Heavier is prioritized.
        }
    }
    */

    return Target;
}

DefaultProperties
{
    LifeSpan=2
    bCollideActors=True
    RemoteRole=ROLE_None

    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionRadius=5000
        CollisionHeight=250
        BlockNonZeroExtent=False
        BlockZeroExtent=True
        BlockActors=False
        CollideActors=True
    End Object
    CollisionComponent=CollisionCylinder
    Components.Add(CollisionCylinder)
}
