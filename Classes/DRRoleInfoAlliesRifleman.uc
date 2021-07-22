class DRRoleInfoAlliesRifleman extends DRRoleInfoAllies;

DefaultProperties
{
    RoleType=RORIT_Rifleman
    ClassTier=1
    ClassIndex=`DRCI_RIFLEMAN

    Items[RORIGM_Default]={(
        PrimaryWeapons=(class'DRWeap_SMLE_Rifle'),

        OtherItems=(class'DRWeap_Mills_Grenade')
    )}

    ClassIcon=Texture2D'DR_UI.RoleIcons.Small_Class_Icon_Rifleman'
    ClassIconLarge=Texture2D'DR_UI.RoleIcons.Class_Icon_Large_Rifleman'
}
