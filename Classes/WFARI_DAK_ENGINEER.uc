//=============================================================================
// WFARI_DAK_ENGINEER.uc
//=============================================================================
// German Engineer Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_DAK_ENGINEER extends WFARI_DAK;

defaultproperties
{
	RoleType=RORIT_Engineer
	ClassTier=3
	ClassIndex=`RI_ENGINEER
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_Kar98_Rifle'
	PrimaryWeapons(1)=class'WFGame.WFWeap_MP40_SMG'
	
	OtherItems(0)=class'WFGame.WFWeaponSatchelGer_3kg'
	
	bCanCompleteMiniObjectives=true
}
