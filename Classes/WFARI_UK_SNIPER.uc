//=============================================================================
// WFARI_UK_SNIPER.uc
//=============================================================================
// British Sniper Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_UK_SNIPER extends WFARI_UK;

defaultproperties
{
	RoleType=RORIT_Marksman
	ClassTier=3
	ClassIndex=`RI_SNIPER
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_SMLE_Scoped_Rifle'
	
	PrimaryWeapons(1)=class'WFGame.WFWeap_Kar98Scoped_Rifle'
	NumPrimaryVeteranEnemyWeapons=1
	
	SecondaryWeapons(0)=class'WFGame.WFWeap_BHP35_Pistol'
	
	SecondaryWeapons(1)=class'WFGame.WFWeap_P38_Pistol'
	NumSecondaryFrontlineEnemyWeapons=1
	
	bIsMarksman=true
}
