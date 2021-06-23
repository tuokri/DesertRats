// 20mm Hispano H.E/I. Mk IZ.
// TODO: Common base class for both Hispano projectiles.
class DRProjectile_Hispano_HE_MkII extends ROAntiVehicleProjectile;

var ROSupportAircraft OwningAircraft;


simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
    if (Other != OwningAircraft)
    {
        super.Touch(Other, OtherComp, HitLocation, HitNormal);
    }
}

DefaultProperties
{
    bProjectileIsHEAT=True // Not really, but for gameplay logic.
    bExplodeOnDeflect=True
    bExplodeWhenHittingInfantry=True

    BallisticCoefficient=2.0
    Speed=40500 // 810 m/s.
    MaxSpeed=65500 // Allow for aircraft momentum.
    ImpactDamage=200
    Damage=150
    DamageRadius=250
    MomentumTransfer=50000

    ImpactDamageType=class'DRDmgType_Hispano_HE_MkII_Impact'
    GeneralDamageType=class'DRDmgType_Hispano_HE_MkII_General'
    MyDamageType=class'DRDmgType_Hispano_HE_MkII'

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

    ShakeScale=1.5
    // MaxSuppressBlurDuration=4.5
    SuppressBlurScalar=1.25
    SuppressAnimationScalar=0.6
    ExplodeExposureScale=0.45

    ProjExplosionTemplate=ParticleSystem'FX_VN_Weapons.Impacts.FX_WEP_20mm'
    WaterExplosionTemplate=ParticleSystem'FX_VN_Impacts.Water.FX_VN_20mm_Water'
    ExplosionSound=AkEvent'WW_WEP_Bullets.Play_WEP_Bullet_Impact_Dirt'
    ProjDefelectTemplate=ParticleSystem'FX_VN_Weapons.Impacts.FX_WEP_20mm'
    ProjPenetrateTemplate=ParticleSystem'FX_VN_Weapons.Impacts.FX_WEP_20mm'
    ProjPostDeflectTemplate=ParticleSystem'FX_VN_Weapons.Impacts.FX_WEP_20mm'
    // TODO:
    ProjFlightTemplate=ParticleSystem'FX_WEP_Gun_Three.Tracers.FX_WEP_Gun_A_TankShell_Tracer'

    // LensFlareEffect=none
    ExplosionLightClass=none
    ShockwaveDecal=none

    ExplosionDecal=None
}
