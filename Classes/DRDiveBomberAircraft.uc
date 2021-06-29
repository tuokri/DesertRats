// TODO: Randomize payload drop height, spawn altitude, and diving angle.
class DRDiveBomberAircraft extends RONapalmStrikeAircraftARVN;

enum EDiveBomberDiveState
{
    EDBDS_None,
    EDBDS_Diving,
    EDBDS_Ascending,
    EDBDS_EnteringDive,
    EDBDS_ExitingDive,
    EDBDS_RollingIn,
    EDBDS_RollingOut,
};

var DRAudioComponent DiveSoundComponent;
var DRAudioComponent FlightSoundComponent;

var int Altitude;
var int AngleOfRoll;
var int AngleOfDive;
var int DiveSpeed;
var int PayloadDropHeight;
var int AscensionRollAngle;

var float InterpSpeedAscend;

// TODO: Optimize what needs to be replicated.
// REPLICATED VARS BEGIN //
var EDiveBomberDiveState DivingState;

var int AscensionAngleInURT;
var int PitchUnitsPerSecondEnter;
var int PitchUnitsPerSecondExit;
var int RollUnitsPerSecond;
var int DiveAngleInURT;
var int RollAngleInURT;
var int AscensionRollAngleInURT;
var int YawUnitsPerSecondExit;

var float AccelPerSecondEnter;
var float AccelPerSecondExit;
var float CurveRadiusEnterDive;
var float CurveRadiusExitDive;
var float AngleOfDiveFromZAxis;
var float AccelPerSecondDive;

var bool bAccelerating;
var bool bExitTimerSet;

var vector CurveCenterEnterDive;
var vector CurveCenterExitDive;
// REPLICATED VARS END //

// Debugging.
// var vector DebugLastPointLocation;
// var float Line_CH;
// var float StartTime;

replication
{
    if (/*bNetDirty && */Role == ROLE_Authority)
        CurveCenterEnterDive, CurveCenterExitDive, RollAngleInURT, DiveAngleInURT,
        DivingState, AscensionAngleInURT, RollUnitsPerSecond, PitchUnitsPerSecondExit,
        PitchUnitsPerSecondEnter, bAccelerating, AccelPerSecondEnter,
        AccelPerSecondExit, CurveRadiusEnterDive, CurveRadiusExitDive, AngleOfDiveFromZAxis,
        AccelPerSecondDive, AscensionRollAngleInURT, YawUnitsPerSecondExit, bExitTimerSet;
}

// TODO: Make this a macro or somethinge reusable.
// TODO: Make this run on server and tell clients to add this to their list.
simulated function AudioInit()
{
    local DRAudioComponent DRAC;
    local DRPlayerController DRPC;

    if (Role < ROLE_Authority || WorldInfo.NetMode == NM_StandAlone)
    {
        ForEach LocalPlayerControllers(class'DRPlayerController', DRPC)
        {
            if (DRPC.AudioManager != None)
            {
                ForEach ComponentList(class'DRAudioComponent', DRAC)
                {
                    DRPC.AudioManager.RegisterAudioComponent(DRAC);
                }
            }
        }
    }
}

reliable client function ClientRegisterAudioComponents()
{
    local DRAudioComponent DRAC;
    local DRPlayerController DRPC;

    ForEach LocalPlayerControllers(class'DRPlayerController', DRPC)
    {
        if (DRPC.AudioManager != None)
        {
            ForEach ComponentList(class'DRAudioComponent', DRAC)
            {
                DRPC.AudioManager.RegisterAudioComponent(DRAC);
            }
        }
    }
}

function AudioInit2()
{
    if (Role == ROLE_Authority || WorldInfo.NetMode == NM_StandAlone)
    {
        ClientRegisterAudioComponents();
    }
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    AudioInit();
    PlayAmbientAudio();

    // DrawDebugPoint(Location, 2, MakeLinearColor(255.0, 0.0, 0.0, 0.5), True);
    // DebugLastPointLocation = Location;

    SetTimer(55, False, 'StartExitFlight');
    SetTimer(65, False, 'Destroy');
}

