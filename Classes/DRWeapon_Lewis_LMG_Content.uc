class DRWeapon_Lewis_LMG_Content extends DRWeapon_Lewis_LMG;

DefaultProperties
{
    ArmsAnimSet=AnimSet'WP_VN_VC_DP_28_LMG.animation.WP_DP28bipodhands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_UK_LEWIS.Mesh.Lewis'
        PhysicsAsset=PhysicsAsset'WP_VN_VC_DP_28_LMG.Phys.Sov_DP28_Physics'
        AnimSets(0)=AnimSet'WP_VN_VC_DP_28_LMG.animation.WP_DP28bipodhands'
        AnimTreeTemplate=AnimTree'WP_VN_VC_DP_28_LMG.animation.Sov_DP28Bipod_Tree'
        Scale=1.0
        FOV=70
    End Object

    // Pickup staticmesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_UK_LEWIS.Mesh.Lewis_3rd'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy.DP28_3rd_Master_Physics'
        AnimTreeTemplate=AnimTree'WP_VN_3rd_Master.Animation.DP28_3rd_Tree'
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

    AttachmentClass=class'DRWeapon_Lewis_LMG_Attach'
}
