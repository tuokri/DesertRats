//=============================================================================
// DRDmgType_M1928A1_Drum
//=============================================================================
// Damage type for a bullet fired from the M1928A1 (Drum)
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRDmgType_M1928A1_Drum extends RODmgType_SmallArmsBullet
    abstract;

defaultproperties
{
    WeaponShortName="M1928"
    KDamageImpulse=208.5 // kg * uu/s
    BloodSprayTemplate=ParticleSystem'FX_VN_Impacts.BloodNGore.FX_VN_BloodSpray_Clothes_small'
}