simulated function Explode()
{
    super.Explode();

    if (Role < ROLE_Authority || WorldInfo.NetMode == NM_StandAlone)
    {
        DiveSoundComponent.FadeOut(1.0, 0.0);
        FlightSoundComponent.FadeOut(1.0, 0.0);
    }
}

simulated function Destroyed()
{
    if (Role < ROLE_Authority || WorldInfo.NetMode == NM_StandAlone)
    {
        DiveSoundComponent.FadeOut(2.0, 0.0);
        DiveSoundComponent.SoundCue = None;

        FlightSoundComponent.FadeOut(2.0, 0.0);
        FlightSoundComponent.SoundCue = None;
    }

    DivingState = EDBDS_None;
    ClearTimer('Roll');
    ClearTimer('StartEnterDive');
    ClearTimer('DropPayload');
    ClearTimer('StartExitDive');
    ClearTimer('StartExitFlight');

    // ClearTimer('StopAccelerating');
}

simulated function Tick(float DeltaTime)
{
    local DRPlayerController PC;

    super.Tick(DeltaTime);

    foreach LocalPlayerControllers(class'DRPlayerController', PC)
    {
        PC.ClientMessage("[" $ DivingState $ "]" $ " S="
            $ VSize(Velocity) $ " P=" $ Rotation.Pitch * UnrRotToDeg $ " R="
            $ Rotation.Roll * UnrRotToDeg);
    }

    /*
    if (DebugLastPointLocation != Location)
    {
        DebugLastPointLocation = Location;
        DrawDebugPoint(Location, 2, MakeLinearColor(255.0, 0.0, 0.0, 0.5), True);
    }
    */
    DrawDebugPoint(Location, 2, MakeLinearColor(255.0, 0.0, 0.0, 0.5), True);

    // DrawDebugCoordinateSystem(Location, Rotation, 5000);

    if (Role == ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
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
            case EDBDS_RollingOut:
                HandleRollingOutUpdate(DeltaTime);
                break;
            default:
                break;
        }
    }

    // `log("Speed = " $ VSize(Velocity));
}

simulated function PlayAmbientAudio()
{
    if (Role < ROLE_Authority || WorldInfo.NetMode == NM_StandAlone)
    {
        //* FlightSoundComponent.FadeIn(6.5, 1.0);
        FlightSoundComponent.Play();
    }
}

function StartEnterDive()
{
    // `log("StartEnterDive() TimeActual = " $ WorldInfo.TimeSeconds);
    DivingState = EDBDS_EnteringDive;
    // DrawDebugSphere(Location, 100, 255, 255, 255, 0, True);
}

function StartExitDive()
{
    ClearTimer('StartExitDive');

    // `log("StartExitDive() TimeActual = " $ WorldInfo.TimeSeconds);
    DivingState = EDBDS_ExitingDive;
    // DrawDebugSphere(Location, 100, 255, 255, 255, 0, True);

    // `log("Dist to target = " $ VSize(TargetLocation - Location));
    // `log("Line_CH        = " $ Line_CH);
}

function Dive()
{
    // `log("Dive() TimeActual = " $ WorldInfo.TimeSeconds);
    DivingState = EDBDS_Diving;
    bAccelerating = True;
    // DrawDebugSphere(Location, 100, 255, 255, 255, 0, True);
}

function Ascend()
{
    // `log("Ascend() TimeActual = " $ WorldInfo.TimeSeconds);
    DivingState = EDBDS_Ascending;
    // bCheckMapBounds = True;

    if (Role < ROLE_Authority || WorldInfo.NetMode == NM_StandAlone)
    {
        FlightSoundComponent.FadeIn(2, 1.0);
        DiveSoundComponent.FadeOut(2, 0.0);
    }

    // DrawDebugSphere(Location, 100, 255, 255, 255, 0, True);
}

/*
function StopAccelerating()
{
    // `log("StopAccelerating() TimeActual = " $ WorldInfo.TimeSeconds);
    bAccelerating = False;
    // DrawDebugSphere(Location, 100, 255, 255, 255, 0, True);
}
*/

function Roll()
{
    // `log("Roll() TimeActual = " $ WorldInfo.TimeSeconds);
    DivingState = EDBDS_RollingIn;

    if (Role < ROLE_Authority || WorldInfo.NetMode == NM_StandAlone)
    {
        DiveSoundComponent.FadeIn(2, 1.0);
        FlightSoundComponent.FadeOut(2, 0.3);
    }

    // DrawDebugSphere(Location, 100, 255, 255, 255, 0, True);
}

