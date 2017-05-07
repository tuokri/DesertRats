//=============================================================================
// WFAMapInfo.uc
//=============================================================================
// A collection of settings that are specific to each map.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAMapInfo extends ROMapInfo;

enum EAxisFaction
{
	AXIS_GER <DisplayName=Germany>,
	AXIS_ITA <DisplayName=Italy (NOT IMPLEMENTED)>
}; 

var(Axis) EAxisFaction AxisFaction;

function PreLoadSharedContentForGameType()
{
	local int SquadIndex, FireTeamIndex, SeatIndex;
	local ROSquadInfo CurrentSquadInfo;
	local ROFireTeam CurrentFireTeam;
	local class<Inventory> InventoryClass;
	local class<ROWeapon> InvType, WeaponClass;
	
	SharedContentReferences.Remove(0, SharedContentReferences.Length);
	class'WorldInfo'.static.GetWorldInfo().ForceGarbageCollection(TRUE);
	
	// InventoryClass = class<Inventory>(DynamicLoadObject("WFGameContentAfrica.WFAWep_Vickers_ActualContent", class'Class'));
	// SharedContentReferences.AddItem(InventoryClass);
	
	InventoryClass = class<Inventory>(DynamicLoadObject("WFGameContent.WFWeap_MG34_Tripod_Content", class'Class'));
	SharedContentReferences.AddItem(InventoryClass);
	
	WFARI(AxisTeamLeader.RoleInfo).PreLoadContentSingle(class'WFAPawnAxisGer');
	WFARI(AlliesTeamLeader.RoleInfo).PreLoadContentSingle(class'WFAPawnAlliesBrit');
	
	for (SquadIndex = 0; SquadIndex < AxisSquads.Length; SquadIndex++)
	{
		CurrentSquadInfo = AxisSquads[SquadIndex];
		
		for (FireTeamIndex = 0; FireTeamIndex < CurrentSquadInfo.FireTeams.Length; FireTeamIndex++ )
		{
			if (CurrentFireTeam.VehicleClass != none)
			{
				for (SeatIndex = 0; SeatIndex < CurrentFireTeam.VehicleClass.default.Seats.Length; SeatIndex++)
				{
					InvType = CurrentFireTeam.VehicleClass.default.Seats[SeatIndex].GunClass;
					
					WeaponClass = class<ROWeapon>(DynamicLoadObject(InvType.default.WeaponContentClass[0], class'Class'));
					
					SharedContentReferences.AddItem(WeaponClass);
				}
			}
		}
	}
	
	for (SquadIndex = 0; SquadIndex < AlliesSquads.Length; SquadIndex++)
	{
		CurrentSquadInfo = AlliesSquads[SquadIndex];
		
		for (FireTeamIndex = 0; FireTeamIndex < CurrentSquadInfo.FireTeams.Length; FireTeamIndex++ )
		{
			if (CurrentFireTeam.VehicleClass != none)
			{
				for (SeatIndex = 0; SeatIndex < CurrentFireTeam.VehicleClass.default.Seats.Length; SeatIndex++)
				{
					InvType = CurrentFireTeam.VehicleClass.default.Seats[SeatIndex].GunClass;
					
					WeaponClass = class<ROWeapon>(DynamicLoadObject(InvType.default.WeaponContentClass[0], class'Class'));
					
					SharedContentReferences.AddItem(WeaponClass);
				}
			}
		}
	}
}

function ConvertSquadToROClassic(ROSquadInfo SquadInfo) {}

function class<RORoleInfo> GetClassicRole(RORoleInfo CurrentRole, bool bEarly) {}

function ConvertVehicleSquad(int SquadIndex, byte TeamIndex) {}

function ConvertInfantrySquad(ROGameReplicationInfo ROGRI, ROSquadInfo SquadInfo) {}

private function PreloadGameClass(class<GameInfo> DummyClass)
{
	DummyClass = class'WFAGameInfoTerritories';
}

DefaultProperties
{
	AxisFaction=AXIS_GER
	
	MortarStats=(BatterySize=5,SalvoAmount=5,StrikeDelay=5,SalvoInterval=2.5,StrikePattern=850,ShellClass=class'RSMortarShell')
	MediumArtyStats=(BatterySize=3,SalvoAmount=5,StrikeDelay=8,SalvoInterval=10.0,StrikePattern=1250,ShellClass=class'RSFieldArtilleryShell')
	RocketArtyStats=(BatterySize=15,SalvoAmount=0,StrikeDelay=12,SalvoInterval=0.5,StrikePattern=2000,ShellClass=class'RSBattleshipShell')
	
	AxisAerialReconDelay=		10
	AxisAerialReconInterval=	120
	AlliesAerialReconDelay=		10
	AlliesAerialReconInterval=	120
	
	AxisReinforcementDelay16=10
	AxisReinforcementDelay32=10
	AxisReinforcementDelay64=15
	AlliesReinforcementDelay16=10
	AlliesReinforcementDelay32=10
	AlliesReinforcementDelay64=15
	
	TimeLimit16=1400
	TimeLimit32=1800
	TimeLimit64=2400
	
	DefendingTeam=DT_Unspecified
	DefendingTeam16=DT_Unspecified
	DefendingTeam32=DT_Unspecified
	DefendingTeam64=DT_Unspecified
	
	AxisMortarStrikeLimit16=8
	AxisMortarStrikeLimit32=8
	AxisMortarStrikeLimit64=8
	AlliesMortarStrikeLimit16=8
	AlliesMortarStrikeLimit32=8
	AlliesMortarStrikeLimit64=8
	
	AxisArtilleryStrikeLimit16=5
	AxisArtilleryStrikeLimit32=5
	AxisArtilleryStrikeLimit64=5
	AlliesArtilleryStrikeLimit16=5
	AlliesArtilleryStrikeLimit32=5
	AlliesArtilleryStrikeLimit64=5
	
	AxisRocketStrikeLimit16=0
	AxisRocketStrikeLimit32=0
	AxisRocketStrikeLimit64=0
	AlliesRocketStrikeLimit16=3
	AlliesRocketStrikeLimit32=3
	AlliesRocketStrikeLimit64=3
	
	TempCelsius=35
}
