class DRBullet_Vickers_Turret extends ROBullet;

DefaultProperties
{
    BallisticCoefficient=0.370 // ?
    Damage=115
    MyDamageType=class'DRDmgType_VickersBullet'
    Speed=43250 // 865 M/S
    MaxSpeed=43250 // 865 M/S
    // Customized to have less falloff damage until it really gets to a long range
    VelocityDamageFalloffCurve=(Points=((InVal=0.0,OutVal=0.0),(InVal=0.4,OutVal=1.0),(InVal=1.0,OutVal=1.0)))
}
