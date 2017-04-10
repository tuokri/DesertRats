//=============================================================================
// WFAPawnTanker.uc
//=============================================================================
// Global attributes shared by all Tank Crew Pawns.
// This class serves only to provide FirstPersonArms1, all 
// other visual properties are set in individual vehicle classes.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAPawnTanker extends WFPawnTanker;

DefaultProperties
{
	Begin Object name=FirstPersonArms1
		SkeletalMesh=SkeletalMesh'CHR_Ger_RawRecruit.Mesh.ger_tanker_fp_hands'
	End Object
}
