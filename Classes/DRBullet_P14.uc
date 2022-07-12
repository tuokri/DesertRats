//=============================================================================
// DRBullet_P14
//=============================================================================
// Bullet for the P14 Scoped Rifle.
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRBullet_P14 extends ROBullet;

defaultproperties
{

    BallisticCoefficient=0.240

    Damage=768
    MyDamageType=class'DRDmgType_P14Bullet'
    Speed=38850         //777 m/s
    MaxSpeed=38850      //777 m/s
    
    // RS2. Energy transfer function.
    // M40, XM21
    VelocityDamageFalloffCurve=(Points=((InVal=241491600,OutVal=0.85), (InVal=1509322500,OutVal=0.2)))
    // VelocityDamageFalloffCurve=(Points=((InVal=0.4,OutVal=0.6), (InVal=1.0,OutVal=0.15)))

    // Test
    ProjFlightTemplate=ParticleSystem'FX_VN_Weapons.Emitter.FX_VN_Bullet_SonicShock'

    DragFunction=RODF_G7

    // http://www.bergerbullets.com/twist-rate-calculator/
    Sg = 1.80
    bUseAdvancedBallistics=true
}
