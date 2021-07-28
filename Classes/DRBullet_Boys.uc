//=============================================================================
// DRBullet_Boys
//=============================================================================
// Bullet for the Boys Anti-Tank Rifle
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRBullet_Boys extends ROAntiVehicleProjectile;

defaultproperties
{
	BallisticCoefficient=0.80
	Speed=50500 //1010 m/s
	MaxSpeed=50500
	ImpactDamage=125
	DamageRadius=0//50
	MomentumTransfer=5000
	Damage=200
	ImpactDamageType=class'DRDmgType_BoysBullet'
	GeneralDamageType=class'DRDmgType_BoysBulletGeneral'
	bDebugBallistics=false
	// TODO: Need to get this back to ROLE_None so it doesn't exist on the client, but will take some more work on replicating the sounds/effects
	//RemoteRole=ROLE_None
	ExplosionSound=none
	ProjExplosionTemplate=none
	ExplosionDecal=none
	ExplosionLightClass=none
	bDoSmallArmsPenetration=true

	ProjPenetrateTemplate=ParticleSystem'FX_VN_Weapons.Explosions.FX_VN_RPG_exitblast' //TODO: Replace me!
	ProjDefelectTemplate=ParticleSystem'FX_VN_Weapons.Explosions.FX_VN_RPG_explosion' //TODO: Replace me!

	//VehiclePenetrateSound=SoundCue'AUD_Impacts.Impacts.Bullet_PTRS_Metal_Penetrate_Cue'
	//VehicleDeflectSound=SoundCue'AUD_Impacts.Impacts.Bullet_PTRS_Metal_Deflect_Cue'

	Caliber=14.5
	ActualRHA=36
	TestPlateHardness=300
	SlopeEffect=0.47989
	ShatterNumber=1.1
	ShatterTd=1.0
	ShatteredPenEffectiveness=0.3

    PenetrateShrapnelLength=75 // 1.5 meters
    SpallShrapnelLength=50 // 1 Meter
    PenetrateShrapnelChance=0.15 // 15% chance
    SpallShrapnelChance=0.1 // 10% chance
}
