//=============================================================================
// WFAPawnAxisGer.uc
//=============================================================================
// Basic German Pawn.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAPawnAxisGer extends WFAPawnAxis;

DefaultProperties
{
	TunicMesh=SkeletalMesh'CHR_Ger_RawRecruit.Mesh.ger_rr_tunic'
	BodyMICTemplate=MaterialInstanceConstant'WFAMDL_CHR_DAK.MIC.WFA_DAK_TUNIC'
	
	PawnMesh_SV=SkeletalMesh'CHR_Ger_RawRecruit.Mesh.ger_rr_assault_low'
	
	FieldgearMesh=SkeletalMesh'CHR_Ger_RawRecruit.Mesh.ger_rr_gear_rifleman'
	
	HeadgearMeshes(0)=SkeletalMesh'WFAMDL_CHR_DAK.Mesh.WFA_CHR_DAK_Helmet'
}
