class DRVehicleFactory_ShermanIII extends DRVehicleFactory;

DefaultProperties
{
    Begin Object Name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'DR_VH_UK_M4A1Sherman.Mesh.sherman_rig'
    End Object

    Begin Object Name=CollisionCylinder
        CollisionHeight=+60.0
        CollisionRadius=+90.0
        Translation=(X=0.0,Y=0.0,Z=10.0)
        bAlwaysRenderIfSelected=true
    End Object

    VehicleClass=class'DRVehicle_ShermanIII_Content'
}
