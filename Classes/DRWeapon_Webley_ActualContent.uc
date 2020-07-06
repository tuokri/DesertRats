
class DRWeapon_Webley_ActualContent extends DRWeapon_Webley;

DefaultProperties
{
	ArmsAnimSet=AnimSet'DR_WP_UK_WEBLEY.Anim.UK_Webley_Anims'
	
	Begin Object Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		SkeletalMesh=SkeletalMesh'DR_WP_UK_WEBLEY.Mesh.UK_Webley'
		PhysicsAsset=None
		AnimSets(0)=AnimSet'DR_WP_UK_WEBLEY.Anim.UK_Webley_Anims'
		AnimTreeTemplate=AnimTree'DR_WP_UK_WEBLEY.Anim.UK_Webley_AnimTree'
		Scale=1.0
		FOV=70
	End Object
	
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_VN_3rd_Master_02.Mesh.M1917_SW_3rd_Master'
		PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master_02.Phy.M1917_SW_3rd_Physics'
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
	
	AttachmentClass=class'DRWeapon_Webley_Attach'
	
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1917.Play_WEP_M1917_Single_3P', FirstPersonCue=AkEvent'WW_WEP_M1917.Play_WEP_M1917_Fire_Single')
	WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1917.Play_WEP_M1917_Single_3P', FirstPersonCue=AkEvent'WW_WEP_M1917.Play_WEP_M1917_Fire_Single')
}
