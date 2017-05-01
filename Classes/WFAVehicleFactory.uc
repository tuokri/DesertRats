//=============================================================================
// WFAVehicleFactory.uc
//=============================================================================
// Base class for vehicle factories.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAVehicleFactory extends ROTransportVehicleFactory
	abstract;

defaultproperties
{
	Components.Remove(Sprite)
	
	Begin Object Name=CollisionCylinder
		CollisionHeight=+60.0
		CollisionRadius=+260.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object
	
	DrawScale=1.0
}
