//=============================================================================
// DRAmmo_P14
//=============================================================================
// Ammo properties for the P14
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================

class DRAmmo_P14 extends ROAmmunition
    abstract;

defaultproperties
{
    CompatibleWeaponClasses(0)=class'DesertRats.DRWeap_P14Scoped_Rifle'

    InitialAmount=5
    Weight=0.175 // 175gr with M118LR.
    ClipsPerSlot=3
}
