class DRVehicleFactory_SdKfz_222_Recon extends DRVehicleFactory;

DefaultProperties
{
    Begin Object Name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'DR_VH_DAK_SDKFZ222.Mesh.SdKfz222_PHAT_Ref'
    End Object

    Begin Object Name=CollisionCylinder
        CollisionHeight=+60.0
        CollisionRadius=+90.0
        Translation=(X=0.0,Y=0.0,Z=60)
        bAlwaysRenderIfSelected=true
    End Object

    VehicleClass=class'DRVehicle_SdKfz_222_Recon_Content'
}
