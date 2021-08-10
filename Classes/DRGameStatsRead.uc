// Dummy class, doesn't actually do any stats reading/writing.
class DRGameStatsRead extends Object;

var array< class<DRRoleInfo> > NorthRoles;
var array< class<DRRoleInfo> > SouthRoles;

/* TODO: Needed?
static function class<ROWeapon> GetWeaponClassByIndex(int InvIndex)
{
    return class'DRHUDWidgetKillMessages'.static.GetWeaponClassByIndex(InvIndex);
}
*/

function class<DRRoleInfo> GetRoleInfoByIndex(int TeamIndex, int ClassIndex)
{
    local int i;

    if( TeamIndex == `AXIS_TEAM_INDEX )
    {
        for( i = 0; i < default.NorthRoles.Length; i++)
        {
            if(default.NorthRoles[i].default.ClassIndex == ClassIndex)
                return default.NorthRoles[i];
        }
    }
    else
    {
        for( i = 0; i < default.SouthRoles.Length; i++)
        {
            if(default.SouthRoles[i].default.ClassIndex == ClassIndex)
                return default.SouthRoles[i];
        }
    }

    return none;
}

static function string GetClassNameByIndex(int TeamIndex, int ClassIndex, optional bool bShortName)
{
    local int i;

    if( TeamIndex == `AXIS_TEAM_INDEX )
    {
        for( i = 0; i < default.NorthRoles.Length; i++)
        {
            if(default.NorthRoles[i].default.ClassIndex == ClassIndex)
                return default.NorthRoles[i].static.GetProfileName(bShortName);
        }
    }
    else
    {
        for( i = 0; i < default.SouthRoles.Length; i++)
        {
            if(default.SouthRoles[i].default.ClassIndex == ClassIndex)
                return default.SouthRoles[i].static.GetProfileName(bShortName);
        }
    }

    return "Error!";
}

static function Texture2D GetClassIconByIndex(int TeamIndex, int ClassIndex)
{
    local int i;

    if( TeamIndex == `AXIS_TEAM_INDEX )
    {
        for (i = 0; i < default.NorthRoles.Length; i++)
        {
            if(default.NorthRoles[i].default.ClassIndex == ClassIndex)
            {
                return default.NorthRoles[i].default.ClassIcon;
            }
        }
    }
    else
    {
        for(i = 0; i < default.SouthRoles.Length; i++)
        {
            if (default.SouthRoles[i].default.ClassIndex == ClassIndex)
            {
                return default.SouthRoles[i].default.ClassIcon;
            }
        }
    }

    return none;
}

DefaultProperties
{
    NorthRoles={(
        class'DRRoleInfoAxisRifleman',
        // class'DRRoleInfoAxisEliteRifleman',
        class'DRRoleInfoAxisAssault',
        class'DRRoleInfoAxisMachineGunner',
        class'DRRoleInfoAxisSniper',
        class'DRRoleInfoAxisSapper',
        // class'DRRoleInfoAxisHeavy',
        // class'DRRoleInfoAxisAntiTank',
        class'DRRoleInfoAxisRadioman',
        class'DRRoleInfoAxisCommander',
        class'DRRoleInfoAxisTankCrew',
        class'DRRoleInfoAxisTankCommander',
    )}

    SouthRoles={(
        class'DRRoleInfoAlliesRifleman',
        // class'DRRoleInfoAlliesEliteRifleman',
        class'DRRoleInfoAlliesAssault',
        class'DRRoleInfoAlliesMachineGunner',
        class'DRRoleInfoAlliesSniper',
        class'DRRoleInfoAlliesSapper',
        // class'DRRoleInfoAlliesHeavy',
        // class'DRRoleInfoAlliesAntiTank',
        class'DRRoleInfoAlliesRadioman',
        class'DRRoleInfoAlliesCommander',
        class'DRRoleInfoAlliesTankCrew',
        class'DRRoleInfoAlliesTankCommander',
    )}
}
