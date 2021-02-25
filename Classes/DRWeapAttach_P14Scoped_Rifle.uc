class DRWeapAttach_P14Scoped_Rifle extends ROSniperWeaponAttachment;

DefaultProperties
{
    CarrySocketName=WeaponSling
    ThirdPersonHandsAnim=M40_Handpose
    IKProfileName=MN9130

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_UK_P14.Mesh.P14_3rd'
        AnimSets(0)=AnimSet'WP_VN_3rd_Master.Anim.M40_3rd_Anims'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy_Bounds.M40_3rd_Bounds_Physics'
        CullDistance=5000
    End Object

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_round'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'
    WeaponClass=class'DRWeap_P14Scoped_Rifle'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_US_M40'
    bNoShellEjectOnFire=true

    // ROPawn weapon specific animations
    CHR_AnimSet=AnimSet'CHR_VN_Playeranim_Master.Weapons.CHR_M40'

    // Firing animations
    FireAnim=Shoot
    FireLastAnim=Shoot_Last
    IdleAnim=Idle
    IdleEmptyAnim=Idle_Empty

    // Weapon animations
    WP_ReloadAnims(0)=Reload_Half
    WP_ReloadAnims(1)=Reload_Single
    WP_Prone_ReloadAnims(0)=Prone_Reload_Half
    WP_Prone_ReloadAnims(1)=Prone_Reload_Single
    // Player animations - Weapon Actions
    ReloadAnims(0)=Reload_Half
    ReloadAnims(1)=Reload_Single
    CH_ReloadAnims(0)=CH_Reload_Half
    CH_ReloadAnims(1)=CH_Reload_Single
    Prone_ReloadAnims(0)=Prone_Reload_Half
    Prone_ReloadAnims(1)=Prone_Reload_Single
}
