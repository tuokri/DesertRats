//=============================================================================
// WFAVehicle_Willys_Desert.uc
//=============================================================================
// Willy MB Jeep w Desert Camo
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAVehicle_Willys_Desert extends WFAVehicleSoftSkinnedTransport
	abstract;

var repnotify byte PassengerOneCurrentPositionIndex;
var repnotify bool bDrivingPassengerOne;
var repnotify byte PassengerTwoCurrentPositionIndex;
var repnotify bool bDrivingPassengerTwo;
var repnotify byte PassengerThreeCurrentPositionIndex;
var repnotify bool bDrivingPassengerThree;

var repnotify TakeHitInfo DeathHitInfo_ProxyDriver;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassOne;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassTwo;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassThree;

replication
{
	if (bNetDirty)
		PassengerOneCurrentPositionIndex, PassengerTwoCurrentPositionIndex,
		PassengerThreeCurrentPositionIndex, 
		bDrivingPassengerOne,bDrivingPassengerTwo,bDrivingPassengerThree;

	if (bNetDirty)
		DeathHitInfo_ProxyDriver, DeathHitInfo_ProxyPassOne,
		DeathHitInfo_ProxyPassTwo, DeathHitInfo_ProxyPassThree;
}


simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		mesh.MinLodModel = 1;
	}
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'DeathHitInfo_ProxyDriver')
	{
		PlaySeatProxyDeathHitEffects(0, DeathHitInfo_ProxyDriver);
	}
	else if (VarName == 'DeathHitInfo_ProxyPassOne')
	{
		PlaySeatProxyDeathHitEffects(1, DeathHitInfo_ProxyPassOne);
	}
	else if (VarName == 'DeathHitInfo_ProxyPassTwo')
	{
		PlaySeatProxyDeathHitEffects(2, DeathHitInfo_ProxyPassTwo);
	}
	else if (VarName == 'DeathHitInfo_ProxyPassThree')
	{
		PlaySeatProxyDeathHitEffects(3, DeathHitInfo_ProxyPassThree);
	}
	else
	{
	   super.ReplicatedEvent(VarName);
	}
}

simulated exec function SwitchFireMode()
{
	
}

