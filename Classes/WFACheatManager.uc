//=============================================================================
// WFACheatManager.uc
//=============================================================================
// Main wrapper class for debugging functions
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFACheatManager extends ROCheatManager;

exec function LogSquadInfo()
{
	local int i, j, k;
	local ROMapInfo MI;
	
	MI = ROMapInfo(WorldInfo.GetMapInfo());
	
	`wfalog("", 'SquadInfo');
	`wfalog("Map Roles:", 'SquadInfo');
	`wfalog("", 'SquadInfo');
	for ( i = 0; i < MI.AxisSquads.length; i++ )
	{
		`wfalog("-" @ MI.AxisSquads[i].Title, 'SquadInfo');
		`wfalog("-" @ MI.AxisSquads[i].MinimumPlayers, 'SquadInfo');
		`wfalog("-" @ MI.AxisSquads[i].SquadLeader.RoleInfo, 'SquadInfo');
		
		for ( j = 0; j < MI.AxisSquads[i].FireTeams.length; j++ )
		{
			`wfalog("--" @ MI.AxisSquads[i].FireTeams[j].Title, 'SquadInfo');
			
			for ( k = 0; k < MI.AxisSquads[i].FireTeams[j].Roles.length; k++ )
			{
				`wfalog("---" @ MI.AxisSquads[i].FireTeams[j].Roles[k].RoleInfo, 'SquadInfo');
			}
		}
	}
	`wfalog("", 'SquadInfo');
	for ( i = 0; i < MI.AlliesSquads.length; i++ )
	{
		`wfalog("-" @ MI.AlliesSquads[i].Title, 'SquadInfo');
		`wfalog("-" @ MI.AlliesSquads[i].MinimumPlayers, 'SquadInfo');
		`wfalog("-" @ MI.AlliesSquads[i].SquadLeader.RoleInfo, 'SquadInfo');
		
		for ( j = 0; j < MI.AlliesSquads[i].FireTeams.length; j++ )
		{
			`wfalog("--" @ MI.AlliesSquads[i].FireTeams[j].Title, 'SquadInfo');
			
			for ( k = 0; k < MI.AlliesSquads[i].FireTeams[j].Roles.length; k++ )
			{
				`wfalog("---" @ MI.AlliesSquads[i].FireTeams[j].Roles[k].RoleInfo, 'SquadInfo');
			}
		}
	}
	`wfalog("", 'SquadInfo');
}

exec function AIEnabled(bool on, bool TanksOnly)
{
	local ROAIController TestAI;
	
	if (on)
	{
		foreach WorldInfo.AllControllers(class'ROAIController', TestAI)
		{
			if (TestAI != none)
			{
				if (!TanksOnly ||(TanksOnly && TestAI.CurrentAIPurpose == AIP_VehicleAI))
				{
					TestAI.AIUnSuspended();
				}
			}
		}
	}
	else
	{
		foreach WorldInfo.AllControllers(class'ROAIController', TestAI)
		{
			if (TestAI != none)
			{
				if (!TanksOnly ||(TanksOnly && TestAI.CurrentAIPurpose == AIP_VehicleAI))
				{
					TestAI.AIUnSuspended();
				}
			}
		}
	}
}


exec function botCrewGun()
{
	local WFAVehicleATGun G;
	local ROAIController TestAI;
	
	foreach WorldInfo.AllControllers(class'ROAIController', TestAI)
	{
		if (TestAI != none && TestAI.CurrentAIPurpose != AIP_VehicleAI)
		{
			foreach AllActors(class'WFAVehicleATGun',G)
			{
				G.TryToDrive(TestAI.Pawn);
				break;
			}
			break;
		}
		
	}
}
