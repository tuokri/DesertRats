class DRGameInfoSupremacy extends ROGameInfoSupremacy
    config(Game_DesertRats_GameInfo);

`include(DesertRats\Classes\DRGameInfo_Common.uci)

`ROUND_WON_FUNCTION

DefaultProperties
{
    `DRGICommonDP

    bDisableCharCustMenu=False

    SquadSpawnMethod[0]=ROSSM_SquadLeader
    SquadSpawnMethod[1]=ROSSM_SquadLeader

    bBalanceStatsAnalyticsEnabled=True
}
