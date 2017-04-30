//=============================================================================
// WFARI_UK_SNIPER.uc
//=============================================================================
// British Sniper Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_UK_SNIPER extends WFARI_UK;

defaultproperties
{
	RoleType=RORIT_Marksman
	ClassTier=3
	ClassIndex=`RI_SNIPER
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_SMLE_Scoped_Rifle'
	
	bAllowPistolsInRealism=true
	
	bIsMarksman=true
}
