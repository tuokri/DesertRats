//=============================================================================
// WFAVehicleSoftSkinnedTransport.uc
//=============================================================================
// Transports that can be damaged by small-arms fire.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAVehicleSoftSkinnedTransport extends ROVehicleTransport;

simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int newDamage, HitIndex;
	
	if ( Role == ROLE_Authority )
	{
		if ( EventInstigator != none )
		{
			if ( ROPawn(EventInstigator.Pawn) != none && ROPawn(EventInstigator.Pawn).GetTeamNum() == Team )
			{
				ROGameInfo(WorldInfo.Game).HandleBattleChatterEvent(EventInstigator.Pawn, `BATTLECHATTER_SawFriendlyFire);
			}
		}
	}
	
	super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	
	newDamage = Damage * 0.05;
	
	`wfalog(self @ "taking" @ newDamage @ "points of" @ DamageType @ "damage by" @ EventInstigator.Pawn, 'SSVDamage'); 
	
	if (class<RODmgType_SmallArmsBullet>(DamageType) != none)
	{
/*		if (HitInfo.BoneName != '')
		{
			HitIndex = VehHitZones.Find('ZoneName',HitInfo.BoneName);
			if( HitIndex >= 0 )
			{
				switch (VehHitZones[HitIndex].VehicleHitZoneType)
				{
					case VHT_Ammo: 
					case VHT_Fuel:
					`wfalog(self @ "was instakilled by a hit in the" @ VehHitZones[HitIndex].VehicleHitZoneType, 'SSVDamage');
					Died(EventInstigator, DamageType, HitLocation);
					break;
					
					case VHT_Engine:
					`wfalog(self @ "took damage by a hit in the" @ VehHitZones[HitIndex].VehicleHitZoneType, 'SSVDamage');
*/					if (newDamage >= Health)
					{
						`wfalog(self @ "died from health:" @ Health, 'SSVDamage');
						Died(EventInstigator, DamageType, HitLocation);
					}
					else
					{
						Health -= newDamage;
						`wfalog(self @ "health:" @ Health, 'SSVDamage');
						AddVelocity(Momentum, HitLocation, DamageType, HitInfo);
					}
/*					break;
					
					default: `wfalog(self @ "was hit in the" @ VehHitZones[HitIndex].ZoneName, 'SSVDamage');
				};
			}
			else
			{
				`wfalog(self @ "could not find" HitInfo.BoneName @ "in hitbox list!", 'SSVDamage');
			}
		}
		else
		{
			`wfalog(self @ "HitInfo.BoneName is null!", 'SSVDamage');
		}
*/	}
	else if (class<RODmgType_AntiVehicleGeneral>(DamageType) != none || 
			class<RODamageType_CannonShell>(DamageType) != none || 
			class<RODamageType_Grenades>(DamageType) != none || 
			class<RODamageType_RunOver>(DamageType) != none || 
			class<RODmgType_Satchel>(DamageType) != none || 
			class<RODmgTypeArtillery>(DamageType) != none || 
			class<RODmgTypeMineField>(DamageType) != none)
	{
		`wfalog(self @ "was instakilled by" @ DamageType, 'SSVDamage');
		Died(EventInstigator, DamageType, HitLocation);
	}
	else
	{
		`wfalog(self @ "took no damage from" @ DamageType, 'SSVDamage');
	}
}

DefaultProperties
{
	Health=100
	
	bOpenVehicle=true
	bInfantryCanUse=true
	
	BigExplosionSocket=FX_Fire
	ExplosionTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_C_Explosion'

	ExplosionDamageType=class'RODmgType_VehicleExplosion'
	ExplosionDamage=100.0
	ExplosionRadius=300.0
	ExplosionMomentum=60000
	ExplosionInAirAngVel=1.5
	InnerExplosionShakeRadius=400.0
	OuterExplosionShakeRadius=1000.0
	ExplosionLightClass=class'ROGame.ROGrenadeExplosionLight'
	MaxExplosionLightDistance=4000.0
	TimeTilSecondaryVehicleExplosion=0
	SecondaryExplosion=none
	bHasTurretExplosion=false

	EngineStartOffsetSecs=2.0
	EngineStopOffsetSecs=0.5
	
	SpeedoMinDegree=5461
	SpeedoMaxDegree=56000
	SpeedoMaxSpeed=1365
	
	Begin Object Name=SimObject
		WheelSuspensionStiffness=325
		WheelSuspensionDamping=25.0
		GearArray(0)={(
			GearRatio=-2.82,
			AccelRate=20.5,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=-4200),
				(InVal=600,OutVal=-1400),
				(InVal=5600,OutVal=-4200),
				(InVal=6000,OutVal=-1400),
				(InVal=6400,OutVal=-0.0)
				)}),
			TurningThrottle=1.0
			)}
		GearArray(1)={()}
		GearArray(2)={(
			GearRatio=2.11,
			AccelRate=15.2,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=5000),
				(InVal=600,OutVal=3600),
				(InVal=5600,OutVal=8000),
				(InVal=6000,OutVal=2000),
				(InVal=6400,OutVal=0.0)
				)}),
			TurningThrottle=1.0
			)}
		GearArray(3)={(
			GearRatio=1.05,
			AccelRate=18.4,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=6000),
				(InVal=5600,OutVal=12400),
				(InVal=6000,OutVal=4000),
				(InVal=6400,OutVal=0.0)
				)}),
			TurningThrottle=1.0
			)}
		GearArray(4)={(
			GearRatio=0.7,
			AccelRate=19.4,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=7000),
				(InVal=5600,OutVal=19000),
				(InVal=6000,OutVal=7000),
				(InVal=6400,OutVal=0.0)
				)}),
			TurningThrottle=1.0
			)}
		GearArray(5)={(
			GearRatio=0.52,
			AccelRate=20.40,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=10000),
				(InVal=5600,OutVal=23400),
				(InVal=6000,OutVal=12000),
				(InVal=6400,OutVal=0.0)
				)}),
			TurningThrottle=1.0
			)}
		FirstForwardGear=2
	End Object
	
	GroundSpeed=1310
	MaxSpeed=1310
}