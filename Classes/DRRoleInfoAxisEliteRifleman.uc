class DRRoleInfoAxisEliteRifleman extends DRRoleInfoAxis
    HideDropDown; // Currently unused.

DefaultProperties
{
    RoleType=RORIT_Rifleman
    ClassTier=1
    ClassIndex=`DRCI_ELITE_RIFLEMAN

    Items[RORIGM_Default]={(
        PrimaryWeapons=(class'DRWeap_Kar98_Rifle'),

        OtherItems=(class'DRWeap_M24_Grenade')
    )}

    ClassIcon=Texture2D'DR_UI.RoleIcons.Small_Class_Icon_Rifleman'
    ClassIconLarge=Texture2D'DR_UI.RoleIcons.Class_Icon_Large_Rifleman'
}
