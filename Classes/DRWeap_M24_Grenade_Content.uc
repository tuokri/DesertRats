class DRWeap_M24_Grenade_Content extends DRWeap_M24_Grenade;

DefaultProperties
{
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'WP_Ger_M1939_granate.Mesh.Ger_Granate'
        PhysicsAsset=None
        AnimSets(0)=AnimSet'WP_Ger_M1939_granate.animation.WP_GranateHands'
        Animations=AnimTree'WP_Ger_M1939_granate.animation.Ger_M1939_Tree'
        Scale=1.0
        FOV=70
    End Object

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'WP_3rd_Master.Mesh.M1939_Grenade_3rd_Master'
        PhysicsAsset=PhysicsAsset'WP_3rd_Master.Phy.M1939_Grenade_3rd_Master_Physics'
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

    ArmsAnimSet=AnimSet'WP_Ger_M1939_granate.animation.WP_GranateHands'
}
