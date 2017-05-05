//=============================================================================
// WFAPawnAlliesBrit.uc
//=============================================================================
// Information for British Pawns.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAPawnAlliesBrit extends WFAPawnAllies;

DefaultProperties
{
	HeadAndArmsMeshes(0)=SkeletalMesh'CHR_RS_USA_Heads.Mesh.USA_Head_01_Adam'
	HeadAndArmsMeshes(1)=SkeletalMesh'CHR_RS_USA_Heads.Mesh.USA_Head_02_Jake'
	HeadAndArmsMeshes(2)=SkeletalMesh'CHR_RS_USA_Heads.Mesh.USA_Head_03_Glenn'
	HeadAndArmsMeshes(3)=SkeletalMesh'CHR_RS_USA_Heads.Mesh.USA_Head_04_John'
	HeadAndArmsMeshes(4)=SkeletalMesh'CHR_RS_USA_Heads.Mesh.USA_Head_05_SimonM'
	HeadAndArmsMeshes(5)=SkeletalMesh'CHR_RS_USA_Heads.Mesh.USA_Head_06_Bill'
	HeadAndArmsMeshes(6)=SkeletalMesh'CHR_RS_USA_Heads.Mesh.USA_Head_07_Sam'
	HeadAndArmsMeshes(7)=SkeletalMesh'CHR_RS_USA_Heads.Mesh.USA_Head_08_SimonC'
	
	FPMeshesDefault=SkeletalMesh'CHR_1stP_Hands_Master.Mesh.1stP_Hands_US_rolledSleeve'
	
	BodyMeshDefault=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Tunic'
	
	GearMeshDefault=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Gear_Generic'
	GearMeshOverride(`RI_RADIOMAN)=SkeletalMesh'CHR_RS_USMC.Mesh.usmc_gear_raw_radio'
	
	HelmMeshDefault=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Headgear_Helmet'
	HelmMeshOverride(`RI_TEAMLEADER)=(Mesh=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Headgear_Beret', isMetal=false)
	
	PawnMesh_SV=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Tunic'
	
	// For VehicleCrewProxy Only
	TunicMesh=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Tunic'
	BodyMICTemplate=MaterialInstanceConstant'WFAMDL_CHR_UK.MIC.WFA_UK_Tunic'
}
