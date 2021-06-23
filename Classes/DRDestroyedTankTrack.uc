// TODO: this is a development asset. (Maybe use the vehicle gib system).

class DRDestroyedTankTrack extends Actor;

var() StaticMeshComponent Mesh;

DefaultProperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bIsVehicleLightEnvironment=true
        bSynthesizeSHLight=true
    End Object
    Components.Add(MyLightEnvironment)

    Begin Object Class=StaticMeshComponent Name=TrackMesh
        StaticMesh=StaticMesh'ENV_VN_Tunnels.Destruction.destr_wood4'
        Materials[0]=MaterialInstanceConstant'VH_VN_M113.Materials.M_M113_Tracks'
        RBChannel=RBCC_Vehicle
        BlockActors=false
        BlockZeroExtent=false
        BlockRigidBody=false
        BlockNonzeroExtent=false
        CollideActors=false
        bNotifyRigidBodyCollision=false
        ScriptRigidBodyCollisionThreshold=10.0
        LightEnvironment=MyLightEnvironment
        Scale=5
    End Object
    Mesh=TrackMesh
    Components.Add(TrackMesh)

    RemoteRole=ROLE_SimulatedProxy

    bCollideWorld=true
    bCollideActors=false
    bNetTemporary=true
    bGameRelevant=true
    LifeSpan=60
}
