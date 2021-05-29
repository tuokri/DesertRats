class DRTurret_Vickers_HMG extends ROTurret
    placeable;

/** Limit, in rotator units, of how far from center the turret can rotate down while ducking */
var() float DuckedAimPitchMin;

/** @See Pawn::FaceRotation */
simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
    Super.FaceRotation(NewRotation, DeltaTime);
    LimitDesiredPitch(DesiredAimDir);
}

simulated function bool LimitDesiredPitch(out rotator out_DesiredAim)
{
    local int   DeltaFromCenter;

    // use normal limits when not ducking
    if ( !bIsDriverDucking )
    {
        return false;
    }

    // limit pitch
    DeltaFromCenter = NormalizeRotAxis(out_DesiredAim.Pitch - Rotation.Pitch);
    if ( DeltaFromCenter < DuckedAimPitchMin )
    {
        //out_DesiredAim.Pitch = DuckedAimPitchMin;
    }

    return true;
}

/**
 * The maxim needs to use the socket here, because the AimDir SkelControls are
 * uneven and won't convert 1:1.  (The maxim actually Rolls with Yaw)
 */
simulated function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
    local vector MuzzleLoc;
    local rotator MuzzleRot;
    local vector RealAimPoint, DesiredAimPoint, DirA, DirB;
    local float DiffAngle;
    local Quat Q;
    local ROWeapon ROWeap;

    Mesh.GetSocketWorldLocationAndRotation(MuzzleFlashSocket, MuzzleLoc, MuzzleRot);

    ROWeap = ROWeapon(W);

    // Make the aim go to the center of the crosshair when not using iron sights
    // and the weapon is using casual weapon functionality
    if( ROWeap != none && true && !ROWeap.bUsingSights
         && ROPlayerController(Controller) != none )
    {
        DesiredAimPoint = ROPlayerController(Controller).GetFixedMGAimPoint(W.GetTraceRange());

        RealAimPoint = MuzzleLoc + Vector(MuzzleRot) * W.GetTraceRange();
        DirA = normal(DesiredAimPoint - MuzzleLoc);
        DirB = normal(RealAimPoint - MuzzleLoc);
        DiffAngle = ( DirA dot DirB );
        if ( DiffAngle >= MaxFinalAimAdjustment )
        {
            // no adjustment
            return rotator(DesiredAimPoint - MuzzleLoc);
        }
        else
        {
            Q = QuatFromAxisAndAngle(Normal(DirB cross DirA), ACos(MaxFinalAimAdjustment));
            return Rotator( QuatRotateVector(Q,DirB));
        }
    }

    return MuzzleRot;
}

DefaultProperties
{
    OwningTeam=`ALLIES_TEAM_INDEX

    bHasYawLimit=True

    // limits
    DuckedAimPitchMin=-1820

    // sights
    WeaponFireCorrection=()

    Begin Object Name=WeaponSkeletalMeshComponent
        SkeletalMesh=SkeletalMesh'DR_WP_UK_Vickers_HMG.Mesh.Vickers_3rd_Master'
        AnimTreeTemplate=AnimTree'DR_WP_UK_Vickers_HMG.Anim.VickersTurretAnimtree_3rd'
        AnimSets(0)=AnimSet'DR_WP_UK_Vickers_HMG.Anim.Vickers_3rd_anim'
    End Object

    Begin Object Name=CollisionCylinder
        CollisionHeight=16.000000
        CollisionRadius=10.000000 //15 // Adjusting this makes the Use area larger, but also blocks pawns from getting close to it(tough balance)
    End Object

    DefaultInventoryContentClass(0)="DesertRats.DRWeap_Vickers_HMG_Content"

    RootBoneName=ROOTBONE
    PivotBoneName=Maxim_Traverse
    AttachSocketName=AttachSocket
    PlayerRefSocketName=PlayerRef
    CameraSocketName=PlayerCam
    CamPivotSocketName=PlayerCamPivot
    IronSightsCameraSocketName=PlayerCamIS
    IronSightsCamPivotSocketName=PlayerCamPivotIS
    DuckedCameraSocketName=PlayerCamDuck
    LeftHandBoneHandleName=LeftHand
    RightHandBoneHandleName=RightHand
    ChestIKSocketName=ChestIKStand
    DuckedChestSocketName=ChestIKDuck
    MuzzleFlashSocket=MuzzleFlashSocket

    // Player animations
    MoveToAnim=Maxim_goto
    DismountAnim=Maxim_getoff
    StandingAnim=Maxim_Idle
    DuckingAnim=Maxim_Duck_Idle
}
