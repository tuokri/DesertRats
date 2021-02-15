class DRWeap_Mills_Grenade_Content extends DRWeap_Mills_Grenade;

DefaultProperties
{
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_UK_MillsBomb.Mesh.MillsBomb'
        PhysicsAsset=None
        AnimSets(0)=AnimSet'DR_WP_UK_MillsBomb.Anim.WP_MillsBombhands'
        Animations=AnimTree'DR_WP_UK_MillsBomb.Anim.MillsBomb_Tree'
        Scale=1.0
        FOV=70
    End Object

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_UK_MillsBomb.Mesh.MillsBomb_3rd'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Projectile.Phy.M61Grenade_Projectile_3rd_Physics'
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

    AttachmentClass=class'DRWeapAttach_Mills_Grenade'

    ArmsAnimSet=AnimSet'DR_WP_UK_MillsBomb.Anim.WP_MillsBombhands'
}
