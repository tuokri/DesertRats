class DRWeap_Mills_Grenade_Content extends DRWeap_Mills_Grenade;

simulated function SetupArmsAnim()
{
    super.SetupArmsAnim();

    // ArmsMesh.AnimSets has slots 0-2-3 filled, so we need to back fill slot 1 and then move to slot 4
    ROPawn(Instigator).ArmsMesh.AnimSets[1] = SkeletalMeshComponent(Mesh).AnimSets[0];
    ROPawn(Instigator).ArmsMesh.AnimSets[4] = SkeletalMeshComponent(Mesh).AnimSets[1];
}

DefaultProperties
{
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_UK_MillsBomb.Mesh.MillsBomb'
        PhysicsAsset=None
        AnimSets(0)=AnimSet'WP_VN_USA_M61_Grenade.Animation.WP_M61GrenadeHands'
        AnimSets(1)=AnimSet'DR_WP_UK_MillsBomb.Anim.Mills_Anim'
        AnimTreeTemplate=AnimTree'WP_VN_USA_M61_Grenade.Animation.USA_M61_Tree'
        Scale=1.0
        FOV=70
    End Object

    WeaponPullPinAnim=Mills_pullpin // new pin anim ~ @adrian

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_UK_MillsBomb.Mesh.MillsBomb_3rd'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy.M61Grenade_3rd_Physics'
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

    ArmsAnimSet=AnimSet'WP_VN_USA_M61_Grenade.Animation.WP_M61GrenadeHands'
}
