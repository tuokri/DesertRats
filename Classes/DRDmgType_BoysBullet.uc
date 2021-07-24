//=============================================================================
// DRDmgType_BoysBullet 
//=============================================================================
// Damage type for a bullet fired from the Boys Anti-Tank rifle
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================

class DRDmgType_BoysBullet extends RODamageType_CannonShell
	abstract;

defaultproperties
{
	WeaponShortName="Boys AT"
	KDamageImpulse=1000
	RadialDamageImpulse=79
	bCausesFracture=true
	bLocationalHit=true
	VehicleDamageScaling=1.0
	VehicleTreadDamageScale=1.0
	bCanObliterate=false
	bCanUberGore=false
	bCanDismember=true
	BloodSprayTemplate=ParticleSystem'RP_CHAR_Soldier_Two.Emitters.FX_CHAR_Soldier_BloodSpray_Large'
	bOverrideInstantDeathForStandardDamageMode=true
	//ActionModeInfantryPawnDamageScale=0.45
	// "Instant Death" zones
   // ActionModeInfantryZoneDamageScaleArray[0]=(ZoneName="Head",DamageScale=1.5)
   // ActionModeInfantryZoneDamageScaleArray[1]=(ZoneName="NECK",DamageScale=1.5)
   // ActionModeInfantryZoneDamageScaleArray[2]=(ZoneName="HEART",DamageScale=1.5)
   // ActionModeInfantryZoneDamageScaleArray[3]=(ZoneName="SEXORGAN",DamageScale=1.5)
}
