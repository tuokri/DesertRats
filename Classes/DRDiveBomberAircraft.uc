// TODO: calculate trajectory on server but replicate pre-calculated values to clients?

class DRDiveBomberAircraft extends RONapalmStrikeAircraftARVN;

enum EDiveBomberDiveState
{
    EDBDS_None,
    EDBDS_Diving,
    EDBDS_Ascending,
    EDBDS_EnteringDive,
    EDBDS_ExitingDive,
    EDBDS_RollingIn,
};

var EDiveBomberDiveState DivingState;

var float AccelPerSecondEnter;
var float AccelPerSecondExit;
var float CurveRadiusEnterDive;
var float CurveRadiusExitDive;
var float AngleOfDiveFromZAxis;
var float DistDive;
var float AccelPerSecondDive;

var int Altitude;
var int PitchUnitsPerSecondEnter;
var int PitchUnitsPerSecondExit;
var int RollUnitsPerSecond;
var int AngleOfRoll;
var int AngleOfDive;
var int DiveAngleInURT;
var int RollAngleInURT;
var int AscensionAngleInURT;
var int DiveSpeed;
var int PayloadDropHeight;

var bool bAccelerating;

var vector CurveCenterEnterDive;

var AudioComponent AmbientComponentCustom;
var SoundCue AmbientSoundCustom;

var vector DebugLastPointLocation;


simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetTimer(InboundDelay + 5, False, 'PlayAmbientAudio');
    DrawDebugPoint(Location, 2, MakeLinearColor(255.0, 0.0, 0.0, 0.5), True);
    DebugLastPointLocation = Location;
}

simulated function Destroyed()
{
    if (AmbientSoundCustom != None)
    {
        if (AmbientComponentCustom != None)
        {
            AmbientComponentCustom.Stop();
            AmbientComponentCustom.SoundCue = None;
        }
    }

    DivingState = EDBDS_None;
    ClearTimer('Roll');
    ClearTimer('StartEnterDive');
    ClearTimer('DropPayload');
    ClearTimer('StartExitDive');
    ClearTimer('StopAccelerating');
    ClearTimer('StartExitFlight');
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (DebugLastPointLocation != Location)
    {
        DrawDebugPoint(Location, 2, MakeLinearColor(255.0, 0.0, 0.0, 0.5), True);
        DebugLastPointLocation = Location;
    }

    // DrawDebugCoordinateSystem(Location, Rotation, 5000);

    if (Role == ROLE_Authority)
    {
        switch (DivingState)
        {
            case EDBDS_RollingIn:
                HandleRollUpdate(DeltaTime);
                break;
            case EDBDS_EnteringDive:
                HandleEnteringDiveUpdate(DeltaTime);
                break;
            case EDBDS_Diving:
                HandleDivingUpdate(DeltaTime);
                break;
            case EDBDS_ExitingDive:
                HandleExitingDiveUpdate(DeltaTime);
                break;
            case EDBDS_Ascending:
                HandleAscendingUpdate(DeltaTime);
                break;
            default:
                break;
        }
    }
}

simulated function PlayAmbientAudio()
{
    if (AmbientSoundCustom != None)
    {
        if (AmbientComponentCustom != None)
        {
            AmbientComponentCustom.SoundCue = AmbientSoundCustom;
            AmbientComponentCustom.FadeIn(0.5, 1.0 );
            AmbientComponentCustom.OcclusionCheckInterval = 0.1;
        }
    }
}

function StartEnterDive()
{
    `log("StartEnterDive()");
    DivingState = EDBDS_EnteringDive;
}

function StartExitDive()
{
    `log("StartExitDive()");
    DivingState = EDBDS_ExitingDive;
}

function Dive()
{
    `log("Dive()");
    DivingState = EDBDS_Diving;
    bAccelerating = True;
}

function StopAccelerating()
{
    `log("StopAccelerating()");
    bAccelerating = False;
}

function Roll()
{
    `log("Roll()");
    DivingState = EDBDS_RollingIn;
}

function StartExitFlight()
{
    `log("StartExitFlight()");
    DivingState = EDBDS_None;
}

