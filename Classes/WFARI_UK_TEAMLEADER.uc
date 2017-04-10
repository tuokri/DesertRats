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
	
	PrimaryWeapons(2)=class'WFGame.WFWeap_Kar98_Rifle'
	PrimaryWeapons(3)=class'WFGame.WFWeap_MP40_SMG'
	NumPrimaryVeteranEnemyWeapons=2
	
	SecondaryWeapons(0)=class'WFGame.WFWeap_BHP35_Pistol'
	
	SecondaryWeapons(1)=class'WFGame.WFWeap_P38_Pistol'
	NumSecondaryFrontlineEnemyWeapons=1
	
	OtherItems(0)=class'WFGame.WFWeap_Mills_Grenade'
	OtherItems(1)=class'RSGame.RSWeap_M8_Smoke'
	OtherItems(2)=class'RSGame.RSItem_Binoculars'
	
	bIsTeamLeader=true
}
