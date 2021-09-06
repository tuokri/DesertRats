class DRGameEngine extends ROGameEngine;

function string GetPlayerTeamForRichPresence(ROGameReplicationInfo ROGRI, ROMapInfo ROMI)
{
    local string RetValue;
    local ROPlayerController ROPC;
    local ROPlayerReplicationInfo ROPRI;
    local int TeamIndex;
    local DRMapInfo DRMI;

    RetValue = " ";
    DRMI = DRMapInfo(ROMI);

    if (DRMI == None)
    {
        return RetValue;
    }

    ROPC = GetLocalPlayerController();
    if (ROPC != none && ROPC.PlayerReplicationInfo != none && ROPC.PlayerReplicationInfo.Team != none)
    {
        ROPRI = ROPlayerReplicationInfo(ROPC.PlayerReplicationInfo);
        TeamIndex = ROPRI.Team.TeamIndex;
        if (TeamIndex == `AXIS_TEAM_INDEX)
        {
            RetValue = DRMI.NorthernArmyShortNames[DRMI.AxisForce];
        }
        else if (TeamIndex == `ALLIES_TEAM_INDEX)
        {
            RetValue = DRMI.SouthernArmyShortNames[DRMI.AlliedForce];
        }
        else
        {
            RetValue = "Spectator";
        }
    }

    return RetValue;
}