function StartExitFlight()
{
    // `log("StartExitFlight() TimeActual = " $ WorldInfo.TimeSeconds);
    DivingState = EDBDS_None;
    bCheckMapBounds = True;
    bAccelerating = False;
    // DrawDebugSphere(Location, 100, 255, 255, 255, 0, True);
}

// Solve trajectory geometry with given height,
// dive angle and payload drop height.
// https://www.geogebra.org/geometry/v4jyuram
function CalculateTrajectory()
{
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
    local float Temp;
    local float Correction;

    // Helper constants.
    local float SinAODFZA;
    local float TanAODFZA;
    local float Rad90;
    local float Rad180;

    // Flight distances in UU.
    local float DistMaxDiveSpeed;
    local float DistToTarget;
    local float DistPitchBeginOffset;
    local float DistDive;

    // Flight times in seconds.
    local float TimeTillDrop;
    local float TimeTillMaxSpeed;
    local float TimeTillTarget;
    local float TimeDiving;
    local float TimeTillBeginRoll;
    //? local float TimeTillStopAccel;
    //? local float TimeTillExitFlight;

    // Angles in radians.
    local float AngleOfAscension;
    local float Beta;
    local float Xi;
    local float Theta;
    local float Mu;
    // local float Lambda;
    // local float Eta;

    // Line lengths in UU.
    local float Line_CA;
    local float Line_FD;
    local float Line_CD;
    local float Line_VA;
    local float Line_B1;
    local float Line_CH;
    local float Line_HE_1;
    local float Line_CF_1;
    local float Line_AF_1;

    // Only calculated on server OR when standalone.
    if ((Role != ROLE_Authority) || (WorldInfo.NetMode != NM_Standalone))
    {
        return;
    }

    AngleOfDiveFromZAxis = 270 - AngleOfDive;
    // `log("AngleOfDiveFromZAxis = " $ AngleOfDiveFromZAxis);

    SinAODFZA = Sin(AngleOfDiveFromZAxis * DegToRad);
    TanAODFZA = Tan(AngleOfDiveFromZAxis * DegToRad);

    Rad90 = 90 * DegToRad;
    Rad180 = 180 * DegToRad;

    DiveAngleInURT = AngleOfDive * DegToUnrRot;
    RollAngleInURT = AngleOfRoll * DegToUnrRot;

    Beta = (90 - AngleOfDiveFromZAxis) * DegToRad;
    Line_CH = PayloadDropHeight / Sin(Beta);
    Line_B1 = Line_CH * SinAODFZA;

    TargetLocElevated = TargetLocation;
    TargetLocElevated.Z = Location.Z;

    StrikeDir3D = Normal(TargetLocElevated - Location);

    // Adjust target by offset to improve accuracy.
    // E.g. if AngleOfDiveFromZAxis = 15 deg,
    // we shift target in dive direction by Line_B1 * 0.15 * 0.75.
    // `log("________________________________________________________");
    // `log("Offset = " $ -(Line_B1 * (AngleOfDiveFromZAxis / 100.0) * 0.75));
    // `log("TargetLocation (before) = " $ TargetLocation);
    TargetLocation += StrikeDir3D * -(Line_B1 * (AngleOfDiveFromZAxis / 100.0) * 0.75);
    TargetLocElevated = TargetLocation;
    TargetLocElevated.Z = Location.Z;
    // `log("TargetLocation (after)  = " $ TargetLocation);
    // `log("________________________________________________________");

    // `log("Location           = " $ Location);
    // `log("TargetLocElevated  = " $ TargetLocElevated);

    DistToTarget = VSize(TargetLocElevated - Location);
    // `log("DistToTarget = " $ DistToTarget);

    TimeTillTarget = InboundDelay + (DistToTarget / Speed);
    // `log("TimeTillTarget = " $ TimeTillTarget);

    // Arbitrary duration. Larger divisor means faster rolling.
    RollDuration = (TimeTillTarget / 8);
    TimeTillBeginRoll = TimeTillTarget - (RollDuration * 1.05); // 1.05 "safety margin".
    // `log("TimeTillBeginRoll = " $ TimeTillBeginRoll);

    Height = Location.Z - TargetLocation.Z;
    // `log("Height = " $ Height);

    DistPitchBeginOffset = Height * TanAODFZA;
    // `log("DistPitchBeginOffset = " $ DistPitchBeginOffset);

    RollUnitsPerSecond = RollAngleInURT / RollDuration;
    // `log("RollUnitsPerSecond = " $ RollUnitsPerSecond);

    CurveRadiusEnterDive = Tan(DegToRad * ((90 - AngleOfDiveFromZAxis) * 0.5)) * DistPitchBeginOffset;
    AccelPerSecondEnter = Square(Speed) / CurveRadiusEnterDive;

    // `log("CurveRadiusEnterDive = " $ CurveRadiusEnterDive);
    // `log("AccelPerSecondEnter = " $ AccelPerSecondEnter);

    if(WorldEdgeExitBuffer < CurveRadiusEnterDive)
    {
        // `log("Extending world edge limits (CurveRadiusEnterDive)");
        SetWorldEdgeLimits(CurveRadiusEnterDive + 25);
    }

    PitchArcAngleInRadEnter = 2 * Atan(DistPitchBeginOffset / CurveRadiusEnterDive);
    PitchArcLengthEnter = PitchArcAngleInRadEnter * CurveRadiusEnterDive;
    PitchArcTravelTimeEnter = PitchArcLengthEnter / Speed;

    // `log("PitchArcAngleInRadEnter = " $ PitchArcAngleInRadEnter);
    // `log("PitchArcAngleEnter (deg) = " $ PitchArcAngleInRadEnter * RadToDeg);
    // `log("PitchArcLengthEnter = " $ PitchArcLengthEnter);
    // `log("PitchArcTravelTimeEnter = " $ PitchArcTravelTimeEnter);

    // Upside-down during the actual dive.
    DiveAngleInURT -= 360 * DegToUnrRot;
    PitchUnitsPerSecondEnter = DiveAngleInURT / PitchArcTravelTimeEnter;
    // `log("PitchUnitsPerSecondEnter = " $ PitchUnitsPerSecondEnter);

    CurveCenterEnterDive = TargetLocElevated;
    CurveCenterEnterDive.Z -= CurveRadiusEnterDive;

    // Eta = ((90 - AngleOfDiveFromZAxis) * 0.5) * DegToRad;
    // Xi = ((360 - (PitchArcAngleInRadEnter * RadToDeg)) * 0.5) * DegToRad;
    // Xi = 75 * DegToRad; // TODO: Temporarily hard-coded.
    // Xi = ((360 * DegToRad) - (4 * Lambda)) * 0.5;
    Xi = (90 - AngleOfDiveFromZAxis) * DegToRad;
    // Lambda = Rad90 - Eta;

    // `log("Eta            (deg) = " $ Eta * RadToDeg);
    // `log("Xi             (deg) = " $ Xi * RadToDeg);
    // `log("Lambda         (deg) = " $ Lambda * RadToDeg);
    // `log("Lambda (check) (deg) = " $ (PitchArcAngleInRadEnter * 0.5) * RadToDeg);
    // `log("Beta           (deg) = " $ Beta * RadToDeg);

    // Check calculations.
    // `log("PitchArcAngleEnter (check) (deg) = " $ 2 * Lambda * RadToDeg);

    //? Line_FD = CurveRadiusEnterDive / Tan(Eta);
    Line_FD = CurveRadiusEnterDive;
    Line_HE_1 = TanAODFZA * Line_CH;
    Line_CD = (Line_CH / Line_HE_1) * CurveRadiusEnterDive;
    DistDive = Line_CD - Line_CH; // Line_DH.

    // `log("Line_CH    = " $ Line_CH);
    // `log("Line_B1    = " $ Line_B1);
    // `log("Line_FD    = " $ Line_FD);
    // `log("Line_HE_1  = " $ Line_HE_1);
    // `log("Line_CD    = " $ Line_CD);
    // `log("DistDive   = " $ DistDive);

    CurveRadiusExitDive = (DistDive + Line_FD) / (Line_FD / CurveRadiusEnterDive);
    Line_CA = Sqrt(CurveRadiusExitDive**2 + Line_CH**2);

    // `log("CurveRadiusExitDive = " $ CurveRadiusExitDive);
    // `log("Line_CA             = " $ Line_CA);

    AccelPerSecondExit = Square(DiveSpeed) / CurveRadiusExitDive;
    // `log("AccelPerSecondExit = " $ AccelPerSecondExit);

    Mu = ASin(Line_CH / Line_CA);
    Theta = Rad90 - Mu;

    // `log("Theta (deg) = " $ Theta * RadToDeg);
    // `log("Mu    (deg) = " $ Mu * RadToDeg);
    // `log("Gamma (deg) = " $ Gamma * RadToDeg);

    PitchArcAngleInRadExit = Rad180 - (2 * Theta);

    if(WorldEdgeExitBuffer < CurveRadiusExitDive)
    {
        // `log("Extending world edge limits (CurveRadiusExitDive)");
        SetWorldEdgeLimits(CurveRadiusExitDive + 25);
    }

    AngleOfAscension = PitchArcAngleInRadExit - Xi;

    // TODO: Dirty hack to take absolute value...
    // 10 deg = 0.174532925 rad.
    // 19 deg = 0.331612558 rad.
    if ((AngleOfAscension * RadToDeg) < 0)
    {
        // Clamp it for good measure...
        AngleOfAscension = FClamp(AngleOfAscension, 0.174532925, 0.331612558);
        // Also correct PitchArcAngleInRadExit...
        PitchArcAngleInRadExit = AngleOfAscension + Xi;
    }
    AscensionAngleInURT = AngleOfAscension * RadToUnrRot;

    `log("AngleOfAscension (deg) = " $ AngleOfAscension * RadToDeg);

    PitchArcLengthExit = PitchArcAngleInRadExit * CurveRadiusExitDive;
    PitchArcTravelTimeExit = PitchArcLengthExit / DiveSpeed;

    // Upside-down during actual dive.
    AscensionAngleInURT = (-180 * DegToUnrRot) - (AngleOfAscension * RadToUnrRot);
    `log("AscensionAngleInURT (deg) (actual) = " $ AscensionAngleInURT * UnrRotToDeg);

    // 3000 UU / 2 s^2 (arbitrary value chosen for now).
    AccelPerSecondDive = (Abs(PhysicsVolume.GetGravityZ()) * SinAODFZA) + (3000 / 2);
    // `log("AccelPerSecondDive = " $ AccelPerSecondDive);

    TimeTillMaxSpeed = (DiveSpeed - Speed) / AccelPerSecondDive;
    DistMaxDiveSpeed = (Speed * TimeTillMaxSpeed) + (0.5 * AccelPerSecondDive * Square(TimeTillMaxSpeed));
    TimeDiving = TimeTillMaxSpeed + ((DistDive - DistMaxDiveSpeed) / DiveSpeed);
    TimeTillDrop = TimeTillTarget + PitchArcTravelTimeEnter + TimeDiving;

    // if (DistMaxDiveSpeed > DistDive)
    // {
    //     `log("ERROR: DIVE BOMBER CAN'T REACH DIVESPEED!");
    // }

    // `log("PitchArcAngleInRadExit  = " $ PitchArcAngleInRadExit);
    // `log("PitchArcAngleExit (deg) = " $ PitchArcAngleInRadExit * RadToDeg);
    // `log("PitchArcLengthExit      = " $ PitchArcLengthExit);
    // `log("PitchArcTravelTimeExit  = " $ PitchArcTravelTimeExit);

    // `log("DistMaxDiveSpeed = " $ DistMaxDiveSpeed);
    // `log("DistDive         = " $ DistDive);
    // `log("TimeDiving       = " $ TimeDiving);
    // `log("TimeTillDrop     = " $ TimeTillDrop);
    // `log("TimeTillMaxSpeed = " $ TimeTillMaxSpeed);

    Line_VA = (CurveRadiusExitDive / Sin(Rad90)) * Sin(Rad90 - (AngleOfDiveFromZAxis * DegToRad));
    Line_CF_1 = Line_VA - Line_B1;
    Line_AF_1 = Sqrt(Line_CA**2 - Line_CF_1**2);

    // `log("Line_VA    = " $ Line_VA);
    // `log("Line_CF_1  = " $ Line_CF_1);
    // `log("Line_AF_1  = " $ Line_AF_1);

    CurveCenterExitDive = TargetLocation;
    CurveCenterExitDive -= StrikeDir3D * Line_CF_1;
    CurveCenterExitDive.Z += Line_AF_1;

    Temp = AscensionAngleInURT / PitchArcTravelTimeExit;

    // Manual correction due to some error in trajectory calculation.
    if (CurveRadiusExitDive >= (CurveCenterExitDive.Z - TargetLocation.Z))
    {
        // `log("ERROR: DIVE BOMBER WILL CRASH, CORRECTING CurveCenterExitDive!");
        Correction = (CurveRadiusExitDive - CurveCenterExitDive.Z) * 1.2;
        CurveCenterExitDive.Z += Correction;

        // Pitch faster to make it look more natural.
        // Use the ratio of the previous correction.
        Correction /= CurveRadiusExitDive;
        Temp += Temp * Correction;
    }
    PitchUnitsPerSecondExit = Temp;
    // `log("PitchUnitsPerSecondExit = " $ PitchUnitsPerSecondExit);

    // DrawDebugSphere(CurveCenterEnterDive, CurveRadiusEnterDive, 64, 0, 255, 0, True);
    // DrawDebugSphere(CurveCenterExitDive, CurveRadiusExitDive, 64, 255, 35, 0, True);

    // `log("CurveCenterEnterDive = " $ CurveCenterEnterDive);
    // `log("CurveCenterExitDive  = " $ CurveCenterExitDive);

    //? TimeTillStopAccel = TimeTillTarget + PitchArcTravelTimeEnter + TimeTillMaxSpeed;
    //? TimeTillExitFlight = TimeTillStopAccel + PitchArcTravelTimeExit;

    //? `log("TimeTillStopAccel  = " $ TimeTillStopAccel);
    //? `log("TimeTillExitFlight = " $ TimeTillExitFlight);

    // StartTime = WorldInfo.TimeSeconds;

    // `log("*************************************************");
    // `log("RollTime   = " $ StartTime + TimeTillBeginRoll);
    // `log("TargetTime = " $ StartTime + TimeTillTarget);
    // `log("DropTime   = " $ StartTime + TimeTillDrop);
    // `log("*************************************************");

    // `log("-------------------------------------------------");
    // `log("CenterEnter + Radius = " $ CurveCenterEnterDive.Z + CurveRadiusEnterDive);
    // `log("CenterExit  + Radius = " $ CurveCenterExitDive.Z + CurveRadiusExitDive);
    // `log("-------------------------------------------------");

    if (FRand() > 0.5)
    {
        Temp = -AscensionRollAngle;
        YawUnitsPerSecondExit = PitchUnitsPerSecondExit * 0.5;
    }
    else
    {
        Temp = AscensionRollAngle;
        YawUnitsPerSecondExit = PitchUnitsPerSecondExit * -0.5;
    }
    AscensionRollAngleInURT = (180 + Temp) * DegToUnrRot;

    SetTimer(TimeTillBeginRoll, False, 'Roll');
    SetTimer(TimeTillTarget, False, 'StartEnterDive');
    SetTimer(TimeTillDrop, False, 'DropPayload');
    SetTimer(TimeTillDrop, False, 'StartExitDive');
    //? SetTimer(TimeTillStopAccel, False, 'StopAccelerating');
    //? SetTimer(TimeTillExitFlight, False, 'StartExitFlight');
}

