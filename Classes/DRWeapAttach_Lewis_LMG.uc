class DRWeapAttach_Lewis_LMG extends ROWeaponAttachmentBipod;

defaultproperties
{
	TriggerHoldDuration=0.2

	CarrySocketName=WeaponSling
	ThirdPersonHandsAnim=DP28_Handpose
	IKProfileName=DP28

	// Weapon SkeletalMesh
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'DR_WP_UK_LEWIS.Mesh.Lewis_3rd'
		AnimTreeTemplate=AnimTree'WP_VN_3rd_Master.Animation.DP28_3rd_Tree'
		Animations=NONE
		AnimSets(0)=AnimSet'WP_VN_3rd_Master.Anim.DP28_3rd_anim'
		PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy_Bounds.DP28_3rd_Bounds_Physics'
		CullDistance=5000
	End Object

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_round'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'RORifleMuzzleFlashLight'
	WeaponClass=class'DRWeap_Lewis_LMG'

	// Shell eject FX
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_VC_DP28'

	// Tracer FX
	TracerClass=class'DP28BulletTracer'
	TracerFrequency=5

	// ROPawn weapon specific animations
	CHR_AnimSet=AnimSet'CHR_VN_Playeranim_Master.Weapons.CHR_DP28'

	// Firing animations
	FireAnim=Shoot
	FireLastAnim=Shoot_Last
	IdleAnim=Idle
	IdleEmptyAnim=Idle_Empty
}
