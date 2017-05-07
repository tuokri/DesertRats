//=============================================================================
// WFAVehicleATGun_Pak38.uc
//=============================================================================
// 5 cm Pak 38 Anti-Tank Gun
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAVehicleATGun_Pak38 extends WFAVehicleATGun
	abstract;

var repnotify TakeHitInfo DeathHitInfo_ProxyGunner;
var repnotify TakeHitInfo DeathHitInfo_ProxyLoader;

var Material ScopeLensMaterial;

replication
{
	if (bNetDirty)
		DeathHitInfo_ProxyLoader, DeathHitInfo_ProxyGunner;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'DeathHitInfo_ProxyGunner')
	{
		if( IsLocalPlayerInThisVehicle() )
		{
			PlaySeatProxyDeathHitEffects(0, DeathHitInfo_ProxyGunner);
		}
	}
	else if (VarName == 'DeathHitInfo_ProxyLoader')
	{
		if( IsLocalPlayerInThisVehicle() )
		{
			PlaySeatProxyDeathHitEffects(1, DeathHitInfo_ProxyLoader);
		}
	}
	else
	{
		super.ReplicatedEvent(VarName);
	}
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	
	ShellController = ROSkelControlCustomAttach(mesh.FindSkelControl('ShellCustomAttach'));
	
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		mesh.MinLodModel = 1;
	}
}

