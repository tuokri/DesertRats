class DRWeapAttach_MG34_LMG_Turret extends ROWeaponAttachment;

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

DefaultProperties
{
    //? ImpactInfoClass=class'ROPImpactEffectInfo'

    TriggerHoldDuration=0.2

    IKProfileName=Turret

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
    End Object

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_round'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'
    WeaponClass=class'DRWeap_MG34_Tripod'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'RP_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_MG34'

    // Tracers
    TracerClass=class'DRBullet_MG34_TurretTracer'
    TracerFrequency=10

    // Player animations - Weapon Actions
    ReloadAnims(0)=Tripod_ReloadEmpty
    ReloadAnims(1)=Tripod_ReloadHalf

    // ROPawn weapon specific animations
    CHR_AnimSet=AnimSet'CHR_VN_Playeranim_Master.Anim.CHR_VN_Tripod_anim'

    // Firing animations
    FireAnim=Shoot
    FireLastAnim=Shoot//Shoot_Last
    IdleAnim=Idle
    IdleEmptyAnim=Idle//Idle_Empty
}
