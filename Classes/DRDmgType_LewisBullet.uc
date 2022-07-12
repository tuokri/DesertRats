//=============================================================================
// DRDmgType_LewisBullet
//=============================================================================
// Damage type for a bullet fired from the Lewis Gun
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRDmgType_LewisBullet extends RODmgType_SmallArmsBullet
    abstract;

defaultproperties
{
    WeaponShortName="LEWIS GUN"
    KDamageImpulse=403 // kg * uu/s
    BloodSprayTemplate=ParticleSystem'FX_VN_Impacts.BloodNGore.FX_VN_BloodSpray_Clothes_large'
}
