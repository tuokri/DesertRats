//=============================================================================
// WFAVehicle_Willys_Desert_Content.uc
//=============================================================================
// Willy MB Jeep w Desert Camo (Content)
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAVehicle_Willys_Desert_Content extends WFAVehicle_Willys_Desert 
	placeable;

DefaultProperties
{
	// ------------------------------- Mesh --------------------------------------------------------------

	Begin Object Name=ROSVehicleMesh
		SkeletalMesh=SkeletalMesh'WF_Vehicles_Jeep.jeep_rig_master'	
		LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
		AnimTreeTemplate=AnimTree'WF_Vehicles_Jeep.AT_Jeep'
		PhysicsAsset=PhysicsAsset'WF_Vehicles_Jeep.jeep_Physics'
		AnimSets.Add(AnimSet'WF_Vehicles_Jeep.jeepAnims')
	End Object

	// -------------------------------- Sounds -----------------------------------------------------------

	// Engine start sounds
	Begin Object Class=AudioComponent Name=StartEngineLSound
		SoundCue=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Engine_Start_Cabin_L_Cue'
	End Object
	EngineStartLeftSound=StartEngineLSound

	Begin Object Class=AudioComponent Name=StartEngineRSound
		SoundCue=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Engine_Start_Cabin_R_Cue'
	End Object
	EngineStartRightSound=StartEngineRSound

	Begin Object Class=AudioComponent Name=StartEngineExhaustSound
		SoundCue=SoundCue'AUD_Vehicle_Transport_UC.Movement.UC_Movement_Engine_Start_Exhaust_Cue'
	End Object
	EngineStartExhaustSound=StartEngineExhaustSound

	Begin Object Class=AudioComponent Name=StopEngineSound
		SoundCue=SoundCue'AUD_Vehicle_Transport_UC.Movement.UC_Movement_Engine_Stop_Cue'
	End Object
	EngineStopSound=StopEngineSound

	// Engine idle sounds
	Begin Object Class=AudioComponent Name=IdleEngineLeftSound
		SoundCue=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Engine_Run_Cabin_L_Cue'
		bShouldRemainActiveIfDropped=TRUE
	End Object
	EngineIntLeftSound=IdleEngineLeftSound

	Begin Object Class=AudioComponent Name=IdleEngineRighSound
		SoundCue=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Engine_Run_Cabin_R_Cue'
		bShouldRemainActiveIfDropped=TRUE
	End Object
	EngineIntRightSound=IdleEngineRighSound

	Begin Object Class=AudioComponent Name=IdleEngineExhaustSound
		SoundCue=SoundCue'AUD_Vehicle_Transport_UC.Movement.UC_Movement_Engine_Run_Exhaust_Cue'
		bShouldRemainActiveIfDropped=TRUE
	End Object
	EngineSound=IdleEngineExhaustSound

	// Track sounds
	Begin Object Class=AudioComponent Name=TrackLSound
		SoundCue=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Treads_L_Cue'
	End Object
	TrackLeftSound=TrackLSound

	Begin Object Class=AudioComponent Name=TrackRSound
		SoundCue=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Treads_R_Cue'
	End Object
	TrackRightSound=TrackRSound

	// Brake sounds
	Begin Object Class=AudioComponent Name=BrakeLeftSnd
		SoundCue=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Treads_Brake_Cue'
	End Object
	BrakeLeftSound=BrakeLeftSnd

	Begin Object Class=AudioComponent Name=BrakeRightSnd
		SoundCue=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Treads_Brake_Cue'
	End Object
	BrakeRightSound=BrakeRightSnd

	EngineIdleDamagedSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Broken_Cue'
	TrackTakeDamageSound=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Treads_Brake_Cue'
	TrackDamagedSound=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Treads_Broken_Cue'
	TrackDestroyedSound=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Treads_Skid_Cue'

	Begin Object Class=AudioComponent Name=BrokenTransmissionSnd
		SoundCue=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Transmission_Broken_Cue'
		bStopWhenOwnerDestroyed=TRUE
	End Object
	BrokenTransmissionSound=BrokenTransmissionSnd

	ShiftUpSound=SoundCue'AUD_Vehicle_Transport_UC.Movement.UC_Movement_Engine_Exhaust_ShiftUp_Cue'
	ShiftDownSound=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Engine_Exhaust_ShiftDown_Cue'
	ShiftLeverSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Foley.Panzer_Lever_GearShift_Cue'

	ExplosionSound=SoundCue'AUD_EXP_Tanks.A_CUE_Tank_Explode'

	DestroyedSkeletalMesh=SkeletalMesh'WF_Vehicles_Jeep.jeep_destroyed'
	DestroyedPhysicsAsset=PhysicsAsset'WF_Vehicles_Jeep.jeep_Physics'
	DestroyedMaterial=MaterialInstanceConstant'WF_Vehicles_Jeep.M_Willy_Jeep_Inst'
	DestroyedTurretClass=none

	HUDBodyTexture=Texture2D'UI_Textures_VehiclePack.HUD.Vehicles.UniC.ui_hud_uc_VehicleBase'
	HUDTurretTexture=none
	DriverOverlayTexture=none

	HUDMainCannonTexture=none
	HUDGearBoxTexture=Texture2D'UI_Textures_VehiclePack.HUD.Vehicles.UniC.ui_hud_uc_Transmission'
	HUDFrontArmorTexture=Texture2D'UI_Textures_VehiclePack.HUD.Vehicles.UniC.ui_hud_uc_FrontArmor'
	HUDBackArmorTexture=Texture2D'UI_Textures_VehiclePack.HUD.Vehicles.UniC.ui_hud_uc_RearArmor'
	HUDLeftArmorTexture=Texture2D'UI_Textures_VehiclePack.HUD.Vehicles.UniC.ui_hud_uc_LeftArmor'
	HUDRightArmorTexture=Texture2D'UI_Textures_VehiclePack.HUD.Vehicles.UniC.ui_hud_uc_RightArmor'

	SeatProxies(0)={(
		TunicMeshType=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Tunic',
		HeadGearMeshType=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Headgear_Helmet',
		HeadAndArmsMeshType=SkeletalMesh'CHR_RS_USA_Heads.Mesh.USA_Head_01_Adam',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_RS_USA_Heads.MIC.M_USA_Rank1_Head_01_Adam_INST',
		BodyMICTemplate=MaterialInstanceConstant'WFAMDL_CHR_UK.MIC.WFA_UK_Tunic',
		SeatIndex=0,
		PositionIndex=1)}

	
	SeatProxies(1)={(
		TunicMeshType=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Tunic',
		HeadGearMeshType=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Headgear_Helmet',
		HeadAndArmsMeshType=SkeletalMesh'CHR_RS_USA_Heads.Mesh.USA_Head_01_Adam',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_RS_USA_Heads.MIC.M_USA_Rank1_Head_01_Adam_INST',
		BodyMICTemplate=MaterialInstanceConstant'WFAMDL_CHR_UK.MIC.WFA_UK_Tunic',
		SeatIndex=1,
		PositionIndex=0)}

	SeatProxies(2)={(
		TunicMeshType=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Tunic',
		HeadGearMeshType=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Headgear_Helmet',
		HeadAndArmsMeshType=SkeletalMesh'CHR_RS_USA_Heads.Mesh.USA_Head_01_Adam',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_RS_USA_Heads.MIC.M_USA_Rank1_Head_01_Adam_INST',
		BodyMICTemplate=MaterialInstanceConstant'WFAMDL_CHR_UK.MIC.WFA_UK_Tunic',
		SeatIndex=2,
		PositionIndex=0)}
	
	SeatProxies(3)={(
		TunicMeshType=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Tunic',
		HeadGearMeshType=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Headgear_Helmet',
		HeadAndArmsMeshType=SkeletalMesh'CHR_RS_USA_Heads.Mesh.USA_Head_01_Adam',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_RS_USA_Heads.MIC.M_USA_Rank1_Head_01_Adam_INST',
		BodyMICTemplate=MaterialInstanceConstant'WFAMDL_CHR_UK.MIC.WFA_UK_Tunic',
		SeatIndex=3,
		PositionIndex=0)}

	SeatProxyAnimSet=AnimSet'VH_ger_SdKfz.Anim.CHR_SdkFz_Anim_Master'
	
	Begin Object class=StaticMeshComponent name=ExtBodyAttachment0
		StaticMesh=StaticMesh'WF_Vehicles_Jeep.JEEP_Body'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_Foreground
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
	End Object

	Begin Object class=StaticMeshComponent name=IntBodyAttachment0
		StaticMesh=StaticMesh'WF_Vehicles_Jeep.jeep_glass'
		LightingChannels=(Dynamic=FALSE,Unnamed_1=TRUE,bInitialized=TRUE)
		LightEnvironment = MyInteriorLightEnvironment
		CastShadow=false
		DepthPriorityGroup=SDPG_Foreground
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
	End Object

	MeshAttachments(0)={(AttachmentName=ExtBodyComponent,Component=ExtBodyAttachment0,bAttachToSocket=true,AttachmentTargetName=body)}
	MeshAttachments(1)={(AttachmentName=IntBodyComponent,Component=IntBodyAttachment0,bAttachToSocket=true,AttachmentTargetName=windshield)}
}
