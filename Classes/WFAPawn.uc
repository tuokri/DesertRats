//=============================================================================
// WFAPawn.uc
//=============================================================================
// Global attributes shared by all Pawns.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAPawn extends WFPawn
	notplaceable;

var SkeletalMesh BodyMeshDefault, GearMeshDefault, HelmMeshDefault, FPMeshesDefault;
var array<SkeletalMesh> BodyMeshOverride, GearMeshOverride, FPMeshesOverride;

struct SpecialAttachmentHeadgear
{
	var SkeletalMesh Mesh;
	var bool isMetal;
};

var array<SpecialAttachmentHeadgear> HelmMeshOverride;

var int hasRadioRoleIndex, hasFlamerRoleIndex;

function PossessedBy(Controller C, bool bVehicleTransition)
{
	super.PossessedBy(C, bVehicleTransition);
	
	if (!bVehicleTransition)
	{
		CreateNewPawnMesh();
	}
}

simulated function CreatePawnMesh() {}

simulated function CreateNewPawnMesh()
{
	local SkeletalMesh BodyToUse, HelmToUse, GearToUse, ArmsToUse;
	local int RoleIndex;
	local bool defaulting;
	local SkeletalMeshSocket HeadSocket;
	
	if (Controller == none)
	{
		`wfalog("Pawn" @ self @ "has a null Controller!", 'PawnCreation');
		defaulting = true;
	}
	else if (ROPlayerReplicationInfo(Controller.PlayerReplicationInfo) == none)
	{
		`wfalog("Pawn" @ self @ "could not get RoleIndex from" @ Controller.PlayerReplicationInfo$"!", 'PawnCreation');
		defaulting = true;
	}
	else
	{
		RoleIndex = ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.ClassIndex;
		`wfalog("Pawn" @ self @ "controlled by" @ Controller @ "has role index" @ RoleIndex, 'PawnCreation');
		defaulting = false;
	}
	
	HeadAndArmsMesh = HeadAndArmsMeshes[rand(HeadAndArmsMeshes.length)];
	
	BodyToUse = BodyMeshDefault;
	HelmToUse = HelmMeshDefault;
	GearToUse = GearMeshDefault;
	ArmsToUse = FPMeshesDefault;
	
	if (!defaulting)
	{
		if (BodyMeshOverride[RoleIndex] != none)
		{
			BodyToUse = BodyMeshOverride[RoleIndex];
		}
		
		if (HelmMeshOverride[RoleIndex].Mesh != none)
		{
			HelmToUse = HelmMeshOverride[RoleIndex].Mesh;
			bHeadGearIsHelmet = HelmMeshOverride[RoleIndex].isMetal;
		}
		
		if (GearMeshOverride[RoleIndex] != none)
		{
			GearToUse = GearMeshOverride[RoleIndex];
			bHasARadio = (RoleIndex == hasRadioRoleIndex);
			bHasFlamethrower = (RoleIndex == hasFlamerRoleIndex);
		}
		
		if (FPMeshesOverride[RoleIndex] != none)
		{
			ArmsToUse = FPMeshesOverride[RoleIndex];
		}
	}
	
	if (!defaulting)
	{
		`wfalog("BodyToUse:" @ BodyToUse @ "overridden:" @ (BodyToUse != BodyMeshDefault), 'PawnCreation');
		`wfalog("HelmToUse:" @ HelmToUse @ "overridden:" @ (HelmToUse != HelmMeshDefault), 'PawnCreation');
		`wfalog("GearToUse:" @ GearToUse @ "overridden:" @ (GearToUse != GearMeshDefault), 'PawnCreation');
		`wfalog("ArmsToUse:" @ ArmsToUse @ "overridden:" @ (ArmsToUse != FPMeshesDefault), 'PawnCreation');
	}
	
	if (!bUseSingleCharacterVariant)
	{
		CompositedBodyMesh = ROMapInfo(WorldInfo.GetMapInfo()).GetCachedCompositedPawnMesh(BodyToUse, GearToUse);
	}
	else
	{
		CompositedBodyMesh = PawnMesh_SV;
	}
	
	CompositedBodyMesh.Characterization = PlayerHIKCharacterization;
	
	ROSkeletalMeshComponent(mesh).ReplaceSkeletalMesh(CompositedBodyMesh);
	ROSkeletalMeshComponent(mesh).GenerateAnimationOverrideBones(HeadAndArmsMesh);
	
	ThirdPersonHeadAndArmsMeshComponent.SetSkeletalMesh(HeadAndArmsMesh);
	ThirdPersonHeadAndArmsMeshComponent.SetParentAnimComponent(mesh);
	ThirdPersonHeadAndArmsMeshComponent.SetShadowParent(mesh);
	ThirdPersonHeadAndArmsMeshComponent.SetLODParent(mesh);
	AttachComponent(ThirdPersonHeadAndArmsMeshComponent);
	
	
	HeadSocket = ThirdPersonHeadAndArmsMeshComponent.GetSocketByName('helmet');
	
	ThirdPersonHeadgearMeshComponent.SetSkeletalMesh(HelmToUse);
	
	if( mesh.MatchRefBone(HeadSocket.BoneName) != INDEX_NONE )
	{
		ThirdPersonHeadgearMeshComponent.SetShadowParent(mesh);
		ThirdPersonHeadgearMeshComponent.SetLODParent(mesh);
		mesh.AttachComponent( ThirdPersonHeadgearMeshComponent, HeadSocket.BoneName, HeadSocket.RelativeLocation, HeadSocket.RelativeRotation, HeadSocket.RelativeScale);
	}
	
	ArmsMesh.SetSkeletalMesh(ArmsToUse);
	
	if ( bOverrideLighting )
	{
		ThirdPersonHeadAndArmsMeshComponent.SetLightingChannels(LightingOverride);
		ThirdPersonHeadgearMeshComponent.SetLightingChannels(LightingOverride);
	}
	
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		mesh.ForcedLODModel = 1000;
		ThirdPersonHeadAndArmsMeshComponent.ForcedLodModel = 1000;
	}
	
	if (!bHeadGearIsHelmet)
	{
		`wfalog("Headgear" @ HelmToUse @ "is soft", 'PawnCreation');
	}
	
	if (bHasARadio && Role == ROLE_Authority && portableRadio1 == none)
	{
		SpawnRadio();
	}
}

