class DRWeapAttach_Dynamite extends ROWeaponAttachmentSatchel;

DefaultProperties
{
    ThirdPersonHandsAnim=Soviet_Satchel_HandPose
    IKProfileName=F1

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_Dynamite.Mesh.Dynamite_3rd'
        CullDistance=5000
    End Object

    WeaponClass=class'DRWeap_Dynamite'
}
