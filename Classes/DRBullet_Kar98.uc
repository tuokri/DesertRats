class DRBullet_Kar98 extends ROBullet;

// TODO: CHECK KAR98 BULLET BALLISTICS!
DefaultProperties
{
{
    BallisticCoefficient=0.535
    Damage=800
    MyDamageType=class'DRDmgType_Kar98Bullet'
    // TODO:
    Speed=37800         //756m/s    //MuzzleVel(m/s) * 50
    MaxSpeed=37800      //756m/s    //MuzzleVel(m/s) * 50
    VelocityDamageFalloffCurve=(Points=((InVal=467640625,OutVal=0.5), (InVal=1870562500,OutVal=0.18)))
    // Customized to have less falloff damage until it really gets to a long range
    //VelocityDamageFalloffCurve=(Points=((InVal=0.0,OutVal=0.0),(InVal=0.4,OutVal=1.0),(InVal=1.0,OutVal=1.0)))
}
