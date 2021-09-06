class DRMapInfo extends ROMapInfo
    HideCategories(SinglePlayer,Modding,Skirmish,SouthernForce,NorthernForce);

var(CommanderNorth) int DiveBomberHeightOffset <Tooltip=Dive bomber spawn location height offset.>;

enum EAxisForces
{
    AXISFORCE_DAK,
};

enum EAlliedForces
{
    ALLIEDFORCE_UK,
};

var() EAxisForces AxisForce;
var() EAlliedForces AlliedForce;

/*
var(WinterWar) AirSupportLevel  FinnishAirSupportLevel      <ToolTip=What type of Air Support is allowed on the map.>;
var(WinterWar) int              FinnishFighterPlaneCallLimit<ToolTip=How many times the Fighter Planes ability can be used before the ability is disabled, cooldown time is automatically calulated from this variable. Use Air Support Level to disable completely.|ClampMin=1>;
var(WinterWar) int              FinnishReconPlaneInterval   <ToolTip=Recon cooldown time in seconds. Make sure this value is long enough to cover the entire recon matinee duration!|ClampMin=15>;
var(WinterWar) int              FinnishLightArtilleryLimit  <ToolTip=How many times Light Artillery can be called before the ability is disabled, cooldown time is automatically calulated from this variable. Set 0 to disable completely.>;
var(WinterWar) int              FinnishHeavyArtilleryLimit  <ToolTip=How many times Heavy Artillery can be called before the ability is disabled, cooldown time is automatically calulated from this variable. Set 0 to disable completely.>;

var(WinterWar) AirSupportLevel  SovietAirSupportLevel       <ToolTip=What type of Air Support is allowed on the map.>;
var(WinterWar) int              SovietBomberCallLimit       <ToolTip=How many times the Bombers ability can be used before the ability is disabled, cooldown time is automatically calulated from this variable. Use Air Support Level to disable completely.|ClampMin=1>;
var(WinterWar) int              SovietReconPlaneInterval    <ToolTip=Recon cooldown time in seconds. Make sure this value is long enough to cover the entire recon matinee duration!|ClampMin=15>;
var(WinterWar) int              SovietBomberHeightOffset    <ToolTip=Bombers will fly at this altitude, should be quite high. 50 units = 1 meter.>;
var(WinterWar) int              SovietLightArtilleryLimit   <ToolTip=How many times Light Artillery can be called before the ability is disabled, cooldown time is automatically calulated from this variable. Set 0 to disable completely.>;
var(WinterWar) int              SovietHeavyArtilleryLimit   <ToolTip=How many times Heavy Artillery can be called before the ability is disabled, cooldown time is automatically calulated from this variable. Set 0 to disable completely.>;

var ArtyTypeStats FinnishArtilleryStats[2];
var ArtyTypeStats SovietArtilleryStats[2];

function int GetFirstAbilityLimit(int MaxPlayers, int TeamIndex)
{
    if (TeamIndex == `ALLIES_TEAM_INDEX)
    {
        return SovietLightArtilleryLimit;
    }
    else
    {
        return FinnishLightArtilleryLimit;
    }
}

function int GetSecondAbilityLimit(int MaxPlayers, int TeamIndex)
{
    if (TeamIndex == `ALLIES_TEAM_INDEX)
    {
        return SovietHeavyArtilleryLimit;
    }
    else
    {
        return FinnishHeavyArtilleryLimit;
    }
}

function int GetThirdAbilityLimit(int MaxPlayers, int TeamIndex)
{
    if (TeamIndex == `ALLIES_TEAM_INDEX)
    {
        return SovietBomberCallLimit;
    }
    else
    {
        return FinnishFighterPlaneCallLimit;
    }
}

function int GetMaxArtyType(int Team, bool bReversedRoles)
{
    if (Team == `ALLIES_TEAM_INDEX)
    {
        return (SovietAirSupportLevel < AirSupport_FULL) ? 1 : 2;
    }
    else
    {
        return (FinnishAirSupportLevel < AirSupport_FULL) ? 1 : 2;
    }
}

function bool MapHasRecon(int Team)
{
    if (Team == `ALLIES_TEAM_INDEX)
    {
        return (SovietAirSupportLevel > AirSupport_NONE);
    }
    else
    {
        return (FinnishAirSupportLevel > AirSupport_NONE);
    }
}

function int GetReconInterval(int Team)
{
    if (Team == `AXIS_TEAM_INDEX)
    {
        return FinnishReconPlaneInterval;
    }

    return SovietReconPlaneInterval;
}

function int GetBatterySizeWW(int Team, int ArtilleryType)
{
    switch (Team)
    {
        case `AXIS_TEAM_INDEX:
            return FinnishArtilleryStats[ArtilleryType].BatterySize;

        case `ALLIES_TEAM_INDEX:
            return SovietArtilleryStats[ArtilleryType].BatterySize;
    }

    `wwdebug("returning Default!", 'CMDA');
    return Rand(3) + 4;
}

function int GetSalvoAmountWW(int Team, int ArtilleryType)
{
    switch (Team)
    {
        case `AXIS_TEAM_INDEX:
            return FinnishArtilleryStats[ArtilleryType].SalvoAmount;

        case `ALLIES_TEAM_INDEX:
            return SovietArtilleryStats[ArtilleryType].SalvoAmount;
    }

    `wwdebug("returning Default!", 'CMDA');
    return Rand(3) + 4;
}

function int GetSpreadAmountWW(int Team, int ArtilleryType)
{
    switch (Team)
    {
        case `AXIS_TEAM_INDEX:
            return FinnishArtilleryStats[ArtilleryType].StrikePattern;

        case `ALLIES_TEAM_INDEX:
            return SovietArtilleryStats[ArtilleryType].StrikePattern;
    }

    `wwdebug("returning Default!", 'CMDA');
    return 1000;
}

function int GetSalvoIntervalWW(int Team, int ArtilleryType)
{
    switch (Team)
    {
        case `AXIS_TEAM_INDEX:
            return FinnishArtilleryStats[ArtilleryType].SalvoInterval;

        case `ALLIES_TEAM_INDEX:
            return SovietArtilleryStats[ArtilleryType].SalvoInterval;
    }

    `wwdebug("returning Default!", 'CMDA');
    return 5;
}

function int GetStrikeDelayWW(int Team, int ArtilleryType)
{
    switch (Team)
    {
        case `AXIS_TEAM_INDEX:
            return FinnishArtilleryStats[ArtilleryType].StrikeDelay;

        case `ALLIES_TEAM_INDEX:
            return SovietArtilleryStats[ArtilleryType].StrikeDelay;
    }

    `wwdebug("returning Default!", 'CMDA');
    return 15;
}

function class<ROArtilleryShell> GetShellClassWW(int Team, int ArtilleryType)
{
    switch (Team)
    {
        case `AXIS_TEAM_INDEX:
            return FinnishArtilleryStats[ArtilleryType].ShellClass;

        case `ALLIES_TEAM_INDEX:
            return SovietArtilleryStats[ArtilleryType].ShellClass;
    }

    `wwdebug("returning Default!", 'CMDA');
    return class'ROArtilleryShell';
}
*/

