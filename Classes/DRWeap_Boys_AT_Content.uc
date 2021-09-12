//=============================================================================
// DRWeap_Boys_AT_Content.uc
//=============================================================================
// Boys Anti-Tank Rifle (Content class).
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRWeap_Boys_AT_Content extends DRWeap_Boys_AT;

DefaultProperties
{
	ArmsAnimSet=AnimSet'DR_WEP_CW_BOYS.Anim.Boys_Hands'
	
	Begin Object Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		SkeletalMesh=SkeletalMesh'DR_WEP_CW_BOYS.Mesh.Boys_AT'
		PhysicsAsset=None
		AnimSets(0)=AnimSet'DR_WEP_CW_BOYS.Anim.Boys_Hands'
		Animations=AnimTree'DR_WEP_CW_BOYS.Anim.Boys_AnimTree'
		Scale=1.0
		FOV=70
	End Object
	
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'DR_WEP_CW_BOYS.Mesh.Boys_AT' //TODO: REPLACE WITH PROPER 3RD PERSON MODEL
		PhysicsAsset=None //TODO: REPLACE WITH PROPER PHYSASSET WHEN THE MODEL IS READY!
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
	
	AttachmentClass=class'ROGameContent.ROWeapAttach_MAT49_SMG' //TODO: REPLACE WITH PROPER ATTACHMENT CODE WHEN READY!
}
