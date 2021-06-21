class DRVehicleFactory_UC_Bren extends DRVehicleFactory;

DefaultProperties
{
    Begin Object Name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'DR_VH_UK_UC.Mesh.UC_Rig'
    End Object

    Begin Object Name=CollisionCylinder
        CollisionHeight=+60.0
        CollisionRadius=+90.0
        Translation=(X=0.0,Y=0.0,Z=10.0)
        bAlwaysRenderIfSelected=true
    End Object

    VehicleClass=class'DRVehicle_UC_Bren_Content'
}
