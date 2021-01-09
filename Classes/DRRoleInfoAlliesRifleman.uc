class DRRoleInfoAlliesRifleman extends DRRoleInfoAllies;

DefaultProperties
{
    RoleType=RORIT_Rifleman
    ClassTier=1
    ClassIndex=`RI_RIFLEMAN

    Items[RORIGM_Default]={(
        PrimaryWeapons=(class'DRWeapon_Enfield'),

        OtherItems=(class'ROWeap_M61_GrenadeSingle')
    )}

    ClassIcon=Texture2D'DR_UI.RoleIcons.Small_Class_Icon_Rifleman'
    ClassIconLarge=Texture2D'DR_UI.RoleIcons.Class_Icon_Large_Rifleman'
}
