class DRWeapAttach_SMLE_Rifle extends ROWeaponAttachment;

DefaultProperties
{
	CarrySocketName=WeaponSling
	ThirdPersonHandsAnim=LeeEnfield_Handpose // Included in CHR_LeeEnfield
	IKProfileName=MN9130

	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'DR_WP_UK_ENFIELD.Mesh.Enfield_3rd'
		AnimSets(0)=AnimSet'DR_WP_UK_ENFIELD.Anim.LeeEnfield_3rd_anim'
		CullDistance=5000
	End Object

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_round'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

	WeaponClass=class'DRWeap_SMLE_Rifle'

	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_VC_MN9130'
	bNoShellEjectOnFire=true

	CHR_AnimSet=AnimSet'DR_WP_UK_ENFIELD.Anim.CHR_LeeEnfield'

	FireAnim=Shoot
	FireLastAnim=Shoot_Last
	IdleAnim=Idle
	IdleEmptyAnim=Idle_Empty
}
