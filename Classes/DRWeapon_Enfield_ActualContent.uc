
class DRWeapon_Enfield_ActualContent extends DRWeapon_Enfield;

DefaultProperties
{
	ArmsAnimSet=AnimSet'DR_WP_UK_ENFIELD.Anim.WP_LeeEnfieldhands'
	
	Begin Object Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		SkeletalMesh=SkeletalMesh'DR_WP_UK_ENFIELD.Mesh.Enfield'
		PhysicsAsset=None
		AnimSets(0)=AnimSet'DR_WP_UK_ENFIELD.Anim.WP_LeeEnfieldhands'
		Animations=AnimTree'DR_WP_UK_ENFIELD.Anim.WP_LeeEnfieldHands_Tree'
		Scale=1.0
		FOV=70
	End Object
	
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'DR_WP_UK_ENFIELD.Mesh.Enfield_3rd'
		PhysicsAsset=PhysicsAsset'DR_WP_UK_ENFIELD.Phy.Enfield_Phy'
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
	
	AttachmentClass=class'DRWeapon_Enfield_Attach'
}