// Using basic physics, work out where each payload needs to be released in order to hit the target.
// Then use a timer to spawn the payload, as it's far less intensive than distance checks every tick, and less prone to error
function SetDropPoint()
{
    local float FallDist;
    // local float PreDropDist;
    // local float TimeTillDrop;
    // local float ImpactVelPct;

    FallDist = PayloadDropHeight;
    // `log("FallDist = " $ FallDist);

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
    // `log("FallTime = " $ FallTime);

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
    TimeTweenDrops = 0.05;
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

    // `log("DropPayload(), Height = " $ Location.Z);

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
    // `log("FallDist = " $ FallDist);

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
        SpawnedPayload.Velocity = Vector(AddSpreadY(rotator(Velocity))) * VSize(Velocity);
        SpawnedPayload.FallDist = FallDist;
        SpawnedPayload.Lifespan = FallTime + 0.5;   // This should stop situations where a canister gets stuck on something and isn't able to actually impact the ground
        SpawnedPayload.SetExplosionTime(FallTime);
    }

    if( !bDroppedFirstBomb )
    {
        // We've reached the target, so it's now safe to starting checking for despawn.
        // bCheckMapBounds = true;
        bDroppedFirstBomb = true;

        // `log("bCheckMapBounds = True");

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
        // `log("Roll finished");
    }

    SetRotation(NewRot);
}

