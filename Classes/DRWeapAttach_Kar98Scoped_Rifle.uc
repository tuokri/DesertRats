class DRWeapAttach_Kar98Scoped_Rifle extends ROSniperWeaponAttachment;

DefaultProperties
{
    CarrySocketName=WeaponSling
    ThirdPersonHandsAnim=Kar98_Handpose
    IKProfileName=Kar98

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_KAR98.Mesh.Kar98_Sniper_3rd'
        AnimSets(0)=AnimSet'DR_WP_DAK_KAR98.Anim.Kar98sniper_3rd_anim'
        //? AnimTreeTemplate=AnimTree'DR_WP_DAK_KAR98.Anim.Ger_Kar98_Tree_Bayonet'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy_Bounds.MN9130_Sniper_3rd_Bounds_Physics'
        CullDistance=5000
    End Object

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_round'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'
    WeaponClass=class'DRWeap_Kar98Scoped_Rifle'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_VC_MN9130'
    bNoShellEjectOnFire=true

    // ROPawn weapon specific animations
    CHR_AnimSet=AnimSet'CHR_Playeranim_Master.Weapons.CHR_K98'

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
