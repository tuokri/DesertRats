// 20mm Hispano H.E/I. Mk IZ.
class DRProjectile_Hispano_HE_MkII extends ROAntiVehicleProjectile;

// TODO: Tracers.
// simulated function SpawnFlightEffects()
// {
// }

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
    //? ImpactDamageType=class'DRDmgType_Hispano_HE_MkII'
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

    // TODO:
    ProjExplosionTemplate=ParticleSystem'FX_WEP_Explosive_Three.FX_VEH_Explosive_C_TankCannon_AP_Shell_Impact_Dirt'
    ProjFlightTemplate=ParticleSystem'FX_WEP_Gun_Three.Tracers.FX_WEP_Gun_A_TankShell_Tracer'
    ProjDefelectTemplate=ParticleSystem'FX_VEH_Tank_Three.FX_VEH_Tank_B_NoRound_Deflect'
    ProjPenetrateTemplate=ParticleSystem'FX_VEH_Tank_Three.FX_VEH_Tank_B_TankShell_Penetrate'
    ProjPostDeflectTemplate=ParticleSystem'FX_WEP_Gun_Three.Tracers.FX_WEP_Gun_A_TankShell_Tracer_PostDeflect'
}