// TODO: check if we need this.
function OverrideForces()
{
    NorthernForce = 0;
    SouthernForce = 0;
}

function InitRolesForGametype(class<GameInfo> GameTypeClass, int MaxPlayers, bool bReverseRoles)
{
    OverrideForces();

    if (bInitializedRoles)
    {
        return;
    }

    bInitializedRoles = true;
}

function PreLoadSharedContentForGameType()
{
    local RORoleInfoClasses NorthPawnContentClasses;
    local RORoleInfoClasses SouthPawnContentClasses;
    local ROGameReplicationInfo ROGRI;
    // local int i;

    OverrideForces();

    ROGRI = ROGameReplicationInfo(class'WorldInfo'.static.GetWorldInfo().GRI);

    NorthPawnContentClasses = class'DRGameInfo'.default.NorthRoleContentClasses;
    SouthPawnContentClasses = class'DRGameInfo'.default.SouthRoleContentClasses;

    SharedContentReferences.Remove(0, SharedContentReferences.Length);
    class'WorldInfo'.static.GetWorldInfo().ForceGarbageCollection(TRUE);

    // SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_Maxim_ActualContent", class'Class')));
    // SharedContentReferences.AddItem(class<Inventory>(DynamicLoadObject("WinterWar.WWWeapon_QuadMaxims_ActualContent", class'Class')));

    if (NorthernTeamLeader.RoleInfo != none)
    {
        NorthernTeamLeader.RoleInfo.PreLoadContent(NorthPawnContentClasses.LevelContentClasses, ROGRI.RoleInfoItemsIdx);
    }

    if (SouthernTeamLeader.RoleInfo != none)
    {
        SouthernTeamLeader.RoleInfo.PreLoadContent(SouthPawnContentClasses.LevelContentClasses, ROGRI.RoleInfoItemsIdx);
    }
    `drtrace;
    // We can't do real asynchronous loading since we're not Native, so let's just load everything here to avoid hitching midgame
    /*
    for (i = 0; i < class'DRTeamInfo'.default.AxisLowMoralePlayList.CRef_MusicTracks.length; i++)
    {
        SharedContentReferences.AddItem(class<SoundCue>(DynamicLoadObject(class'DRTeamInfo'.default.AxisLowMoralePlayList.CRef_MusicTracks[i], class'SoundCue')));
    }

    for (i = 0; i < class'DRTeamInfo'.default.AlliesLowMoralePlayList.CRef_MusicTracks.length; i++)
    {
        SharedContentReferences.AddItem(class<SoundCue>(DynamicLoadObject(class'DRTeamInfo'.default.AlliesLowMoralePlayList.CRef_MusicTracks[i], class'SoundCue')));
    }

    for (i = 0; i < class'DRTeamInfo'.default.AxisNormalMoralePlayList.CRef_MusicTracks.length; i++)
    {
        SharedContentReferences.AddItem(class<SoundCue>(DynamicLoadObject(class'DRTeamInfo'.default.AxisNormalMoralePlayList.CRef_MusicTracks[i], class'SoundCue')));
    }

    for (i = 0; i < class'DRTeamInfo'.default.AlliesNormalMoralePlayList.CRef_MusicTracks.length; i++)
    {
        SharedContentReferences.AddItem(class<SoundCue>(DynamicLoadObject(class'DRTeamInfo'.default.AlliesNormalMoralePlayList.CRef_MusicTracks[i], class'SoundCue')));
    }

    for (i = 0; i < class'DRTeamInfo'.default.AxisHighMoralePlayList.CRef_MusicTracks.length; i++)
    {
        SharedContentReferences.AddItem(class<SoundCue>(DynamicLoadObject(class'DRTeamInfo'.default.AxisHighMoralePlayList.CRef_MusicTracks[i], class'SoundCue')));
    }

    for (i = 0; i < class'DRTeamInfo'.default.AlliesHighMoralePlayList.CRef_MusicTracks.length; i++)
    {
        SharedContentReferences.AddItem(class<SoundCue>(DynamicLoadObject(class'DRTeamInfo'.default.AlliesHighMoralePlayList.CRef_MusicTracks[i], class'SoundCue')));
    }*/
}

function int GetNorthernNation()
{
    return `AXIS_TEAM_INDEX;
}

