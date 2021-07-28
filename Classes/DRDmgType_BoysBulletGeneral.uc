//=============================================================================
// DRDmgType_BoysBulletGeneral
//=============================================================================
// Damage type for a bullet fired from the Boys Anti-Tank rifle
// Impact General Vehicle Damage
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================

class DRDmgType_BoysBulletGeneral extends RODmgType_AntiVehicleGeneral
	abstract;

defaultproperties
{
	WeaponShortName="BOYS AT"
	KDamageImpulse=1000
	RadialDamageImpulse=79
	bCausesFracture=true
	bLocationalHit=true
	VehicleDamageScaling=1.0
	VehicleTreadDamageScale=1.0
	bCanObliterate=false
	bCanUberGore=false
	bCanDismember=true
	BloodSprayTemplate=ParticleSystem'FX_VN_Impacts.BloodNGore.FX_VN_BloodSpray_Clothes_large'
}
