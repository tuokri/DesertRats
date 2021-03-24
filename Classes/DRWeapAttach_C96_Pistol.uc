class DRWeapAttach_C96_Pistol extends ROWeaponAttachmentPistol;

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

defaultproperties
{
    ImpactInfoClass=class'ROPImpactEffectInfo'
    ThirdPersonHandsAnim=C96_Handpose
    IKProfileName=C96

    LeftHandStandingBoneName=Left_Hand_Standing;

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_C96_Mauser.Meshes.C96_UPGD1_New'
        AnimSets(0)=AnimSet'DR_WP_DAK_C96_Mauser.Anim_3rd.WP_C96_UPGD1'
        CullDistance=5000
    End Object

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Pistol'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'
    WeaponClass=class'DRWeap_C96_Pistol'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'RP_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_C96'

    // ROPawn weapon specific animations
    CHR_AnimSet=AnimSet'DR_WP_DAK_C96_Mauser.Anim_3rd.CHR_C96_UPGD1'

    WP_Crouch_ReloadAnims(0)=CH_Reload_Empty
    WP_Crouch_ReloadAnims(1)=CH_Reload_Empty

    // Firing animations
    FireAnim=Shoot
    FireLastAnim=Shoot_Last
    IdleAnim=Idle
    IdleEmptyAnim=Idle_Empty
}
