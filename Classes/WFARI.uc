//=============================================================================
// WFARI.uc
//=============================================================================
// Global attributes shared by all Role Info classes.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFARI extends WFRoleInfo
	// seperate config as placeholder, will work out integration when officially approved
	config(Game_WFA)
	abstract;

DefaultProperties
{
	bAllowPistolsInRealism=false
	
	NumPrimaryUnlimitedWeapons=0
	
	bBotSelectable=true
}
