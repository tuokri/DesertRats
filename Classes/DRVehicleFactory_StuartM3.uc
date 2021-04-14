class DRVehicleFactory_StuartM3 extends DRVehicleFactory;

DefaultProperties
{
    Begin Object Name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'DR_VH_UK_M3Stuart.Mesh.StuartM3_Rig'
    End Object

    Begin Object Name=CollisionCylinder
        CollisionHeight=+60.0
        CollisionRadius=+90.0
        Translation=(X=0.0,Y=0.0,Z=10.0)
        bAlwaysRenderIfSelected=true
    End Object

    VehicleClass=class'DRVehicle_StuartM3_Content'
}
