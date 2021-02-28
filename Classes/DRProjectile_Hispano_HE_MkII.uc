// 20mm Hispano H.E/I. Mk IZ.
class DRProjectile_Hispano_HE_MkII extends ROAntiVehicleProjectile;

// TODO: Tracers.
simulated function SpawnFlightEffects()
{
}

// TODO: Ballistics.
DefaultProperties
{
    bProjectileIsHEAT=False
    bExplodeOnDeflect=True

    Speed=40500 // 810 m/s.

    // World penetration.
    PenetrationDepth=30
    MaxPenetrationTests=6
}
