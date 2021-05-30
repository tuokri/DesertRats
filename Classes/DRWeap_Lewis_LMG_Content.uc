class DRWeap_Lewis_LMG_Content extends DRWeap_Lewis_LMG;

DefaultProperties
{
    ArmsAnimSet=AnimSet'DR_WP_DAK_MG34_LMG.Animation.WP_MG34_UPGD2hands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_UK_LEWIS.Mesh.Lewis'
        PhysicsAsset=PhysicsAsset'DR_WP_UK_LEWIS.Phy.Lewis_Physics'
        AnimSets(0)=AnimSet'DR_WP_DAK_MG34_LMG.Animation.WP_MG34_UPGD2hands'
        AnimTreeTemplate=AnimTree'DR_WP_UK_LEWIS.Anim.Lewis_AnimationTree'
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

    AttachmentClass=class'DRWeapAttach_Lewis_LMG'
}