function HandleExitingDiveUpdate(float DeltaTime)
{
    local rotator NewRot;
    local vector AccelToApply;
    local vector FinalVelocity;
    local float AircraftSpeed;

    /*
    `log("Rotation.Pitch (deg) = " $ Rotation.Pitch * UnrRotToDeg
        $ " AscensionAngle (deg) = " $ AscensionAngleInURT * UnrRotToDeg);
    */

    NewRot = Rotation;
    NewRot.Pitch += PitchUnitsPerSecondExit * DeltaTime;

    AircraftSpeed = VSize(Velocity);
    // TODO: Final velocity should be AircraftSpeed * vector(FinalRotation)?
    FinalVelocity = AircraftSpeed * vector(Rotation);

    // If we are getting close to the final angle,
    // interpolate velocity towards the "final velocity" & pitch.
    // 1820 ~= 10 * DegToUnrRot.
    if (((Abs(AscensionAngleInURT) - Abs(Rotation.Pitch)) < 1820)
        && (Rotation.Pitch > AscensionAngleInURT))
    {

        Velocity = VInterpTo(Velocity, FinalVelocity, DeltaTime, 1);
        //? NewRot.Pitch = FInterpTo(Rotation.Pitch, AscensionAngleInURT, DeltaTime, 1);
    }
    else if (Rotation.Pitch < AscensionAngleInURT)
    {
        //? NewRot.Pitch = AscensionAngleInURT;
        //? SetRotation(NewRot);
        //? Velocity = FinalVelocity;
        Ascend();
        // `log("Finished exiting dive");
        return;
    }

    SetRotation(NewRot);

    AccelToApply = AccelPerSecondExit * Normal(CurveCenterExitDive - Location) * DeltaTime;
    Velocity += AccelToApply;

    // `ExitVelocityCorrection(DiveSpeed);
    if (AircraftSpeed < DiveSpeed)
    {
        AccelToApply = ((DiveSpeed - AircraftSpeed) * 3) * Normal(
            CurveCenterExitDive - Location) * DeltaTime;
        Velocity += AccelToApply;
    }
}

