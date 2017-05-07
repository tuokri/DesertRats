//=============================================================================
// WFAVehicleATGun.uc
//=============================================================================
// Static anti-tank guns useable by infantry.
// Mixture of ROVehicleTank and ROVehicleTransport.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAVehicleATGun extends ROVehicleTank
	abstract;

static function bool IsTank()
{
	return false;
}

simulated function PostBeginPlay()
{
	local int i, NewSeatIndexHealths, LoopMax;

	super(ROVehicle).PostBeginPlay();
	
	if (bDeleteMe) { return; }
	
	for (i = 0; i < VehHitZones.length; i++)
	{
		VehHitZoneHealths[i] = 255;
		if( VehHitZones[i].VehicleHitZoneType == VHT_CrewHead || VehHitZones[i].VehicleHitZoneType == VHT_CrewBody )
		{
			CrewVehHitZoneIndexes[CrewVehHitZoneIndexes.Length] = i;
		}
	}
	
	for (i = 0; i < MAX_ARMOR_PLATE_ZONES; i++)
	{
		ArmorPlateZoneHealthsCompressed[i] = 255;
	}
	
	SeatIndexGunner = 0;
	
	if (Role == ROLE_Authority)
	{
		if( TankController == None )
		{
			TankController = Spawn(TankControllerClass, self, , Location, Rotation, , true);
		}
		
		if( SeatProxies.Length > 7 )
			LoopMax = 7;
		else
			LoopMax = SeatProxies.Length;
		
		for ( i = 0; i < LoopMax; i++ )
		{
			NewSeatIndexHealths = (NewSeatIndexHealths - (NewSeatIndexHealths & (15 << (4 * i)))) | (int(SeatProxies[i].Health / 6.6666666) << (4 * i));
		}
		ReplicatedSeatProxyHealths = NewSeatIndexHealths;

		if( LoopMax < SeatProxies.Length )
		{
			LoopMax = SeatProxies.Length;
			NewSeatIndexHealths = 0;
			
			for ( i = 7; i < LoopMax; i++ )
			{
				NewSeatIndexHealths = (NewSeatIndexHealths - (NewSeatIndexHealths & (15 << (4 * (i - 7))))) | (int(SeatProxies[i].Health / 6.6666666) << (4 * (i - 7)));
			}
			ReplicatedSeatProxyHealths2 = NewSeatIndexHealths;
		}
	}
	
	SpawnExternallyVisibleSeatProxies();
}

