//=============================================================================
// WFAPawnAlliesBrit.uc
//=============================================================================
// Basic British Pawn.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAPawnAlliesBrit extends WFAPawnAllies;

DefaultProperties
{
	TunicMesh=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Tunic'
	BodyMICTemplate=MaterialInstanceConstant'WFAMDL_CHR_UK.MIC.WFA_UK_Tunic'
	
	PawnMesh_SV=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Tunic'
	
	FieldgearMesh=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Gear_Generic'
	
	HeadgearMeshes(0)=SkeletalMesh'WFAMDL_CHR_UK.Mesh.WFA_UK_Headgear_Helmet'
}
