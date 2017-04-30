//=============================================================================
// WFARI_UK_RIFLEMAN.uc
//=============================================================================
// British Rifleman Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_UK_RIFLEMAN extends WFARI_UK;

defaultproperties
{
	RoleType=RORIT_Rifleman
	ClassTier=1
	ClassIndex=`RI_RIFLEMAN
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_SMLE_Rifle'
	
	OtherItems(0)=class'WFGame.WFWeap_Mills_Grenade'
}