function DamageSeatProxy(int SeatProxyIndex, int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional Actor DamageCauser)
{
	switch( SeatProxyIndex )
	{
	case 0:
		DeathHitInfo_ProxyGunner.Damage = Damage;
		DeathHitInfo_ProxyGunner.HitLocation = HitLocation;
		DeathHitInfo_ProxyGunner.Momentum = Momentum;
		DeathHitInfo_ProxyGunner.DamageType = DamageType;
		break;
	case 1:
		DeathHitInfo_ProxyLoader.Damage = Damage;
		DeathHitInfo_ProxyLoader.HitLocation = HitLocation;
		DeathHitInfo_ProxyLoader.Momentum = Momentum;
		DeathHitInfo_ProxyLoader.DamageType = DamageType;
		break;
	}
	
	Super.DamageSeatProxy(SeatProxyIndex, Damage, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}

simulated function HandleProxySeatTransition(int NewSeatIndex, int OldSeatIndex)
{
	local float AnimTimer;
	local name TransitionAnim, TimerName;
	local VehicleCrewProxy VCP;
	local bool bTransitionWithoutProxy;

	super.HandleProxySeatTransition(NewSeatIndex, OldSeatIndex);

	VCP = SeatProxies[GetSeatProxyIndexForSeatIndex(NewSeatIndex)].ProxyMeshActor;

	if( VCP == none )
	{
		bTransitionWithoutProxy = true;
	}
	
	if( NewSeatIndex == 4 )
	{
		TimerName = 'SeatTransitioningFour';
	}
	
	TransitionAnim = '';
	
	if( TransitionAnim != '' )
	{
		Seats[NewSeatIndex].TransitionProxy = VCP;

		Seats[OldSeatIndex].PositionBlend.HandleAnimPlay(TransitionAnim, false);
		Seats[NewSeatIndex].PositionBlend.HandleAnimPlay(Seats[NewSeatIndex].SeatPositions[Seats[NewSeatIndex].InitialPositionIndex].PositionIdleAnim, false);

		if( bTransitionWithoutProxy )
		{
			AnimTimer = SeatProxyAnimSet.GetAnimLength(TransitionAnim);
		}
		else
		{
			AnimTimer = VCP.Mesh.GetAnimLength(TransitionAnim);
			VCP.PlayFullBodyAnimation(TransitionAnim);
		}
	}
	else
	{
		AnimTimer = Seats[OldSeatIndex].FadedTransTimes[NewSeatIndex];
		
		VCP.PlayFullBodyAnimation(Seats[NewSeatIndex].SeatPositions[Seats[NewSeatIndex].InitialPositionIndex].DriverIdleAnim);
	}
	
	Seats[NewSeatIndex].bTransitioningToSeat = true;
	HandlePostInstantSeatTransition(OldSeatIndex);
	
	SetTimer(AnimTimer, false, TimerName);
}

/**
 * Finish a faded non-animated transition to Seat Index 0
 */
simulated function SeatTransitioningZero()
{
	FinishFadedTransition(0);
}

/**
 * Finish a faded non-animated transition to Seat Index 1
 */
simulated function SeatTransitioningOne()
{
	FinishFadedTransition(1);
}

/**
 * Finish a faded non-animated transition to Seat Index 2
 */
simulated function SeatTransitioningTwo()
{
	FinishFadedTransition(2);
}

/**
 * Finish a faded non-animated transition to Seat Index 3
 */
simulated function SeatTransitioningThree()
{
	FinishFadedTransition(3);
}

/**
 * Finish a faded non-animated transition to Seat Index 4
 */
simulated function SeatTransitioningFour()
{
	FinishFadedTransition(4);
}

simulated function PositionIndexUpdated(int SeatIndex, byte NewPositionIndex)
{
	if( SeatIndex == GetGunnerSeatIndex() )
	{
		if( NewPositionIndex != Seats[SeatIndex].FiringPositionIndex )
		{
			Seats[SeatIndex].Gun.ForceEndFire();
		}
	}
	
	super.PositionIndexUpdated(SeatIndex, NewPositionIndex);
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionHeight=60.0
		CollisionRadius=260.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object
	CylinderComponent=CollisionCylinder

	bDontUseCollCylinderForRelevancyCheck=true
	RelevancyHeight=90.0
	RelevancyRadius=155.0
	
	CrewAnimSet=AnimSet'VH_Ger_Panzer_IIIM.Anim.CHR_Panzer3M_Anim_Master'
	bNoAnimTransition=true
	
	Seats(0)={(	GunClass=class'ROVWeap_PanzerIIIM_Turret',
				SightOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_PZIV_optics_bg',
				NeedleOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_PZIV_optics_bg_TOP',
				RangeOverlayTexture=Texture2D'UI_Textures_VehiclePack.VehicleOptics.ui_hud_vehicle_PZIIIM_range',
				VignetteOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_vignette',
				GunSocket=(Barrel),
				GunPivotPoints=(gun_base,gun_base),
				TurretVarPrefix="Turret",
				TurretControls=(Turret_Gun,Turret_Main),
				CameraTag=None,
				CameraOffset=-420,
				bSeatVisible=true,
				SeatBone=Turret,
				SeatAnimBlendName=GunnerPositionNode,
				SeatPositions=((bDriverVisible=false,bAllowFocus=true,PositionCameraTag=None,ViewFOV=70.0,bRotateGunOnCommand=true,PositionUpAnim=Gunner_portTOclose,PositionIdleAnim=Gunner_Close_Idle,DriverIdleAnim=Gunner_Close_Idle,AlternateIdleAnim=Gunner_Close_Idle_AI,SeatProxyIndex=4,
							        LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=GunnerElevationHandle,DefaultEffectorRotationTargetName=GunnerElevationHandle),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=GunnerTraverseHandle,DefaultEffectorRotationTargetName=GunnerTraverseHandle),
									LeftFootIKInfo=(IKEnabled=false),
									RightFootIKInfo=(IKEnabled=false),
									PositionFlinchAnims=(Gunner_close_Flinch),
									PositionDeathAnims=(Gunner_Death),
									PositionInteractions=((InteractionIdleAnim=Gunner_sideport_Idle,StartInteractionAnim=Gunner_closeTOsideport,EndInteractionAnim=Gunner_sideportTOclose,FlinchInteractionAnim=Gunner_sideport_Flinch,
										ViewFOV=70,bAllowFocus=true,InteractionSocketTag=GunnerViewPort,InteractDotAngle=0.95,bUseDOF=true))),
							   (bDriverVisible=false,bAllowFocus=false,PositionCameraTag=Camera_Gunner,ViewFOV=13.5,bCamRotationFollowSocket=true,bViewFromCameraTag=true,bDrawOverlays=true,PositionDownAnim=Gunner_closeTOport,PositionIdleAnim=Gunner_port_idle,DriverIdleAnim=Gunner_port_idle,AlternateIdleAnim=Gunner_port_idle_AI,SeatProxyIndex=4,
									LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=GunnerElevationHandle,DefaultEffectorRotationTargetName=GunnerElevationHandle),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=GunnerTraverseHandle,DefaultEffectorRotationTargetName=GunnerTraverseHandle),
									LeftFootIKInfo=(IKEnabled=false),
									RightFootIKInfo=(IKEnabled=false),
									PositionFlinchAnims=(Gunner_close_Flinch),
									PositionDeathAnims=(Gunner_Death))),
				DriverDamageMult=1.0,
				InitialPositionIndex=0,
				FiringPositionIndex=1,
				TracerFrequency=5,
				WeaponTracerClass=(none,class'MG34BulletTracer'),
				MuzzleFlashLightClass=(class'ROGrenadeExplosionLight',class'ROVehicleMGMuzzleFlashLight'),
				SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
				VehicleBloodMICParameterName=Gore01,
				FadedTransTimes=(6.25,1.5,0,6.25,5),
				)}

	Seats(1)={(	CameraTag=None,
				CameraOffset=-420,
				SeatAnimBlendName=LoaderPositionNode,
				DriverDamageMult=1.0,
				InitialPositionIndex=0,
				TurretVarPrefix="Loader",
				SeatPositions=((bDriverVisible=false,PositionIdleAnim=Loader_idle,AlternateIdleAnim=Loader_idle,SeatProxyIndex=3,
				                    LeftHandIKInfo=(PinEnabled=true),
				                    RightHandIKInfo=(PinEnabled=true),
				                    HipsIKInfo=(PinEnabled=true),
				                    PositionFlinchAnims=(Loader_Flinch),
									PositionDeathAnims=(Loader_Death),
				                    HeightInfo=(HeightDisplacementEnabled=false,
										AlternateHeightTargets=((Action=DAct_ReloadCoaxMG,HeightDisplacementEnabled=true,OriginalHeightTargetName=DefualtMGReload,ModifiedHeightTargetName=CurrentMGReload))),
									LeftHandIKInfo=(IKEnabled=false,
										AlternateEffectorTargets=((Action=DAct_CannonReload_LH1,IKEnabled=true,PinEnabled=false,EffectorLocationTargetName=LoaderLHCannon1,EffectorRotationTargetName=LoaderLHCannon1),
																  (Action=DAct_CannonReload_LH2,IKEnabled=true,PinEnabled=false,EffectorLocationTargetName=LoaderLHCannon2,EffectorRotationTargetName=LoaderLHCannon2),
																  (Action=DAct_CannonReload_LH3,IKEnabled=true,PinEnabled=false,EffectorLocationTargetName=LoaderLHCannonBreech1,EffectorRotationTargetName=LoaderLHCannonBreech1),
																  (Action=DAct_CannonReload_LHOff,IKEnabled=false,PinEnabled=true))),
									RightHandIKInfo=(IKEnabled=false,
										AlternateEffectorTargets=((Action=DAct_CannonReload_RH1,IKEnabled=true,PinEnabled=false,EffectorLocationTargetName=LoaderRHCannon1,EffectorRotationTargetName=LoaderRHCannon1),
																  (Action=DAct_CannonReload_RH2,IKEnabled=true,PinEnabled=false,EffectorLocationTargetName=LoaderRHCannonMG1,EffectorRotationTargetName=LoaderRHCannonMG1),
																  (Action=DAct_CannonReload_RHOff,IKEnabled=false,PinEnabled=true)))
								)),
				bSeatVisible=true,
				SeatBone=Turret,
				SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
				VehicleBloodMICParameterName=Gore01,
				FadedTransTimes=(6.25,1.5,6.25,1.5,0),
				)}

	LeftWheels(0)="L0_Wheel_Static"
	LeftWheels(1)="L1_Wheel"
	LeftWheels(2)="L2_Wheel"
	LeftWheels(3)="L3_Wheel"
	LeftWheels(4)="L4_Wheel"
	LeftWheels(5)="L5_Wheel"
	LeftWheels(6)="L6_Wheel"
	LeftWheels(7)="L7_Wheel_Static"
	LeftWheels(8)="L8_9_10_Wheel_Static"

	RightWheels(0)="R0_Wheel_Static"
	RightWheels(1)="R1_Wheel"
	RightWheels(2)="R2_Wheel"
	RightWheels(3)="R3_Wheel"
	RightWheels(4)="R4_Wheel"
	RightWheels(5)="R5_Wheel"
	RightWheels(6)="R6_Wheel"
	RightWheels(7)="R7_Wheel_Static"
	RightWheels(8)="R8_9_10_Wheel_Static"