function DamageSeatProxy(int SeatProxyIndex, int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional Actor DamageCauser)
{
	switch( SeatProxyIndex )
	{
	case 0:
		// Driver
		DeathHitInfo_ProxyDriver.Damage = Damage;
		DeathHitInfo_ProxyDriver.HitLocation = HitLocation;
		DeathHitInfo_ProxyDriver.Momentum = Momentum;
		DeathHitInfo_ProxyDriver.DamageType = DamageType;
		break;
	case 1:
		// Passenger One
		DeathHitInfo_ProxyPassOne.Damage = Damage;
		DeathHitInfo_ProxyPassOne.HitLocation = HitLocation;
		DeathHitInfo_ProxyPassOne.Momentum = Momentum;
		DeathHitInfo_ProxyPassOne.DamageType = DamageType;
		break;
	case 2:
		// Passenger Two
		DeathHitInfo_ProxyPassTwo.Damage = Damage;
		DeathHitInfo_ProxyPassTwo.HitLocation = HitLocation;
		DeathHitInfo_ProxyPassTwo.Momentum = Momentum;
		DeathHitInfo_ProxyPassTwo.DamageType = DamageType;
		break;
	case 3:
		// Passenger Three
		DeathHitInfo_ProxyPassThree.Damage = Damage;
		DeathHitInfo_ProxyPassThree.HitLocation = HitLocation;
		DeathHitInfo_ProxyPassThree.Momentum = Momentum;
		DeathHitInfo_ProxyPassThree.DamageType = DamageType;
		break;
	}
	
	Super.DamageSeatProxy(SeatProxyIndex, Damage, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}

DefaultProperties
{
	Team=1

	ExitRadius=180

	Begin Object Name=CollisionCylinder
		CollisionHeight=60.0
		CollisionRadius=200.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object
	CylinderComponent=CollisionCylinder

	bDontUseCollCylinderForRelevancyCheck=true
	RelevancyHeight=70.0
	RelevancyRadius=130.0

	Seats(0)={(	CameraTag=none,
			    CameraOffset=-420,
			    SeatAnimBlendName=DriverPositionNode,
			    				// Open, leaning forward
			    SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=70.0,PositionUpAnim=Driver_LeanIN_open,PositionIdleAnim=Driver_LeanIN_open_Idle,DriverIdleAnim=Driver_LeanIN_open_Idle,AlternateIdleAnim=Driver_LeanIN_open_Idle_AI,SeatProxyIndex=0,
									bIsExterior=true,
				                    LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverLeftSteer,DefaultEffectorRotationTargetName=IK_DriverLeftSteer),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverRightSteer,DefaultEffectorRotationTargetName=IK_DriverRightSteer,
										AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchLever,EffectorRotationTargetName=IK_DriverClutchLever))),
									LeftFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverClutchPedal,DefaultEffectorRotationTargetName=IK_DriverClutchPedal,
										AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchPedal,EffectorRotationTargetName=IK_DriverClutchPedal))),
									RightFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverGasPedal,DefaultEffectorRotationTargetName=IK_DriverGasPedal),
									HipsIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(Driver_open_Flinch),
									PositionDeathAnims=(Driver_Death)),

					   (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=70.0,PositionUpAnim=Driver_LeanIN_open,PositionIdleAnim=Driver_LeanIN_open_Idle,DriverIdleAnim=Driver_LeanIN_open_Idle,AlternateIdleAnim=Driver_LeanIN_open_Idle_AI,SeatProxyIndex=0,
									bIsExterior=true,
				                    LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverLeftSteer,DefaultEffectorRotationTargetName=IK_DriverLeftSteer),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverRightSteer,DefaultEffectorRotationTargetName=IK_DriverRightSteer,
										AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchLever,EffectorRotationTargetName=IK_DriverClutchLever))),
									LeftFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverClutchPedal,DefaultEffectorRotationTargetName=IK_DriverClutchPedal,
										AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchPedal,EffectorRotationTargetName=IK_DriverClutchPedal))),
									RightFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverGasPedal,DefaultEffectorRotationTargetName=IK_DriverGasPedal),
									HipsIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(Driver_open_Flinch),
									PositionDeathAnims=(Driver_Death))),
						

			bSeatVisible=true,
			DriverDamageMult=1.0,
			SeatBone=DriverAttach,
			InitialPositionIndex=0,
			SeatRotation=(Pitch=0,Yaw=0,Roll=0),
			VehicleBloodMICParameterName=Gore03
			)}

	Seats(1)={(	CameraTag=None,
		CameraOffset=-420,
		SeatAnimBlendName=Pass3PositionNode,
		SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger2_StandIdleTOSitIdle,PositionIdleAnim=Passenger2_Sit_Idle,DriverIdleAnim=Passenger2_Sit_Idle,AlternateIdleAnim=Passenger2_Sit_Idle,SeatProxyIndex=4,
		               		bIsExterior=true,
		               		PositionFlinchAnims=(MG_close_Flinch),
							PositionDeathAnims=(Passenger2_SitDeath))),
		TurretVarPrefix="PassengerOne",
		bSeatVisible=true,
		DriverDamageMult=1.0,
		InitialPositionIndex=0,
		SeatRotation=(Pitch=0,Yaw=0,Roll=0),
		SeatBone=Passanger1Attach,
		VehicleBloodMICParameterName=Gore04
		)}

	Seats(2)={(	CameraTag=None,
		CameraOffset=-420,
		SeatAnimBlendName=Pass3PositionNode,
		SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger2_StandIdleTOSitIdle,PositionIdleAnim=Passenger2_Sit_Idle,DriverIdleAnim=Passenger2_Sit_Idle,AlternateIdleAnim=Passenger2_Sit_Idle,SeatProxyIndex=4,
		               		bIsExterior=true,
		               		PositionFlinchAnims=(MG_close_Flinch),
							PositionDeathAnims=(Passenger2_SitDeath))),
		TurretVarPrefix="PassengerTwo",
		bSeatVisible=true,
		DriverDamageMult=1.0,
		InitialPositionIndex=0,
		SeatRotation=(Pitch=0,Yaw=0,Roll=0),
		SeatBone=Passanger2Attach,
		VehicleBloodMICParameterName=Gore04
		)}

	Seats(3)={(	CameraTag=None,
		CameraOffset=-420,
		SeatAnimBlendName=Pass3PositionNode,
		SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger2_StandIdleTOSitIdle,PositionIdleAnim=Passenger2_Sit_Idle,DriverIdleAnim=Passenger2_Sit_Idle,AlternateIdleAnim=Passenger2_Sit_Idle,SeatProxyIndex=4,
		               		bIsExterior=true,
		               		PositionFlinchAnims=(MG_close_Flinch),
							PositionDeathAnims=(Passenger2_SitDeath))),
		TurretVarPrefix="PassengerThree",
		bSeatVisible=true,
		DriverDamageMult=1.0,
		InitialPositionIndex=0,
		SeatRotation=(Pitch=0,Yaw=0,Roll=0),
		SeatBone=Passanger3Attach,
		VehicleBloodMICParameterName=Gore04
	)}

	PassengerAnimTree=AnimTree'CHR_Playeranimtree_Master.CHR_Tanker_animtree'
	CrewAnimSet=AnimSet'VH_ger_SdKfz.Anim.CHR_SdkFz_Anim_Master'

	LeftWheels(0)="L1_Wheel"
	LeftWheels(1)="L2_Wheel"
	RightWheels(0)="R1_Wheel"
	RightWheels(1)="R2_Wheel"
	
	Wheels.Empty
	
	Begin Object Name=RRWheel
		BoneName="RearWheelRight"
		BoneOffset=(X=0.0,Y=0.0,Z=0.0)
		WheelRadius=19.5
		SteerFactor=0.1f
	End Object
	Wheels(0)=RRWheel

	Begin Object Name=RFWheel
		BoneName="FrontWheelRight"
		BoneOffset=(X=0.0,Y=0.0,Z=0.0)
		WheelRadius=19.5
		SteerFactor=1.0f
	End Object
	Wheels(1)=RFWheel

	Begin Object Name=LRWheel
		BoneName="RearWheelLeft"
		BoneOffset=(X=0.0,Y=0.0,Z=0.0)
		WheelRadius=19.5
		SteerFactor=0.1f
	End Object
	Wheels(2)=LRWheel

	Begin Object Name=LFWheel
		BoneName="FrontWheelLeft"
		BoneOffset=(X=0.0,Y=0.0,Z=0.0)
		WheelRadius=19.5
		SteerFactor=1.0f
	End Object
	Wheels(3)=LFWheel

	DrivingPhysicalMaterial=PhysicalMaterial'WF_Vehicles_Jeep.PhysMat_Jeep_moving'
	DefaultPhysicalMaterial=PhysicalMaterial'WF_Vehicles_Jeep.PhysMat_Jeep'

	VehicleEffects(TankVFX_Exhaust)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,EffectTemplate=ParticleSystem'FX_Vehicles_Two.UniversalCarrier.FX_UnivCarrier_exhaust',EffectSocket=Exhaust)
	VehicleEffects(TankVFX_TreadWing)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bStayActive=true,EffectTemplate=ParticleSystem'FX_VEH_Tank_Three.FX_VEH_Tank_A_Wing_Dirt_T34',EffectSocket=attachments_body_ground)
	
	VehicleEffects(TankVFX_DmgSmoke)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'FX_Vehicles_Two.UniversalCarrier.FX_UnivCarrier_damaged_burning',EffectSocket=attachments_body)
	VehicleEffects(TankVFX_DmgInterior)=(EffectStartTag=DamageInterior,EffectEndTag=NoInternalSmoke,bRestartRunning=false,bInteriorEffect=true,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_Interior_Penetrate',EffectSocket=attachments_body)
	
	VehicleEffects(TankVFX_DeathSmoke1)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_1)
	VehicleEffects(TankVFX_DeathSmoke2)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_2)
	VehicleEffects(TankVFX_DeathSmoke3)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_3)

	SeatTextureOffsets(0)=(PositionOffSet=(X=-9,Y=-3,Z=0),bTurretPosition=0)
	SeatTextureOffsets(1)=(PositionOffSet=(X=0,Y=4,Z=0),bTurretPosition=0)
	SeatTextureOffsets(2)=(PositionOffSet=(X=-9,Y=15,Z=0),bTurretPosition=0)
	SeatTextureOffsets(3)=(PositionOffSet=(X=8,Y=15,Z=0),bTurretPosition=0)

	CabinL_FXSocket=Sound_Cabin_L
	CabinR_FXSocket=Sound_Cabin_R
	Exhaust_FXSocket=Exhaust
	TreadL_FXSocket=Sound_Tread_L
	TreadR_FXSocket=Sound_Tread_R

	VehHitZones(0)=(ZoneName=LEFTTRACKONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(1)=(ZoneName=LEFTTRACKTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(2)=(ZoneName=LEFTTRACKTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(3)=(ZoneName=LEFTTRACKFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(4)=(ZoneName=LEFTTRACKFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(5)=(ZoneName=LEFTTRACKSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(6)=(ZoneName=LEFTTRACKSEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(7)=(ZoneName=LEFTTRACKEIGHT,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(8)=(ZoneName=LEFTTRACKNINE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(9)=(ZoneName=LEFTTRACKTEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(10)=(ZoneName=LEFTTRACKELEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(11)=(ZoneName=RIGHTTRACKONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(12)=(ZoneName=RIGHTTRACKTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(13)=(ZoneName=RIGHTTRACKTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(14)=(ZoneName=RIGHTTRACKFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(15)=(ZoneName=RIGHTTRACKFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(16)=(ZoneName=RIGHTTRACKSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(17)=(ZoneName=RIGHTTRACKSEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(18)=(ZoneName=RIGHTTRACKEIGHT,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(19)=(ZoneName=RIGHTTRACKNINE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(20)=(ZoneName=RIGHTTRACKTEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(21)=(ZoneName=RIGHTTRACKELEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(22)=(ZoneName=LEFTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
	VehHitZones(23)=(ZoneName=RIGHTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
	VehHitZones(24)=(ZoneName=LEFTTURNINGWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
	VehHitZones(25)=(ZoneName=RIGHTTURNINGWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
	VehHitZones(26)=(ZoneName=RIGHTBRAKE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=9)
	VehHitZones(27)=(ZoneName=LEFTBRAKE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=5)
	VehHitZones(28)=(ZoneName=FUELTANK,DamageMultiplier=5.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=200,KillPercentage=0.3,VisibleFrom=15)
	VehHitZones(29)=(ZoneName=GEARBOX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=100,VisibleFrom=15)
	VehHitZones(30)=(ZoneName=GEARBOXCORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=200,VisibleFrom=15)
	VehHitZones(31)=(ZoneName=ENGINEBLOCK,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=100,VisibleFrom=13)
	VehHitZones(32)=(ZoneName=ENGINECORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=300,VisibleFrom=13)
	VehHitZones(33)=(ZoneName=PASS1BODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=2,SeatProxyIndex=2,CrewBoneName=Root_pass_l1_HITBOX)
	VehHitZones(34)=(ZoneName=PASS1HEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=2,SeatProxyIndex=2,CrewBoneName=pass_l1_head_HITBOX)
	VehHitZones(35)=(ZoneName=PASS2BODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=3,SeatProxyIndex=3,CrewBoneName=Root_pass_r1_HITBOX)
	VehHitZones(36)=(ZoneName=PASS2HEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=3,SeatProxyIndex=3,CrewBoneName=pass_r1_head_HITBOX)
	VehHitZones(37)=(ZoneName=PASS3BODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=4,SeatProxyIndex=4,CrewBoneName=Root_pass_l2_HITBOX)
	VehHitZones(38)=(ZoneName=PASS3HEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=4,SeatProxyIndex=4,CrewBoneName=pass_l2_head_HITBOX)
	VehHitZones(39)=(ZoneName=PASS4BODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=5,SeatProxyIndex=5,CrewBoneName=Root_pass_r2_HITBOX)
	VehHitZones(40)=(ZoneName=PASS4HEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=5,SeatProxyIndex=5,CrewBoneName=pass_r2_head_HITBOX)
	VehHitZones(41)=(ZoneName=PASS5BODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=6,SeatProxyIndex=6,CrewBoneName=Root_pass_l3_HITBOX)
	VehHitZones(42)=(ZoneName=PASS5HEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=6,SeatProxyIndex=6,CrewBoneName=pass_l3_head_HITBOX)
	VehHitZones(43)=(ZoneName=PASS6BODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=7,SeatProxyIndex=7,CrewBoneName=Root_pass_r3_HITBOX)
	VehHitZones(44)=(ZoneName=PASS6HEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=7,SeatProxyIndex=7,CrewBoneName=pass_r3_head_HITBOX)
	VehHitZones(45)=(ZoneName=MGGUNNERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=Root_MG_HITBOX)
	VehHitZones(46)=(ZoneName=MGGUNNERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=MG_head_HITBOX)
	VehHitZones(47)=(ZoneName=DRIVERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Root_Driver_HITBOX)
	VehHitZones(48)=(ZoneName=DRIVERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Driver_head_HITBOX)

	CrewHitZoneStart=33
	CrewHitZoneEnd=48

	// ArmorHitZones(0)=(ZoneName=BONNETRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=BONNET)
	// ArmorHitZones(1)=(ZoneName=BONNETMID,PhysBodyBoneName=Chassis,ArmorPlateName=BONNET)
	// ArmorHitZones(2)=(ZoneName=BONNETLEFT,PhysBodyBoneName=Chassis,ArmorPlateName=BONNET)
	// ArmorHitZones(3)=(ZoneName=FRONTLOWER,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTPLATE)
	// ArmorHitZones(4)=(ZoneName=FRONTLOWERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTPLATE)
	// ArmorHitZones(5)=(ZoneName=REARUNDERSIDE,PhysBodyBoneName=Chassis,ArmorPlateName=UNDERSIDE)
	// ArmorHitZones(6)=(ZoneName=REARUNDERSIDETWO,PhysBodyBoneName=Chassis,ArmorPlateName=UNDERSIDE)
	// ArmorHitZones(7)=(ZoneName=CENTRALUNDERSIDE,PhysBodyBoneName=Chassis,ArmorPlateName=UNDERSIDE)
	// ArmorHitZones(8)=(ZoneName=MIDFORWARDUNDERSIDE,PhysBodyBoneName=Chassis,ArmorPlateName=UNDERSIDE)
	// ArmorHitZones(9)=(ZoneName=FORWARDUNDERSIDE,PhysBodyBoneName=Chassis,ArmorPlateName=UNDERSIDE)
	// ArmorHitZones(10)=(ZoneName=REARDOORFRAMEONE,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(11)=(ZoneName=REARDOORFRAMETWO,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(12)=(ZoneName=REARDOORFRAMETHREE,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(13)=(ZoneName=REARDOORFRAMEFOUR,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(14)=(ZoneName=REARDOORFRAMEFIVE,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(15)=(ZoneName=REARDOORFRAMESIX,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(16)=(ZoneName=REARDOORFRAMESEVEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(17)=(ZoneName=REARDOORFRAMEEIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(18)=(ZoneName=REARDOORFRAMENINE,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(19)=(ZoneName=REARDOORFRAMETEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(20)=(ZoneName=REARDOORFRAMEELEVEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(21)=(ZoneName=REARDOORFRAMETWELVE,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(22)=(ZoneName=REARDOORFRAMETHIRTEEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(23)=(ZoneName=REARDOORFRAMEFOURTEEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(24)=(ZoneName=REARDOORFRAMEFIFTEEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(25)=(ZoneName=REARDOORFRAMESIXTEEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(26)=(ZoneName=REARDOORFRAMESEVENTEEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(27)=(ZoneName=REARDOORFRAMEEIGHTEEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
	// ArmorHitZones(28)=(ZoneName=LEFTREARUPPER,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARUPPER)
	// ArmorHitZones(29)=(ZoneName=LEFTREARUPPERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARUPPER)
	// ArmorHitZones(30)=(ZoneName=LEFTREARMIDONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARMID)
	// ArmorHitZones(31)=(ZoneName=LEFTREARLOWERONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARLOWER)
	// ArmorHitZones(32)=(ZoneName=LEFTREARLOWERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARLOWER)
	// ArmorHitZones(33)=(ZoneName=LEFTREARLOWERTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARLOWER)
	// ArmorHitZones(34)=(ZoneName=LEFTFRONTLOWERONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTLOWER)
	// ArmorHitZones(35)=(ZoneName=LEFTFRONTLOWERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTLOWER)
	// ArmorHitZones(36)=(ZoneName=LEFTFRONTLOWERTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTLOWER)
	// ArmorHitZones(37)=(ZoneName=LEFTFRONTLOWERFOUR,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTLOWER)
	// ArmorHitZones(38)=(ZoneName=LEFTFRONTUPPERONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTUPPER)
	// ArmorHitZones(39)=(ZoneName=LEFTFRONTUPPERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTUPPER)
	// ArmorHitZones(40)=(ZoneName=RIGHTFRONTUPPERONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTUPPER)
	// ArmorHitZones(41)=(ZoneName=RIGHTFRONTUPPERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTUPPER)
	// ArmorHitZones(42)=(ZoneName=RIGHTFRONTLOWERONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTLOWER)
	// ArmorHitZones(43)=(ZoneName=RIGHTFRONTLOWERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTLOWER)
	// ArmorHitZones(44)=(ZoneName=RIGHTFRONTLOWERTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTLOWER)
	// ArmorHitZones(45)=(ZoneName=RIGHTFRONTLOWERFOUR,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTLOWER)
	// ArmorHitZones(46)=(ZoneName=RIGHTREARLOWERONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARLOWER)
	// ArmorHitZones(47)=(ZoneName=RIGHTREARLOWERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARLOWER)
	// ArmorHitZones(48)=(ZoneName=RIGHTREARLOWERTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARLOWER)
	// ArmorHitZones(49)=(ZoneName=RIGHTREARUPPER,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTREARUPPER)
	// ArmorHitZones(50)=(ZoneName=RIGHTREARUPPERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTREARUPPER)
	// ArmorHitZones(51)=(ZoneName=RIGHTREARMIDONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTREARMID)
	// ArmorHitZones(52)=(ZoneName=FRONTUPPERRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTSIDEUPPER)
	// ArmorHitZones(53)=(ZoneName=FRONTUPPERCENTER,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTSIDEUPPER)
	// ArmorHitZones(54)=(ZoneName=FRONTUPPERLEFT,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTSIDEUPPER)
	// ArmorHitZones(55)=(ZoneName=SIDEVIEWSLITLEFT,PhysBodyBoneName=Chassis,ArmorPlateName=SIDEVIEWSLITLEFT)
	// ArmorHitZones(56)=(ZoneName=SIDEVIEWSLITRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=SIDEVIEWSLITRIGHT)
	// ArmorHitZones(57)=(ZoneName=FRONTVIEWSLITRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTVIEWSLITRIGHT)
	// ArmorHitZones(58)=(ZoneName=REARDOORUPPER,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORS)
	// ArmorHitZones(59)=(ZoneName=REARDOORLOWER,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORS)
	// ArmorHitZones(60)=(ZoneName=DRIVERHATCHARMOR,PhysBodyBoneName=Driver_hatch,ArmorPlateName=DRIVERHATCH)
	// ArmorHitZones(61)=(ZoneName=DRIVERHATCHOPENING,PhysBodyBoneName=Driver_hatch,bInstaPenetrateZone=true)


	// ArmorPlates(0)=(PlateName=BONNET,ArmorZoneType=AZT_Front,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(1)=(PlateName=FRONTSIDEUPPER,ArmorZoneType=AZT_Front,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(2)=(PlateName=FRONTPLATE,ArmorZoneType=AZT_Front,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(3)=(PlateName=REARDOORS,ArmorZoneType=AZT_Back,PlateThickness=6,OverallHardness=400,bHighHardness=false)
	// ArmorPlates(4)=(PlateName=REARDOORFRAME,ArmorZoneType=AZT_Back,PlateThickness=10,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(5)=(PlateName=INTERNALFLOOR,ArmorZoneType=AZT_Front,PlateThickness=6,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(6)=(PlateName=UNDERSIDE,ArmorZoneType=AZT_Floor,PlateThickness=6,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(7)=(PlateName=LEFTREARUPPER,ArmorZoneType=AZT_Left,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(8)=(PlateName=LEFTREARMID,ArmorZoneType=AZT_Left,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(9)=(PlateName=LEFTREARLOWER,ArmorZoneType=AZT_Left,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(10)=(PlateName=RIGHTREARUPPER,ArmorZoneType=AZT_Right,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(11)=(PlateName=RIGHTREARMID,ArmorZoneType=AZT_Right,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(12)=(PlateName=RIGHTREARLOWER,ArmorZoneType=AZT_Right,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(13)=(PlateName=RIGHTFRONTLOWER,ArmorZoneType=AZT_Right,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(14)=(PlateName=RIGHTFRONTUPPER,ArmorZoneType=AZT_Right,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(15)=(PlateName=LEFTFRONTUPPER,ArmorZoneType=AZT_Left,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(16)=(PlateName=LEFTFRONTLOWER,ArmorZoneType=AZT_Left,PlateThickness=14,OverallHardness=400,bHighHardness=true)
	// ArmorPlates(17)=(PlateName=SIDEVIEWSLITLEFT,ArmorZoneType=AZT_WeakSpots,PlateThickness=5,OverallHardness=150,bHighHardness=false)
	// ArmorPlates(18)=(PlateName=SIDEVIEWSLITRIGHT,ArmorZoneType=AZT_WeakSpots,PlateThickness=5,OverallHardness=150,bHighHardness=false)
	// ArmorPlates(20)=(PlateName=FRONTVIEWSLITRIGHT,ArmorZoneType=AZT_Front,PlateThickness=10,OverallHardness=340,bHighHardness=false)
	// ArmorPlates(21)=(PlateName=DRIVERHATCH,ArmorZoneType=AZT_Front,PlateThickness=10,OverallHardness=340,bHighHardness=false)

	RanOverDamageType=RODmgType_RunOver_UC
	TransportType=ROTT_UniversalCarrier
}

