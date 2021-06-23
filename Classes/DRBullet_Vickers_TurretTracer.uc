class DRBullet_Vickers_TurretTracer extends ROBulletTracer;

DefaultProperties
{
    // Copied from Maxim1910Bullet
    BallisticCoefficient=0.370 // ?
    MyDamageType=class'DRDmgType_VickersBullet'
    Speed=43250 // 865 M/S
    MaxSpeed=43250 // 865 M/S

    //? ProjFlightTemplate=ParticleSystem'RP_WEP_Gun_Three.Tracers.FX_Wep_Gun_A_MGTracer_Allies'
    //? ProjExplosionTemplate=ParticleSystem'RP_WEP_Gun_Three.Tracers.FX_Wep_Gun_A_MGTracer_Deflect_Allies'

    TracerLightClass=class'ROGame.ROBulletTracerLightGreen'
}
