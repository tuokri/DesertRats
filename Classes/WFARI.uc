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

function PreLoadContentSingle(class<Pawn> PawnIn)
{
	local int InvIndex, InvLevelIndex;
	local class<ROWeapon> InvType, WeaponClass;
	
	AddSharedContentRef(PawnIn);
	
	for (InvIndex = 0; InvIndex < PrimaryWeapons.length; InvIndex++)
	{
		InvType = PrimaryWeapons[InvIndex];
		
		for (InvLevelIndex = 0; InvLevelIndex < InvType.default.WeaponContentClass.Length; InvLevelIndex++)
		{
			WeaponClass = class<ROWeapon>(DynamicLoadObject(InvType.default.WeaponContentClass[InvLevelIndex], class'Class'));
			
			AddSharedContentRef(WeaponClass);
		}
	}
	
	for (InvIndex = 0; InvIndex < SecondaryWeapons.length; InvIndex++)
	{
		InvType = SecondaryWeapons[InvIndex];
		
		for (InvLevelIndex = 0; InvLevelIndex < InvType.default.WeaponContentClass.Length; InvLevelIndex++)
		{
			WeaponClass = class<ROWeapon>(DynamicLoadObject(InvType.default.WeaponContentClass[InvLevelIndex], class'Class'));
			
			AddSharedContentRef(WeaponClass);
		}
	}
	
	for (InvIndex = 0; InvIndex < OtherItems.length; InvIndex++)
	{
		InvType = OtherItems[InvIndex];
		
		for (InvLevelIndex = 0; InvLevelIndex < InvType.default.WeaponContentClass.Length; InvLevelIndex++)
		{
			WeaponClass = class<ROWeapon>(DynamicLoadObject(InvType.default.WeaponContentClass[InvLevelIndex], class'Class'));
			
			AddSharedContentRef(WeaponClass);
		}
	}
}

DefaultProperties
{
	bAllowPistolsInRealism=false
	
	NumPrimaryUnlimitedWeapons=0
	
	bBotSelectable=true
}
