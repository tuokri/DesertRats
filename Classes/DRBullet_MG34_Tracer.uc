class DRBullet_MG34_Tracer extends ROBulletTracer;

DefaultProperties
{
    BallisticCoefficient=0.390
    Damage=115
    MyDamageType=class'DRDmgType_MG34Bullet'
    Speed=37750         //755m/s    //MuzzleVel(m/s) * 50
    MaxSpeed=37750      //755m/s    //MuzzleVel(m/s) * 50
    // Customized to have less falloff damage until it really gets to a long range
    VelocityDamageFalloffCurve=(Points=((InVal=0.0,OutVal=0.0),(InVal=0.4,OutVal=1.0),(InVal=1.0,OutVal=1.0)))

    // TODO:
    //? ProjFlightTemplate=ParticleSystem'RP_WEP_Gun_Three.Tracers.FX_Wep_Gun_A_MGTracer_Axis'
    //? ProjExplosionTemplate=ParticleSystem'RP_WEP_Gun_Three.Tracers.FX_Wep_Gun_A_MGTracer_Deflect_Axis'

    TracerLightClass=class'ROGame.ROBulletTracerLightRed'
}
