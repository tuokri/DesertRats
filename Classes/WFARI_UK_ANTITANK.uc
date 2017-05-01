//=============================================================================
// WFARI_UK_ANTITANK.uc
//=============================================================================
// British Anti Tank Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_UK_ANTITANK extends WFARI_UK;

defaultproperties
{
	RoleType=RORIT_AntiTank
	ClassTier=3
	ClassIndex=`RI_ANTITANK
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_PIAT'
	
	bAllowPistolsInRealism=true
}