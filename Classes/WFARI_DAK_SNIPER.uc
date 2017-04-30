//=============================================================================
// WFARI_DAK_SNIPER.uc
//=============================================================================
// German Sniper Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_DAK_SNIPER extends WFARI_DAK;

defaultproperties
{
	RoleType=RORIT_Marksman
	ClassTier=3
	ClassIndex=`RI_SNIPER
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_Kar98Scoped_Rifle'
	
	bAllowPistolsInRealism=true
	
	bIsMarksman=true
}
