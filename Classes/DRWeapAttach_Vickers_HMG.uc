class DRWeapAttach_Vickers_HMG extends ROWeaponAttachment;

/** Turrets have their own third person mesh */
simulated function AttachTo(Pawn OwnerPawn, bool bVisible, optional bool bCarry = false)
{
    if ( ROTurret(OwnerPawn) != None )
    {
        if ( OwnerPawn.Mesh != None )
        {
            Mesh = OwnerPawn.Mesh;
        }

        Super.AttachTo(OwnerPawn, bVisible);
    }
}

simulated function CheckToForceRefPose()
{
    ClearTimer('CheckToForceRefPose');
}

defaultproperties
{
    // ImpactInfoClass=class'ROPImpactEffectInfo'

    TriggerHoldDuration=0.2

    IKProfileName=Turret

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
    End Object

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_round'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'
    WeaponClass=class'DRWeap_Vickers_HMG'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'RP_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Sov_Maxim'

    // Tracers
    TracerClass=class'DRBullet_Vickers_TurretTracer'
    TracerFrequency=5

    // Player animations - Weapon Actions
    ReloadAnims(0)=Maxim_ReloadEmpty
    ReloadAnims(1)=Maxim_ReloadEmpty

    // ROPawn weapon specific animations
    CHR_AnimSet=AnimSet'CHR_VN_Playeranim_Master.Anim.CHR_VN_Tripod_anim'

    // Firing animations
    FireAnim=Shoot
    FireLastAnim=Shoot_Last
    IdleAnim=Idle
    IdleEmptyAnim=Idle_Empty
}
