class DRVProjectile_ShermanIII_AP extends DRTankCannonProjectile;

DefaultProperties
{
    // M61 APCBC-HE-T
    BallisticCoefficient=1.735
    Speed=30900 //618 M/S
    MaxSpeed=30900
    ImpactDamage=400
    Damage=100
    DamageRadius=50
    MomentumTransfer=50000
    ImpactDamageType=class'DRDmgType_PanzerIVFShell_AP'
    GeneralDamageType=class'DRDmgType_PanzerIVFShell_AP_General'
    MyDamageType=class'DRDmgType_PanzerIVFShell_AP'

    //? ExplosionSound=SoundCue'AUD_Impacts.Impacts.Tank_AP_Impact_Dirt_Cue'

    Begin Object Name=CollisionCylinder
        CollisionRadius=4
        CollisionHeight=4
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

    Caliber=75
    ActualRHA=88
    TestPlateHardness=400
    SlopeEffect=0.82472
    ShatterNumber=1.0
    ShatterTd=0.65
    ShatteredPenEffectiveness=0.8
    // World penetration
    PenetrationDepth=120
    MaxPenetrationTests=6
}
