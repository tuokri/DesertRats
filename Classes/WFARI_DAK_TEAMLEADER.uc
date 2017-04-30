//=============================================================================
// WFARI_DAK_TEAMLEADER.uc
//=============================================================================
// German Team Leader Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_DAK_TEAMLEADER extends WFARI_DAK;

defaultproperties
{
	RoleType=RORIT_Commander
	ClassTier=4
	ClassIndex=`RI_TEAMLEADER
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_Kar98_Rifle'
	PrimaryWeapons(1)=class'WFGame.WFWeap_MP40_SMG'
	
	bAllowPistolsInRealism=true
	
	OtherItems(0)=class'WFGame.WFWeap_M1939_Grenade'
	OtherItems(1)=class'WFGame.WFWeap_NG39_Grenade'
	OtherItems(2)=class'WFGame.WFItem_Binoculars'
	
	bIsTeamLeader=true
}
