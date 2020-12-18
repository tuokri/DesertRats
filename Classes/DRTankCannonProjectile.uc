class DRTankCannonProjectile extends ROTankCannonProjectile;

DefaultProperties
{
    //? AmbientSound=AkEvent'AUD_Projectiles.Bullet_Whip.Tank_Cannon_Shell_Zoom_Cue'

    ProjExplosionTemplate=ParticleSystem'FX_WEP_Explosive_Three.FX_VEH_Explosive_C_TankCannon_AP_Shell_Impact_Dirt'
    ProjFlightTemplate=ParticleSystem'FX_WEP_Gun_Three.Tracers.FX_WEP_Gun_A_TankShell_Tracer'
    ProjDefelectTemplate=ParticleSystem'FX_VEH_Tank_Three.FX_VEH_Tank_B_NoRound_Deflect'
    ProjPenetrateTemplate=ParticleSystem'FX_VEH_Tank_Three.FX_VEH_Tank_B_TankShell_Penetrate'
    ProjPostDeflectTemplate=ParticleSystem'FX_WEP_Gun_Three.Tracers.FX_WEP_Gun_A_TankShell_Tracer_PostDeflect'
}
