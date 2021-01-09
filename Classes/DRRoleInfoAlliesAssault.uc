class DRRoleInfoAlliesAssault extends DRRoleInfoAllies;

DefaultProperties
{
    RoleType=RORIT_Rifleman
    ClassTier=2
    ClassIndex=`RI_ASSAULT

    Items[RORIGM_Default]={(
        PrimaryWeapons=(class'DRWeapon_Thompson'),

        OtherItems=(class'ROWeap_M61_Grenade',class'ROWeap_M8_Smoke')
    )}

    ClassIcon=Texture2D'DR_UI.RoleIcons.Small_Class_Icon_Assault'
    ClassIconLarge=Texture2D'DR_UI.RoleIcons.Class_Icon_Large_Assault'
}
