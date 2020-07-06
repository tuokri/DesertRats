
class DRWeapon_Webley_Attach extends ROWeaponAttachmentPistol;

defaultproperties
{
	ThirdPersonHandsAnim=M1917_Handpose
	IKProfileName=C96
	
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_VN_3rd_Master_02.Mesh.M1917_SW_3rd_Master'
		AnimSets(0)=AnimSet'WP_VN_3rd_Master_02.Anim.M1917_SW_3rd_Anim'
		PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master_02.Phy_Bounds.M1917_SW_3rd_Bounds_Physics'
		CullDistance=5000
	End Object
	
	CHR_AnimSet=AnimSet'CHR_VN_Playeranim_Master_02.Weapons.CHR_M1917_SW'
	
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Pistol'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'
	
	WeaponClass=class'DRWeapon_Webley'
	
	FireAnim=Shoot
	FireLastAnim=Shoot_Last
	IdleAnim=Idle
	IdleEmptyAnim=Idle_Empty
}
