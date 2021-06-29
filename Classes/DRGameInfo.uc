class DRGameInfo extends ROGameInfo
    config(Game_DesertRats_GameInfo)
    HideDropDown;

var localized string AxisBotNames[32];
var localized string AlliesBotNames[32];

`include(DesertRats\Classes\DRGameInfo_Common.uci)

DefaultProperties
{
    MenuMusicTrack=None

    `DRGICommonDP

    NorthRoleContentClasses=(LevelContentClasses=("DesertRats.DRPawnAxis"))
    SouthRoleContentClasses=(LevelContentClasses=("DesertRats.DRPawnAllies"))
}
