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
	Begin Object Name=ROPawnSkeletalMeshComponent
		AnimSets(11)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Russian_Unique'
	End Object
	
	bSingleHandedSprinting=false
}
