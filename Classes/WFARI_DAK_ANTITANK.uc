//=============================================================================
// WFARI_DAK_ANTITANK.uc
//=============================================================================
// German Anti Tank Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_DAK_ANTITANK extends WFARI_DAK;

defaultproperties
{
	RoleType=RORIT_AntiTank
	ClassTier=3
	ClassIndex=`RI_ANTITANK
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_M1A1Bazooka' // Panzerschreck stand-in
	
	bAllowPistolsInRealism=true
}
