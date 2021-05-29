class DRTurret extends ROTurret;

// Easier to mount turrets in FindActorAimedAt() - Tobias.
var vector TurretLookAtOffset;

simulated function vector GetAdjustedTurretViewLocation()
{
    return TurretLookAtOffset - Location;
}

DefaultProperties
{
    TurretLookAtOffset=(X=0,Y=0,Z=5000)
}
