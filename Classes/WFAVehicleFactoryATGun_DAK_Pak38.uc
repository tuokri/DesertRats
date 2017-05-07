//=============================================================================
// WFAVehicleFactoryATGun_DAK_Pak38.uc
//=============================================================================
// 5 cm Pak 38 Anti-Tank Gun (Content) (Factory)
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAVehicleFactoryATGun_DAK_Pak38 extends WFAVehicleFactoryATGun;

defaultproperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_Ger_Panzer_IIIM.Mesh.Ger_PZIII_Rig_Master'
		Materials(0)=MaterialInstanceConstant'VH_Ger_Panzer_IIIM.Materials.VH_Ger_Panzer_IIIM_Winter_Mic'
		Materials(1)=Material'Vehicle_Mats.VH_Ger_Panzer_IIIM.Ger_Panzer_IIIM_Winter_LTread'
		Materials(2)=Material'Vehicle_Mats.VH_Ger_Panzer_IIIM.Ger_Panzer_IIIM_Winter_RTread'
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object
	
	VehicleClass=class'WFAVehicleATGun_Pak38_Content'
}
