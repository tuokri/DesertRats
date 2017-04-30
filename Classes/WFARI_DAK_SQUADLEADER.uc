//=============================================================================
// WFARI_DAK_SQUADLEADER.uc
//=============================================================================
// German Squad Leader Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_DAK_SQUADLEADER extends WFARI_DAK;

defaultproperties
{
	RoleType=RORIT_SquadLeader
	ClassTier=3
	ClassIndex=`RI_SQUADLEADER
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_MP40_SMG'
	PrimaryWeapons(1)=class'WFGame.WFWeap_Kar98_Rifle'
	
	bAllowPistolsInRealism=true
	
	OtherItems(0)=class'WFGame.WFWeap_M1939_Grenade'
	OtherItems(1)=class'WFGame.WFWeap_NG39_GrenadeSL'
	OtherItems(2)=class'WFGame.WFItem_Binoculars'
	
	bIsSquadLeader=true
}
