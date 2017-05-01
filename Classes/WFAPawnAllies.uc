//=============================================================================
// WFAPawnAllies.uc
//=============================================================================
// Global attributes shared by all Allied Pawns.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAPawnAllies extends WFAPawn
	abstract;

simulated event byte ScriptGetTeamNum()
{
	return `ALLIES_TEAM_INDEX;
}

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
	
	HeadAndArmsMICs(0)=MaterialInstanceConstant'CHR_RS_USA_Heads.MIC.M_USA_Rank1_Head_01_Adam_INST'
	HeadAndArmsMICs(1)=MaterialInstanceConstant'CHR_RS_USA_Heads.MIC.M_USA_Rank1_Head_02_Jake_INST'
	HeadAndArmsMICs(2)=MaterialInstanceConstant'CHR_RS_USA_Heads.MIC.M_USA_Rank1_Head_03_Glenn_INST'
	HeadAndArmsMICs(3)=MaterialInstanceConstant'CHR_RS_USA_Heads.MIC.M_USA_Rank1_Head_04_John_INST'
	HeadAndArmsMICs(4)=MaterialInstanceConstant'CHR_RS_USA_Heads.MIC.M_USA_Rank1_Head_05_SimonM_INST'
	HeadAndArmsMICs(5)=MaterialInstanceConstant'CHR_RS_USA_Heads.MIC.M_USA_Rank1_Head_06_Bill_INST'
	HeadAndArmsMICs(6)=MaterialInstanceConstant'CHR_RS_USA_Heads.MIC.M_USA_Rank1_Head_07_Sam_INST'
	HeadAndArmsMICs(7)=MaterialInstanceConstant'CHR_RS_USA_Heads.MIC.M_USA_Rank1_Head_08_SimonC_INST'
	
	ArmsMeshesFP(0)=SkeletalMesh'CHR_1stP_Hands_Master.Mesh.1stP_Hands_US_rolledSleeve'
	
	Begin Object Name=ROPawnSkeletalMeshComponent
		AnimSets(11)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Russian_Unique'
	End Object
	
	bSingleHandedSprinting=false
}