// Solve trajectory geometry with given height,
// dive angle and payload drop height.
// https://www.geogebra.org/m/ys53zuap
function CalculateTrajectory()
{
    local DRTeamInfo DRTI;

    local vector TargetLocElevated;
    local vector StrikeDir3D;

    local float RollDuration;
    local float PitchArcLengthEnter;
    local float PitchArcAngleInRadEnter;
    local float PitchArcTravelTimeEnter;
    local float PitchArcLengthExit;
    local float PitchArcAngleInRadExit;
    local float PitchArcTravelTimeExit;
    local float Height;
    local float ExitCurveCenterHeight;

    // Helper constants.
    local float SinAODFZA;
    local float TanAODFZA;

    // Flight distances in UU.
    local float DistMaxDiveSpeed;
    local float DistToTarget;
    local float DistPitchBeginOffset;

    // Flight times in seconds.
    local float TimeTillDrop;
    local float TimeTillMaxSpeed;
    local float TimeTillTarget;
    local float TimeTillStopAccel;
    local float TimeTillExitFlight;
    local float TimeDiving;
    local float TimeTillBeginRoll;

    // Angles in radians.
    local float Beta;
    local float Eta;
    local float Xi;
    local float Lambda;
    local float Psi;
    local float Phi;
    local float AngleOfAscension;
    local float Theta;
    local float Rho;

    // Line lengths in UU.
    local float Line_FD;
    local float Line_DH;
    local float Line_CH;
    local float Line_CD;
    local float Line_HE_1;

    AngleOfDiveFromZAxis = 270 - AngleOfDive;
    `log("AngleOfDiveFromZAxis = " $ AngleOfDiveFromZAxis);

    SinAODFZA = Sin(AngleOfDiveFromZAxis * DegToRad);
    TanAODFZA = Tan(AngleOfDiveFromZAxis * DegToRad);

    DiveAngleInURT = AngleOfDive * DegToUnrRot;
    RollAngleInURT = AngleOfRoll * DegToUnrRot;

    TargetLocElevated = TargetLocation;
    TargetLocElevated.Z = Location.Z;

    `log("Location = " $ Location);
    `log("TargetLocation = " $ TargetLocation);
    `log("TargetLocElevated = " $ TargetLocElevated);

    DistToTarget = VSize(TargetLocElevated - Location);
    `log("DistToTarget = " $ DistToTarget);

    TimeTillTarget = InboundDelay + (DistToTarget / Speed);
    `log("TimeTillTarget = " $ TimeTillTarget);

    // Arbitrary duration. Larger divisor means faster rolling.
    RollDuration = (TimeTillTarget / 15);
    TimeTillBeginRoll = TimeTillTarget - (RollDuration * 1.05); // 1.05 "safety margin".
    `log("TimeTillBeginRoll = " $ TimeTillBeginRoll);

    Height = Location.Z - TargetLocation.Z;
    `log("Height = " $ Height);

    DistPitchBeginOffset = Height * TanAODFZA;
    `log("DistPitchBeginOffset = " $ DistPitchBeginOffset);

    RollUnitsPerSecond = RollAngleInURT / RollDuration;
    `log("RollUnitsPerSecond = " $ RollUnitsPerSecond);

    CurveRadiusEnterDive = Tan(DegToRad * ((90 - AngleOfDiveFromZAxis) * 0.5)) * DistPitchBeginOffset;
    AccelPerSecondEnter = Square(Speed) / CurveRadiusEnterDive;

    `log("CurveRadiusEnterDive = " $ CurveRadiusEnterDive);
    `log("AccelPerSecondEnter = " $ AccelPerSecondEnter);

    if(WorldEdgeExitBuffer < CurveRadiusEnterDive)
    {
        `log("Extending world edge limits (CurveRadiusEnterDive)");
        SetWorldEdgeLimits(CurveRadiusEnterDive + 25);
    }

    PitchArcAngleInRadEnter = 2 * Atan(DistPitchBeginOffset / CurveRadiusEnterDive);
    PitchArcLengthEnter = PitchArcAngleInRadEnter * CurveRadiusEnterDive;
    PitchArcTravelTimeEnter = PitchArcLengthEnter / Speed;

    `log("PitchArcAngleInRadEnter = " $ PitchArcAngleInRadEnter);
    `log("PitchArcAngleEnter (deg) = " $ PitchArcAngleInRadEnter * RadToDeg);
    `log("PitchArcLengthEnter = " $ PitchArcLengthEnter);
    `log("PitchArcTravelTimeEnter = " $ PitchArcTravelTimeEnter);

    // Upside-down during the actual dive.
    DiveAngleInURT -= 360 * DegToUnrRot;
    PitchUnitsPerSecondEnter = DiveAngleInURT / PitchArcTravelTimeEnter;
    `log("PitchUnitsPerSecondEnter = " $ PitchUnitsPerSecondEnter);

    CurveCenterEnterDive = TargetLocElevated;
    CurveCenterEnterDive.Z -= CurveRadiusEnterDive;
    DrawDebugSphere(CurveCenterEnterDive, CurveRadiusEnterDive, 64, 0, 255, 0, True);

    Eta = ((90 - AngleOfDiveFromZAxis) * 0.5) * DegToRad;
    // Xi = (90 - AngleOfDiveFromZAxis) * DegToRad;
    Xi = ((360 - (PitchArcAngleInRadEnter * RadToDeg)) * 0.5) * DegToRad;
    Lambda = (90 * DegToRad) - Eta;
    Beta = (90 - AngleOfDiveFromZAxis) * DegToRad;
    Rho = (90 * DegToRad) - Lambda;

    `log("Eta            (deg) = " $ Eta * RadToDeg);
    `log("Xi             (deg) = " $ Xi * RadToDeg);
    `log("Xi_Old         (deg) = " $ (90 - AngleOfDiveFromZAxis) * DegToRad);
    `log("Lambda         (deg) = " $ Lambda * RadToDeg);
    `log("Lambda (check) (deg) = " $ (PitchArcAngleInRadEnter * 0.5) * RadToDeg);
    `log("Beta           (deg) = " $ Beta * RadToDeg);
    `log("Rho            (deg) = " $ Rho * RadToDeg);

    // Check calculations.
    `log("PitchArcAngleEnter (check) (deg) = " $ 2 * Lambda * RadToDeg);

    Line_FD = CurveRadiusEnterDive / Tan(Eta);
    Line_CH = PayloadDropHeight / Sin(Beta);
    Line_HE_1 = TanAODFZA * Line_CH;
    Line_CD = (Line_CH / Line_HE_1) * CurveRadiusEnterDive;
    Line_DH = Line_CD - Line_CH;
    DistDive = Line_DH;

    `log("Line_FD   = " $ Line_FD);
    `log("Line_CH   = " $ Line_CH);
    `log("Line_HE_1 = " $ Line_HE_1);
    `log("Line_CD   = " $ Line_CD);
    `log("Line_DH   = " $ Line_DH);

    CurveRadiusExitDive = (Line_DH + Line_FD) / (Line_FD / CurveRadiusEnterDive);
    `log("CurveRadiusExitDive = " $ CurveRadiusExitDive);

    /*
    Line_ZC = TanAODFZA * PayloadDropHeight;
    Line_HE = (Line_HC * Sin(Xi)) * SinAODFZA;
    DistDive = ((CurveRadiusEnterDive / Line_HE) * Line_HC) - Line_HC;
    Line_EC = Line_HE / SinAODFZA;
    Line_BE = ((CurveRadiusEnterDive / Line_HE) * Line_EC) - Line_EC;
    Line_HX = SinAODFZA * Line_HC;
    Line_HK = TanAODFZA * Line_HC;

    `log("Line_ZC  = " $ Line_ZC);
    `log("Line_HE  = " $ Line_HE);
    `log("DistDive = " $ DistDive);
    `log("Line_EC  = " $ Line_EC);
    `log("Line_BE  = " $ Line_BE);
    `log("Line_HX  = " $ Line_HX);
    `log("Line_HK  = " $ Line_HK);
    */

    /*

    `log("Psi   (deg) = " $ Psi * RadToDeg);

    CurveRadiusExitDive = Line_BE + Line_HE;
    `log("CurveRadiusExitDive = " $ CurveRadiusExitDive);
    */

    AccelPerSecondExit = Square(DiveSpeed) / CurveRadiusExitDive;
    `log("AccelPerSecondExit = " $ AccelPerSecondExit);

    PitchArcAngleInRadExit = Xi - (Lambda / 2);
    Theta = ((180 * DegToRad) - PitchArcAngleInRadExit) * 0.5;

    `log("Theta (deg) = " $ Theta * RadToDeg);

    if(WorldEdgeExitBuffer < CurveRadiusExitDive)
    {
        `log("Extending world edge limits (CurveRadiusExitDive)");
        SetWorldEdgeLimits(CurveRadiusExitDive + 25);
    }

    AngleOfAscension = (90 * DegToRad) - (2 * Theta);
    AscensionAngleInURT = AngleOfAscension * RadToUnrRot;

    `log("AngleOfAscension (deg) = " $ AngleOfAscension * RadToDeg);

    // PitchArcAngleInRadExit = (180 * DegToRad) - (2 * Theta);
    PitchArcLengthExit = PitchArcAngleInRadExit * CurveRadiusExitDive;
    PitchArcTravelTimeExit = PitchArcLengthExit / DiveSpeed;

    // Upside-down during actual dive.
    AscensionAngleInURT = (-180 * DegToUnrRot) - (AngleOfAscension * RadToUnrRot);
    `log("AscensionAngleInURT (deg) (actual) = " $ AscensionAngleInURT * UnrRotToDeg);
    PitchUnitsPerSecondExit = AscensionAngleInURT / PitchArcTravelTimeExit;
    `log("PitchUnitsPerSecondExit = " $ PitchUnitsPerSecondExit);

    // 3000 UU / 5 s^2 (arbitrary value chosen for now).
    AccelPerSecondDive = Abs(PhysicsVolume.GetGravityZ()) * Sin(AngleOfDiveFromZAxis * DegToRad) + (3000 / 5);
    `log("AccelPerSecondDive = " $ AccelPerSecondDive);

    TimeTillMaxSpeed = (DiveSpeed - Speed) / AccelPerSecondDive;
    DistMaxDiveSpeed = (Speed * TimeTillMaxSpeed) + (0.5 * AccelPerSecondDive * Square(TimeTillMaxSpeed));
    TimeDiving = TimeTillMaxSpeed + ((DistDive - DistMaxDiveSpeed) / DiveSpeed);
    TimeTillDrop = TimeTillTarget + PitchArcTravelTimeEnter + TimeDiving;

    `log("PitchArcAngleInRadExit = " $ PitchArcAngleInRadExit);
    `log("PitchArcAngleExit (deg) = " $ PitchArcAngleInRadExit * RadToDeg);
    `log("PitchArcLengthExit = " $ PitchArcLengthExit);
    `log("PitchArcTravelTimeExit = " $ PitchArcTravelTimeExit);

    `log("DistMaxDiveSpeed = " $ DistMaxDiveSpeed);
    `log("DistDive = " $ DistDive);
    `log("TimeDiving = " $ TimeDiving);
    `log("TimeTillDrop = " $ TimeTillDrop);
    `log("TimeTillMaxSpeed = " $ TimeTillMaxSpeed);

    DRTI = DRTeamInfo(WorldInfo.GRI.Teams[TeamIndex]);
    // StrikeDir3D = Normal(Location - TargetLocElevated);
    StrikeDir3D.X = DRTI.StrikeDirection.X;
    StrikeDir3D.Y = DRTI.StrikeDirection.Y;

    // ExitCurveCenterHeight = (Line_RA / Sin(AngleOfAscension + Theta)) * Sin(AngleOfAscension + Theta);
    // CurveCenterExitDive = Normal(TargetLocation - (StrikeDir3D * Line_RA));
    // CurveCenterExitDive.Z = ExitCurveCenterHeight;
    // CurveCenterExitDive = CurveCenterEnterDive;

    /*
    StrikeDir3D.Z = ExitCurveCenterHeight;
    DrawDebugLine(Location, StrikeDir3D, 0, 255, 0, True);
    `log("StrikeDir3D = " $ StrikeDir3D);

    DrawDebugSphere(CurveCenterExitDive, CurveRadiusExitDive, 64, 255, 35, 0, True);

    `log("CurveCenterEnterDive = " $ CurveCenterEnterDive);
    `log("CurveCenterExitDive = " $ CurveCenterExitDive);
    */

    TimeTillStopAccel = TimeTillTarget + PitchArcTravelTimeEnter + TimeTillMaxSpeed;
    `log("TimeTillStopAccel = " $ TimeTillStopAccel);

    TimeTillExitFlight = TimeTillStopAccel + PitchArcTravelTimeExit;
    `log("TimeTillExitFlight = " $ TimeTillExitFlight);

    SetTimer(TimeTillBeginRoll, False, 'Roll');
    SetTimer(TimeTillTarget, False, 'StartEnterDive');
    SetTimer(TimeTillDrop, False, 'DropPayload');
    SetTimer(TimeTillDrop, False, 'StartExitDive');
    SetTimer(TimeTillStopAccel, False, 'StopAccelerating');
    SetTimer(TimeTillExitFlight, False, 'StartExitFlight');
}

// Using basic physics, work out where each payload needs to be released in order to hit the target.
// Then use a timer to spawn the payload, as it's far less intensive than distance checks every tick, and less prone to error
function SetDropPoint()
{
    local float FallDist;
    // local float PreDropDist;
    // local float TimeTillDrop;
    // local float ImpactVelPct;

    // TODO: We will actually be dropping the payload later.
    FallDist = PayloadDropHeight;
    `log("FallDist = " $ FallDist);

    if( FallDist < 0 )
    {
        `warn("Napalm target is higher than the aircraft's spawn location! Aborting strike.");
        return;
    }

    /*
    if( FallDist > 5000 )
        ImpactVelPct = default.MinImpactVelPct + (default.MaxImpactVelPct - default.MinImpactVelPct) * (1 - FMin(1.0, ((FallDist - 5000) / 5000)));
    else
        ImpactVelPct = default.MaxImpactVelPct;
    */

    FallTime = Sqrt((FallDist * 2) / Abs(PhysicsVolume.GetGravityZ()));
    `log("FallTime = " $ FallTime);

    // Now calculate how early the payload must be dropped in order to hit the target (payload inherits half the aircraft's speed)
    // DropLocationOne = TargetLocation;
    // DropLocationOne.Z = Location.Z;
    // DropLocationTwo = DropLocationOne;
    // PreDropDist = (Speed + Speed * ImpactVelPct) / 2 * FallTime;

    // DropLocationOne += Normal(Location - DropLocationOne) * (PreDropDist + FirstPayloadClass.default.DamageRadius);// * 0.45);
    // DropLocationTwo += Normal(Location - DropLocationTwo) * (PreDropDist);// - FirstPayloadClass.default.DamageRadius * 0.45);

    // Now set a timer to drop the payload at the correct location (the timer is less CPU intensive and less error prone than location checks every tick)
    // TimeTillDrop = VSize(DropLocationOne - Location) / Speed;
    // TimeTweenDrops = (VSize(DropLocationTwo - Location) / Speed) - TimeTillDrop;
    TimeTweenDrops = 1;
    // TimeTillDrop += InboundDelay;
    // SetTimer(TimeTillDrop, false, 'DropPayload');

    //`log("TimeTweenDrops"@TimeTweenDrops);

    // Lastly, set the drop location slightly lower so we don't collide with our own payload
    //DropLocation.Z -= 25;
}

function DropPayload()
{
    local ROBombProjectile SpawnedPayload;
    local vector X, Y, Z, Accel;
    local float FallDist, ImpactVelPct;
    local ROVolumeTest RVT;
    local ROGameReplicationInfo ROGRI;

    if( !bAbortStrike )
    {
        RVT = Spawn(class'ROVolumeTest',self,,TargetLocation);

        // if the place we're targetting has become a NoArtyVolume after the
        // strike was called, cancel the strike.
        if ( RVT != none && RVT.IsInNoArtyVolume() )
        {
            if ( InstigatorController != none )
            {
                InstigatorController.ReceiveLocalizedMessage(class'ROLocalMessageArtillery', 5,,,InstigatorController.Pawn);
            }

            bAbortStrike = true;
        }

        RVT.Destroy();
    }

    // If we're not dropping our payload, only use up the strike if the aircraft wasn't shot down
    if( bAbortStrike )
    {
        if( !bDroppedFirstBomb && !bShotDown )
        {
            ROGRI = ROGameReplicationInfo(WorldInfo.GRI);

            if( ROGRI != none )
            {
                if( InstigatorController != none )
                    ROGRI.NextAbilityThreeTime[GetTeamNum()] = WorldInfo.GRI.RemainingTime - InstigatorController.GetNextAbilityDelay(3) * 0.25;
                ROGRI.TotalStrikes[GetTeamNum()]--;
            }
        }

        return;
    }

    GetAxes(Rotation,X,Y,Z);
    FallDist = PayloadDropHeight;
    `log("FallDist = " $ FallDist);

    if( !bDroppedFirstBomb )
    {
        // First canister
        SpawnedPayload = Spawn(FirstPayloadClass, InstigatorController,, Mesh.GetBoneLocation(NapalmCanisterLeft), rotator(velocity));
        // SpawnedPayload = Spawn(FirstPayloadClass, InstigatorController,, DropLocationOne - Y * DropLocYOffset, rotator(velocity));
    }
    else
    {
        // Second canister
        SpawnedPayload = Spawn(SecondPayloadClass, InstigatorController,, Mesh.GetBoneLocation(NapalmCanisterRight), rotator(velocity));
        // SpawnedPayload = Spawn(FirstPayloadClass, InstigatorController,, DropLocationTwo + Y * DropLocYOffset, rotator(velocity));
    }

    if( SpawnedPayload != none )
    {
        if( FallDist > 5000 )
            ImpactVelPct = default.MinImpactVelPct + (default.MaxImpactVelPct - default.MinImpactVelPct) * (1 - FMin(1.0, ((FallDist - 5000) / 5000)));
        else
            ImpactVelPct = default.MaxImpactVelPct;

        // Set initial velocity and deceleration to ensure we hit the target - this canister will hit just beyond the target
        Accel = (Velocity * ImpactVelPct - Velocity) / FallTime;
        Accel.Z = PhysicsVolume.GetGravityZ();
        //Accel.Z = -490;   // 9.8 m/s^2
        SpawnedPayload.AccelToApply = Accel;    // Replicated variable so that the client can correctly calculate its own change in velocity
        SpawnedPayload.Acceleration = Accel;
        SpawnedPayload.Velocity = Vector(AddSpreadY(rotator(Velocity))) * Speed;
        SpawnedPayload.FallDist = FallDist;
        SpawnedPayload.Lifespan = FallTime + 0.5;   // This should stop situations where a canister gets stuck on something and isn't able to actually impact the ground
        SpawnedPayload.SetExplosionTime(FallTime);
    }

    if( !bDroppedFirstBomb )
    {
        // We've reached the target, so it's now safe to starting checking for despawn
        bCheckMapBounds = true;
        bDroppedFirstBomb = true;

        `log("bCheckMapBounds = True");

        SetTimer(TimeTweenDrops, false, 'DropPayload');

        mesh.HideBoneByName(NapalmCanisterLeft, PBO_None);
    }
    else
    {
        mesh.HideBoneByName(NapalmCanisterRight, PBO_None);
    }
}

