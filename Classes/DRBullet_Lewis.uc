//=============================================================================
// DRBullet_Lewis
//=============================================================================
// Bullet for the Lewis Gun
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRBullet_Lewis extends ROBullet;

defaultproperties
{
    BallisticCoefficient=0.377 // Steel Core Light Ball http://7.62x54r.net/MosinID/MosinAmmo025.htm
    // Damage=148
    Damage=768
    MyDamageType=class'DRDmgType_LewisBullet'
    Speed=42000 // 840 M/S
    MaxSpeed=42000 // 840 M/S

    // RS2. Energy transfer function
    // MN9130, DP28
    VelocityDamageFalloffCurve=(Points=((InVal=467640625,OutVal=0.5), (InVal=1870562500,OutVal=0.18)))
    // VelocityDamageFalloffCurve=(Points=((InVal=0.5,OutVal=0.5), (InVal=1.0,OutVal=0.18)))
}
