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
	Begin Object Name=ROPawnSkeletalMeshComponent
		AnimSets(11)=AnimSet'CHR_Playeranim_Master.Anim.CHR_German_Unique'
	End Object
	
	bSingleHandedSprinting=true
}
