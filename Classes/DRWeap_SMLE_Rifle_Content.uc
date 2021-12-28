class DRWeap_SMLE_Rifle_Content extends DRWeap_SMLE_Rifle;

DefaultProperties
{
	ArmsAnimSet=AnimSet'DR_WP_UK_ENFIELD.Anim.SMLE_Anim'

	Begin Object Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		SkeletalMesh=SkeletalMesh'DR_WP_UK_ENFIELD.Mesh.SMLE_1p'
		PhysicsAsset=None
		AnimSets(0)=AnimSet'DR_WP_UK_ENFIELD.Anim.SMLE_Anim'
		// AnimSets(1)=AnimSet'DR_WP_UK_ENFIELD.Anim.WP_LeeEnfieldBayonetHands'
		Animations=AnimTree'DR_WP_UK_ENFIELD.Anim.SMLE_AnimTree'
		Scale=1.0
		FOV=70
	End Object

	// TODO: new 3rd person mesh.
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'DR_WP_UK_ENFIELD.Mesh.Enfield_3rd'
		PhysicsAsset=PhysicsAsset'DR_WP_UK_ENFIELD.Phy.Enfield_new_Physics'
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

	AttachmentClass=class'DRWeapAttach_SMLE_Rifle'
}
