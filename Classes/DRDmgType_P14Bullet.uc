//=============================================================================
// DRDmgType_P14Bullet
//=============================================================================
// Damage type for a bullet fired from the P14 Rifle
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRDmgType_P14Bullet extends RODmgType_SmallArmsBullet
      abstract;

DefaultProperties
{
    WeaponShortName="P14"
    KDamageImpulse=435.5 // kg * uu/s
    BloodSprayTemplate=ParticleSystem'FX_VN_Impacts.BloodNGore.FX_VN_BloodSpray_Clothes_large'
}
