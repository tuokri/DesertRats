class DRWeapAttach_Bren_LMG extends ROWeaponAttachmentBipod;

// Temporary solution for Bren 3rd person left hand weirdness.
var SkelControlSingleBone LeftHandYawController;

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super.PostInitAnimTree(SkelComp);

    LeftHandYawController = SkelControlSingleBone(Mesh.FindSkelControl('HandYawControl'));
    SetLeftHandYaw(1);
}

simulated function SetLeftHandYaw(float YawValue, optional float InBlendTime = 0)
{
    if (LeftHandYawController != None)
    {
        LeftHandYawController.SetSkelControlStrength(YawValue, InBlendTime);
    }
}

simulated function RestoreHeftLandYaw()
{
    SetLeftHandYaw(1, 0.1);
}

simulated function PlayReloadAnimation(ROPawn ROPOwner, float ProficiencyMod, bool bWeaponIsEmpty)
{
    local name PlayedAnimName;
    local float Duration;

    PlayedAnimName = GetReloadAnimName(ROPOwner, bWeaponIsEmpty);
    Duration = ProficiencyMod * Mesh.GetAnimLength(PlayedAnimName);

    SetLeftHandYaw(0, 0.1);
    Mesh.PlayAnim(PlayedAnimName, Duration,, false);
    SetTimer(Duration, False, 'RestoreHeftLandYaw');
}

DefaultProperties
{
    TriggerHoldDuration=0.2

    CarrySocketName=WeaponSling
    ThirdPersonHandsAnim=Bren_handpose
    IKProfileName=MG34

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_UK_BREN.Mesh.BrenMk2_3rd_Master'
        Animations=AnimTree'DR_WP_UK_BREN.Animation.BrenM2_3rd_Tree'
        AnimSets(0)=AnimSet'DR_WP_UK_BREN.Animation.BrenMk2_3rd_anim'
        CullDistance=5000
    End Object

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_WEP_Gun.FX_WEP_Gun_A_Rifle_MuzzleFlash'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'RORifleMuzzleFlashLight'
    WeaponClass=class'DRWeap_Bren_LMG'

    // TODO: Shell eject FX
    // ShellEjectSocket=ShellEjectSocket
    // ShellEjectPSCTemplate=ParticleSystem'FX_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_MG34'

    // TODO: Tracer FX
    // TracerClass=class'BrenBulletTracer'
    // TracerFrequency=10

    // ROPawn weapon specific animations
    CHR_AnimSet=AnimSet'DR_WP_UK_BREN.Animation.CHR_BrenMk2'

    // Firing animations
    FireAnim=Shoot
    FireLastAnim=Shoot_Last
    IdleAnim=Idle
    IdleEmptyAnim=Idle_Empty
}
