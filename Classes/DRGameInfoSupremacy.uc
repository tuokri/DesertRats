class DRGameInfoSupremacy extends ROGameInfoSupremacy;

`include(DesertRats\Classes\DRGameInfo_Common.uci)

DefaultProperties
{
    `DRGICommonDP

    bDisableCharCustMenu=False

    SquadSpawnMethod[0]=ROSSM_SquadLeader
    SquadSpawnMethod[1]=ROSSM_SquadLeader
}
