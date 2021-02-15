class DRWeapAttach_Mills_Grenade extends ROWeapAttach_EggGrenade;

DefaultProperties
{
    ThirdPersonHandsAnim=F1_Grenade_Handpose // TODO: M61_Grenade_Handpose?
    IKProfileName=F1

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_UK_MillsBomb.Mesh.MillsBomb_3rd'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy_Bounds.M61Grenade_3rd_Bounds_Physics'
        CullDistance=5000
    End Object

    WeaponClass=class'DRWeap_Mills_Grenade'
}
