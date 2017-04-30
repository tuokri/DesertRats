//=============================================================================
// WFARI_DAK_RIFLEMAN.uc
//=============================================================================
// German Rifleman Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_DAK_RIFLEMAN extends WFARI_DAK;

defaultproperties
{
	RoleType=RORIT_Rifleman
	ClassTier=1
	ClassIndex=`RI_RIFLEMAN
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_Kar98_Rifle'
	
	OtherItems(0)=class'WFGame.WFWeap_M1939_Grenade'
}
