
class DRWeapon_Webley_ActualContent extends DRWeapon_Webley;

DefaultProperties
{
	ArmsAnimSet=AnimSet'WinterWar_WP_SOV_REVOLVER.Anim.NagantRevolver_Hands'
	
	Begin Object Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		SkeletalMesh=SkeletalMesh'WinterWar_WP_SOV_REVOLVER.Mesh.Nagant_Revolver'
		PhysicsAsset=None
		AnimSets(0)=AnimSet'WinterWar_WP_SOV_REVOLVER.Anim.NagantRevolver_Hands'
		AnimTreeTemplate=AnimTree'WinterWar_WP_SOV_REVOLVER.Anim.Sov_M1895_Tree'
		Scale=1.0
		FOV=70
	End Object
	
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WinterWar_WP_SOV_REVOLVER.Mesh.Nagant_Revolver_3rd_Master'
		PhysicsAsset=PhysicsAsset'WinterWar_WP_SOV_REVOLVER.Phy.Nagant_Revolver_3rd_phy'
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
