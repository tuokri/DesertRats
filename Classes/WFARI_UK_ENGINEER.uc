//=============================================================================
// WFARI_UK_ENGINEER.uc
//=============================================================================
// British Engineer Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_UK_ENGINEER extends WFARI_UK;

defaultproperties
{
	RoleType=RORIT_Engineer
	ClassTier=3
	ClassIndex=`RI_ENGINEER
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_SMLE_Rifle'
	PrimaryWeapons(1)=class'RSGame.RSWeap_M1928_SMG'
	
	PrimaryWeapons(2)=class'WFGame.WFWeap_Kar98_Rifle'
	PrimaryWeapons(3)=class'WFGame.WFWeap_MP40_SMG'
	NumPrimaryVeteranEnemyWeapons=2
	
	OtherItems(0)=class'RSGame.RSWeap_M37_SatchelCharge'
	
	bCanCompleteMiniObjectives=true
}
