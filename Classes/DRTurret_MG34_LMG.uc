class DRTurret_MG34_LMG extends ROTurret
    placeable;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    EntryActor.SetRelativeLocation( vect(-25, 0, 9) );
}

defaultproperties
{
    OwningTeam=`AXIS_TEAM_INDEX
    bHasYawLimit = True
    // limits
    YawLimit=(X=-4096,Y=4096)
    PitchLimit=(X=-1024,Y=1966)

    // sights
    WeaponFireCorrection=(Pitch=-155)

    Begin Object Name=WeaponSkeletalMeshComponent
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_MG34_Tripod.Mesh.Ger_MG34_Tripod'
        AnimTreeTemplate=AnimTree'DR_WP_DAK_MG34_Tripod.Animation.MG34TurretAnimtree'
        AnimSets(0)=AnimSet'DR_WP_DAK_MG34_Tripod.Anim.Tripod_3rd_anim'
    End Object

    Begin Object Name=CollisionCylinder
        CollisionHeight=16.000000
        CollisionRadius=15.000000 // Adjusting this makes the Use area larger, but also blocks pawns from getting close to it(tough balance)
    End Object

    DefaultInventoryContentClass(0)="DesertRats.DRWeap_MG34_Tripod_Content"

    RootBoneName=ROOTBONE
    PivotBoneName=Tripod_Brace_Yaw
    AttachSocketName=AttachSocket
    PlayerRefSocketName=PlayerRef
    CameraSocketName=PlayerCam
    CamPivotSocketName=PlayerCamPivot
    IronSightsCameraSocketName=PlayerCamIS
    IronSightsCamPivotSocketName=PlayerCamPivotIS
    DuckedCameraSocketName=PlayerCamDuck
    LeftHandBoneHandleName=LefthandHand01
    RightHandBoneHandleName=RightHand
    ChestIKSocketName=ChestIKStand
    DuckedChestSocketName=ChestIKDuck
    MuzzleFlashSocket=MuzzleFlashSocket

    // Player animations
    MoveToAnim=Tripod_goto_MG34
    DismountAnim=Tripod_getoff_MG34
    StandingAnim=Tripod_idle_MG34
    DuckingAnim=Tripod_Duck_Idle_MG34
}
