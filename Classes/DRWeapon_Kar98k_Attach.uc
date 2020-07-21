
class DRWeapon_Kar98k_Attach extends ROWeapAttach_MN9130_Rifle;

defaultproperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'DR_WP_DAK_KAR98.Mesh.Kar98_3rd'
		AnimSets(0)=AnimSet'WP_VN_3rd_Master.Anim.MN9130_3rd_anim'
		AnimTreeTemplate=AnimTree'WP_VN_3rd_Master.AnimTree.MN9130_3rd_Tree'
		Animations=NONE
		PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy_Bounds.MN9130_3rd_Bounds_Physics'
		CullDistance=5000
	End Object
	
	WeaponClass=class'DRWeapon_Kar98k'
}
