//=============================================================================
// WFAGameInfoTerritories.uc
//=============================================================================
// Game rules for Territories
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAGameInfoTerritories extends WFGameInfoTerritories
	// seperate config as placeholder, will work out integration when officially approved
	config(Game_WFA); 

var WFALogWriter Logger;

// TODO: Is this necessary?
static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return class'WFAGameInfoTerritories';
}

simulated function PreBeginPlay()
{
	Logger = Spawn(class'WFALogWriter');
	`wfalog(Logger @ "successfully initialized!", 'Init');
	
	super.PreBeginPlay();
}

function class<Pawn> GetPlayerClass(Controller C)
{
	local ROPlayerReplicationInfo ROPRI;
	local class<Pawn> PawnClass;
	local byte UniformIndex;
	local string nm;
	
	ROPRI = ROPlayerReplicationInfo(C.PlayerReplicationInfo);
	UniformIndex = ROPRI.RoleInfo.ClassIndex;
	
	switch (UniformIndex)
	{
		case `RI_RIFLEMAN:		nm = "RI_RIFLEMAN"; break;
		case `RI_ASSAULT:		nm = "RI_ASSAULT"; break;
		case `RI_MACHINEGUN:	nm = "RI_MACHINEGUN"; break;
		case `RI_ENGINEER:		nm = "RI_ENGINEER"; break;
		case `RI_ANTITANK:		nm = "RI_ANTITANK"; break;
		case `RI_SNIPER:		nm = "RI_SNIPER"; break;
		case `RI_SQUADLEADER:	nm = "RI_SQUADLEADER"; break;
		case `RI_RADIOMAN:		nm = "RI_RADIOMAN"; break;
		case `RI_TEAMLEADER:	nm = "RI_TEAMLEADER"; break;
		case `RI_TANK_CREW:		nm = "RI_TANK_CREW"; break;
		case `RI_TANK_COMM:		nm = "RI_TANK_COMM"; break;
		case `RI_TANK_SL:		nm = "RI_TANK_SL"; break;
		case `RI_TANK_TL:		nm = "RI_TANK_TL"; break;
		default:				nm = "BAD CLASS";
	}
	
	switch (UniformIndex)
	{
		case `RI_TANK_CREW:
		case `RI_TANK_COMM:
		case `RI_TANK_SL:
		case `RI_TANK_TL:
			PawnClass = class'WFAPawnTanker';
			break;
		
		default:
			PawnClass = (ROPRI.Team.TeamIndex == `AXIS_TEAM_INDEX) ? class'WFAPawnAxisGer' : class'WFAPawnAlliesBrit';
	}
	`wfalog("Class index is" @ nm @ "("$UniformIndex$") - returning" @ PawnClass, 'PawnClass');
	
	return PawnClass;
}


defaultProperties
{
	PlayerControllerClass=	class'WFAPlayerController'
	AIControllerClass=		class'WFAAIController'
	HUDType=				class'WFAHUD'
}
