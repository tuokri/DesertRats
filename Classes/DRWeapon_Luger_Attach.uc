
class DRWeapon_Luger_Attach extends ROWeapAttach_BHP_Pistol;

defaultproperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'DR_WP_DAK_LUGER.Mesh.FIN_Luger_3rd'
		AnimSets(0)=AnimSet'WP_VN_AUS_3rd_Master.Animation.Browning_HP_3rd_Anim'
		PhysicsAsset=PhysicsAsset'WP_VN_AUS_3rd_Master.Phy_Bounds.Browning_HP_3rd_Bounds_Physics'
		CullDistance=5000
	End Object
	
	WeaponClass=class'DRWeapon_Luger'
	
	ReloadAnims(0)=Reload_Half
	CH_ReloadAnims(0)=CH_Reload_Half
	Prone_ReloadAnims(0)=Prone_Reload_Half
}
