//=============================================================================
// WFAVehicleATGun_Pak38_Content.uc
//=============================================================================
// 5 cm Pak 38 Anti-Tank Gun (Content)
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAVehicleATGun_Pak38_Content extends WFAVehicleATGun_Pak38
	placeable;

defaultproperties
{
	Begin Object Name=ROSVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_Ger_Panzer_IIIM.Mesh.Ger_PZIII_Rig_Master'
		Materials(0)=MaterialInstanceConstant'VH_Ger_Panzer_IIIM.Materials.VH_Ger_Panzer_IIIM_Winter_Mic'
		Materials(1)=Material'Vehicle_Mats.VH_Ger_Panzer_IIIM.Ger_Panzer_IIIM_Winter_LTread'
		Materials(2)=Material'Vehicle_Mats.VH_Ger_Panzer_IIIM.Ger_Panzer_IIIM_Winter_RTread'
		AnimTreeTemplate=AnimTree'VH_Ger_Panzer_IIIM.Anim.AT_VH_PanzerIIIM'
		PhysicsAsset=PhysicsAsset'VH_Ger_Panzer_IIIM.Phys.Ger_PZIII_Rig_Physics'
		AnimSets.Add(AnimSet'VH_Ger_Panzer_IIIM.Anim.PZIII_anim_Master')
		AnimSets.Add(AnimSet'VH_Ger_Panzer_IIIM.Anim.PZIII_Destroyed_anim_Master')
	End Object

	Begin Object Class=AudioComponent Name=TurretTraverseComponent
		SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Turret.Turret_Traverse_Manual_Cue'
	End Object
	TurretTraverseSound=TurretTraverseComponent
	Components.Add(TurretTraverseComponent);

	Begin Object Class=AudioComponent Name=TurretElevationComponent
		SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Turret.Turret_Elevate_Cue'
	End Object
	TurretElevationSound=TurretElevationComponent
	Components.Add(TurretElevationComponent);

	ExplosionSound=SoundCue'AUD_EXP_Tanks.A_CUE_Tank_Explode'

	DestroyedSkeletalMesh=SkeletalMesh'VH_Ger_Panzer_IIIM.Mesh.Ger_PZIII_Destroyed_Master'
	DestroyedPhysicsAsset=PhysicsAsset'VH_Ger_Panzer_IIIM.Phys.Ger_PZIII_Destroyed_Physics'
	DestroyedMaterial=MaterialInstanceConstant'VH_Ger_Panzer_IIIM.Materials.VH_Ger_Panzer_IIIM_Destroyed_Mic'
	
	HUDBodyTexture=Texture2D'UI_Textures_VehiclePack.HUD.Vehicles.PzIIIm.ui_tank_PzIIIm_ger_body'
	HUDTurretTexture=Texture2D'UI_Textures_VehiclePack.HUD.Vehicles.PzIIIm.ui_tank_PzIIIm_ger_turret'
	HUDMainCannonTexture=Texture2D'UI_Textures_VehiclePack.HUD.Vehicles.PzIIIm.ui_tank_PzIIIm_ger_maingun'
	HUDTurretFrontArmorTexture=Texture2D'UI_Textures_VehiclePack.HUD.Vehicles.PzIIIm.ui_tank_PzIIIm_ger_turretfront'
	HUDTurretLeftArmorTexture=Texture2D'UI_Textures_VehiclePack.HUD.Vehicles.PzIIIm.ui_tank_PzIIIm_ger_turretleft'
	HUDTurretRightArmorTexture=Texture2D'UI_Textures_VehiclePack.HUD.Vehicles.PzIIIm.ui_tank_PzIIIm_ger_turretright'

	SeatProxies(0)={(
		TunicMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker',
		HeadGearMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tank_headgear',
		HeadAndArmsMeshType=SkeletalMesh'CHR_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A01',
		HeadphonesMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker_equipment',
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank3_Head01_M',
		BodyMICTemplate=MaterialInstanceConstant'CHR_Ger_Tanker.Materials.Ger_Rank3_Tanker_M',
		SeatIndex=0,
		PositionIndex=0)}

	SeatProxies(1)={(
		TunicMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker',
		HeadGearMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tank_headgear',
		HeadAndArmsMeshType=SkeletalMesh'CHR_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A02',
		HeadphonesMeshType=SkeletalMesh'CHR_Ger_Tanker.Mesh.ger_tanker_equipment',
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank3_Head02_M',
		BodyMICTemplate=MaterialInstanceConstant'CHR_Ger_Tanker.Materials.Ger_Rank3_Tanker_M',
		SeatIndex=1,
		PositionIndex=0)}

	SeatProxyAnimSet=AnimSet'VH_Ger_Panzer_IIIM.Anim.CHR_Panzer3M_Anim_Master'

	Begin Object class=StaticMeshComponent name=ExtBodyAttachment2
		StaticMesh=StaticMesh'VH_Ger_Panzer_IIIM_Interior.Mesh.VH_SM_PzIIIM_Ext_GunBase'
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

	Begin Object class=StaticMeshComponent name=ExtBodyAttachment3
		StaticMesh=StaticMesh'VH_Ger_Panzer_IIIM_Interior.Mesh.VH_SM_PzIIIM_Ext_Barrel'
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

	Begin Object class=StaticMeshComponent name=TurretAttachment1
		StaticMesh=StaticMesh'VH_Ger_Panzer_IIIM_Interior.Mesh.VH_SM_PzIIIM_Int_GunBase'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
		LightEnvironment = MyInteriorLightEnvironment
		CastShadow=false
		DepthPriorityGroup=SDPG_Foreground
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
	End Object

	MeshAttachments(0)={(AttachmentName=ExtGunBaseComponent,Component=ExtBodyAttachment2,bAttachToSocket=true,AttachmentTargetName=attachments_gun)}
	MeshAttachments(1)={(AttachmentName=ExtBarrelComponent,Component=ExtBodyAttachment3,bAttachToSocket=true,AttachmentTargetName=attachments_turretBarrel)}
	MeshAttachments(2)={(AttachmentName=TurretGunGaseComponent,Component=TurretAttachment1,bAttachToSocket=true,AttachmentTargetName=attachments_gun)}
}