function HandleRollUpdate(float DeltaTime)
{
    local rotator NewRot;

    NewRot = Rotation;
    NewRot.Roll += RollUnitsPerSecond * DeltaTime;

    if (Rotation.Roll > RollAngleInURT)
    {
        NewRot.Roll = RollAngleInURT;
        DivingState = EDBDS_None;
        `log("Roll finished");
    }

    SetRotation(NewRot);
}

function HandleExitingDiveUpdate(float DeltaTime)
{
    local rotator NewRot;
    local vector AccelToApply;
    local vector CurveCenterExitDive;

    `log("Rotation.Pitch (deg) = " $ Rotation.Pitch * UnrRotToDeg
        $ " AscensionAngle (deg) = " $ AscensionAngleInURT * UnrRotToDeg);

    NewRot = Rotation;
    NewRot.Pitch += PitchUnitsPerSecondExit * DeltaTime;

    if (Rotation.Pitch < AscensionAngleInURT)
    {
        NewRot.Pitch = AscensionAngleInURT;
        DivingState = EDBDS_None;
        `log("Finished exiting dive");
    }

    SetRotation(NewRot);

    // TODO:
    // CurveRadiusExitDive = Location;

    AccelToApply = AccelPerSecondExit * Normal(CurveCenterExitDive - Location) * DeltaTime;
    Velocity += AccelToApply;
}

function HandleDivingUpdate(float DeltaTime)
{
    local vector AccelToApply;

    if (bAccelerating)
    {
        AccelToApply = AccelPerSecondDive * Normal(TargetLocation - Location) * DeltaTime;
        Velocity += AccelToApply;
        `log("Speed = " $ VSize(Velocity));
    }
}

function HandleEnteringDiveUpdate(float DeltaTime)
{
    local rotator NewRot;
    local vector AccelToApply;

    NewRot = Rotation;
    NewRot.Pitch += PitchUnitsPerSecondEnter * DeltaTime;

    `log("Rotation.Pitch (deg) = " $ Rotation.Pitch * UnrRotToDeg
        $ " DiveAngle (deg) = " $ DiveAngleInURT * UnrRotToDeg);

    if (Rotation.Pitch < DiveAngleInURT)
    {
        NewRot.Pitch = DiveAngleInURT;
        Dive();
        `log("Finished entering dive");
    }

    SetRotation(NewRot);

    // `log("Velocity = " $ Velocity);
    AccelToApply = AccelPerSecondEnter * Normal(CurveCenterEnterDive - Location) * DeltaTime;
    Velocity += AccelToApply;
    // `log("AccelToApply = " $ AccelToApply);
    // `log("AFTER ACCEL:");
    // `log("Velocity = " $ Velocity);

    // DrawDebugLine(Location, AccelToApply, 0, 255, 0, True);
    // DrawDebugLine(Location, Velocity, 0, 0, 255, True);
    // DrawDebugLine(Location, CurveCenterEnterDive, 255, 0, 0, True);
}

function HandleAscendingUpdate(float DeltaTime)
{
    // local rotator NewRot;
    // NewRot = Rotation;
}

DefaultProperties
{
    TeamIndex = `ALLIES_TEAM_INDEX; // TODO: Actually Axis.

    Speed=3756 // 146 knots or 75 m/s.
    DiveSpeed=7156 // 150 m/s (constant dive speed after initial acceleration).
    Altitude=50000 // 50kUU = 1000m.
    PayloadDropHeight=15000 // 15kUU = 300m.

    AngleOfDive=260 // From mesh 0 rotation position.
    AngleOfRoll=180

    DivingState=EDBDS_None

    bCheckMapBounds=False
    bAccelerating=False

    AmbientSound=None
    AmbientComponent=None
    //? AmbientSoundCustom=SoundCue'DR_AUD_Stuka.Stuka_1_Cue'

    Begin Object Class=AudioComponent name=AmbientSoundComponentCustom
        OcclusionCheckInterval=1.0
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
        bAutoPlay=false
    End Object
    AmbientComponentCustom=AmbientSoundComponentCustom
    Components.Add(AmbientSoundComponentCustom)
}
