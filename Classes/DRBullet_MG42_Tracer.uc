class DRBullet_MG42_Tracer extends ROBulletTracer;

DefaultProperties
{
    // Copied from MG42Bullet
    BallisticCoefficient=0.390
    MyDamageType=class'DRDmgType_MG42Bullet'
    Speed=43000         //860m/s    //MuzzleVel(m/s) * 50
    MaxSpeed=43000      //860m/s    //MuzzleVel(m/s) * 50

    ProjFlightTemplate=ParticleSystem'RP_WEP_Gun_Three.Tracers.FX_Wep_Gun_A_MGTracer_Axis'
    ProjExplosionTemplate=ParticleSystem'RP_WEP_Gun_Three.Tracers.FX_Wep_Gun_A_MGTracer_Deflect_Axis'

    TracerLightClass=class'ROGame.ROBulletTracerLightRed'
}