function SpawnRadio()
{
	if (GetTeamNum() == `AXIS_TEAM_INDEX)
	{
		portableRadio1 = Spawn(class'WFPortableRadioAxis',self);
	}
	else
	{
		portableRadio1 = Spawn(class'WFPortableRadioAllies',self);
	}
	
	portableRadio1.OwningSoldier = self;
	
	`wfalog("Successfully spawned" @ portableRadio1 @ "on" @ portableRadio1.OwningSoldier, 'PawnCreation');
}

DefaultProperties
{
	// InventoryManagerClass=class'WFAInventoryManager'
	
	hasRadioRoleIndex = `RI_RADIOMAN
	hasFlamerRoleIndex = -1
	
	Begin Object Name=ROPawnSkeletalMeshComponent
		AnimSets(0)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Stand_anim'
		AnimSets(1)=AnimSet'CHR_Playeranim_Master.Anim.CHR_ChestCover_anim'
		AnimSets(2)=AnimSet'CHR_Playeranim_Master.Anim.CHR_WaistCover_anim'
		AnimSets(3)=AnimSet'CHR_Playeranim_Master.Anim.CHR_StandCover_anim'
		AnimSets(4)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Crouch_anim'
		AnimSets(5)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Prone_anim'
		AnimSets(6)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Hand_Poses_Master'
		AnimSets(7)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Death_anim'
		AnimSets(8)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Tripod_anim'
		AnimSets(9)=AnimSet'CHR_Playeranim_Master.Anim.Special_Actions'
		AnimSets(10)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Melee'
		AnimSets(11)=none // Faction specific animations
		AnimSets(12)=none // Weapon animations
		AnimSets(13)=AnimSet'CHR_RS_Playeranim_Master.Anim.CHR_RS_Hand_Poses_Master'
		AnimSets(14)=AnimSet'CHR_RS_Playeranim_Master.Anim.CHR_RS_Tripod_Anim'
	End Object
	
	ArmsOnlyMesh=SkeletalMesh'CHR_RS_HandsOnly.3P_Hands_Only'
}
