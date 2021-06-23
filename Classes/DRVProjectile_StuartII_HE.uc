class DRVProjectile_StuartII_HE extends DRTankCannonProjectile;

DefaultProperties
{
    // M63 HE
    BallisticCoefficient=1.1
    Speed=39600 //792 M/S
    MaxSpeed=39600
    Damage=250
    DamageRadius=300
    MomentumTransfer=50000
    ImpactDamageType=class'DRDmgType_PanzerIVFShell_HEImpact'
    GeneralDamageType=class'DRDmgType_PanzerIVFShell_HEImpact_General'
    MyDamageType=class'DRDmgType_PanzerIVFShell_HE'

    // Shell values
    Caliber=37
    ActualRHA=10
    TestPlateHardness=400
    SlopeEffect=0.82472
    ShatterNumber=1.0
    ShatterTd=0.55
    ShatteredPenEffectiveness=0.8

    //? ExplosionSound=SoundCue'AUD_EXP_Tanks.A_CUE_Tank_Explode'

    ShakeScale=2.0
    MaxSuppressBlurDuration=2.5
    SuppressBlurScalar=1
    SuppressAnimationScalar=0.4
    ExplodeExposureScale=0.40

    Begin Object Name=CollisionCylinder
        CollisionRadius=3
        CollisionHeight=3
        AlwaysLoadOnClient=True
        AlwaysLoadOnServer=True
    End Object

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Object
    Components.Add(MyLightEnvironment)


    Begin Object Class=StaticMeshComponent Name=ProjectileMesh
        StaticMesh=StaticMesh'DR_VH_DAK_PanzerIV_F.Mesh.Panzer_IVG_Warhead'
        Materials(0)=MaterialInstanceConstant'DR_VH_DAK_PanzerIV_F.Materials.Panzer_IVG_Warhead_INST'
        MaxDrawDistance=500000
        CollideActors=true
        CastShadow=false
        LightEnvironment=MyLightEnvironment
        BlockActors=false
        BlockZeroExtent=true
        BlockNonZeroExtent=true//false
        BlockRigidBody=true
        Scale=1
    End Object
    Components.Add(ProjectileMesh)

    bExplodeOnDeflect=true
    bExplodeWhenHittingInfantry=true

    // TODO: port this from RO2.
    //? ProjExplosionTemplate=ParticleSystem'FX_WEP_Explosive_Three.FX_VEH_Explosive_C_TankCannon_HE_Shell_Impact_Dirt'
}
