class DRGameInfo extends ROGameInfo
	config(Game_DesertRats_GameInfo)
	HideDropDown;

var localized string AxisBotNames[32];
var localized string AlliesBotNames[32];

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	local class<GameInfo> NewGameType;
	local array<ROUIResourceDataProvider> ProviderList;
	local ROUIDataProvider_GameModeInfo Provider;
	local string ThisMapPrefix;
	local int i, MapPrefixPos;

	ReplaceText(MapName, "UEDPIE", "");

	if (Left(MapName, InStr(MapName, "-")) ~= "DRTE")
	{
		return class'DRGameInfoTerritories';
	}

	MapPrefixPos = InStr(MapName,"-");
	ThisMapPrefix = left(MapName,MapPrefixPos);

	class'ROUIDataStore_MenuItems'.static.GetAllResourceDataProviders(class'ROUIDataProvider_GameModeInfo', ProviderList);
	for (i = 0; i < ProviderList.Length; i++)
	{
		Provider = ROUIDataProvider_GameModeInfo(ProviderList[i]);
		if ( Provider.Prefixes ~= ThisMapPrefix )
		{
			NewGameType = class<GameInfo>(DynamicLoadObject(Provider.GameMode,class'Class'));
			if ( NewGameType != None )
			{
				return NewGameType;
			}
		}
	}

	return default.class;
}

function RestartPlayer(Controller NewPlayer)
{
	local DRPlayerController DRPC;

	super.RestartPlayer(NewPlayer);

	DRPC = DRPlayerController(NewPlayer);
	if (DRPC != None)
	{
		DRPC.ClearLeftVehicleFlag();
	}
}

DefaultProperties
{
	MenuMusicTrack=None

	`DRGICommonDP

	NorthRoleContentClasses=(LevelContentClasses=("DesertRats.DRPawnAxis"))
	SouthRoleContentClasses=(LevelContentClasses=("DesertRats.DRPawnAllies"))
}
