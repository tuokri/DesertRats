class DRWeap_MG42_LMG_Content extends DRWeap_MG42_LMG;

DefaultProperties
{
    ArmsAnimSet=AnimSet'WP_Ger_MG42_LMG.Anims.WP_MG42bipodhands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'WP_Ger_MG42_LMG.Mesh.Ger_MG42'
        PhysicsAsset=None
        AnimSets(0)=AnimSet'WP_Ger_MG42_LMG.Anims.WP_MG42bipodhands'
        Animations=AnimTree'WP_Ger_MG42_LMG.Anims.Ger_MG42Bipod_Tree'
        Scale=1.0
        FOV=70
    End Object

    // Pickup staticmesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'WP_3rd_Master.Mesh.MG42_3rd_Master'
        PhysicsAsset=PhysicsAsset'WP_3rd_Master.Phy.MG42_3rd_Master_Physics'
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

    AttachmentClass=class'DesertRats.ROPWeapAttach_MG42_LMG'

}
