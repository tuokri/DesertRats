
class DRWeapon_Binoculars_ActualContent extends DRWeapon_Binoculars;

DefaultProperties
{
	Begin Object Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		SkeletalMesh=SkeletalMesh'WP_VN_VC_Binoculars.Mesh.Sov_Binocs'
		PhysicsAsset=PhysicsAsset'WP_VN_VC_Binoculars.Phys.Sov_Binocs_Physics'
		AnimSets(0)=AnimSet'WP_VN_VC_Binoculars.Anim.WP_BinocsHands'
		AnimTreeTemplate=AnimTree'WP_VN_VC_Binoculars.Anim.Sov_Binocs_Tree'
		Scale=1.0
		FOV=70
	End Object
	
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_VN_VC_Binoculars.Mesh.Sov_Binocs'
		PhysicsAsset=PhysicsAsset'WP_VN_VC_Binoculars.Phys.Sov_Binocs_Physics2'
		AnimTreeTemplate=AnimTree'WP_VN_VC_Binoculars.Anim.Sov_Binocs_Tree'
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true//false
		BlockRigidBody=true
		bHasPhysicsAssetInstance=false//true
		bUpdateKinematicBonesFromAnimation=false
		PhysicsWeight=1.0
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
		bSkipAllUpdateWhenPhysicsAsleep=TRUE
		bSyncActorLocationToRootRigidBody=true
	End Object
	
	AttachmentClass=class'DRWeapon_Binoculars_Attach'
	
	ArmsAnimSet=AnimSet'WP_VN_VC_Binoculars.Anim.WP_BinocsHands'
	
	BinocOverlayTexture=Texture2D'WP_VN_VC_Binoculars.Materials.BINOC_overlay'
}
