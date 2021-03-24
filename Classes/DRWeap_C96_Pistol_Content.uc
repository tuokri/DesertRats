class DRWeap_C96_Pistol_Content extends DRWeap_C96_Pistol;

DefaultProperties
{
    //Arms
    ArmsAnimSet=AnimSet'DR_WP_DAK_C96_Mauser.Animation.WP_C96Hands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_C96_Mauser.Mesh.Ger_C96'
        PhysicsAsset=None
        AnimSets(0)=AnimSet'DR_WP_DAK_C96_Mauser.Animation.WP_C96Hands'
        Animations=AnimTree'DR_WP_DAK_C96_Mauser.Animation.Ger_C96_Tree'
        Scale=1.0
        FOV=70
    End Object

    // Pickup staticmesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_C96_Mauser.Meshes.C96_UPGD1_New'
        PhysicsAsset=PhysicsAsset'DR_WP_DAK_C96_Mauser.Phys.C96_3rd_RS2_Physics'
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

    AttachmentClass=class'DRWeapAttach_C96_Pistol'
}