function HandleDivingUpdate(float DeltaTime)
{
    local vector AccelToApply;

    if (bAccelerating)
    {
        AccelToApply = AccelPerSecondDive * Normal(TargetLocation - Location) * DeltaTime;
        Velocity += AccelToApply;

        if (VSize(Velocity) >= DiveSpeed)
        {
            bAccelerating = False;
        }
    }
}

function HandleEnteringDiveUpdate(float DeltaTime)
{
    local rotator NewRot;
    local vector AccelToApply;

    NewRot = Rotation;
    NewRot.Pitch += PitchUnitsPerSecondEnter * DeltaTime;

    /*
    `log("Rotation.Pitch (deg) = " $ Rotation.Pitch * UnrRotToDeg
        $ " DiveAngle (deg) = " $ DiveAngleInURT * UnrRotToDeg);
    */

    if (Rotation.Pitch < DiveAngleInURT)
    {
        NewRot.Pitch = DiveAngleInURT;
        SetRotation(NewRot);
        Dive();
        // `log("Finished entering dive");
        return;
    }

    SetRotation(NewRot);

    AccelToApply = AccelPerSecondEnter * Normal(CurveCenterEnterDive - Location) * DeltaTime;
    Velocity += AccelToApply;
}

function HandleRollingOutUpdate(float DeltaTime)
{
    local rotator NewRot;
    local matrix M;
    //? local vector AccelToApply;
    //? local float AircraftSpeed;

    NewRot = Rotation;

    // 910 ~= 10 * DegToUnrRot.
    if (Abs(Abs(Rotation.Roll) - Abs(AscensionRollAngleInURT)) > 910.0)
    {
        NewRot.Roll = int(FInterpTo(float(Rotation.Roll), float(AscensionRollAngleInURT), DeltaTime, 1));
        // `log("Rotation.Roll            = " $ Rotation.Roll);
        // `log("AscensionRollAngleInURT  = " $ AscensionRollAngleInURT);
        // `log("Diff                     = " $ Abs(Abs(Rotation.Roll) - Abs(AscensionRollAngleInURT)));
    }
    else
    {
        if (!bExitTimerSet)
        {
            SetTimer(8.0, False, 'StartExitFlight');
            bExitTimerSet = True;
        }

        // We're actually "yawing" now because the aircraft is rolled.
        // TODO: Find a way to pitch in actual "aircraft space",
        // instead of world space. (Check UE4 implementation of FVector::RotateAngleAxis).
        NewRot.Yaw += YawUnitsPerSecondExit * DeltaTime;

        M = MakeRotationMatrix(Rotation);
        Velocity += AccelPerSecondExit * Normal(MatrixGetAxis(M, AXIS_Z)) * DeltaTime * 0.5;

        //? AircraftSpeed = VSize(Velocity);
        //? `ExitVelocityCorrection(Speed);
    }

    SetRotation(NewRot);
}

