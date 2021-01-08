class DRBullet_Bren extends ROBullet;

// TODO: CHECK BALLISTICS!
DefaultProperties
{
    BallisticCoefficient=0.390
    Damage=115
    MyDamageType=class'DRDmgType_BrenBullet'
    Speed=37750         //755m/s    //MuzzleVel(m/s) * 50
    MaxSpeed=37750      //755m/s    //MuzzleVel(m/s) * 50
    // Customized to have less falloff damage until it really gets to a long range
    VelocityDamageFalloffCurve=(Points=((InVal=0.0,OutVal=0.0),(InVal=0.4,OutVal=1.0),(InVal=1.0,OutVal=1.0)))
}
