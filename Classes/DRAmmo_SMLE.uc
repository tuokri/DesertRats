//=============================================================================
// DRAmmo_SMLE
//=============================================================================
// Ammo properties for the SMLE Stripper Clip
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================

class DRAmmo_SMLE extends ROAmmunition
    abstract;

defaultproperties
{
    CompatibleWeaponClasses(0)=class'DesertRats.DRWeap_SMLE_Rifle'

    InitialAmount=5
    Weight=0.1235
    ClipsPerSlot=3
}
