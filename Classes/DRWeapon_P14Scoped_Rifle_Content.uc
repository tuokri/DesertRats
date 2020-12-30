class DRWeapon_P14Scoped_Rifle_Content extends DRWeapon_P14Scoped_Rifle;

DefaultProperties
{
    //Arms
    ArmsAnimSet=AnimSet'WP_VN_USA_M40.Animation.WP_M40Hands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_UK_P14.Mesh.P14'
        PhysicsAsset=PhysicsAsset'WP_VN_USA_M40.Phys.USA_M40_Physics'
        AnimSets(0)=AnimSet'WP_VN_USA_M40.Animation.WP_M40Hands'
        AnimTreeTemplate=AnimTree'WP_VN_USA_M40.Animation.USA_M40_Tree'
        Scale=1.0
        FOV=70
    End Object

    // Pickup staticmesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_UK_P14.Mesh.P14_3rd'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy.M40_3rd_Master_Physics'
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

    AttachmentClass=class'DRWeapAttach_P14Scoped_Rifle'

    ScopeLenseMICTemplate=MaterialInstanceConstant'DR_WP_UK_P14.MIC.P14_LenseMat'
}
