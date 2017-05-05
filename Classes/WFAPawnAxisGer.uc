//=============================================================================
// WFAPawnAxisGer.uc
//=============================================================================
// Information for German Pawns.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAPawnAxisGer extends WFAPawnAxis;

DefaultProperties
{
	HeadAndArmsMeshes(0)=SkeletalMesh'WF_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A01'
	HeadAndArmsMeshes(1)=SkeletalMesh'WF_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A02'
	HeadAndArmsMeshes(2)=SkeletalMesh'WF_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A03'
	HeadAndArmsMeshes(3)=SkeletalMesh'WF_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A04'
	HeadAndArmsMeshes(4)=SkeletalMesh'WF_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A05'
	HeadAndArmsMeshes(5)=SkeletalMesh'WF_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A06'
	HeadAndArmsMeshes(6)=SkeletalMesh'WF_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A07'
	HeadAndArmsMeshes(7)=SkeletalMesh'WF_Ger_RawRecruit_Heads.Mesh.ger_rr_head_A08'
	
	FPMeshesDefault=SkeletalMesh'1stP_Hands_Master.Mesh.1stP_Hands_Ger_Tunic'
	
	BodyMeshDefault=SkeletalMesh'CHR_Ger_RawRecruit.Mesh.ger_rr_tunic'
	
	GearMeshDefault=SkeletalMesh'CHR_Ger_RawRecruit.Mesh.ger_rr_gear_rifleman'
	GearMeshOverride(`RI_RADIOMAN)=SkeletalMesh'GER_Heer.Mesh.WF_Ger_Gear_radioman'
	GearMeshOverride(`RI_TEAMLEADER)=SkeletalMesh'CHR_Ger_RawRecruit.Mesh.ger_rr_gear_commander'
	
	HelmMeshDefault=SkeletalMesh'WFAMDL_CHR_DAK.Mesh.WFA_CHR_DAK_Helmet'
	HelmMeshOverride(`RI_TEAMLEADER)=(Mesh=SkeletalMesh'CHR_Ger_RawRecruit.Mesh.ger_rr_crusher', isMetal=false)
	
	PawnMesh_SV=SkeletalMesh'CHR_Ger_RawRecruit.Mesh.ger_rr_assault_low'
	
	// For VehicleCrewProxy Only
	TunicMesh=SkeletalMesh'CHR_Ger_RawRecruit.Mesh.ger_rr_assault_low'
	BodyMICTemplate=MaterialInstanceConstant'WFAMDL_CHR_DAK.MIC.WFA_DAK_TUNIC'
}
