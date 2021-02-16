class DRWeap_Dynamite_Content extends DRWeap_Dynamite;

DefaultProperties
{
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_Dynamite.Mesh.Dynamite'
        PhysicsAsset=None //? PhysicsAsset'WP_VN_VC_Satchel.Phys.Sov_Satchel_Physics'
        AnimSets(0)=AnimSet'DR_WP_DAK_Dynamite.Anim.WP_M37SatchelHands'
        AnimTreeTemplate=AnimTree'DR_WP_DAK_Dynamite.Anim.WP_M37_Tree'
        Scale=1.0
        FOV=70
    End Object

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_Dynamite.Mesh.Dynamite_3rd'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy.Rus_Satchel_3rd_Master_Physics'
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

    AttachmentClass=class'DRWeapAttach_Dynamite'

    ArmsAnimSet=AnimSet'DR_WP_DAK_Dynamite.Anim.WP_M37SatchelHands'
}
