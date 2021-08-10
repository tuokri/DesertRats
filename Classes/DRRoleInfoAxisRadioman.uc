class DRRoleInfoAxisRadioman extends DRRoleInfoAxis;

DefaultProperties
{
    RoleType=RORIT_Radioman
    ClassTier=3
    ClassIndex=`DRCI_RADIOMAN
    bIsRadioman=True

    Items[RORIGM_Default]={(
        PrimaryWeapons=(class'DRWeap_Kar98_Rifle'),

        OtherItems=(class'DRWeap_M24_Grenade')
    )}

    bAllowPistolsInRealism=False

    ClassIcon=Texture2D'DR_UI.RoleIcons.class_icon_radioman'
    ClassIconLarge=Texture2D'DR_UI.RoleIcons.class_icon_large_radioman'
