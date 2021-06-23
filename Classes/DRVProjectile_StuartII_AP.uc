class DRVProjectile_StuartII_AP extends DRTankCannonProjectile;

DefaultProperties
{
    // M51 APCBC-T
    BallisticCoefficient=0.984
    Speed=44200 //884 M/S
    MaxSpeed=44200
    ImpactDamage=250
    Damage=100
    DamageRadius=10
    MomentumTransfer=50000
    ImpactDamageType=class'DRDmgType_PanzerIVFShell_AP'
    GeneralDamageType=class'DRDmgType_PanzerIVFShell_AP_General'
    MyDamageType=class'DRDmgType_PanzerIVFShell_AP'

    //? ExplosionSound=SoundCue'AUD_Impacts.Impacts.Tank_AP_Impact_Dirt_Cue'

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
        BlockNonZeroExtent=true
        BlockRigidBody=true
        Scale=1
    End Object
    Components.Add(ProjectileMesh)

    Caliber=37
    ActualRHA=80
    TestPlateHardness=400
    SlopeEffect=0.82472
    ShatterNumber=1.0
    ShatterTd=0.55
    ShatteredPenEffectiveness=0.75
    PenetrateShrapnelChance=0.2
    SpallShrapnelChance=0.1
    // World penetration
    PenetrationDepth=100
    MaxPenetrationTests=6
}
