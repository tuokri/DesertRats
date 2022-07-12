//=============================================================================
// DRBullet_SMLE
//=============================================================================
// Bullet for the SMLE 
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRBullet_SMLE extends ROBullet;

defaultproperties
{
    BallisticCoefficient=0.408
    Damage=115
    MyDamageType=class'DRDmgType_SMLEBullet'
    Speed=42650         //853m/s    //MuzzleVel(m/s) * 50
    MaxSpeed=42650      //853m/s    //MuzzleVel(m/s) * 50

    VelocityDamageFalloffCurve=(Points=((InVal=467640625,OutVal=0.4), (InVal=1870562500,OutVal=0.2)))
}
