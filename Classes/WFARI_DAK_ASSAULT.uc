//=============================================================================
// WFARI_DAK_ASSAULT.uc
//=============================================================================
// German Assault Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_DAK_ASSAULT extends WFARI_DAK;

defaultproperties
{
	RoleType=RORIT_Assault
	ClassTier=3
	ClassIndex=`RI_ASSAULT
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_MP40_SMG'
	
	OtherItems(0)=class'WFGame.WFWeap_M1939_Grenade'
}
