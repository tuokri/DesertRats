class DRAerialReconPlane extends ROAerialReconPlane
    abstract;

DefaultProperties
{
    Begin Object Class=AnimNodeSequence Name=AnimNodeSeq0
    bCauseActorAnimEnd=true
    End Object

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bIsVehicleLightEnvironment=true
        bSynthesizeSHLight=true
    End Object
    Components.Add(MyLightEnvironment)

    Begin Object Class=SkeletalMeshComponent Name=PlaneMesh
        SkeletalMesh=SkeletalMesh'VH_VN_US_Recon.Mesh.us_aircraft_recon_birdDog'
        PhysicsAsset=PhysicsAsset'VH_VN_US_Recon.Phy.O1BirdDog_Physics'
        AnimSets[0]=AnimSet'VH_VN_US_Recon.Animation.O1BirdDog_anim'
        // Materials[0]=MaterialInstanceConstant'VH_VN_US_Recon.Materials.M_VN_BirdDogUSAF'
        // Materials[1]=Material'VH_VN_US_Recon.Materials.M_BirdDog_Glass'
        Animations=AnimNodeSeq0
        RBChannel=RBCC_Vehicle
        RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE,Vehicle=TRUE,Untitled1=TRUE,Untitled4=TRUE)
        BlockActors=true
        BlockZeroExtent=true
        BlockRigidBody=true
        BlockNonzeroExtent=true
        CollideActors=true
        bForceDiscardRootMotion=true
        bUseSingleBodyPhysics=1
        bNotifyRigidBodyCollision=true
        ScriptRigidBodyCollisionThreshold=10.0
        LightEnvironment=MyLightEnvironment
    End Object
    CollisionComponent=PlaneMesh
    Mesh=PlaneMesh
    Components.Add(PlaneMesh)
}
