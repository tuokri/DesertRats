class DRRoleInfoAlliesAssault extends DRRoleInfoAllies;

DefaultProperties
{
    RoleType=RORIT_Rifleman
    ClassTier=2
    ClassIndex=`DRCI_ASSAULT

    Items[RORIGM_Default]={(
        PrimaryWeapons=(class'DRWeap_Thompson_SMG',class'DRWeap_Thompson_M1928A1_SMG'),
        OtherItems=(class'DRWeap_Mills_Grenade',class'ROWeap_M8_Smoke')
    )}

    ClassIcon=Texture2D'DR_UI.RoleIcons.Small_Class_Icon_Assault'
    ClassIconLarge=Texture2D'DR_UI.RoleIcons.Class_Icon_Large_Assault'
}
