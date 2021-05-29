class DRWeap_MP41_SMG_Content extends DRWeap_MP41_SMG;

DefaultProperties
{
    //Arms
    ArmsAnimSet=AnimSet'WP_VN_VC_MP40.Animation.WP_MP40hands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_MP41.Mesh.MP41'
        PhysicsAsset=PhysicsAsset'WP_VN_VC_MP40.Phys.VC_MP40_Physics'
        AnimSets(0)=AnimSet'WP_VN_VC_MP40.Animation.WP_MP40hands'
        AnimTreeTemplate=AnimTree'DR_WP_DAK_MP41.Animation.DAK_MP41_Tree'
        Scale=1.0
        FOV=70
    End Object

    // Pickup staticmesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_MP41.Mesh.MP41_3rd'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master_03.Phy.MP40_3rd_Physics'
        AnimTreeTemplate=AnimTree'WP_VN_3rd_Master_03.AnimTree.MP40_SMG_3rd_Tree'
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

    // Attachment class.
    AttachmentClass=class'DRWeapAttach_MP41_SMG'
}
