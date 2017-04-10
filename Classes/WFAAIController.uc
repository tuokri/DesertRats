//=============================================================================
// WFAAIController.uc
//=============================================================================
// Modified AI controller to let bots choose Sniper and Commander roles
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAAIController extends RSAIController;
/* Removed until MapInfo is set up
function bool ChooseRole()
{
	local WFAMapInfo MI;
	local int NewSquadIndex;
	local ROPlayerReplicationInfo PRI;
	local string tm;
	
	PRI = ROPlayerReplicationInfo(PlayerReplicationInfo);
	MI = WFAMapInfo(WorldInfo.GetMapInfo());
	tm = (PRI.Team.TeamIndex == `ALLIES_TEAM_INDEX) ? "Commonwealth" : "Japanese";
	
	if (PRI.Team.TeamIndex == `ALLIES_TEAM_INDEX)
	{
		for (NewSquadIndex = 0; NewSquadIndex < MI.AlliesSquads.Length; NewSquadIndex++)
		{
			if(MI.AlliesSquads[NewSquadIndex].SquadLeader.RoleInfo.isA('WFARI_UK_SNIPER') && MI.AlliesSquads[NewSquadIndex].SquadLeader.Owner == none && WorldInfo.GRI.PRIArray.length > MI.AlliesSquads[NewSquadIndex].MinimumPlayers)
			{
				`WFA(self @ "now taking aim through the British sniper's scope!", 'AIRoles');
				return PRI.SelectRole(self,NewSquadIndex,`FIRETEAM_INDEX_SQUADLEADER,0);
			}
		}
	}
	else 
	{
		for (NewSquadIndex = 0; NewSquadIndex < MI.AxisSquads.Length; NewSquadIndex++)
		{
			if(MI.AxisSquads[NewSquadIndex].SquadLeader.RoleInfo.isA('WFARI_JAP_SNIPER') && MI.AxisSquads[NewSquadIndex].SquadLeader.Owner == none && WorldInfo.GRI.PRIArray.length > MI.AxisSquads[NewSquadIndex].MinimumPlayers)
			{
				`WFA(self @ "now taking aim through the Japanese sniper's scope!", 'AIRoles');
				return PRI.SelectRole(self,NewSquadIndex,`FIRETEAM_INDEX_SQUADLEADER,0);
			}
		}
	}
	
	if(!ROTeamInfo(PlayerReplicationInfo.Team).bHasTeamLeader)
	{
		`WFA(self @ "now taking charge of the" @ tm @ "platoon!", 'AIRoles');
		return ROPlayerReplicationInfo(PlayerReplicationInfo).SelectRole(self,`SQUAD_INDEX_TEAMLEADER,0,0);
	}
	
	return super.ChooseRole();
}
*/