//=============================================================================
// DRAmmo_Boys
//=============================================================================
// Ammo properties for the Boys Magazine
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRAmmo_Boys extends ROAmmunition
	abstract;

defaultproperties
{
    CompatibleWeaponClasses(0)=class'GOM4.DRWeapon_Boys'

    InitialAmount=5
    Weight=1.1 			// kg - 5 x 198.5g + clip
    ClipsPerSlot=1
}
