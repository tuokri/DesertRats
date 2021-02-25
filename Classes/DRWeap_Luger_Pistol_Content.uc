class DRWeap_Luger_Pistol_Content extends DRWeap_Luger_Pistol;

DefaultProperties
{
	ArmsAnimSet=AnimSet'DR_WP_DAK_LUGER.Anim.Luger_Anims'

	Begin Object Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		SkeletalMesh=SkeletalMesh'DR_WP_DAK_LUGER.Mesh.FIN_Luger'
		PhysicsAsset=PhysicsAsset'DR_WP_DAK_LUGER.Phy.Luger_Physics'
		AnimSets(0)=AnimSet'DR_WP_DAK_LUGER.Anim.Luger_Anims'
		AnimTreeTemplate=AnimTree'DR_WP_DAK_LUGER.Anim.Luger_AnimTree'
		Scale=1.0
		FOV=70
	End Object

	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'DR_WP_DAK_LUGER.Mesh.FIN_Luger_3rd'
		PhysicsAsset=PhysicsAsset'WP_VN_AUS_3rd_Master.Phy.Browning_HP_3rd_Physics'
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

	AttachmentClass=class'DRWeapAttach_Luger_Pistol'

	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_BHP.Play_WEP_BHP_Fire_Single_3P', FirstPersonCue=AkEvent'WW_WEP_BHP.Play_WEP_BHP_Fire_Single')
}
