//=============================================================================
// DRDmgType_BerettaM1934
//=============================================================================
// Damage type for bullets from the Beretta M1934 bullets.
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRDmgType_BerettaM1934 extends RODmgType_SmallArmsBullet
    abstract;

defaultproperties
{
    WeaponShortName="BERETTA M1934"
    KDamageImpulse=145.5 // kg * uu/s
    BloodSprayTemplate=ParticleSystem'FX_VN_Impacts.BloodNGore.FX_VN_BloodSpray_Clothes_small'
}
