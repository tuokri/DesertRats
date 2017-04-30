//=============================================================================
// WFARI_UK_ASSAULT.uc
//=============================================================================
// British Assault Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_UK_ASSAULT extends WFARI_UK;

defaultproperties
{
	RoleType=RORIT_Assault
	ClassTier=3
	ClassIndex=`RI_ASSAULT
	
	PrimaryWeapons(0)=class'RSGame.RSWeap_M1928_SMG'
	
	OtherItems(0)=class'WFGame.WFWeap_Mills_Grenade'
}
