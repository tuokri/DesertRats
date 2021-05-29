class DRWeapAttach_MG42_LMG extends ROWeaponAttachmentBipod;

DefaultProperties
{
    //? ImpactInfoClass=class'ROPImpactEffectInfo'

    TriggerHoldDuration=0.2

    CarrySocketName=WeaponSling
    ThirdPersonHandsAnim=MG42_Handpose
    IKProfileName=MG34

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'WP_3rd_Master.Mesh.MG42_3rd_Master'
        Animations=AnimTree'WP_3rd_Master.Animation.MG42_3rd_Tree'
        AnimSets(0)=AnimSet'WP_3rd_Master.Anim.MG42_3rd_anim'
        CullDistance=5000
    End Object

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_round'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'
    WeaponClass=class'DRWeap_MG42_LMG'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'RP_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_MG34'

    // Tracer FX
    TracerClass=class'MG42BulletTracer'
    TracerFrequency=10

    // ROPawn weapon specific animations
    CHR_AnimSet=AnimSet'RCHRPlayeranim_Master.Weapons.CHR_MG42'

    // Firing animations
    FireAnim=Shoot
    FireLastAnim=Shoot_Last
    IdleAnim=Idle
    IdleEmptyAnim=Idle_Empty
}