simulated function DetachDriver(Pawn P)
{
	local ROPawn ROP;
	ROP = ROPawn(P);
	
	if (ROP != None)
	{
		ROP.Mesh.SetAnimTreeTemplate(ROP.Mesh.default.AnimTreeTemplate);
		ROSkeletalMeshComponent(ROP.Mesh).AnimSets[0]=ROSkeletalMeshComponent(ROP.Mesh).default.AnimSets[0];
		ROP.ThirdPersonHeadAndArmsMeshComponent.SetSkeletalMesh(ROP.HeadAndArmsMesh);
		ROP.ThirdPersonHeadgearMeshComponent.SetHidden(false);
		ROP.HideGear(false);
	}
	
	Super.DetachDriver(P);
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
  		ROP.Mesh.SetAnimTreeTemplate(AnimTree'CHR_Playeranimtree_Master.CHR_Tanker_animtree');
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
				`wfalog("WFAVehicleATGun.SpawnOrReplaceSeatProxy() - ProxyMeshActor.bIsDismembered!");
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

function EvaluateBackSeatDrivers()
{
	return;
}

function ShowScuttleMessage()
{
	return;
}

simulated function HandleSeatProxyHealthUpdated()
{
	local int i;
	local bool bRevivingProxy;
	
	for ( i = 0; i < SeatProxies.Length; i++ )
	{
		bRevivingProxy = false;
		
		if( SeatProxies[i].Health != GetSeatProxyHealth(i) )
		{
			if( SeatProxies[i].Health <=0 && GetSeatProxyHealth(i) > 0 )
			{
				bRevivingProxy = true;
			}
			
			SeatProxies[i].Health = GetSeatProxyHealth(i);
			
			if( SeatProxies[i].ProxyMeshActor != none )
			{
				if( bRevivingProxy )
				{
					SeatProxies[i].ProxyMeshActor.ClearBloodOverlay();
					
					if( Seats[SeatProxies[i].SeatIndex].SeatPositions[SeatProxies[i].PositionIndex].bDriverVisible )
					{
						Seats[SeatProxies[i].SeatIndex].PositionBlend.HandleAnimPlay(Seats[SeatProxies[i].SeatIndex].SeatPositions[SeatPositionIndex(SeatProxies[i].SeatIndex,,true)].PositionIdleAnim, true);
						
						SeatProxies[i].ProxyMeshActor.HideMesh(true);
					}
				}
				else if( SeatProxies[i].Health <= 0  )
				{
					if( Seats[SeatProxies[i].SeatIndex].SeatPositions[SeatProxies[i].PositionIndex].bDriverVisible )
					{
						SeatProxies[i].ProxyMeshActor.HideMesh(false);
					}
				}
			}
		}
	}
}
/*
function DriverRadiusDamage( float DamageAmount, float DamageRadius, Controller EventInstigator,
				class<DamageType> DamageType, float Momentum, vector HitLocation, Actor DamageCauser, optional float DamageFalloffExponent=1.f)
{
	local int i, j, HitIndex, ArmourZoneIndex;
	local Vehicle V;
	local vector EndTrace;
	local array<ImpactInfo> HitInfos;
	local ImpactInfo Impact;

	Impact.HitInfo.HitComponent = Mesh;

	if( CrewHitZoneEnd < 1 )
		CrewHitZoneEnd = VehHitZones.length - 1;

	for (j = 1; j < Seats.length; j++)
	{
		V = Seats[j].SeatPawn;

		if( V != none && V.Driver != none && ROPawn(V.Driver) != none )
		{
			for( i = CrewHitZoneStart; i <= CrewHitZoneEnd; i++ )
			{
				if( VehHitZones[i].CrewSeatIndex == j )
				{
					if( VehHitZones[i].VehicleHitZoneType == VHT_CrewHead )
					{
						EndTrace = Mesh.GetBoneLocation(VehHitZones[i].CrewBoneName);
						break;
					}
				}
			}

			EndTrace = V.Driver.Location;

			GetAllHitBones(Impact, HitInfos, EndTrace, HitLocation);

			for (i = 0; i < HitInfos.Length; i++)
			{
				if( HitInfos[i].HitInfo.BoneName != '' )
				{
					HitIndex = VehHitZones.Find('ZoneName',HitInfos[i].HitInfo.BoneName);
					ArmourZoneIndex = ArmorHitZones.Find('ZoneName',HitInfos[i].HitInfo.BoneName);
					
					if( HitIndex >= 0 && (VehHitZones[HitIndex].VehicleHitZoneType == VHT_CrewBody ||
						VehHitZones[HitIndex].VehicleHitZoneType == VHT_CrewHead))
					{
						if( VehHitZones[HitIndex].CrewSeatIndex == j )
						{
							V.DriverRadiusDamage(DamageAmount, DamageRadius, EventInstigator, DamageType, Momentum, HitLocation, DamageCauser, DamageFalloffExponent);
							break;
						}
					}
					else if( ArmourZoneIndex >= 0 && ArmorHitZones[ArmourZoneIndex].bInstaPenetrateZone )
					{
						continue;
					}
					else
						break;
				}
			}
		}
	}
}
*/
function rotator GetExitRotation(Controller C)
{
	local rotator rot;
	rot.Yaw = Rotation.Yaw;
	return rot;
}

simulated function VehicleLoadMainGun()
{
	local int LoaderIndex;
	
	LoaderIndex = GetLoaderSeatIndex();
	if ( SeatProxies[GetSeatProxyIndexForSeatIndex(LoaderIndex)].Health <= 0 )
	{
		return;
	}
	
	ProxyAnimAction.AnimActionName = 'Loader_Load';
	ProxyAnimAction.SeatProxyIndex = Seats[LoaderIndex].SeatPositions[SeatPositionIndex(LoaderIndex,,true)].SeatProxyIndex;
	
	if( ProxyAnimAction.ProxyActionCount < 255 )
	{
		ProxyAnimAction.ProxyActionCount += 1;
	}
	else
	{
		ProxyAnimAction.ProxyActionCount = 0;
	}
	
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		HandleSeatProxyAnimAction();
		
		if( Seats[GetLoaderSeatIndex()].PositionBlend != none )
		{
			Seats[GetLoaderSeatIndex()].PositionBlend.HandleAnimPlay(ProxyAnimAction.AnimActionName, false);
		}
	}
}

simulated function RequestPosition(byte SeatIndex, byte DesiredIndex, optional bool bViaInteraction)
{
	if( SeatIndex == GetLoaderSeatIndex() && !ROVWeap_TankTurret(Seats[SeatIndex].Gun).bMainCannonLoaded )
		return;

	super.RequestPosition(SeatIndex, DesiredIndex, bViaInteraction);
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
	
	bTankScuttleEnabled=false
	
	// WeaponPawnClass=class'ROTransportWeaponPawn'
	// ClientWeaponPawnClass=class'ROTransportClientSideWeaponPawn'
	
	bHasTurret=false
}