//=============================================================================
// WFARI_UK_TEAMLEADER.uc
//=============================================================================
// British Team Leader Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_UK_TEAMLEADER extends WFARI_UK;

defaultproperties
{
	RoleType=RORIT_Commander
	ClassTier=4
	ClassIndex=`RI_TEAMLEADER
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_SMLE_Rifle'
	PrimaryWeapons(1)=class'RSGame.RSWeap_M1928_SMG'
	
	bAllowPistolsInRealism=true
	
	OtherItems(0)=class'WFGame.WFWeap_Mills_Grenade'
	OtherItems(1)=class'RSGame.RSWeap_M8_Smoke'
	OtherItems(2)=class'RSGame.RSItem_Binoculars'
	
	bIsTeamLeader=true
}
