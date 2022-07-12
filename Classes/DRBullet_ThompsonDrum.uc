//=============================================================================
// DRBullet_ThompsonDrum
//=============================================================================
// Bullet for the Thompson Drum Variant
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRBullet_ThompsonDrum extends ROBullet;

defaultproperties
{
    BallisticCoefficient=0.195

    // Damage=230
    Damage = 133
    MyDamageType=class'DRDmgType_M1928A1_Drum'
    Speed=14250 // 282 M/S
    MaxSpeed=14250  // 288 M/S

    // RS2. Energy transfer function
    // M1911, M3A1
    VelocityDamageFalloffCurve=(Points=((InVal=49000000,OutVal=0.1),(InVal=203062500,OutVal=0.85)))
    // VelocityDamageFalloffCurve=(Points=((InVal=0.5,OutVal=1.0),(InVal=1.0,OutVal=0.95)))
}
