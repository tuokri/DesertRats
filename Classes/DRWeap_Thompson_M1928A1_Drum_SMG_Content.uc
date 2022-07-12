class DRWeap_Thompson_M1928A1_Drum_SMG_Content extends DRWeap_Thompson_M1928A1_SMG;

DefaultProperties
{
    AttachmentClass=class'DRWeapAttach_Thompson_M1928A1_Drum_SMG'
    ArmsAnimSet=AnimSet'DR_WP_UK_M1928A1.Animation.WP_M1928A1butREAL'

    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_UK_M1928A1.Mesh.M1928A1_Thompson_Grip'
        PhysicsAsset=none //PhysicsAsset'DR_WP_UK_M1928A1.Phy.M1928A1_Thompson_Grip_Physics'
        AnimSets(0)=AnimSet'DR_WP_UK_M1928A1.Animation.WP_M1928A1butREAL'
        AnimTreeTemplate=AnimTree'DR_WP_UK_M1928A1.Animation.USA_M1928A1_AnimTree'
        Scale=1.0
        FOV=70
    End Object

    // ArmsAnimSet=AnimSet'DR_WP_UK_M1928A1.Animation.WP_M1928ThompsonHands'

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_UK_M1928A1.Mesh.Thompson_3rd_Master_UPGD3'
        //? PhysicsAsset=PhysicsAsset'DR_WP_UK_M1928A1.Phy.Thompson_3rd_Master_UPGD2_Physics'
        AnimTreeTemplate=AnimTree'DR_WP_UK_M1928A1.Animation.USA_M1928A1_AnimTree'
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=true
        BlockNonZeroExtent=true//false
        BlockRigidBody=true
        bHasPhysicsAssetInstance=false
        bUpdateKinematicBonesFromAnimation=false
        PhysicsWeight=1.0
        RBChannel=RBCC_GameplayPhysics
        RBCollideWithChannels=(Default=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
        bSkipAllUpdateWhenPhysicsAsleep=TRUE
        bSyncActorLocationToRootRigidBody=true
    End Object

    PlayerViewOffset=(X=2.5,Y=4.5,Z=-2.25)//(X=1,Y=4,Z=-2)
    IronSightPosition=(X=-2,Y=0,Z=0)

    //Reloading
    WeaponReloadEmptyMagAnim=Thompson_reloadhalfDrum // TODO: REPLACE ME SOON
    WeaponReloadNonEmptyMagAnim=Thompson_reloadhalfDrum
    WeaponRestReloadEmptyMagAnim=Thompson_reloadhalfDrum // TODO: REPLACE ME SOON
    WeaponRestReloadNonEmptyMagAnim=Thompson_reloadhalfDrum

    WeaponProjectiles(0)=class'DRBullet_ThompsonDrum'
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRBullet_ThompsonDrum'
    InstantHitDamageTypes(0)=class'DRDmgType_M1928A1_Drum'
    InstantHitDamageTypes(1)=class'DRDmgType_M1928A1_Drum'

    // Ammo
    AmmoClass=class'DRAmmo_ThompsonDrum'
    MaxAmmoCount=50
    bUsesMagazines=true
    InitialNumPrimaryMags=3
    bPlusOneLoading=false
    bCanReloadNonEmptyMag=true
    PenetrationDepth=13
    MaxPenetrationTests=3
    MaxNumPenetrations=2
    PerformReloadPct=0.85f

    //TODO: SET UP BOLT CONTROLLER
}
