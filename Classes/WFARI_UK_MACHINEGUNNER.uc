//=============================================================================
// WFARI_UK_MACHINEGUNNER.uc
//=============================================================================
// British Machine Gunner Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_UK_MACHINEGUNNER extends WFARI_UK;

defaultproperties
{
	RoleType=RORIT_MachineGunner
	ClassTier=2
	ClassIndex=`RI_MACHINEGUN
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_Bren_LMG'
	
	bAllowPistolsInRealism=true
}
