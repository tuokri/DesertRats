//=============================================================================
// WFAVehicleFactory_UK_Willys_Desert.uc
//=============================================================================
// Willy MB Jeep w Desert Camo (Factory)
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAVehicleFactory_UK_Willys_Desert extends WFAVehicleFactory;

defaultproperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'WF_Vehicles_Jeep.jeep_rig_master'
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object
	
	VehicleClass=class'WFAVehicle_Willys_Desert_Content'
}
