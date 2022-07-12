//=============================================================================
// DRDmgType_SMLEBullet
//=============================================================================
// Damage type for a bullet fired from the SMLE
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRDmgType_SMLEBullet extends RODmgType_SmallArmsBullet
    abstract;

defaultproperties
{
    WeaponShortName="SMLE"
    KDamageImpulse=415 // kg * uu/s
    BloodSprayTemplate=ParticleSystem'FX_VN_Impacts.BloodNGore.FX_VN_BloodSpray_Clothes_large'
}
