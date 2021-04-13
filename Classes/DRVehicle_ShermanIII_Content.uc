class DRVehicle_ShermanIII_Content extends DRVehicle_ShermanIII
	placeable;

DefaultProperties
{
	// ------------------------------- Mesh --------------------------------------------------------------

	Begin Object Name=ROSVehicleMesh
		SkeletalMesh=SkeletalMesh'WF_Vehicles_M4A3Sherman.Mesh.sherman_rig'
		AnimTreeTemplate=AnimTree'WF_Vehicles_M4A3Sherman.Anim.AT_VH_M4A1_Sherman'
		PhysicsAsset=PhysicsAsset'WF_Vehicles_M4A3Sherman.Mesh.sherman_rig_Physics'
		AnimSets.Add(AnimSet'VH_Ger_Panzer_IVG.Anim.PZIV_anim_Master')
		AnimSets.Add(AnimSet'VH_Ger_Panzer_IVG.Anim.PZIV_Destroyed_anim_Master')
	End Object

	// -------------------------------- Sounds -----------------------------------------------------------

	/* TODO: SOUNDS
	// Engine start sounds
	Begin Object Class=AudioComponent Name=StartEngineLSound
		SoundCue=SoundCue'AUD_WF_Vehicle_M4A3.Movement.Sherman_Movement_Engine_Start_Exhaust_Cue'
	End Object
	EngineStartLeftSound=StartEngineLSound

	Begin Object Class=AudioComponent Name=StartEngineRSound
		SoundCue=SoundCue'AUD_WF_Vehicle_M4A3.Movement.Sherman_Movement_Engine_Start_Exhaust_Cue'
	End Object
	EngineStartRightSound=StartEngineRSound

	Begin Object Class=AudioComponent Name=StartEngineExhaustSound
		SoundCue=SoundCue'AUD_WF_Vehicle_M4A3.Movement.Sherman_Movement_Engine_Start_Exhaust_Cue'
	End Object
	EngineStartExhaustSound=StartEngineExhaustSound

	// Engine idle sounds
	Begin Object Class=AudioComponent Name=IdleEngineLeftSound
		SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Run_Cabin_L_Cue'
		bShouldRemainActiveIfDropped=TRUE
	End Object
	EngineIntLeftSound=IdleEngineLeftSound

	Begin Object Class=AudioComponent Name=IdleEngineRighSound
		SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Run_Cabin_R_Cue'
		bShouldRemainActiveIfDropped=TRUE
	End Object
	EngineIntRightSound=IdleEngineRighSound

	Begin Object Class=AudioComponent Name=IdleEngineExhaustSound
		SoundCue=SoundCue'AUD_WF_Vehicle_M4A3.Movement.Sherman_Movement_Engine_Run_Exhaust_Cue'
		bShouldRemainActiveIfDropped=TRUE
	End Object
	EngineSound=IdleEngineExhaustSound

	// Track sounds
	Begin Object Class=AudioComponent Name=TrackLSound
		SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_L_Cue'
	End Object
	TrackLeftSound=TrackLSound

	Begin Object Class=AudioComponent Name=TrackRSound
		SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_R_Cue'
	End Object
	TrackRightSound=TrackRSound

	// Brake sounds
	Begin Object Class=AudioComponent Name=BrakeLeftSnd
		SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_Brake_Cue'
	End Object
	BrakeLeftSound=BrakeLeftSnd

	Begin Object Class=AudioComponent Name=BrakeRightSnd
		SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_Brake_Cue'
	End Object
	BrakeRightSound=BrakeRightSnd

	// Damage sounds
	EngineIdleDamagedSound=SoundCue'AUD_WF_Vehicle_M4A3.Movement.Sherman_Movement_Engine_Broken_Cue'
	TrackTakeDamageSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_Brake_Cue'
	TrackDamagedSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_Broken_Cue'
	TrackDestroyedSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_Skid_Cue'

	// Destroyed tranmission
	Begin Object Class=AudioComponent Name=BrokenTransmissionSnd
		SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Transmission_Broken_Cue'
		bStopWhenOwnerDestroyed=TRUE
	End Object
	BrokenTransmissionSound=BrokenTransmissionSnd

	// Gear shift sounds
	ShiftUpSound=SoundCue'AUD_WF_Vehicle_M4A3.Movement.Panzer_Movement_Engine_Exhaust_ShiftUp_Cue'
	ShiftDownSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Exhaust_ShiftDown_Cue'
	ShiftLeverSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Foley.Panzer_Lever_GearShift_Cue'

	// Turret sounds
	Begin Object Class=AudioComponent Name=TurretTraverseComponent
		SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Turret.Turret_Traverse_Manual_Cue'
	End Object
	TurretTraverseSound=TurretTraverseComponent
	Components.Add(TurretTraverseComponent);

	Begin Object Class=AudioComponent Name=TurretMotorTraverseComponent
		SoundCue=SoundCue'AUD_Vehicle_Tank_T34.Turret.Turret_Traverse_Hydraulic_Cue'
	End Object
	TurretMotorTraverseSound=TurretMotorTraverseComponent
	Components.Add(TurretMotorTraverseComponent);

	Begin Object Class=AudioComponent Name=TurretElevationComponent
		SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Turret.Turret_Elevate_Cue'
	End Object
	TurretElevationSound=TurretElevationComponent
	Components.Add(TurretElevationComponent);

	ExplosionSound=SoundCue'AUD_EXP_Tanks.A_CUE_Tank_Explode'

	Begin Object Class=AudioComponent name=HullMGSoundComponent
		bShouldRemainActiveIfDropped=true
		bStopWhenOwnerDestroyed=true
		SoundCue=SoundCue'AUD_WF_Vehicle_M4A3.Weapon.MG_M1919_Fire_Loop_M_Cue'
	End Object
	HullMGAmbient=HullMGSoundComponent
	Components.Add(HullMGSoundComponent)

	Begin Object Class=AudioComponent name=CoaxMGSoundComponent
		bShouldRemainActiveIfDropped=true
		bStopWhenOwnerDestroyed=true
		SoundCue=SoundCue'AUD_WF_Vehicle_M4A3.Weapon.MG_M1919_Fire_Loop_M_Cue'
	End Object
	CoaxMGAmbient=CoaxMGSoundComponent
	Components.Add(CoaxMGSoundComponent)

	HullMGStopSound=SoundCue'AUD_WF_Vehicle_M4A3.Weapon.MG_M1919_Fire_LoopEnd_M_Cue'
	CoaxMGStopSound=SoundCue'AUD_WF_Vehicle_M4A3.Weapon.MG_M1919_Fire_LoopEnd_M_Cue'
	*/

	// -------------------------------- Dead -----------------------------------------------------------

	DestroyedSkeletalMesh=SkeletalMesh'WF_Vehicles_M4A3Sherman.Mesh.sherman_Destroyed_rig'
	DestroyedSkeletalMeshWithoutTurret=SkeletalMesh'WF_Vehicles_M4A3Sherman.Mesh.sherman_Destroyed_body'
	DestroyedPhysicsAsset=PhysicsAsset'WF_Vehicles_M4A3Sherman.Mesh.sherman_Destroyed_rig_Physics'
	DestroyedMaterial=MaterialInstanceConstant'WF_Vehicles_M4A3Sherman.MIC.VH_M4A3_Sherman_Destroyed_Mic'
	DestroyedFXMaterial=Material'Vehicle_Mats.M_Common_Vehicles.Tank_Fireplanes'
	DestroyedTurretClass=class'DesertRats.WFVehicleDeathTurret_Sherman'

	// HUD
	HUDBodyTexture=Texture2D'WF_Vehicles_M4A3Sherman.Textures.HUD.ui_tank_M4A3_US_body'
	HUDTurretTexture=Texture2D'WF_Vehicles_M4A3Sherman.Textures.HUD.ui_tank_M4A3_US_turret'
	DriverOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_PZIV_driver'
	HUDMainCannonTexture=Texture2D'WF_Vehicles_M4A3Sherman.Textures.HUD.ui_tank_M4A3_US_maingun'
	HUDGearBoxTexture=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_transmition'
	HUDFrontArmorTexture=Texture2D'WF_Vehicles_M4A3Sherman.Textures.HUD.ui_tank_M4A3_US_bodyfront'
	HUDBackArmorTexture=Texture2D'WF_Vehicles_M4A3Sherman.Textures.HUD.ui_tank_M4A3_US_bodyback'
	HUDLeftArmorTexture=Texture2D'WF_Vehicles_M4A3Sherman.Textures.HUD.ui_tank_M4A3_US_bodyleft'
	HUDRightArmorTexture=Texture2D'WF_Vehicles_M4A3Sherman.Textures.HUD.ui_tank_M4A3_US_bodyright'
	HUDTurretFrontArmorTexture=Texture2D'WF_Vehicles_M4A3Sherman.Textures.HUD.ui_tank_M4A3_US_turretfront'
	HUDTurretBackArmorTexture=Texture2D'WF_Vehicles_M4A3Sherman.Textures.HUD.ui_tank_M4A3_US_turretback'
	HUDTurretLeftArmorTexture=Texture2D'WF_Vehicles_M4A3Sherman.Textures.HUD.ui_tank_M4A3_US_turretleft'
	HUDTurretRightArmorTexture=Texture2D'WF_Vehicles_M4A3Sherman.Textures.HUD.ui_tank_M4A3_US_turretright'

	RoleSelectionImage=Texture2D'WF_Vehicles_M4A3Sherman.Textures.sherman'

	// Driver
	SeatProxies(0)={(
		TunicMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker',
		HeadGearMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tank_headgear',
		HeadAndArmsMeshType=SkeletalMesh'CHR_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A01',
		HeadphonesMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker_equipment',
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank3_Head01_M',
		BodyMICTemplate=MaterialInstanceConstant'CHR_Ger_Tanker.Materials.Ger_Rank3_Tanker_M',
		SeatIndex=0,
		PositionIndex=0)}

	// Commander
	SeatProxies(1)={(
		TunicMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker',
		HeadGearMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tank_headgear',
		HeadAndArmsMeshType=SkeletalMesh'CHR_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A02',
		HeadphonesMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker_equipment',
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank3_Head02_M',
		BodyMICTemplate=MaterialInstanceConstant'CHR_Ger_Tanker.Materials.Ger_Rank3_Tanker_M',
		SeatIndex=1,
		PositionIndex=0)}

	// Hull MG
	SeatProxies(2)={(
		TunicMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker',
		HeadGearMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tank_headgear',
		HeadAndArmsMeshType=SkeletalMesh'CHR_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A06',
		HeadphonesMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker_equipment',
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank3_Head06_M',
		BodyMICTemplate=MaterialInstanceConstant'CHR_Ger_Tanker.Materials.Ger_Rank3_Tanker_M',
		SeatIndex=2,
		PositionIndex=0)}

	// Loader
	SeatProxies(3)={(
		TunicMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker',
		HeadGearMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tank_headgear',
		HeadAndArmsMeshType=SkeletalMesh'CHR_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A04',
		HeadphonesMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker_equipment',
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank3_Head04_M',
		BodyMICTemplate=MaterialInstanceConstant'CHR_Ger_Tanker.Materials.Ger_Rank3_Tanker_M',
		SeatIndex=3,
		PositionIndex=0)}

	// Gunner
	SeatProxies(4)={(
		TunicMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker',
		HeadGearMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tank_headgear',
		HeadAndArmsMeshType=SkeletalMesh'CHR_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A05',
		HeadphonesMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker_equipment',
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank3_Head05_M',
		BodyMICTemplate=MaterialInstanceConstant'CHR_Ger_Tanker.Materials.Ger_Rank3_Tanker_M',
		SeatIndex=4,
		PositionIndex=0)}

	// Seat proxy animations
	SeatProxyAnimSet=AnimSet'WF_Vehicles_M4A3Sherman.Anim.CHR_Sherman_Anim_Master'

	MeshAttachments.Empty

}
