
class DRPawnAllies extends DRPawn;

simulated event byte ScriptGetTeamNum()
{
	return `ALLIES_TEAM_INDEX;
}

defaultproperties
{
	TunicMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.UK_Tunic'
	
	FieldgearMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.UK_Gear_Generic'
	
	ArmsOnlyMeshFP=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.1stP_ALL'
	
	HeadAndArmsMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.UK_Kead'
	HeadAndArmsMICTemplate=MaterialInstanceConstant'DR__PLACEHOLDER_CHR.MIC.UK_Head'
	
	HeadgearMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.UK_Headgear_Helmet'
	
	Begin Object Name=ROPawnSkeletalMeshComponent
		AnimSets(11)=AnimSet'DR_CHR.Anim.CHR_Allies_Unique'
	End Object
	
	bSingleHandedSprinting=false
}
