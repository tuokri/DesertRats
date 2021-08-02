class DRWeap_Thompson_M1928A1_SMG_Content extends DRWeap_Thompson_M1928A1_SMG;

DefaultProperties
{
    AttachmentClass=class'DRWeapAttach_Thompson_M1928A1_SMG'

    WeaponFireLastAnim=Thompson_shoot // KEEP THIS ONE! WE DON'T WANT THE BOLT LOCKING BACK EVER ~adrian

    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_UK_M1928A1.Mesh.M1928A1_Thompson'
        PhysicsAsset=PhysicsAsset'DR_WP_UK_M1928A1.Phy.M1928A1_Thompson_Physics'
        AnimSets(0)=AnimSet'WP_VN_ARVN_ThompsonM1A1_SMG.Animation.WP_M1A1ThompsonHands'
        AnimTreeTemplate=AnimTree'WP_VN_ARVN_ThompsonM1A1_SMG.Animation.ARVN_M1Thompson_AnimTree'
        Scale=1.0
        FOV=70
    End Object

    ArmsAnimSet=AnimSet'WP_VN_ARVN_ThompsonM1A1_SMG.Animation.WP_M1A1ThompsonHands'

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_UK_M1928A1.Mesh.Thompson_3rd_Master_UPGD2'
        PhysicsAsset=PhysicsAsset'DR_WP_UK_M1928A1.Phy.Thompson_3rd_Master_UPGD2_Physics'
        AnimTreeTemplate=AnimTree'WP_VN_ARVN_3rd_Master.AnimTree.M1Thompson_SMG_3rd_Tree'
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
}
