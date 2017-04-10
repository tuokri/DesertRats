//=============================================================================
// WFARI_UK_SQUADLEADER.uc
//=============================================================================
// British Squad Leader Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_UK_SQUADLEADER extends WFARI_UK;

defaultproperties
{
	RoleType=RORIT_SquadLeader
	ClassTier=3
	ClassIndex=`RI_SQUADLEADER
	
	PrimaryWeapons(0)=class'RSGame.RSWeap_M1928_SMG'
	PrimaryWeapons(1)=class'WFGame.WFWeap_SMLE_Rifle'
	
	PrimaryWeapons(2)=class'WFGame.WFWeap_MP40_SMG'
	PrimaryWeapons(3)=class'WFGame.WFWeap_Kar98_Rifle'
	NumPrimaryVeteranEnemyWeapons=2
	
	SecondaryWeapons(0)=class'WFGame.WFWeap_BHP35_Pistol'
	
	SecondaryWeapons(1)=class'WFGame.WFWeap_P38_Pistol'
	NumSecondaryFrontlineEnemyWeapons=1
	
	OtherItems(0)=class'WFGame.WFWeap_Mills_Grenade'
	OtherItems(1)=class'RSGame.RSWeap_M8_SmokeSL'
	OtherItems(2)=class'RSGame.RSItem_Binoculars'
	
	bIsSquadLeader=true
}
