class DRRoleInfoAxisAssault extends DRRoleInfoAxis;

DefaultProperties
{
    RoleType=RORIT_Scout
    ClassTier=2
    ClassIndex=`RI_ASSAULT

    // TODO: Should MP41 be part of standard loadout?
    Items[RORIGM_Default]={(
        PrimaryWeapons=(class'DRWeapon_MP40',class'DRWeap_MP41_SMG'),

        OtherItems=(class'ROWeap_Type67_Grenade',class'ROWeap_RDG1_Smoke')
    )}

    ClassIcon=Texture2D'DR_UI.RoleIcons.Small_Class_Icon_Assault'
    ClassIconLarge=Texture2D'DR_UI.RoleIcons.Class_Icon_Large_Assault'
}
