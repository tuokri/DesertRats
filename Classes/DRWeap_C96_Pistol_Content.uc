class DRWeap_C96_Pistol_Content extends ROPWeap_C96_Pistol;

DefaultProperties
{
    //Arms
    ArmsAnimSet=AnimSet'WP_Ger_C96_Mauser.animation.WP_C96Hands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'WP_Ger_C96_Mauser.Mesh.Ger_C96'
        PhysicsAsset=None
        AnimSets(0)=AnimSet'WP_Ger_C96_Mauser.animation.WP_C96Hands'
        Animations=AnimTree'WP_Ger_C96_Mauser.animation.Ger_C96_Tree'
        Scale=1.0
        FOV=70
    End Object

    // Pickup staticmesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'WP_3rd_Master.Mesh.C96_3rd_Master'
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

    AttachmentClass=class'ROPGameContent.ROPWeapAttach_C96_Pistol'
}
