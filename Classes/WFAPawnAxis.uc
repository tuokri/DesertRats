//=============================================================================
// WFAPawnAxis.uc
//=============================================================================
// Global attributes shared by all Axis Pawns.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAPawnAxis extends WFAPawn
	abstract;

simulated event byte ScriptGetTeamNum()
{
	return `AXIS_TEAM_INDEX;
}

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
	
	HeadAndArmsMICs(0)=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank1_Head01_M'
	HeadAndArmsMICs(1)=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank1_Head02_M'
	HeadAndArmsMICs(2)=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank1_Head03_M'
	HeadAndArmsMICs(3)=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank1_Head04_M'
	HeadAndArmsMICs(4)=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank1_Head05_M'
	HeadAndArmsMICs(5)=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank1_Head06_M'
	HeadAndArmsMICs(6)=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank1_Head07_M'
	HeadAndArmsMICs(7)=MaterialInstanceConstant'CHR_Ger_RawRecruit_Heads.Materials.Ger_Rank1_Head08_M'
	
	ArmsMeshesFP(0)=SkeletalMesh'1stP_Hands_Master.Mesh.1stP_Hands_Ger_Tunic'
	
	Begin Object Name=ROPawnSkeletalMeshComponent
		AnimSets(0)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Stand_anim'
		AnimSets(1)=AnimSet'CHR_Playeranim_Master.Anim.CHR_ChestCover_anim'
		AnimSets(2)=AnimSet'CHR_Playeranim_Master.Anim.CHR_WaistCover_anim'
		AnimSets(3)=AnimSet'CHR_Playeranim_Master.Anim.CHR_StandCover_anim'
		AnimSets(4)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Crouch_anim'
		AnimSets(5)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Prone_anim'
		AnimSets(6)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Hand_Poses_Master'
		AnimSets(7)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Death_anim'
		AnimSets(8)=AnimSet'WFGameCustom.Anim.Tripod_all_MG'
		AnimSets(9)=AnimSet'CHR_Playeranim_Master.Anim.Special_Actions'
		AnimSets(10)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Melee'
		AnimSets(11)=AnimSet'CHR_Playeranim_Master.Anim.CHR_German_Unique'
		AnimSets(12)=None	// Reserved for weapon specific animations
	End Object
	
	bSingleHandedSprinting=true
}
