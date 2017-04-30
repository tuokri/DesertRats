//=============================================================================
// WFARI_DAK_MACHINEGUNNER.uc
//=============================================================================
// German Machine Gunner Role Info.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI_DAK_MACHINEGUNNER extends WFARI_DAK;

defaultproperties
{
	RoleType=RORIT_MachineGunner
	ClassTier=2
	ClassIndex=`RI_MACHINEGUN
	
	PrimaryWeapons(0)=class'WFGame.WFWeap_MG34_LMG'
	
	bAllowPistolsInRealism=true
}
