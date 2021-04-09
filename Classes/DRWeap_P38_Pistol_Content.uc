class DRWeap_P38_Pistol_Content extends DRWeap_P38_Pistol;

DefaultProperties
{
    //Arms
    ArmsAnimSet=AnimSet'DR_WP_DAK_P38_Walther.Animation.WP_P38Hands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_P38_Walther.Mesh.Ger_P38'
        PhysicsAsset=None
        AnimSets(0)=AnimSet'DR_WP_DAK_P38_Walther.Animation.WP_P38Hands'
        Animations=AnimTree'DR_WP_DAK_P38_Walther.Animation.Ger_P38_Tree'
        Scale=1.0
        FOV=70
    End Object

    // Pickup staticmesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_P38_Walther.Meshes_3rd.P38_3rd_RS2'
        PhysicsAsset=PhysicsAsset'WP_3rd_Master.Phy.P38_3rd_Master_Physics'
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

    AttachmentClass=class'DRWeapAttach_P38_Pistol'
}
