class DRRoleInfoAlliesSapper extends DRRoleInfoAllies;

DefaultProperties
{
    RoleType=RORIT_Engineer
    ClassTier=3
    ClassIndex=`ROCI_ENGINEER // 4

    Items[RORIGM_Default]={(
        PrimaryWeapons=(class'DRWeap_SMLE_Rifle'),
        OtherItems=(class'DRWeap_TNT'),
    )}

    bAllowPistolsInRealism=false

    ClassIcon=Texture2D'DR_UI.RoleIcons.Small_Class_Icon_Sapper'
    ClassIconLarge=Texture2D'DR_UI.RoleIcons.Class_Icon_Large_Sapper'
}
