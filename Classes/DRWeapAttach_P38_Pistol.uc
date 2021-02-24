class DRWeapAttach_P38_Pistol extends ROPWeaponAttachmentPistol;

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
    ImpactInfoClass=class'ROPImpactEffectInfo'

    ThirdPersonHandsAnim=P38_HandPose
    IKProfileName=C96

    LeftHandStandingBoneName=Left_Hand_Standing;

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'WP_WW2_3rd_Master.Meshes.P38_New'
        AnimSets(0)=AnimSet'WP_WW2_3rd_Master.Anim.WP_P38_New'
        CullDistance=5000
    End Object

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Pistol'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'
    WeaponClass=class'ROPWeap_P38_Pistol'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'RP_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_P38'

    // ROPawn weapon specific animations
    CHR_AnimSet=AnimSet'WP_WW2_3rd_Master.Anim.CHR_P38_New'

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
