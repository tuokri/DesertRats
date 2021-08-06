class DRWeapAttach_M39_Grenade extends ROWeapAttach_EggGrenade;

DefaultProperties
{
    ThirdPersonHandsAnim=M61_Grenade_Handpose
    IKProfileName=F1

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_M39.Mesh.M39_3rd'
        PhysicsAsset=PhysicsAsset'DR_WP_DAK_M39.Phy.M39_1st_Physics'
        CullDistance=5000
    End Object

    WeaponClass=class'DRWeap_M39_Grenade'
}
