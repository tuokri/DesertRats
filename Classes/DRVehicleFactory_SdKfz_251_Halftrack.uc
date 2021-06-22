class DRVehicleFactory_SdKfz_251_Halftrack extends DRVehicleFactory;

DefaultProperties
{
    Begin Object Name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'DR_VH_DAK_SdKfz.Mesh.Ger_SdkFz_Rig_Master'
    End Object

    Begin Object Name=CollisionCylinder
        CollisionHeight=+60.0
        CollisionRadius=+90.0
        Translation=(X=0.0,Y=0.0,Z=10.0)
        bAlwaysRenderIfSelected=true
    End Object

    VehicleClass=class'DRVehicle_SdKfz_251_Halftrack_Content'
}
