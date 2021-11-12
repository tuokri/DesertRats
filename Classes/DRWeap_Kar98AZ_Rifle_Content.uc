class DRWeap_Kar98AZ_Rifle_Content extends DRWeap_Kar98_Rifle;

/*
simulated function SetupArmsAnim()
{
    super.SetupArmsAnim();

    // ArmsMesh.AnimSets has slots 0-2-3 filled, so we need to back fill slot 1 and then move to slot 4
    ROPawn(Instigator).ArmsMesh.AnimSets[1] = SkeletalMeshComponent(Mesh).AnimSets[0];
    ROPawn(Instigator).ArmsMesh.AnimSets[4] = SkeletalMeshComponent(Mesh).AnimSets[1];
}
*/

DefaultProperties
{
    ArmsAnimSet=AnimSet'DR_WP_DAK_KAR98.Anim.WP_K98Hands'

    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_KAR98AZ.Mesh.Ger_K98AZ'
        AnimSets(0)=AnimSet'DR_WP_DAK_KAR98.Anim.WP_K98Hands'
        //? AnimSets(1)=AnimSet'DR_WP_DAK_KAR98.Anim.WP_Kar98BayoAnims'
        AnimTreeTemplate=AnimTree'DR_WP_DAK_KAR98.Anim.Ger_Kar98_Tree'
        PhysicsAsset=PhysicsAsset'DR_WP_DAK_KAR98AZ.Phy.Ger_K98AZ_BOUNDS_Physics'
        Scale=1.0
        FOV=70
    End Object

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_KAR98AZ.Mesh.KAR98AZ_3rd'
        PhysicsAsset=PhysicsAsset'DR_WP_DAK_KAR98AZ.Phy.KAR98AZ_3rd_Physics'
        AnimTreeTemplate=AnimTree'WP_VN_3rd_Master.AnimTree.MN9130_3rd_Tree'
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=true
        BlockNonZeroExtent=true
        BlockRigidBody=true
        bHasPhysicsAssetInstance=false
        bUpdateKinematicBonesFromAnimation=false
        PhysicsWeight=1.0
        RBChannel=RBCC_GameplayPhysics
        RBCollideWithChannels=(Default=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
        bSkipAllUpdateWhenPhysicsAsleep=TRUE
        bSyncActorLocationToRootRigidBody=true
    End Object

    AttachmentClass=class'DRWeapAttach_Kar98AZ_Rifle'
}
