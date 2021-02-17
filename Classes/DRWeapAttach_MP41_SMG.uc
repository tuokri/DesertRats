class DRWeapAttach_MP41_SMG extends ROWeaponAttachment;

DefaultProperties
{
    WeaponClass=class'DRWeap_MP41_SMG'

    CarrySocketName=WeaponSling
    ThirdPersonHandsAnim=MP40_Handpose
    IKProfileName=MAT49

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_MP41.Mesh.MP41_3rd'
        AnimSets(0)=AnimSet'WP_VN_3rd_Master_03.Anim.MP40_3rd_Anim'
        AnimTreeTemplate=AnimTree'WP_VN_3rd_Master_03.AnimTree.MP40_SMG_3rd_Tree'
        Animations=NONE
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master_03.Phy_Bounds.MP40_3rd_Bounds_Physics'
        CullDistance=5000
    End Object

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_SMG'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_VC_MAT49_9mm'

    // ROPawn weapon specific animations
    CHR_AnimSet=AnimSet'CHR_VN_Playeranim_Master_03.Weapons.CHR_MP40'

    // Firing animations
    FireAnim=Shoot
    FireLastAnim=Shoot_Last
    IdleAnim=Idle
    IdleEmptyAnim=Idle_Empty

    HolsterWeaponAnim=Holster_MP40
    HolsterWeaponCrouchedAnim=CH_Holster_MP40

    HolsterWeaponIronAnim=Holster_iron_MP40
    HolsterWeaponCrouchedIronAnim=CH_Holster_iron_MP40

    EquipWeaponAnim=Pullout_MP40
    EquipWeaponCrouchedAnim=CH_Pullout_MP40

    EquipWeaponIronAnim=Pullout_iron_MP40
    EquipWeaponCrouchedIronAnim=CH_Pullout_iron_MP40

    //Add_HolsterWeaponAnim=ADD_Holster_rifle_idle
    //Add_HolsterWeaponIronAnim=ADD_Holster_rifle_iron
}
