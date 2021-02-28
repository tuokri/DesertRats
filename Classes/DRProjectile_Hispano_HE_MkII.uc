// 20mm Hispano H.E/I. Mk IZ.
class DRProjectile_Hispano_HE_MkII extends ROAntiVehicleProjectile;

// TODO: Tracers.
simulated function SpawnFlightEffects()
{
}

DefaultProperties
{
    bProjectileIsHEAT=False
    bExplodeOnDeflect=True
    bExplodeWhenHittingInfantry=True

    BallisticCoefficient=2.0
    Speed=40500 // 810 m/s.
    MaxSpeed=40500
    Damage=150
    DamageRadius=250
    MomentumTransfer=50000
    //? ImpactDamageType=class'DRDmgType_Hispano_HE_MkIIZ'
    //? GeneralDamageType=class'DRDmgType_Hispano_HE_MkII_General'
    //? MyDamageType=class'DRDmgType_Hispano_HE_MkII'

    // TODO: Double-check these.
    Caliber=20
    ActualRHA=8
    TestPlateHardness=300
    SlopeEffect=0.82472
    ShatterNumber=1.0
    ShatterTd=0.65
    ShatteredPenEffectiveness=0.8

    // World penetration.
    PenetrationDepth=30
    MaxPenetrationTests=6

    Begin Object Name=CollisionCylinder
        CollisionRadius=2
        CollisionHeight=4
        AlwaysLoadOnClient=True
        AlwaysLoadOnServer=True
    End Object
}
