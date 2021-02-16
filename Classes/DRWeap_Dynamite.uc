class DRWeap_Dynamite extends DRWeap_TNT
    abstract;

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_Dynamite_Content"

    InvIndex=`DRII_DYNAMITE

    AmmoClass=class'DRAmmo_Dynamite'

    WeaponProjectiles(0)=class'DRProjectile_Dynamite'
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRProjectile_Dynamite'

    PlayerViewOffset=(X=5,Y=5,Z=-3.5)
}
