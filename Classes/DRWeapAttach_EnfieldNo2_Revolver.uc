class DRWeapAttach_EnfieldNo2_Revolver extends ROWeaponAttachmentPistol;

DefaultProperties
{
    ThirdPersonHandsAnim=M1917_Handpose
    IKProfileName=C96

    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_UK_WEBLEY.Mesh.UK_Webley_3rd'
        AnimSets(0)=AnimSet'WP_VN_3rd_Master_02.Anim.M1917_SW_3rd_Anim'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master_02.Phy_Bounds.M1917_SW_3rd_Bounds_Physics'
        CullDistance=5000
    End Object

    CHR_AnimSet=AnimSet'CHR_VN_Playeranim_Master_02.Weapons.CHR_M1917_SW'

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Pistol'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

    WeaponClass=class'DRWeap_Webley_Revolver'

    FireAnim=Shoot
    FireLastAnim=Shoot_Last
    IdleAnim=Idle
    IdleEmptyAnim=Idle_Empty
}
