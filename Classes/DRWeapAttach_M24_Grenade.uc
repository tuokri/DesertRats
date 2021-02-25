class DRWeapAttach_M24_Grenade extends ROWeapAttach_StickGrenade;

DefaultProperties
{
    ImpactInfoClass=class'ROPImpactEffectInfo'

    ThirdPersonHandsAnim=M1939_Grenade_Handpose
    IKProfileName=F1

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'WP_3rd_Master.Mesh.M1939_Grenade_3rd_Master'
        CullDistance=5000
    End Object

    WeaponClass=class'DRWeap_M1939_Grenade'
}
