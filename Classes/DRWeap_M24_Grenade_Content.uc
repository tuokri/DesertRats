class DRWeap_M24_Grenade_Content extends DRWeap_M24_Grenade;

DefaultProperties
{
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_M24_Grenade.Mesh.Ger_Granate'
        PhysicsAsset=None
        AnimSets(0)=AnimSet'DR_WP_DAK_M24_Grenade.Animation.WP_GranateHands'
        Animations=AnimTree'DR_WP_DAK_M24_Grenade.Animation.Ger_M1939_Tree'
        Scale=1.0
        FOV=70
    End Object

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_M24_Grenade.Mesh.M1939_Grenade_3rd_Master'
        PhysicsAsset=PhysicsAsset'DR_WP_DAK_M24_Grenade.Phy.M24_Grenade_Physics'
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

    AttachmentClass=class'DRWeapAttach_M24_Grenade'

    ArmsAnimSet=AnimSet'DR_WP_DAK_M24_Grenade.Animation.WP_GranateHands'
}
