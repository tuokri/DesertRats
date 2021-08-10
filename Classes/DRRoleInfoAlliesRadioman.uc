class DRRoleInfoAlliesRadioman extends DRRoleInfoAllies;

DefaultProperties
{
    RoleType=RORIT_Radioman
    ClassTier=3
    ClassIndex=`DRCI_RADIOMAN
    bIsRadioman=True

    Items[RORIGM_Default]={(
        PrimaryWeapons=(class'DRWeap_SMLE_Rifle'),

        OtherItems=(class'DRWeap_Mills_Grenade')
    )}

    bAllowPistolsInRealism=False

    ClassIcon=Texture2D'DR_UI.RoleIcons.class_icon_radioman'
    ClassIconLarge=Texture2D'DR_UI.RoleIcons.class_icon_large_radioman'
}
