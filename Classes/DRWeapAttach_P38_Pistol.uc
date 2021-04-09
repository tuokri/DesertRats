class DRWeapAttach_P38_Pistol extends ROWeaponAttachmentPistol;

var name WP_Crouch_ReloadAnims[2];

/**
 * Called when ROPawn.SimulatedWeaponEvent is modified.
 */
simulated function name GetReloadAnimName(ROPawn ROPOwner, bool bWeaponIsEmpty)
{
    if ( ROPOwner != None && ROPOwner.bIsProning )
    {
        return (bWeaponIsEmpty) ? WP_Prone_ReloadAnims[0] : WP_Prone_ReloadAnims[1];
    }

    if ( ROPOwner != None && ROPOwner.bIsCrouched )
    {
        return (bWeaponIsEmpty) ? WP_Crouch_ReloadAnims[0] : WP_Crouch_ReloadAnims[1];
    }

    return (bWeaponIsEmpty) ? WP_ReloadAnims[0] : WP_ReloadAnims[1];
}

DefaultProperties
{
    //? ImpactInfoClass=class'ROPImpactEffectInfo'

    ThirdPersonHandsAnim=Makarov_Handpose
    ThirdPersonHandsIronAnim=Makarov_Ironsight_Handpose

    IKProfileName=C96

    LeftHandJogBoneName=Left_Hand
    RightHandJogBoneName=Right_Hand
    LeftHandRussianSprintBoneName=Left_Hand
    RightHandRussianSprintBoneName=Right_Hand
    RightHandGermanSprintBoneName=Right_Hand

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_P38_Walther.Meshes_3rd.P38_3rd_RS2'
        // AnimSets(0)=AnimSet'DR_WP_DAK_P38_Walther.Anim.WP_P38_New'
        AnimSets(0)=AnimSet'WP_VN_3rd_Master_02.Anim.Makarov_Pistol_3rd_Anim'
        CullDistance=5000
    End Object

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Pistol'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'
    WeaponClass=class'DRWeap_P38_Pistol'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'RP_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_P38'

    // ROPawn weapon specific animations
    // CHR_AnimSet=AnimSet'DR_WP_DAK_P38_Walther.Anim.CHR_P38_New'
    CHR_AnimSet=AnimSet'CHR_VN_Playeranim_Master_02.Weapons.CHR_Makarov_Pistol'

    ReloadAnims(0)=Reload_Empty
    ReloadAnims(1)=Reload_Half
    CH_ReloadAnims(0)=CH_Reload_Empty
    CH_ReloadAnims(1)=CH_Reload_Half
    Prone_ReloadAnims(0)=Prone_Reload_Empty
    Prone_ReloadAnims(1)=Prone_Reload_Half

    WP_ReloadAnims(0)=Reload_Empty
    WP_ReloadAnims(1)=Reload_Half
    WP_Crouch_ReloadAnims(0)=CH_Reload_Empty
    WP_Crouch_ReloadAnims(1)=CH_Reload_Half
    WP_Prone_ReloadAnims(0)=Prone_Reload_Empty
    WP_Prone_ReloadAnims(1)=Prone_Reload_Half

    // Firing animations
    FireAnim=Shoot
    FireLastAnim=Shoot_Last
    IdleAnim=Idle
    IdleEmptyAnim=Idle_Empty
}
