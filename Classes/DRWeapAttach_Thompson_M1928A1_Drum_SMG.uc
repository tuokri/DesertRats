class DRWeapAttach_Thompson_M1928A1_Drum_SMG extends DRWeapAttach_Thompson_SMG;

DefaultProperties
{
    WeaponClass=class'DRWeap_Thompson_M1928A1_Drum_SMG'

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_UK_M1928A1.Mesh.Thompson_3rd_Master_UPGD3'
        AnimSets(0)=AnimSet'DR_WP_UK_M1928A1.Animation.Thompson_3rd_Anims_UPGD3'
        AnimTreeTemplate=AnimTree'DR_WP_UK_M1928A1.Animation.USA_M1928A1_AnimTree'
        Animations=NONE
        PhysicsAsset=PhysicsAsset'DR_WP_UK_M1928A1.Phy.Thompson_3rd_Master_UPGD2_Physics'
        CullDistance=5000
    End Object

    // TODO: is this correct?
    // ROPawn weapon specific animations
    CHR_AnimSet=AnimSet'CHR_VN_ARVN_Playeranim_Master.Weapons.CHR_M1Thompson'

    ReloadAnims(0)=Reload_Half
    ReloadAnims(1)=Reload_Half
    CH_ReloadAnims(0)=CH_Reload_Half
    CH_ReloadAnims(1)=CH_Reload_Half
    Prone_ReloadAnims(0)=Prone_Reload_Half
    Prone_ReloadAnims(1)=Prone_Reload_Half

    // Weapon animations
    WP_ReloadAnims(0)=Reload_Half
    WP_ReloadAnims(1)=Reload_Half
    WP_Prone_ReloadAnims(0)=Prone_Reload_Half
    WP_Prone_ReloadAnims(1)=Prone_Reload_Half

    // Firing animations
    FireAnim=Shoot
    FireLastAnim=Shoot
    IdleAnim=Idle
    IdleEmptyAnim=Idle

    HolsterWeaponAnim=Holster_M1928A1
    HolsterWeaponCrouchedAnim=CH_Holster_M1928A1

    HolsterWeaponIronAnim=Holster_iron_M1928A1
    HolsterWeaponCrouchedIronAnim=CH_Holster_iron_M1928A1

    EquipWeaponAnim=Pullout_M1928A1
    EquipWeaponCrouchedAnim=CH_Pullout_M1928A1

    EquipWeaponIronAnim=Pullout_iron_M1928A1
    EquipWeaponCrouchedIronAnim=CH_Pullout_iron_M1928A1
}
