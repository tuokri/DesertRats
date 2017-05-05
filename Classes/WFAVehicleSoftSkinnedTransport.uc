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
	local int newDamage/*, HitIndex*/;
	
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

simulated function SitDriver( ROPawn ROP, int SeatIndex )
{
	local ROPlayerController ROPC;
	local Pawn LocalPawn;

	super.SitDriver(ROP, SeatIndex);
	
	if( Seats[SeatIndex].SeatPawn != none && Seats[SeatIndex].SeatPawn.Driver != none )
	{
		ROPC = ROPlayerController(Seats[SeatIndex].SeatPawn.Driver.Controller);
	}
	if( ROPC == none && Seats[SeatIndex].SeatPawn != none )
	{
		ROPC = ROPlayerController(Seats[SeatIndex].SeatPawn.Controller);
	}
	if( ROPC == none )
	{
		if( ROP.DrivenVehicle.Controller != none && ROP.DrivenVehicle.Controller == GetALocalPlayerController() )
		{
			ROPC = ROPlayerController(ROP.DrivenVehicle.Controller);
		}
	}
	if( ROPC == none && SeatIndex == 0 )
	{
		if( GetALocalPlayerController() != none && GetALocalPlayerController().Pawn == self )
		{
			ROPC = ROPlayerController(GetALocalPlayerController());
		}
	}
	if( ROPC == none  )
	{
		LocalPawn = GetALocalPlayerController().Pawn;
		if( GetALocalPlayerController() != none && LocalPawn == Seats[SeatIndex].SeatPawn )
		{
			ROPC = ROPlayerController(GetALocalPlayerController());
		}
	}
	
	if( ROPC != none && (WorldInfo.NetMode == NM_Standalone || IsLocalPlayerInThisVehicle()) )
	{
		ROPC.SetRotation(rot(0,0,0));
	}
	
	if( ROP != none )
	{
  		ROP.Mesh.SetAnimTreeTemplate(PassengerAnimTree);
		if( ROP.CurrentWeaponAttachment != none )
			ROP.PutAwayWeaponAttachment();

		if( Role == ROLE_Authority )
		{
			UpdateSeatProxyHealth(GetSeatProxyIndexForSeatIndex(SeatIndex), ROP.Health, false);
		}
	}

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		if ( ROPC != None && LocalPlayer(ROPC.Player) != none && (WorldInfo.NetMode == NM_Standalone || IsLocalPlayerInThisVehicle()) )
		{
			if ( Mesh.DepthPriorityGroup == SDPG_World )
			{
				SetVehicleDepthToForeground();
			}
			
			if (ROP != None)
			{
				if( ROP.ThirdPersonHeadgearMeshComponent != none )
				{
					ROP.ThirdPersonHeadgearMeshComponent.SetHidden(true);
				}

				ROP.ThirdPersonHeadAndArmsMeshComponent.SetSkeletalMesh(ROP.ArmsOnlyMesh);
				ROP.ArmsMesh.SetHidden(true);
			}
		}
		
		SpawnOrReplaceSeatProxy(SeatIndex, ROP);
	}

	if( ROP != none )
	{
		ROP.SetRelativeRotation(Seats[SeatIndex].SeatRotation);
		ROP.UpdateVehicleIK(self, SeatIndex, SeatPositionIndex(SeatIndex,, true));
	}
}

simulated function SpawnOrReplaceSeatProxy(int SeatIndex, ROPawn ROP)
{
	local int i;
	local VehicleCrewProxy CurrentProxyActor;

	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	for ( i = 0; i < SeatProxies.Length; i++ )
	{
		if( SeatIndex == i && ROP != none )
		{
			if( SeatProxies[i].ProxyMeshActor != none && SeatProxies[i].ProxyMeshActor.bIsDismembered )
			{
				`wfalog("WFAVehicleSoftSkinnedTransport.SpawnOrReplaceSeatProxy() - ProxyMeshActor.bIsDismembered!");
				SeatProxies[i].ProxyMeshActor.Destroy();
			}

			if( SeatProxies[i].ProxyMeshActor == none )
			{
				SeatProxies[i].ProxyMeshActor = Spawn(class'VehicleCrewProxy',self);
				SeatProxies[i].ProxyMeshActor.MyVehicle = self;
				SeatProxies[i].ProxyMeshActor.SeatProxyIndex = i;

				CurrentProxyActor = SeatProxies[i].ProxyMeshActor;
				SeatProxies[i].TunicMeshType.Characterization = class'ROPawn'.default.PlayerHIKCharacterization;
				CurrentProxyActor.Mesh.SetShadowParent(Mesh);
				CurrentProxyActor.SetLightingChannels(InteriorLightingChannels);
				CurrentProxyActor.SetLightEnvironment(InteriorLightEnvironment);
				CurrentProxyActor.SetCollision( false, false);
				CurrentProxyActor.bCollideWorld = false;
				CurrentProxyActor.SetBase(none);
				CurrentProxyActor.SetHardAttach(true);
				CurrentProxyActor.SetLocation( Location );
				CurrentProxyActor.SetPhysics( PHYS_None );
				CurrentProxyActor.SetBase( Self, , Mesh, Seats[SeatProxies[i].SeatIndex].SeatBone);
				CurrentProxyActor.SetRelativeLocation( vect(0,0,0) );
				CurrentProxyActor.SetRelativeRotation( Seats[SeatProxies[i].SeatIndex].SeatRotation );
			}
			else
				CurrentProxyActor = SeatProxies[i].ProxyMeshActor;

			CurrentProxyActor.ReplaceProxyMeshWithPawn(ROP);

			if ( SeatProxyAnimSet != None )
			{
				CurrentProxyActor.Mesh.AnimSets[0] = SeatProxyAnimSet;
			}
			
			if( IsLocalPlayerInThisVehicle() )
				CurrentProxyActor.SetVisibilityToInterior();
			else
				CurrentProxyActor.SetVisibilityToExterior();

			CurrentProxyActor.HideMesh(true);
		}
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