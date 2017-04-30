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

var array< class<Pawn> > BRIT;
var array< class<Pawn> > GER;

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
	
	// Since I highly doubt Italians will be coming I'll just make this a boolean
	// Can always easily change later
	PawnClass = (ROPRI.Team.TeamIndex == `AXIS_TEAM_INDEX) ? GER[UniformIndex] : BRIT[UniformIndex];
	
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
		case `RI_TANK_CREW:		nm = "RI_TANK_CREW"; break;
		case `RI_TANK_COMM:		nm = "RI_TANK_COMM"; break;
		case `RI_TANK_SL:		nm = "RI_TANK_SL"; break;
		case `RI_TANK_TL:		nm = "RI_TANK_TL"; break;
		case `RI_TEAMLEADER:	nm = "RI_TEAMLEADER"; break;
		default:				nm = "BAD CLASS";
	}
	`wfalog("Class index is" @ nm @ "("$UniformIndex$") - returning" @ PawnClass, 'PawnClass');
	
	return PawnClass;
}


defaultProperties
{
	PlayerControllerClass=	class'WFPlayerController'
	AIControllerClass=		class'WFAAIController'
	TeamInfoClass=			class'WFTeamInfo'
	HUDType=				class'WFHUD'
	
	BRIT(`RI_RIFLEMAN)=		class'WFAPawnAlliesBrit'
	BRIT(`RI_ASSAULT)=		class'WFAPawnAlliesBrit'
	BRIT(`RI_MACHINEGUN)=	class'WFAPawnAlliesBrit'
	BRIT(`RI_ENGINEER)=		class'WFAPawnAlliesBrit'
	BRIT(`RI_ANTITANK)=		class'WFAPawnAlliesBrit'
	BRIT(`RI_SNIPER)=		class'WFAPawnAlliesBrit'
	BRIT(`RI_RADIOMAN)=		class'WFAPawnAlliesBritRO'
	BRIT(`RI_SQUADLEADER)=	class'WFAPawnAlliesBrit'
	BRIT(`RI_TEAMLEADER)=	class'WFAPawnAlliesBritTL'
	BRIT(`RI_TANK_CREW)=	class'WFAPawnTanker'
	BRIT(`RI_TANK_COMM)=	class'WFAPawnTanker'
	BRIT(`RI_TANK_SL)=		class'WFAPawnTanker'
	BRIT(`RI_TANK_TL)=		class'WFAPawnTanker'
	
	GER(`RI_RIFLEMAN)=		class'WFAPawnAxisGer'
	GER(`RI_ASSAULT)=		class'WFAPawnAxisGer'
	GER(`RI_MACHINEGUN)=	class'WFAPawnAxisGer'
	GER(`RI_ENGINEER)=		class'WFAPawnAxisGer'
	GER(`RI_ANTITANK)=		class'WFAPawnAxisGer'
	GER(`RI_SNIPER)=		class'WFAPawnAxisGer'
	GER(`RI_RADIOMAN)=		class'WFAPawnAxisGerRO'
	GER(`RI_SQUADLEADER)=	class'WFAPawnAxisGer'
	GER(`RI_TEAMLEADER)=	class'WFAPawnAxisGerTL'
	GER(`RI_TANK_CREW)=		class'WFAPawnTanker'
	GER(`RI_TANK_COMM)=		class'WFAPawnTanker'
	GER(`RI_TANK_SL)=		class'WFAPawnTanker'
	GER(`RI_TANK_TL)=		class'WFAPawnTanker'
}
