class DRWeap_M39_Grenade_Content extends DRWeap_M39_Grenade;

DefaultProperties 
{
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_M39.Mesh.M39_1st'
        PhysicsAsset=PhysicsAsset'DR_WP_DAK_M39.Phy.M39_1st_Physics'
        AnimSets(0)=AnimSet'DR_WP_DAK_M39.Anim.WP_M39_Hands'
        AnimTreeTemplate=AnimTree'DR_WP_DAK_M39.Anim.M39_AnimTree'
        Scale=1.0
        FOV=70
    End Object

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_M39.Mesh.M39_3rd'
        PhysicsAsset=PhysicsAsset'DR_WP_DAK_M39.Phy.M39_3rd_Physics'
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

    AttachmentClass=class'DRWeapAttach_M39_Grenade'

    ArmsAnimSet=AnimSet'DR_WP_DAK_M39.Anim.WP_M39_Hands'
}