function int GetSouthernNation()
{
    return `ALLIES_TEAM_INDEX;
}

static function int GetNationForArmy(byte ArmyIndex)
{
    if (ArmyIndex >= 1)
        return 1;
    else
        return 0;
}

function int GetNumArmiesForTeam(byte TeamIndex)
{
    return 1;
}

function string GetArmyNameForTeam(byte TeamIndex, bool bGetShortName, optional byte ArmyIndex = 255)
{
    if (TeamIndex == `AXIS_TEAM_INDEX)
    {
        return bGetShortName ? NorthernArmyShortNames[0] : NorthernArmyNames[0];
    }
    else
    {
        return bGetShortName ? SouthernArmyShortNames[0] : SouthernArmyNames[0];
    }
}

static function string GetClassNameByIndex(int TeamIndex, int ClassIndex, optional bool bShortName)
{
    local int i;

    if (ClassIndex == `DRCI_COMMANDER)
    {
        `drtrace;
        return (TeamIndex == `AXIS_TEAM_INDEX) ? class'DRRoleInfoAxisCommander'.static.GetProfileName(bShortName) : "";// class'DRRoleInfoAlliesCommander'.static.GetProfileName(bShortName);
    }

    if (TeamIndex == `AXIS_TEAM_INDEX)
    {
        for (i = 0; i < default.NorthernRoles.Length; i++)
        {
            if (default.NorthernRoles[i].RoleInfoClass.default.ClassIndex == ClassIndex)
                return default.NorthernRoles[i].RoleInfoClass.static.GetProfileName(bShortName);
        }
    }
    else
    {
        for (i = 0; i < default.SouthernRoles.Length; i++)
        {
            if (default.SouthernRoles[i].RoleInfoClass.default.ClassIndex == ClassIndex)
                return default.SouthernRoles[i].RoleInfoClass.static.GetProfileName(bShortName);
        }
    }

    return "Error!";
}

function int GetInitialCommanderCooldown(class<GameInfo> GameTypeClass)
{
`ifndef(RELEASE)
    return 0;
`endif

    return INITIAL_COMMANDER_COOLDOWN;
}

`ifndef(RELEASE)
function int GetNorthReinforcementDelay(int MaxPlayers, class<GameInfo> GameTypeClass, bool bReversedTeams, optional float TimeScale = 1.0, optional bool bEnhancedLogistics)
{
    return 2;
}

function int GetSouthReinforcementDelay(int MaxPlayers, class<GameInfo> GameTypeClass, bool bReversedTeams, optional float TimeScale = 1.0)
{
    return 2;
}
`endif

DefaultProperties
{
    /*
    FinnishAirSupportLevel=AirSupport_NONE
    FinnishReconPlaneInterval=300
    FinnishFighterPlaneCallLimit=3
    FinnishLightArtilleryLimit=0
    FinnishHeavyArtilleryLimit=0

    SovietAirSupportLevel=AirSupport_NONE
    SovietReconPlaneInterval=300
    SovietBomberCallLimit=4
    SovietLightArtilleryLimit=0
    SovietHeavyArtilleryLimit=0

    // 1 meter = 50 units
    SovietBomberHeightOffset=17500

    FinnishArtilleryStats(0)=(BatterySize=6,SalvoAmount=6,StrikeDelay=5,SalvoInterval=4.0,StrikePattern=2200,ShellClass=class'ROMortarShell')
    FinnishArtilleryStats(1)=(BatterySize=4,SalvoAmount=5,StrikeDelay=8,SalvoInterval=6.0,StrikePattern=1250,ShellClass=class'ROArtilleryShell')

    SovietArtilleryStats(0)=(BatterySize=8,SalvoAmount=4,StrikeDelay=8,SalvoInterval=7.0,StrikePattern=1800,ShellClass=class'ROArtilleryShell')
    SovietArtilleryStats(1)=(BatterySize=2,SalvoAmount=8,StrikeDelay=10,SalvoInterval=15.0,StrikePattern=400,ShellClass=class'WW203mmArtilleryShell')
    */

    // SouthernForce=ALLIEDFORCE_UK;
    // NorthernForce=AXISFORCE_DAK;

    DiveBomberHeightOffset=0

    DefendingTeam=DT_None
    DefendingTeam16=DT_None
    DefendingTeam32=DT_None
    DefendingTeam64=DT_None

    TempCelsius=35

    NorthernRoles.Empty
    NorthernRoles(0)=(RoleInfoClass=class'DRRoleInfoAxisRifleman',Count=255)
    // NorthernRoles(X)=(RoleInfoClass=class'DRRoleInfoAxisEliteRifleman',Count=2)
    NorthernRoles(1)=(RoleInfoClass=class'DRRoleInfoAxisAssault',Count=2)
    NorthernRoles(2)=(RoleInfoClass=class'DRRoleInfoAxisMachineGunner',Count=2)
    NorthernRoles(3)=(RoleInfoClass=class'DRRoleInfoAxisSniper',Count=1)
    NorthernRoles(4)=(RoleInfoClass=class'DRRoleInfoAxisSapper',Count=2)
    // NorthernRoles(X)=(RoleInfoClass=class'DRRoleInfoAxisHeavy',Count=2)
    // NorthernRoles(X)=(RoleInfoClass=class'DRRoleInfoAxisAntiTank',Count=2)
    NorthernRoles(5)=(RoleInfoClass=class'DRRoleInfoAxisRadioman',Count=2)
    NorthernRoles(6)=(RoleInfoClass=class'DRRoleInfoAxisCommander',Count=2)
    NorthernRoles(7)=(RoleInfoClass=class'DRRoleInfoAxisTankCrew',Count=2)
    NorthernRoles(8)=(RoleInfoClass=class'DRRoleInfoAxisTankCommander',Count=1)

    SouthernRoles.Empty
    SouthernRoles(0)=(RoleInfoClass=class'DRRoleInfoAlliesRifleman',Count=255)
    // SouthernRoles(X)=(RoleInfoClass=class'DRRoleInfoAlliesEliteRifleman',Count=2)
    SouthernRoles(1)=(RoleInfoClass=class'DRRoleInfoAlliesAssault',Count=2)
    SouthernRoles(2)=(RoleInfoClass=class'DRRoleInfoAlliesMachineGunner',Count=2)
    SouthernRoles(3)=(RoleInfoClass=class'DRRoleInfoAlliesSniper',Count=1)
    SouthernRoles(4)=(RoleInfoClass=class'DRRoleInfoAlliesSapper',Count=2)
    // SouthernRoles(X)=(RoleInfoClass=class'DRRoleInfoAlliesHeavy',Count=2)
    // SouthernRoles(X)=(RoleInfoClass=class'DRRoleInfoAlliesAntiTank',Count=2)
    SouthernRoles(5)=(RoleInfoClass=class'DRRoleInfoAlliesRadioman',Count=2)
    SouthernRoles(6)=(RoleInfoClass=class'DRRoleInfoAlliesCommander',Count=2)
    SouthernRoles(7)=(RoleInfoClass=class'DRRoleInfoAlliesTankCrew',Count=2)
    SouthernRoles(8)=(RoleInfoClass=class'DRRoleInfoAlliesTankCommander',Count=1)
}
