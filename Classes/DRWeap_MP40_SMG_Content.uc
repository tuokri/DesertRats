class DRWeap_MP40_SMG_Content extends DRWeap_MP40_SMG;

DefaultProperties
{
	ArmsAnimSet=AnimSet'WP_VN_VC_MP40.Animation.WP_MP40hands'

	WeaponReloadEmptyMagAnim=MP40_reloadempty_NEW

	Begin Object Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		SkeletalMesh=SkeletalMesh'WP_VN_VC_MP40.Mesh.VC_MP40'
		PhysicsAsset=PhysicsAsset'WP_VN_VC_MP40.Phys.VC_MP40_Physics'
		AnimSets(0)=AnimSet'WP_VN_VC_MP40.Animation.WP_MP40hands'
		AnimSets(1)=AnimSet'DR_WP_DAK_MP41.Animation.mp40_anim' // animations by hoover ~ @adrian
		AnimTreeTemplate=AnimTree'WP_VN_VC_MP40.Animation.VC_MP40_Tree'
		Scale=1.0
		FOV=70
	End Object

	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_VN_3rd_Master_03.Mesh.MP40_3rd_Master'
		PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master_03.Phy.MP40_3rd_Physics'
		AnimTreeTemplate=AnimTree'WP_VN_3rd_Master_03.AnimTree.MP40_SMG_3rd_Tree'
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

	AttachmentClass=class'DRWeapAttach_MP40_SMG'
}
