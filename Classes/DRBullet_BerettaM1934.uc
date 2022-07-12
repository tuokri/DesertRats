//=============================================================================
// DRBullet_BerettaM1934
//=============================================================================
// 9mm Bullet class for the Beretta M1934.
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRBullet_BerettaM1934 extends ROBullet;

defaultproperties
{
    BallisticCoefficient=0.140 // 9mm Luger - 115gr FMJ
    
    // Damage=115
    Damage=129
    MyDamageType=class'DRDmgType_BerettaM1934'
    Speed=19500 // 390 M/S
    MaxSpeed=19500 // 390 M/S

    // RS2. Energy transfer function
    // MAT-49, BHP, Owen, F1
    VelocityDamageFalloffCurve=(Points=((InVal=95062500,OutVal=1.0),(InVal=380250000,OutVal=0.55)))
    // VelocityDamageFalloffCurve=(Points=((InVal=0.5,OutVal=1.0),(InVal=1.0,OutVal=0.55)))
}
