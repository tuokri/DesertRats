class DRWaterVolume extends ROWaterVolume
    placeable;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
    local ROVehicleTreaded ROVHT;
    ROVHT = ROVehicleTreaded(Other);

    if (ROVHT != none)
    {
        if (!ROVHT.bTransmissionDestroyed)
        {
            ROVehicleSimTreaded(ROVHT.SimObj).bLimitHighGear = True;
        }
    }

    Super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

simulated event UnTouch(Actor Other)
{
    local ROVehicleTreaded ROVHT;
    ROVHT = ROVehicleTreaded(Other);

    if (ROVHT != None)
    {
        if (!ROVHT.bTransmissionDestroyed)
        {
            ROVehicleSimTreaded(ROVHT.SimObj).bLimitHighGear = False;
        }
    }

    Super.UnTouch(Other);
}
