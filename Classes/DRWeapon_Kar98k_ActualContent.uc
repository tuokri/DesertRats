
class DRWeapon_Kar98k_ActualContent extends DRWeapon_Kar98k;

simulated function SetupArmsAnim()
{
	super.SetupArmsAnim();
	
	// ArmsMesh.AnimSets has slots 0-2-3 filled, so we need to back fill slot 1 and then move to slot 4
	ROPawn(Instigator).ArmsMesh.AnimSets[1] = SkeletalMeshComponent(Mesh).AnimSets[0];
	ROPawn(Instigator).ArmsMesh.AnimSets[4] = SkeletalMeshComponent(Mesh).AnimSets[1];
}

DefaultProperties
{
	ArmsAnimSet=AnimSet'DR_WP_DAK_KAR98.Anim.WP_Kar98Hands'
	
	Begin Object Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		SkeletalMesh=SkeletalMesh'DR_WP_DAK_KAR98.Mesh.Kar98'
		AnimSets(0)=AnimSet'DR_WP_DAK_KAR98.Anim.WP_Kar98Hands'
		AnimSets(1)=AnimSet'DR_WP_DAK_KAR98.Anim.WP_Kar98BayoAnims'
		AnimTreeTemplate=AnimTree'DR_WP_DAK_KAR98.Anim.Ger_Kar98_Tree_Bayonet'
		Scale=1.0
		FOV=70
	End Object
	
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'DR_WP_DAK_KAR98.Mesh.Kar98_3rd'
		PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy.MN9130_3rd_Master_Physics'
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
	
	AttachmentClass=class'DRWeapon_Kar98k_Attach'
}