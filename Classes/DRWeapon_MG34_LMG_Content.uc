class DRWeapon_MG34_LMG_Content extends DRWeapon_MG34_LMG;

DefaultProperties
{
    // Arms
    ArmsAnimSet=AnimSet'WP_VN_VC_MG34_LMG.Animation.VC_MG34bipodhands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'WP_VN_VC_MG34_LMG.Mesh.VC_MG34_LMG_UPGD2'
        PhysicsAsset=PhysicsAsset'WP_VN_VC_MG34_LMG.Phy.VC_MG34_LMG_Physics'
        AnimSets(0)=AnimSet'WP_VN_VC_MG34_LMG.Animation.VC_MG34bipodhands'
        AnimTreeTemplate=AnimTree'WP_VN_VC_MG34_LMG.Animation.VC_MG34Bipod_Tree'
        Scale=1.0
        FOV=70
    End Object

    // Pickup staticmesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'WP_VN_3rd_Master_04.Mesh.MG34_3rd_Master'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master_04.Phy.MG34_3rd_Physics'
        AnimTreeTemplate=AnimTree'WP_VN_3rd_Master_04.AnimTree.MG34_Bipod_3rd_Tree'
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=true
        BlockNonZeroExtent=true
        BlockRigidBody=true
        bHasPhysicsAssetInstance=false
        bUpdateKinematicBonesFromAnimation=false
        PhysicsWeight=1.0
        RBChannel=RBCC_GameplayPhysics
        RBCollideWithChannels=(Default=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
        bSkipAllUpdateWhenPhysicsAsleep=TRUE
        bSyncActorLocationToRootRigidBody=true
    End Object

    // Ammo belt SkeletalMesh
    Begin Object Class=ROAmmoBeltMesh Name=AmmoBelt0
        SkeletalMesh=SkeletalMesh'WP_VN_VC_MG34_LMG.Mesh.VC_MG34_BELT'
        PhysicsAsset=PhysicsAsset'WP_VN_VC_MG34_LMG.Phy.VC_MG34_BELT_Physics'
        AnimSets.Add(AnimSet'WP_VN_VC_MG34_LMG.Animation.VC_MG34_BELT')
        DepthPriorityGroup=SDPG_Foreground
        bOnlyOwnerSee=true
        MaxAmmoShown=17
    End Object

    //Reloading
    WeaponReloadEmptyMagAnim=MG34_reloadempty_crouch
    WeaponReloadNonEmptyMagAnim=MG34_reloadhalf_crouch
    WeaponRestReloadEmptyMagAnim=MG34_reloadempty_crouch
    WeaponRestReloadNonEmptyMagAnim=MG34_reloadhalf_crouch
    DeployReloadEmptyMagAnim=MG34_deploy_reloadempty
    DeployReloadHalfMagAnim=MG34_deploy_reloadhalf

    AmmoBeltMesh=AmmoBelt0

    AmmoBeltSocket=AmmoBeltSocket

    AttachmentClass=class'DRWeapon_MG34_LMG_Attach'

    WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1919_A6.Play_WEP_M1919A6_Loop_3P', FirstPersonCue=AkEvent'WW_WEP_M1919_A6.Play_WEP_M1919A6_Auto_LP')
    WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1918.Play_WEP_M1918_Single_3P', FirstPersonCue=AkEvent'WW_WEP_M1918.Play_WEP_M1918_Fire_Single')

    bLoopingFireSnd(DEFAULT_FIREMODE)=true
    WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1919_A6.Play_WEP_M1919A6_Tail_3P', FirstPersonCue=AkEvent'WW_WEP_M1919_A6.Play_WEP_M1919A6_Auto_Tail')
    bLoopHighROFSounds(DEFAULT_FIREMODE)=true
}
