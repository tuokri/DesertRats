class DRRoleInfoAlliesMachineGunner extends DRRoleInfoAllies;

DefaultProperties
{
    RoleType=RORIT_MachineGunner
    ClassTier=2
    ClassIndex=`RI_MACHINE_GUNNER

    Items[RORIGM_Default]={(
        PrimaryWeapons=(class'DRWeap_Lewis_LMG', class'DRWeap_Bren_LMG')
    )}

    bAllowPistolsInRealism=true

    ClassIcon=Texture2D'DR_UI.RoleIcons.Small_Class_Icon_Machinegunner'
    ClassIconLarge=Texture2D'DR_UI.RoleIcons.Class_Icon_Large_Machinegunner'
}
