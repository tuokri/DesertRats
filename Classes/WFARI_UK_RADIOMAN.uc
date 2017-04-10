//=============================================================================
// WFARI_UK_RADIOMAN.uc
//=============================================================================
// British Radio Operator Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_UK_RADIOMAN extends WFARI_UK;

defaultproperties
{
	RoleType=RORIT_Rifleman
	ClassTier=4
	ClassIndex=`RI_RADIOMAN
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_SMLE_Rifle'
	
	PrimaryWeapons(2)=class'WFGame.WFWeap_Kar98_Rifle'
	NumPrimaryVeteranEnemyWeapons=1
}