/** Physics Wheels */

	// Right Rear Wheel
	Begin Object Name=RRWheel
		BoneName="R_Wheel_06"
		BoneOffset=(X=0,Y=0,Z=0)
		WheelRadius=15
	End Object
	Wheels(0)=RRWheel

	// Right middle wheel
	Begin Object Name=RMWheel
		BoneName="R_Wheel_04"
		BoneOffset=(X=0,Y=0,Z=0)
		WheelRadius=15
	End Object
	Wheels(1)=RMWheel

	// Right Front Wheel
	Begin Object Name=RFWheel
		BoneName="R_Wheel_01"
		BoneOffset=(X=0,Y=0,Z=0)
		WheelRadius=15
	End Object
	Wheels(2)=RFWheel

	// Left Rear Wheel
	Begin Object Name=LRWheel
		BoneName="L_Wheel_06"
		BoneOffset=(X=0,Y=0,Z=0)
		WheelRadius=15
	End Object
	Wheels(3)=LRWheel

	// Left Middle Wheel
	Begin Object Name=LMWheel
		BoneName="L_Wheel_4"	// Name of this bone is slightly different due to issues with the original bone that couldn't be resolved
		BoneOffset=(X=0,Y=0,Z=0)
		WheelRadius=15
	End Object
	Wheels(4)=LMWheel

	// Left Front Wheel
	Begin Object Name=LFWheel
		BoneName="L_Wheel_01"
		BoneOffset=(X=0,Y=0,Z=0)
		WheelRadius=15
	End Object
	Wheels(5)=LFWheel

	VehicleEffects(TankVFX_Firing1)=(EffectStartTag=PanzerIIIMCannon,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_B_TankMuzzle',EffectSocket=Barrel,bRestartRunning=true)
	VehicleEffects(TankVFX_Firing2)=(EffectStartTag=PanzerIIIMCannon,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_B_TankCannon_Dust',EffectSocket=attachments_body_ground,bRestartRunning=true)
	
	VehicleEffects(TankVFX_DmgSmoke)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_Damage',EffectSocket=attachments_engine)
	
	VehicleEffects(TankVFX_DeathSmoke1)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_1)
	VehicleEffects(TankVFX_DeathSmoke2)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_2)
	VehicleEffects(TankVFX_DeathSmoke3)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_3)

	CannonFireImpulseMag=20000
	CannonFireTorqueMag=9375

	BaseEyeHeight=60.0

	bDebugPenetration=false

	VehHitZones(0)=(ZoneName=ENGINEBLOCK,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=100,VisibleFrom=14)
	VehHitZones(1)=(ZoneName=ENGINECORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=300,VisibleFrom=14)
	VehHitZones(2)=(ZoneName=MGAMMOSTOREONE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.4,VisibleFrom=5)
	VehHitZones(3)=(ZoneName=MGAMMOSTORETWO,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=9)
	VehHitZones(4)=(ZoneName=AMMOSTOREONE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=20,KillPercentage=0.4,VisibleFrom=5)
	VehHitZones(5)=(ZoneName=AMMOSTORETWO,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=9)
	VehHitZones(6)=(ZoneName=AMMOSTORETHREE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=4)
	VehHitZones(7)=(ZoneName=AMMOSTOREFOUR,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=8)
	VehHitZones(8)=(ZoneName=FUELTANKONE,DamageMultiplier=10.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=100,KillPercentage=0.3,VisibleFrom=6)
	VehHitZones(9)=(ZoneName=FUELTANKTWO,DamageMultiplier=10.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=100,KillPercentage=0.3,VisibleFrom=10)
	VehHitZones(10)=(ZoneName=GEARBOX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=100,VisibleFrom=1)
	VehHitZones(11)=(ZoneName=GEARBOXCORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=200,VisibleFrom=1)
	VehHitZones(12)=(ZoneName=LEFTBRAKES,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=5)
	VehHitZones(13)=(ZoneName=RIGHTBRAKES,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=9)
	VehHitZones(14)=(ZoneName=TURRETRINGONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=13)
	VehHitZones(15)=(ZoneName=TURRETRINGTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=9)
	VehHitZones(16)=(ZoneName=TURRETRINGTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=10)
	VehHitZones(17)=(ZoneName=TURRETRINGFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=5)
	VehHitZones(18)=(ZoneName=TURRETRINGFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=6)
	VehHitZones(19)=(ZoneName=TURRETRINGSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=14)
	VehHitZones(20)=(ZoneName=COAXIALMG,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25)
	VehHitZones(21)=(ZoneName=MAINCANNONREAR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=50,KillPercentage=0.3)
	VehHitZones(22)=(ZoneName=DRIVERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Driver_bone)
	VehHitZones(23)=(ZoneName=DRIVERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Driver_bone)
	VehHitZones(24)=(ZoneName=HULLMGBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=3,SeatProxyIndex=2,CrewBoneName=Hullgunner_Bone)
	VehHitZones(25)=(ZoneName=HULLMGHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=3,SeatProxyIndex=2,CrewBoneName=Hullgunner_Bone)
	VehHitZones(26)=(ZoneName=COMMANDERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=Commander_Bone)
	VehHitZones(27)=(ZoneName=COMMANDERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=Commander_Bone)
	VehHitZones(28)=(ZoneName=LOADERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=4,SeatProxyIndex=3,CrewBoneName=Loader_Bone)
	VehHitZones(29)=(ZoneName=LOADERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=4,SeatProxyIndex=3,CrewBoneName=Loader_Bone)
	VehHitZones(30)=(ZoneName=GUNNERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=2,SeatProxyIndex=4,CrewBoneName=Turretgunner_Bone)
	VehHitZones(31)=(ZoneName=GUNNERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=2,SeatProxyIndex=4,CrewBoneName=Turretgunner_Bone)
	VehHitZones(32)=(ZoneName=LEFTTRACKONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200,VisibleFrom=5)
	VehHitZones(33)=(ZoneName=LEFTTRACKTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(34)=(ZoneName=LEFTTRACKTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(35)=(ZoneName=LEFTTRACKFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(36)=(ZoneName=LEFTTRACKFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(37)=(ZoneName=LEFTTRACKSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(38)=(ZoneName=LEFTTRACKSEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(39)=(ZoneName=LEFTTRACKEIGHT,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(40)=(ZoneName=LEFTTRACKNINE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(41)=(ZoneName=LEFTTRACKTEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(42)=(ZoneName=RIGHTTRACKONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200,VisibleFrom=9)
	VehHitZones(43)=(ZoneName=RIGHTTRACKTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(44)=(ZoneName=RIGHTTRACKTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(45)=(ZoneName=RIGHTTRACKFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(46)=(ZoneName=RIGHTTRACKFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(47)=(ZoneName=RIGHTTRACKSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(48)=(ZoneName=RIGHTTRACKSEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(49)=(ZoneName=RIGHTTRACKEIGHT,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(50)=(ZoneName=RIGHTTRACKNINE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(51)=(ZoneName=RIGHTTRACKTEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(52)=(ZoneName=RIGHTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
	VehHitZones(53)=(ZoneName=LEFTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)

	// Hit zones in the physics asset that detect armor hits
	ArmorHitZones(0)=(ZoneName=FRONTARMORLOWER,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTLOWER)
	ArmorHitZones(1)=(ZoneName=FRONTARMORGLACIS,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTGLACIS)
	ArmorHitZones(2)=(ZoneName=FRONTARMORFACING,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTUPPER)
	ArmorHitZones(3)=(ZoneName=FRONTARMORSUBGLACIS,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTSUBGLACIS)
	ArmorHitZones(4)=(ZoneName=LEFTFRONTARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTLOWERFRONT)
	ArmorHitZones(5)=(ZoneName=LEFTFRONTARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTLOWERFRONT)
	ArmorHitZones(6)=(ZoneName=LEFTARMORLOWERFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTLOWERFRONT)
	ArmorHitZones(7)=(ZoneName=LEFTARMORUPPERFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTUPPERFRONT)
	ArmorHitZones(8)=(ZoneName=LEFTARMORLOWERREAR,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTLOWERREAR)
	ArmorHitZones(9)=(ZoneName=LEFTARMORUPPERREAR,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTUPPERREAR)
	ArmorHitZones(10)=(ZoneName=LEFTREARARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTLOWERREAR)
	ArmorHitZones(11)=(ZoneName=LEFTREARARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTUPPERREAR)
	ArmorHitZones(12)=(ZoneName=LEFTREARARMORTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTUPPERREAR)
	ArmorHitZones(13)=(ZoneName=ROOFARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=ROOFFRONT)
	ArmorHitZones(14)=(ZoneName=ROOFARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=ROOFREAR)
	ArmorHitZones(15)=(ZoneName=FLOORARMOR,PhysBodyBoneName=Chassis,ArmorPlateName=FLOOR)
	ArmorHitZones(16)=(ZoneName=REARARMORLOWER,PhysBodyBoneName=Chassis,ArmorPlateName=REARLOWER)
	ArmorHitZones(17)=(ZoneName=REARARMORUPPER,PhysBodyBoneName=Chassis,ArmorPlateName=REARUPPER)
	ArmorHitZones(18)=(ZoneName=RIGHTFRONTARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTLOWERFRONT)
	ArmorHitZones(19)=(ZoneName=RIGHTFRONTARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTLOWERFRONT)
	ArmorHitZones(20)=(ZoneName=RIGHTARMORLOWERFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTLOWERFRONT)
	ArmorHitZones(21)=(ZoneName=RIGHTARMORUPPERFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTUPPERFRONT)
	ArmorHitZones(22)=(ZoneName=RIGHTARMORUPPERREAR,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTUPPERREAR)
	ArmorHitZones(23)=(ZoneName=RIGHTARMORLOWERREAR,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTLOWERREAR)
	ArmorHitZones(24)=(ZoneName=RIGHTREARARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTLOWERREAR)
	ArmorHitZones(25)=(ZoneName=RIGHTREARARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTUPPERREAR)
	ArmorHitZones(26)=(ZoneName=RIGHTREARARMORTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTUPPERREAR)
	ArmorHitZones(27)=(ZoneName=TURRETFRONTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETFRONT)
	ArmorHitZones(28)=(ZoneName=TURRETFRONTLEFTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETFRONT)
	ArmorHitZones(29)=(ZoneName=TURRETFRONTRIGHTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETFRONT)
	ArmorHitZones(30)=(ZoneName=LEFTFRONTTURRETARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETLEFTFRONT)
	ArmorHitZones(31)=(ZoneName=LEFTREARTURRETARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETLEFTREAR)
	ArmorHitZones(32)=(ZoneName=TURRETREARARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETREAR)
	ArmorHitZones(33)=(ZoneName=TURRETREARLEFTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETREAR)
	ArmorHitZones(34)=(ZoneName=TURRETREARRIGHTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETREAR)
	ArmorHitZones(35)=(ZoneName=RIGHTREARTURRETARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRIGHTREAR)
	ArmorHitZones(36)=(ZoneName=RIGHTFRONTTURRETARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRIGHTFRONT)
	ArmorHitZones(37)=(ZoneName=TURRETROOFARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETROOF)
	ArmorHitZones(38)=(ZoneName=CUPOLAARMORONE,PhysBodyBoneName=Turret,ArmorPlateName=CUPOLA)
	ArmorHitZones(39)=(ZoneName=CUPOLAARMORTWO,PhysBodyBoneName=Turret,ArmorPlateName=CUPOLA)
	ArmorHitZones(40)=(ZoneName=CUPOLAARMORTHREE,PhysBodyBoneName=Turret,ArmorPlateName=CUPOLA)
	ArmorHitZones(41)=(ZoneName=CUPOLAARMORFOUR,PhysBodyBoneName=Turret,ArmorPlateName=CUPOLA)
	ArmorHitZones(42)=(ZoneName=CUPOLAROOFARMOR,PhysBodyBoneName=Turret,ArmorPlateName=CUPOLAROOF)
	ArmorHitZones(43)=(ZoneName=CANNONGLACISARMOR,PhysBodyBoneName=gun_base,ArmorPlateName=CANNONGLACIS)
	ArmorHitZones(44)=(ZoneName=DRIVERFRONTVISIONSLIT,PhysBodyBoneName=Chassis,ArmorPlateName=DRIVERFRONTVISIONSLIT)
	ArmorHitZones(45)=(ZoneName=DRIVERSIDEVISIONSLIT,PhysBodyBoneName=Chassis,ArmorPlateName=DRIVERSIDEVISIONSLIT)
	ArmorHitZones(46)=(ZoneName=HULLMGSIDEVISIONSLIT,PhysBodyBoneName=Chassis,ArmorPlateName=HULLMGSIDEVISIONSLIT)
	ArmorHitZones(47)=(ZoneName=RIGHTENGINEDECKGRATING,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTENGINEDECKGRATING)
	ArmorHitZones(48)=(ZoneName=LEFTENGINEDECKGRATING,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTENGINEDECKGRATING)
	ArmorHitZones(49)=(ZoneName=GUNNERSIDEVISIONSLIT,PhysBodyBoneName=Turret,ArmorPlateName=GUNNERSIDEVISIONSLIT)
	ArmorHitZones(50)=(ZoneName=LOADERSIDEVISIONSLIT,PhysBodyBoneName=Turret,ArmorPlateName=LOADERSIDEVISIONSLIT)
	ArmorHitZones(51)=(ZoneName=CUPOLAVIEWSLITONE,PhysBodyBoneName=Turret,ArmorPlateName=CUPOLAVIEWSLITONE)
	ArmorHitZones(52)=(ZoneName=CUPOLAVIEWSLITTWO,PhysBodyBoneName=Turret,ArmorPlateName=CUPOLAVIEWSLITTWO)
	ArmorHitZones(53)=(ZoneName=CUPOLAVIEWSLITTHREE,PhysBodyBoneName=Turret,ArmorPlateName=CUPOLAVIEWSLITTHREE)
	ArmorHitZones(54)=(ZoneName=CUPOLAVIEWSLITFOUR,PhysBodyBoneName=Turret,ArmorPlateName=CUPOLAVIEWSLITFOUR)
	ArmorHitZones(55)=(ZoneName=CUPOLAVIEWSLITFIVE,PhysBodyBoneName=Turret,ArmorPlateName=CUPOLAVIEWSLITFIVE)

	// Armor plates that store the info for the actual plates
	ArmorPlates(0)=(PlateName=FRONTLOWER,ArmorZoneType=AZT_Front,PlateThickness=50,OverallHardness=331,bHighHardness=false)
	ArmorPlates(1)=(PlateName=FRONTSUBGLACIS,ArmorZoneType=AZT_Front,PlateThickness=50,OverallHardness=331,bHighHardness=false)
	ArmorPlates(2)=(PlateName=FRONTGLACIS,ArmorZoneType=AZT_Front,PlateThickness=26,OverallHardness=347,bHighHardness=false)
	ArmorPlates(3)=(PlateName=FRONTUPPER,ArmorZoneType=AZT_Front,PlateThickness=50,OverallHardness=331,bHighHardness=false)
	ArmorPlates(4)=(PlateName=LEFTLOWERFRONT,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(5)=(PlateName=LEFTUPPERFRONT,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(6)=(PlateName=LEFTLOWERREAR,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(7)=(PlateName=LEFTUPPERREAR,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(8)=(PlateName=ROOFFRONT,ArmorZoneType=AZT_Roof,PlateThickness=10,OverallHardness=450,bHighHardness=true)
	ArmorPlates(9)=(PlateName=ROOFREAR,ArmorZoneType=AZT_Roof,PlateThickness=17,OverallHardness=347,bHighHardness=false)
	ArmorPlates(10)=(PlateName=FLOOR,ArmorZoneType=AZT_Floor,PlateThickness=16,OverallHardness=347,bHighHardness=false)
	ArmorPlates(11)=(PlateName=REARLOWER,ArmorZoneType=AZT_Back,PlateThickness=50,OverallHardness=331,bHighHardness=false)
	ArmorPlates(12)=(PlateName=REARUPPER,ArmorZoneType=AZT_Back,PlateThickness=53,OverallHardness=316,bHighHardness=false)
	ArmorPlates(13)=(PlateName=RIGHTLOWERFRONT,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(14)=(PlateName=RIGHTUPPERFRONT,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(15)=(PlateName=RIGHTLOWERREAR,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(16)=(PlateName=RIGHTUPPERREAR,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(17)=(PlateName=TURRETFRONT,ArmorZoneType=AZT_TurretFront,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(18)=(PlateName=TURRETLEFTFRONT,ArmorZoneType=AZT_TurretLeft,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(19)=(PlateName=TURRETLEFTREAR,ArmorZoneType=AZT_TurretLeft,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(20)=(PlateName=TURRETREAR,ArmorZoneType=AZT_TurretBack,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(21)=(PlateName=TURRETRIGHTREAR,ArmorZoneType=AZT_TurretRight,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(22)=(PlateName=TURRETRIGHTFRONT,ArmorZoneType=AZT_TurretRight,PlateThickness=30,OverallHardness=347,bHighHardness=false)
	ArmorPlates(23)=(PlateName=TURRETROOF,ArmorZoneType=AZT_TurretRoof,PlateThickness=10,OverallHardness=450,bHighHardness=true)
	ArmorPlates(24)=(PlateName=CUPOLA,ArmorZoneType=AZT_Cuppola,PlateThickness=50,OverallHardness=331,bHighHardness=false)
	ArmorPlates(25)=(PlateName=CUPOLAROOF,ArmorZoneType=AZT_Cuppola,PlateThickness=9,OverallHardness=450,bHighHardness=true)
	ArmorPlates(26)=(PlateName=CANNONGLACIS,ArmorZoneType=AZT_TurretFront,PlateThickness=70,OverallHardness=331,bHighHardness=false) // was 50, but using 70 to simulate it being rounded, since our model can't calculate rounded surfaces properly
	ArmorPlates(27)=(PlateName=DRIVERFRONTVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=80,OverallHardness=150,bHighHardness=false)
	ArmorPlates(28)=(PlateName=DRIVERSIDEVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(29)=(PlateName=HULLMGSIDEVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(30)=(PlateName=GUNNERSIDEVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(31)=(PlateName=LOADERSIDEVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(32)=(PlateName=CUPOLAVIEWSLITONE,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(33)=(PlateName=CUPOLAVIEWSLITTWO,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(34)=(PlateName=CUPOLAVIEWSLITTHREE,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(35)=(PlateName=CUPOLAVIEWSLITFOUR,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(36)=(PlateName=CUPOLAVIEWSLITFIVE,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(37)=(PlateName=RIGHTENGINEDECKGRATING,ArmorZoneType=AZT_WeakSpots,PlateThickness=10,OverallHardness=150,bHighHardness=false)
	ArmorPlates(38)=(PlateName=LEFTENGINEDECKGRATING,ArmorZoneType=AZT_WeakSpots,PlateThickness=10,OverallHardness=150,bHighHardness=false)

	AmmoStorageTextureOffsets(0)=(PositionOffset=(X=46,Y=75,Z=0),MySizeX=16,MYSizeY=16)
	AmmoStorageTextureOffsets(1)=(PositionOffset=(X=79,Y=75,Z=0),MySizeX=16,MYSizeY=16)

	FuelTankTextureOffsets(0)=(PositionOffset=(X=45,Y=92,Z=0),MySizeX=16,MYSizeY=16)
	FuelTankTextureOffsets(1)=(PositionOffset=(X=80,Y=92,Z=0),MySizeX=16,MYSizeY=16)

	TurretArmorTextureOffsets(0)=(PositionOffset=(X=-0,Y=-9,Z=0),MySizeX=40,MYSizeY=20)
	TurretArmorTextureOffsets(1)=(PositionOffset=(X=-0,Y=+16,Z=0),MySizeX=38,MYSizeY=19)
	TurretArmorTextureOffsets(2)=(PositionOffset=(X=-10,Y=+2,Z=0),MySizeX=16,MYSizeY=64)
	TurretArmorTextureOffsets(3)=(PositionOffset=(X=+11,Y=+2,Z=0),MySizeX=16,MYSizeY=64)

	MainGunTextureOffset=(PositionOffset=(X=-0,Y=-32,Z=0),MySizeX=14,MYSizeY=37)

	SeatTextureOffsets(0)=(PositionOffSet=(X=+7,Y=+1,Z=0),bTurretPosition=1)
	SeatTextureOffsets(1)=(PositionOffSet=(X=-7,Y=+1,Z=0),bTurretPosition=1)

	ScopeLensMaterial=Material'Vehicle_Mats.M_Common_Vehicles.scope_lens'

	TankControllerClass=class'CCSTankControllerPIII'
}