function HandleAscendingUpdate(float DeltaTime)
{
    if (Abs(VSize(Velocity) - Speed) > 10.0)
    {
        Velocity = VInterpTo(Velocity, vector(Rotation) * Speed, DeltaTime, InterpSpeedAscend);
    }
    else
    {
        DivingState = EDBDS_RollingOut;
    }
}

DefaultProperties
{
    TeamIndex=`AXIS_TEAM_INDEX

    Speed=3800 // 3756 = 146 knots or 75 m/s.
    DiveSpeed=7300 // 7156 = 150 m/s (constant dive speed after initial acceleration).
    Altitude=65000 // 1300m. // 50kUU = 1000m.
    PayloadDropHeight=22500 // 450m. // 15kUU = 300m.

    InterpSpeedAscend=5

    AngleOfDive=260 // From mesh 0 rotation position.
    AngleOfRoll=180

    AscensionRollAngle=85

    DivingState=EDBDS_None

    bCheckMapBounds=False
    bAccelerating=False

    // TODO: 1 big bomb? Need new mesh for big bomb?
    FirstPayloadClass=class'ROCarpetBomb'
    SecondPayloadClass=class'ROCarpetBomb'

    Begin Object Name=PlaneMesh
        SkeletalMesh=SkeletalMesh'DR_VH_CMD.Mesh.JU87_BOMB_SKEL'
        PhysicsAsset=PhysicsAsset'VH_VN_ARVN_Skyraider.Phys.Skyraider_Physics'
        AnimSets[0]=AnimSet'VH_VN_ARVN_Skyraider.Animation.AUS_Skyraider_anim'
        Materials[0]=MaterialInstanceConstant'DR_VH_CMD.MIC.M_JU87_1'
    End Object

    AmbientSound=None
    AmbientComponent=None

    Begin Object Class=DRAudioComponent name=DiveSoundComponent_01
        OcclusionCheckInterval=1.0
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
        bAutoPlay=false
        AudioClass=EAC_SFX
        SoundCue=SoundCue'DR_AUD_Stuka.Stuka_1_Cue'
    End Object
    DiveSoundComponent=DiveSoundComponent_01
    Components.Add(DiveSoundComponent_01)

    Begin Object Class=DRAudioComponent name=FlightSoundComponent_01
        OcclusionCheckInterval=1.0
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
        bAutoPlay=false
        AudioClass=EAC_SFX
        SoundCue=SoundCue'DR_AUD_Stuka.Stuka_Flight_1_Cue'
    End Object
    FlightSoundComponent=FlightSoundComponent_01
    Components.Add(FlightSoundComponent_01)
}
