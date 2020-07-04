
class DRPawnAxis extends DRPawn;

simulated event byte ScriptGetTeamNum()
{
	return `AXIS_TEAM_INDEX;
}

defaultproperties
{
	TunicMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.ger_rr_tunic'
	
	FieldgearMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.ger_rr_gear_rifleman'
	
	ArmsOnlyMeshFP=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.1stP_ALL'
	
	HeadAndArmsMesh=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head6_Mesh'
	HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_06_Long_INST'
	
	HeadgearMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.ger_rr_helmet'
	
	Begin Object Name=ROPawnSkeletalMeshComponent
		AnimSets(11)=AnimSet'DR_CHR.Anim.CHR_Axis_Unique'
	End Object
	
	bSingleHandedSprinting=true
}
