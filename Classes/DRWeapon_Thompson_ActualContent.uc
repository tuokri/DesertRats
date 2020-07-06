
class DRWeapon_Thompson_ActualContent extends DRWeapon_Thompson;

DefaultProperties
{
	Begin Object Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		SkeletalMesh=SkeletalMesh'WP_VN_ARVN_ThompsonM1A1_SMG.Mesh.ARVN_M1A1_Thompson'
		PhysicsAsset=PhysicsAsset'WP_VN_ARVN_ThompsonM1A1_SMG.Phys.M1A1_Thompson_Physics'
		AnimSets(0)=AnimSet'WP_VN_ARVN_ThompsonM1A1_SMG.Animation.WP_M1A1ThompsonHands'
		AnimTreeTemplate=AnimTree'WP_VN_ARVN_ThompsonM1A1_SMG.Animation.ARVN_M1Thompson_AnimTree'
		Scale=1.0
		FOV=70
	End Object
	
	ArmsAnimSet=AnimSet'WP_VN_ARVN_ThompsonM1A1_SMG.Animation.WP_M1A1ThompsonHands'
	
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_VN_ARVN_3rd_Master.Mesh.M1A1_Thompson_3rd_Master'
		PhysicsAsset=PhysicsAsset'WP_VN_ARVN_3rd_Master.Phys.M1A1_Thompson_3rd_Master_Physics'
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
	
	AttachmentClass=class'DRWeapon_Thompson_Attach'
	
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Loop_3P', FirstPersonCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Auto_LP')
	WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue= AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Single_3P', FirstPersonCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Fire_Single')
	
	bLoopingFireSnd(DEFAULT_FIREMODE)=true
	WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Tail_3P', FirstPersonCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Auto_Tail')
	bLoopHighROFSounds(DEFAULT_FIREMODE)=true
}
