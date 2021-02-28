// 20mm Hispano A.P. Mark IIZ.
class DRProjectile_Hispano_AP_MkIIZ extends ROAntiVehicleProjectile;

// TODO: Tracers.
simulated function SpawnFlightEffects()
{
}

// TODO: Ballistics.
DefaultProperties
{
    bProjectileIsHEAT=False
    bExplodeOnDeflect=False

    Speed=40500 // 810 m/s.

    // World penetration.
    PenetrationDepth=80
    MaxPenetrationTests=6
}
