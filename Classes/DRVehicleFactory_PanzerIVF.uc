class DRVehicleFactory_PanzerIVF extends DRVehicleFactory;

event SpawnVehicle()
{
	`dr("Spawning PZIVF...");
	super.SpawnVehicle();
	`dr("Spawned PZIVF");
}

DefaultProperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'DR_VH_DAK_PanzerIV_F.Mesh.PZIV'
	End Object
	
	Begin Object Name=CollisionCylinder
		CollisionHeight=+60.0
		CollisionRadius=+90.0
		Translation=(X=0.0,Y=0.0,Z=10.0)
		bAlwaysRenderIfSelected=true
	End Object
	
	VehicleClass=class'DRVehicle_PanzerIVF_Content'
}
