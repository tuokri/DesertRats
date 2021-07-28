class DRVehicleTank extends ROVehicleTank
    abstract;

//? `include(DesertRats\Classes\DRVehicle_Common.uci)

var DRDestroyedTankTrack DestroyedLeftTrack;
var DRDestroyedTankTrack DestroyedRightTrack;

var byte LeftTrackMaterialIndex;
var byte RightTrackMaterialIndex;

// --- BEGIN SOUNDCUE BACKPORT ---

var int CachedWheelRadius;

var SoundCue ExplosionSoundCustom;

var(Sounds) editconst const DRAudioComponent EngineSoundCustom;
var(Sounds) editconst const DRAudioComponent SquealSoundCustom;

// Engine start sounds.
var DRAudioComponent  EngineStartLeftSoundCustom;
var DRAudioComponent  EngineStartRightSoundCustom;
var DRAudioComponent  EngineStartExhaustSoundCustom;
var DRAudioComponent  EngineStopSoundCustom;

var SoundCue EngineIdleSoundCustom;
var SoundCue EngineIdleDamagedSoundCustom;
var SoundCue TrackTakeDamageSoundCustom;
var SoundCue TrackDamagedSoundCustom;
var SoundCue TrackDestroyedSoundCustom;

// Engine interior cabin sounds.
var DRAudioComponent EngineIntLeftSoundCustom;
var DRAudioComponent EngineIntRightSoundCustom;

// Tread sounds.
var DRAudioComponent  TrackLeftSoundCustom;
var DRAudioComponent  TrackRightSoundCustom;

// Tranmission sounds.
var DRAudioComponent  BrokenTransmissionSoundCustom;

// Brake sounds.
var DRAudioComponent  BrakeLeftSoundCustom;
var DRAudioComponent  BrakeRightSoundCustom;

// Gear shift sounds.
var SoundCue        ShiftUpSoundCustom;
var SoundCue        ShiftDownSoundCustom;
var SoundCue        ShiftLeverSoundCustom;

// Turret rotation components.
var DRAudioComponent  TurretTraverseSoundCustom;
var DRAudioComponent  TurretMotorTraverseSoundCustom;
var DRAudioComponent  TurretElevationSoundCustom;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // Attach sound cues.
    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        Mesh.AttachComponentToSocket(EngineStartLeftSoundCustom, CabinL_FXSocket);
        Mesh.AttachComponentToSocket(EngineStartRightSoundCustom, CabinR_FXSocket);
        Mesh.AttachComponentToSocket(EngineStartExhaustSoundCustom, Exhaust_FXSocket);
        Mesh.AttachComponentToSocket(EngineStopSoundCustom, Exhaust_FXSocket);
        Mesh.AttachComponentToSocket(EngineIntLeftSoundCustom, CabinL_FXSocket);
        Mesh.AttachComponentToSocket(EngineIntRightSoundCustom, CabinR_FXSocket);
        Mesh.AttachComponentToSocket(EngineSoundCustom, Exhaust_FXSocket);
        Mesh.AttachComponentToSocket(TrackLeftSoundCustom, TreadL_FXSocket);
        Mesh.AttachComponentToSocket(TrackRightSoundCustom, TreadR_FXSocket);
        Mesh.AttachComponentToSocket(BrakeLeftSoundCustom, TreadL_FXSocket);
        Mesh.AttachComponentToSocket(BrakeRightSoundCustom, TreadR_FXSocket);
    }

    CachedWheelRadius = Wheels[0].WheelRadius;
}

simulated event Tick(float DeltaTime)
{
    local float SpeedParamPct;
    local float LeftTrackSpeed;
    local float RightTrackSpeed;

    super.Tick(DeltaTime);

    // Only need these effects client side
    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        // attempted throttle with a broken transmission
        if (BrokenTransmissionSoundCustom != None && BrokenTransmissionSoundCustom.bAttached)
        {
            if (Abs(BrokenTransmissionThrottle - 128) > 32)
            {
                if (!BrokenTransmissionSoundCustom.IsPlaying())
                {
                    BrokenTransmissionSoundCustom.Play();
                }
            }
            else if (BrokenTransmissionSoundCustom.IsPlaying())
            {
                BrokenTransmissionSoundCustom.Stop();
            }
        }

        UpdateBrakeSounds();
    }

    LeftTrackSpeed = (ROVehicleSimTreaded(SimObj).LeftTrackVel * CachedWheelRadius);
    RightTrackSpeed = (ROVehicleSimTreaded(SimObj).RightTrackVel * CachedWheelRadius);

    SpeedParamPct = Abs(VSize(Velocity)) / MaxSpeed;

    if (EngineSoundCustom != None)
    {
        EngineSoundCustom.SetFloatParameter('RPMParam', GetEngineOutput());
        EngineSoundCustom.SetFloatParameter('SpeedParam', SpeedParamPct);
    }
    if (EngineIntLeftSoundCustom != None)
    {
        EngineIntLeftSoundCustom.SetFloatParameter('SpeedParam', SpeedParamPct);
    }
    if (EngineIntRightSoundCustom != None)
    {
        EngineIntRightSoundCustom.SetFloatParameter('SpeedParam', SpeedParamPct);
    }

    if (TrackLeftSoundCustom != None)
    {
        TrackLeftSoundCustom.SetFloatParameter('SpeedParam', TrackSoundParamScale * Abs(LeftTrackSpeed));
    }
    if (TrackRightSoundCustom != None)
    {
        TrackRightSoundCustom.SetFloatParameter('SpeedParam', TrackSoundParamScale * Abs(RightTrackSpeed));
    }

    if (ShiftTimeRemaining <= 0.f)
    {
        // shift finished
        if (DelayedOutputGear != OutputGear)
        {
            PlayGearShiftAudio();
        }
    }
    else if (DelayedOutputGear != OutputGear)
    {
        PlayGearShiftAudio();
    }
}

simulated function UpdateBrakeSounds()
{
    if (BrakeLeftSoundCustom != None)
    {
        if ((OutputBrake > 0.2f) || (OutputSteering > 0.2f))
        {
            if (!bSkipLeftBrakeSound)
            {
                bSkipLeftBrakeSound = True;
                BrakeLeftSoundCustom.Play();
            }
        }
        else
        {
            bSkipLeftBrakeSound = False;
            if (BrakeLeftSoundCustom.IsPlaying())
            {
                BrakeLeftSoundCustom.Stop();
            }
        }
    }

    if (BrakeRightSoundCustom != None)
    {
        if ((OutputBrake > 0.2f) || (OutputSteering < -0.2f))
        {
            if (!bSkipRightBrakeSound)
            {
                bSkipRightBrakeSound = False;
                BrakeRightSoundCustom.Play();
            }
        }
        else
        {
            bSkipRightBrakeSound = True;
            if (BrakeRightSoundCustom.IsPlaying())
            {
                BrakeRightSoundCustom.Stop();
            }
        }
    }
}

simulated function float GetEngineOutput()
{
    // EvalInterpCurveFloat(EngineRPMCurve, Vehicle.ForwardVel)
    return ROVehicleSimTreaded(SimObj).EngineRPM / (ROVehicleSimTreaded(SimObj).ChangeUpPoint * 1.1f);
}

simulated function StopVehicleSounds()
{
    Super.StopVehicleSounds();

    if (EngineSoundCustom != None)
    {
        EngineSoundCustom.Stop();
    }

    if (SquealSoundCustom != None)
    {
        SquealSoundCustom.Stop();
    }

    if (TurretTraverseSoundCustom != None)
    {
        TurretTraverseSoundCustom.Stop();
    }
    if (TurretMotorTraverseSoundCustom != None)
    {
        TurretMotorTraverseSoundCustom.Stop();
    }
    if (TurretElevationSoundCustom != None)
    {
        TurretElevationSoundCustom.Stop();
    }
}

simulated function StartEngineSound()
{
    if (EngineSoundCustom != none)
    {
        // If the engine is damaged, use the damaged sound.
        if (EngineStatus == ES_RunningDamaged && EngineIdleDamagedSoundCustom != none)
        {
            EngineSoundCustom.SoundCue = EngineIdleDamagedSoundCustom;
            EngineSoundCustom.Play();
        }
        else
        {
            EngineSoundCustom.SoundCue = EngineIdleSoundCustom;
            EngineSoundCustom.Play();
        }
    }

    super.StartEngineSound();

    if (IsLocalPlayerInThisVehicle())
    {
        if (EngineIntLeftSoundCustom != None)
        {
            EngineIntLeftSoundCustom.Play();
        }
        if (EngineIntRightSoundCustom != None)
        {
            EngineIntRightSoundCustom.Play();
        }
    }
    else
    {
        // Don't do interior sounds if noone is locally in the vehicle
        if (EngineIntLeftSoundCustom != None)
        {
            EngineIntLeftSoundCustom.Stop();
        }
        if (EngineIntRightSoundCustom != None)
        {
            EngineIntRightSoundCustom.Stop();
        }
    }

    if (TrackLeftSoundCustom != None)
    {
        TrackLeftSoundCustom.Play();
    }
    if (TrackRightSoundCustom != None)
    {
        TrackRightSoundCustom.Play();
    }
}

simulated function StartEngineSoundTimed()
{
    Super.StartEngineSoundTimed();

    if(EngineStartLeftSoundCustom != None)
    {
        EngineStartLeftSoundCustom.Play();
    }
    if(EngineStartRightSoundCustom != None)
    {
        EngineStartRightSoundCustom.Play();
    }
    if(EngineStartExhaustSoundCustom != None)
    {
        EngineStartExhaustSoundCustom.Stop(); // If you switch seats rapidly this won't have finished, so force it.
        EngineStartExhaustSoundCustom.Play();
    }
}

simulated function StopEngineSound()
{
    if (EngineSoundCustom != None)
    {
        EngineSoundCustom.Stop();
    }

    super.StopEngineSound();

    if (EngineIntLeftSoundCustom != None)
    {
        EngineIntLeftSoundCustom.Stop();
    }
    if (EngineIntRightSoundCustom != None)
    {
        EngineIntRightSoundCustom.Stop();
    }

    if (TrackLeftSoundCustom != None)
    {
        TrackLeftSoundCustom.Stop();
    }
    if (TrackRightSoundCustom != None)
    {
        TrackRightSoundCustom.Stop();
    }
}

simulated function StopEngineSoundTimed()
{
    if (EngineStopSoundCustom != none )
    {
        EngineStopSoundCustom.Stop();
        EngineStopSoundCustom.Play();
    }

    if (EngineStopOffsetSecs > 0.f)
    {
        ClearTimer('StartEngineSound');
        SetTimer(EngineStopOffsetSecs, false, 'StopEngineSound');
    }
    else
    {
        StopEngineSound();
    }
}

simulated function ReplaceLoopingAudioCustom(AudioComponent AudioComp, SoundCue NewSoundCue)
{
    if (AudioComp == None || NewSoundCue == None)
    {
        return;
    }

    if (AudioComp.IsPlaying() && AudioComp.SoundCue == NewSoundCue)
    {
        return;
    }

    if (AudioComp.IsPlaying())
    {
        AudioComp.Stop();
        AudioComp.SoundCue = NewSoundCue;
        AudioComp.Play();
    }
}

simulated function OnTurretTraverseStatusChange(bool bTurretMoving, bool bHighSpeed)
{
    if (TurretTraverseSoundCustom != None)
    {
        if (bTurretMoving && !bHighSpeed)
        {
            TurretTraverseSoundCustom.FadeIn(0.1, 1.0);
        }
        else if (TurretTraverseSoundCustom.IsPlaying())
        {
            if (TurretTraverseSoundCustom.FadeOutStartTime == 0.0)
            {
                TurretTraverseSoundCustom.FadeOut(0.2, 0.0);
            }
        }
    }

    if (TurretMotorTraverseSoundCustom != None)
    {
        if (bTurretMoving && bHighSpeed)
        {
            TurretMotorTraverseSoundCustom.FadeIn(0.1, 1.0);
        }
        else if (TurretMotorTraverseSoundCustom.IsPlaying())
        {
            if (TurretMotorTraverseSoundCustom.FadeOutStartTime == 0.0)
            {
                TurretMotorTraverseSoundCustom.FadeOut(0.2, 0.0);
            }
        }
    }
}

simulated function OnTurretElevationStatusChange(bool bTurretMoving, bool bHighSpeed)
{
    if (TurretElevationSoundCustom != None)
    {
        if (bTurretMoving)
        {
            TurretElevationSoundCustom.FadeIn(0.1, 1.0);
        }
        else if (TurretElevationSoundCustom.IsPlaying())
        {
            if (TurretElevationSoundCustom.FadeOutStartTime == 0.0)
            {
                TurretElevationSoundCustom.FadeOut(0.2, 0.0);
            }
        }
    }
}

// TODO: volume control.
simulated function PlayLocalVehicleSoundCustom(SoundCue InSoundCue, optional name SocketName)
{
    local vector SocketLoc;

    if (InSoundCue == None)
    {
        return;
    }

    if (SocketName != '')
    {
        if (Mesh != None)
        {
            Mesh.GetSocketWorldLocationAndRotation(SocketName, SocketLoc);
            PlaySoundBase(InSoundCue, true, true, true, SocketLoc);
            return;
        }
    }

    PlaySoundBase(InSoundCue, true, true, true);
}

simulated function PlayGearShiftAudio()
{
    if (TargetOutputGear < DelayedOutputGear)
    {
        `log("ShiftDown",, 'DRDEV');
        PlayLocalVehicleSoundCustom(ShiftDownSoundCustom, Exhaust_FXSocket);
    }
    else if (ROVehicleSimTreaded(SimObj) != None
        && TargetOutputGear != ROVehicleSimTreaded(SimObj).FirstForwardGear)
    {
        `log("ShfitUp",, 'DRDEV');
        PlayLocalVehicleSoundCustom(ShiftUpSoundCustom, Exhaust_FXSocket);
    }
}

// --- END SOUNDCUE BACKPORT ---

simulated function DisableLeftTrack()
{
    local vector SpawnLoc;
    local rotator SpawnRot;

    super.DisableLeftTrack();

    Mesh.GetSocketWorldLocationAndRotation('Destroyed_Track_Spawn_Left', SpawnLoc, SpawnRot);

    Mesh.SetMaterial(LeftTrackMaterialIndex, Material'M_VN_Common_Characters.Materials.M_Hair_NoTransp');
    DestroyedLeftTrack = Spawn(class'DRDestroyedTankTrack', self,, SpawnLoc, SpawnRot);

    `dr("DestroyedLeftTrack = " $ DestroyedLeftTrack);
}

simulated function DisableRightTrack()
{
    local vector SpawnLoc;
    local rotator SpawnRot;

    super.DisableRightTrack();

    Mesh.GetSocketWorldLocationAndRotation('Destroyed_Track_Spawn_Right', SpawnLoc, SpawnRot);

    Mesh.SetMaterial(RightTrackMaterialIndex, Material'M_VN_Common_Characters.Materials.M_Hair_NoTransp');
    DestroyedRightTrack = Spawn(class'DRDestroyedTankTrack', self,, SpawnLoc, SpawnRot);

    `dr("DestroyedRightTrack = " $ DestroyedRightTrack);
}

// TODO: Let's not do this for now.
simulated function SpawnExternallyVisibleSeatProxies()
{
}

// TODO: We'll want these in the future.
function SetPendingDestroyIfEmpty(float WaitToDestroyTime);
function DestroyIfEmpty();

simulated function SpawnOrReplaceSeatProxy(int SeatIndex, ROPawn ROP, optional bool bInternalVisibility)
{
    local int i;//,j;
    local VehicleCrewProxy CurrentProxyActor;
    local bool bSetMeshRequired;
    local ROMapInfo ROMI;

    // Don't spawn the seat proxy actors on the dedicated server (at least for now)
    if( WorldInfo == none || WorldInfo.NetMode == NM_DedicatedServer )
    {
        return;
    }

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    // Don't create proxy if vehicle is dead to prevent leave bodies in the air after round has finished
    if (IsPendingKill() || bDeadVehicle)
        return;

    for ( i = 0; i < SeatProxies.Length; i++ )
    {
        // Only create a proxy for the seat the player has entered, or any seats where players can never enter
        if( (SeatIndex == i && ROP != none) || Seats[SeatProxies[i].SeatIndex].bNonEnterable )
        {
            bSetMeshRequired = false;

            // Dismemberment causes serious problems in native code if we try to reuse the existing mesh, so destroy it and create a new one instead
            if( SeatProxies[i].ProxyMeshActor != none && SeatProxies[i].ProxyMeshActor.bIsDismembered )
            {
                SeatProxies[i].ProxyMeshActor.Destroy();
                SeatProxies[i].ProxyMeshActor = none;
            }

            if( SeatProxies[i].ProxyMeshActor == none )
            {
                SeatProxies[i].ProxyMeshActor = Spawn(class'DRVehicleCrewProxy',self);
                SeatProxies[i].ProxyMeshActor.MyVehicle = self;
                SeatProxies[i].ProxyMeshActor.SeatProxyIndex = i;

                CurrentProxyActor = SeatProxies[i].ProxyMeshActor;

                SeatProxies[i].TunicMeshType.Characterization = class'ROPawn'.default.PlayerHIKCharacterization;

                CurrentProxyActor.Mesh.SetShadowParent(Mesh);
                CurrentProxyActor.SetLightingChannels(InteriorLightingChannels);
                CurrentProxyActor.SetLightEnvironment(InteriorLightEnvironment);

                CurrentProxyActor.SetCollision( false, false);
                CurrentProxyActor.bCollideWorld = false;
                CurrentProxyActor.SetBase(none);
                CurrentProxyActor.SetHardAttach(true);
                CurrentProxyActor.SetLocation( Location );
                CurrentProxyActor.SetPhysics( PHYS_None );
                CurrentProxyActor.SetBase( Self, , Mesh, Seats[SeatProxies[i].SeatIndex].SeatBone);

                CurrentProxyActor.SetRelativeLocation( vect(0,0,0) );
                CurrentProxyActor.SetRelativeRotation( Seats[SeatProxies[i].SeatIndex].SeatRotation );

                bSetMeshRequired = true;
            }
            else
            {
                CurrentProxyActor = SeatProxies[i].ProxyMeshActor;
            }

            if(CurrentProxyActor != none)
            {
                CurrentProxyActor.bExposedToRain = (ROMI != none && ROMI.RainStrength != RAIN_None) && SeatProxies[i].bExposedToRain;
            }

            // Create the proxy mesh
            if( !Seats[SeatProxies[i].SeatIndex].bNonEnterable )
            {
                CurrentProxyActor.ReplaceProxyMeshWithPawn(ROP);
            }
            else if( bSetMeshRequired )
            {
                CurrentProxyActor.CreateProxyMesh(SeatProxies[i]);
            }

            // Override the animation set
            if ( SeatProxyAnimSet != None )
            {
                CurrentProxyActor.Mesh.AnimSets[0] = SeatProxyAnimSet;
            }

            if( bInternalVisibility )
                SetSeatProxyVisibilityInterior();
            else
                SetSeatProxyVisibilityExterior();

            if( !Seats[SeatProxies[i].SeatIndex].bNonEnterable )
                CurrentProxyActor.HideMesh(true);
            else
            {
                CurrentProxyActor.UpdateVehicleIK(self, SeatProxies[i].SeatIndex, SeatProxies[i].PositionIndex);
                if( SeatProxies[i].Health > 0 )
                {
                    ChangeCrewCollision(true, SeatProxies[i].SeatIndex);
                }
            }
        }
    }
}

simulated function DelayedAcknowledgeHullMGer()
{
    local ROPlayerReplicationInfo ROPRI;

    if (GetHullMGSeatIndex() == INDEX_NONE)
    {
        return;
    }

    ROPRI = ROPlayerReplicationInfo(GetValidPRI());

    if ( ROPRI != none )
    {
        ROGameInfo(WorldInfo.Game).BroadcastLocalizedVoiceCom(`VOICECOM_TankAcknowleged, Seats[GetHullMGSeatIndex()].SeatPawn, , , ROPRI, true, GetTeamNum(), ROPRI.SquadIndex);
    }
}

function UpdateSeatProxyHealth(int SeatProxyIndex, int NewHealth, optional bool bIsTransition)
{
    super.UpdateSeatProxyHealth(SeatProxyIndex, NewHealth, bIsTransition);

    if( SeatProxyIndex == GetLoaderSeatIndex() && SeatProxies[SeatProxyIndex].Health <= 0 &&
        VehHitZones[25].ZoneHealth > 0 )
    {
        if (GetLoaderHitZoneIndex() != INDEX_NONE)
        {
            `log("hard-coded fuckery in DRVehicleTank",, 'DRDEV');
            // PCGamer TODO: Hacked in disabled the cannon if loader is dead.
            // Clean this up / don't hard code stuff later - Ramm
            VehHitZones[GetLoaderHitZoneIndex()].ZoneHealth = 0;
            ZoneHealthUpdated(GetLoaderHitZoneIndex());
            // Pack this Hit Zone's new Health into the replicated array
            PackHitZoneDamage(GetLoaderHitZoneIndex());
        }
    }
}

function int GetLoaderHitZoneIndex()
{
    return VehHitZones.Find('ZoneName', 'LOADERHEAD');
}

simulated function float GetArmorAngleForShot(name PhysBodyBone, name HitZoneName, vector ShotDirection, vector HitLocation, out vector ArmorNormal)
{
    local RB_BodySetup TestBody;
    local vector TempLocation;
    Local rotator TempRotation;
    local vector OutPosition;
    local rotator OutRotation;
    local int BodyIndex;
    local int ArrayIndex;
    local vector ArmorVector;
    local float HitAngle;
    local int I;

    BodyIndex = Mesh.PhysicsAsset.FindBodyIndex(PhysBodyBone);
    TestBody = Mesh.PhysicsAsset.BodySetup[BodyIndex];
    ArrayIndex = TestBody.AggGeom.BoxElems.Find('BoneName', HitZoneName);

    if (ArrayIndex == INDEX_NONE)
    {
        `warn(self $ ": GetArmorAngleForShot() invalid HitZoneName=" $ HitZoneName $ " PhysBodyBone="
            $ PhysBodyBone $ " TestBody=" $ TestBody,, 'DRDEV');
        `log("valid HitZoneNames:",, 'DRDEV');
        for(I = 0; I < TestBody.AggGeom.BoxElems.Length; I++)
        {
            `log("**** " $ TestBody.AggGeom.BoxElems[I].BoneName,, 'DRDEV');
        }
    }

    TempLocation = MatrixGetOrigin(TestBody.AggGeom.BoxElems[ArrayIndex].TM);
    TempRotation = MatrixGetRotator(TestBody.AggGeom.BoxElems[ArrayIndex].TM);
    Mesh.TransformFromBoneSpace( TestBody.BoneName, TempLocation, TempRotation, OutPosition, OutRotation );

    // Save the normal of the armor to be used by deflection calculations
    ArmorNormal = normal(vector(OutRotation));

    // This is the inverse normal of the armor plate that was hit
    ArmorVector = normal(vector(OutRotation) * -1);

    // Calculate the angle different between the incoming shot and the armor
    HitAngle = Acos( ArmorVector dot ShotDirection);

    //  Penetration Debugging
    if( bDebugPenetration )
    {
        // Direction the armor is facing
        DrawDebugLine( HitLocation, HitLocation - 50*ArmorVector,0, 255, 0, TRUE);  // Green
        DrawDebugSphere(HitLocation - 50*ArmorVector,4,12,0,255,0,true);// Green

        // Direction the shot is going
        DrawDebugLine( HitLocation, HitLocation - 50*ShotDirection,255, 255, 0, TRUE);  // Yellow
        DrawDebugSphere(HitLocation - 50*ShotDirection,4,12,255,255,0,true);// Yellow

        //`log("Raw hitangle = "$HitAngle$" Converted hitangle = "$(RadToDeg * HitAngle));
    }

    return HitAngle;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    super.PossessedBy(C, bVehicleTransition);

    // Reset camera.
    if (ROPlayerController(C) != None)
    {
        ROPlayerController(C).SetRotation(rot(0, 0, 0));
    }
}

simulated function ZoneHealthRepaired(int ZoneIndexUpdated)
{
    local int Message;
    local int CannonSeatIndex;
    //`log(GetFuncName()$" ZoneIndexUpdated = "$ZoneIndexUpdated$" ZoneName = "$VehHitZones[ZoneIndexUpdated].ZoneName$" Health = "$VehHitZones[ZoneIndexUpdated].ZoneHealth);

    Message = -1;

    if( VehHitZones[ZoneIndexUpdated].VehicleHitZoneType == VHT_Engine && VehHitZones[ZoneIndexUpdated].ZoneHealth > 0 )
    {
        if(  VehHitZones[ZoneIndexUpdated].ZoneName == 'ENGINEBLOCK' )
        {
            ROVehicleSimTreaded(SimObj).bLimitHighGear = false;

            bEngineDamaged = false;
            Message = ROVDMSG_EngineRepaired;
            if( !bEngineDestroyed )
            {
                ReplaceLoopingAudio(EngineSound, EngineSoundEvent);
                // SoundCue backport.
                ReplaceLoopingAudioCustom(EngineSoundCustom, EngineIdleSoundCustom);
            }
        }
        else if( VehHitZones[ZoneIndexUpdated].ZoneName == 'ENGINECORE' )
        {
            if ( Role == ROLE_Authority )
            {
                ClearScuttle();
            }

            bEngineDestroyed = false;
            StartEngineSound();
            Message = ROVDMSG_EngineRepaired;
        }
    }
    else if( VehHitZones[ZoneIndexUpdated].VehicleHitZoneType == VHT_Mechanicals )
    {
        if( VehHitZones[ZoneIndexUpdated].ZoneHealth > 0 )
        {
            if(  VehHitZones[ZoneIndexUpdated].ZoneName == 'GEARBOX' )
            {
                ROVehicleSimTreaded(SimObj).bLimitHighGear = false;

                bTransmissionDamaged = false;
                Message = ROVDMSG_TransRepaired;
            }
            else if( VehHitZones[ZoneIndexUpdated].ZoneName == 'GEARBOXCORE' )
            {
                ROVehicleSimTreaded(SimObj).bLimitHighGear = false;
                DetachBrokenTransmissionSound();

                bTransmissionDestroyed = false;
                Message = ROVDMSG_TransRepaired;
            }
            else if( VehHitZones[ZoneIndexUpdated].ZoneName == 'LEFTBRAKES' )
            {
                bLeftBrakeDestroyed = false;
                Message = ROVDMSG_LBrakeRepaired;

                if( VehHitZones[ZoneIndexUpdated].ZoneHealth == default.VehHitZones[ZoneIndexUpdated].ZoneHealth )
                {
                    bLeftBrakeDamaged = false;
                }
            }
            else if( VehHitZones[ZoneIndexUpdated].ZoneName == 'RIGHTBRAKES' )
            {
                bRightBrakeDestroyed = false;
                Message = ROVDMSG_RBrakeRepaired;

                if( VehHitZones[ZoneIndexUpdated].ZoneHealth == default.VehHitZones[ZoneIndexUpdated].ZoneHealth )
                {
                    bRightBrakeDamaged = false;
                }
            }
            else if( VehHitZones[ZoneIndexUpdated].ZoneName == 'MAINCANNONREAR' )
            {
                if ( Role == ROLE_Authority )
                {
                    ClearScuttle();
                }

                Message = ROVDMSG_MainGunRepaired;
                bMainCannonDestroyed = false;

                CannonSeatIndex = Seats.Find('TurretVarPrefix',"Turret");

                // Enable the main gun
                if( CannonSeatIndex >= 0 && Seats[CannonSeatIndex].Gun != none )
                {
                    Seats[CannonSeatIndex].Gun.bPrimaryFireDisabled = false;
                }
            }
            else if( VehHitZones[ZoneIndexUpdated].ZoneName == 'COAXIALMG' )
            {
                Message = ROVDMSG_CoaxMGRepaired;
                bCoaxMGDestroyed = false;

                CannonSeatIndex = Seats.Find('TurretVarPrefix',"Turret");

                // Enable the coax MG
                if( CannonSeatIndex >= 0 && Seats[CannonSeatIndex].Gun != none )
                {
                    Seats[CannonSeatIndex].Gun.bAlternateFireDisabled = false;
                }
            }
            else if( VehHitZones[ZoneIndexUpdated].ZoneName == 'TRAVERSEMOTOR' )
            {
                Message = ROVDMSG_TraverseRepaired;
                bTraverseMoterDestroyed = false;

                CannonSeatIndex = Seats.Find('TurretVarPrefix',"Turret");

                // PCGamer TODO: Don't hard code this stuff!!! Hacked in for now - Ramm
                if( CannonSeatIndex >= 0 )
                {
                    Seats[CannonSeatIndex].TurretControllers[1].RepairMotor();
                }
            }
            else if( VehHitZones[ZoneIndexUpdated].ZoneName == 'TURRETRINGONE' ||
                VehHitZones[ZoneIndexUpdated].ZoneName == 'TURRETRINGTWO' ||
                VehHitZones[ZoneIndexUpdated].ZoneName == 'TURRETRINGTHREE' ||
                VehHitZones[ZoneIndexUpdated].ZoneName == 'TURRETRINGFOUR' ||
                VehHitZones[ZoneIndexUpdated].ZoneName == 'TURRETRINGFIVE' ||
                VehHitZones[ZoneIndexUpdated].ZoneName == 'TURRETRINGSIX' )
            {
                if ( Role == ROLE_Authority )
                {
                    ClearScuttle();
                }

                Message = ROVDMSG_TurretRingRepaired;
                bTurretRingDisabled = false;

                CannonSeatIndex = Seats.Find('TurretVarPrefix',"Turret");

                // Disable turret rotation
                if( CannonSeatIndex >= 0 && Seats[CannonSeatIndex].Gun != none )
                {
                    Seats[CannonSeatIndex].Gun.bRotationDisabled = false;
                }
            }
        }
    }
    else if( VehHitZones[ZoneIndexUpdated].VehicleHitZoneType == VHT_Track )
    {
        if( VehHitZones[ZoneIndexUpdated].ZoneHealth > 0 )
        {
            if( VehHitZones[ZoneIndexUpdated].ZoneName == 'LEFTTRACKONE' ||
                VehHitZones[ZoneIndexUpdated].ZoneName == 'LEFTTRACKTWO' )
            {
                Message = ROVDMSG_LTrackRepaired;
                bLeftTrackDestroyed = false;

                if( VehHitZones[ZoneIndexUpdated].ZoneHealth == default.VehHitZones[ZoneIndexUpdated].ZoneHealth )
                {
                    ReplaceLoopingAudio(TrackLeftSound, TrackLeftSoundEvent);
                    bLeftTrackDamaged = false;
                }
            }
            else if( VehHitZones[ZoneIndexUpdated].ZoneName == 'RIGHTTRACKONE' ||
                VehHitZones[ZoneIndexUpdated].ZoneName == 'RIGHTTRACKTWO' )
            {
                Message = ROVDMSG_RTrackRepaired;
                bRightTrackDestroyed = false;

                if( VehHitZones[ZoneIndexUpdated].ZoneHealth == default.VehHitZones[ZoneIndexUpdated].ZoneHealth )
                {
                    ReplaceLoopingAudio(TrackRightSound, TrackRightSoundEvent);
                    bRightTrackDamaged = false;
                }
            }
            else if( VehHitZones[ZoneIndexUpdated].ZoneName == 'LEFTTURNINGWHEEL' )
            {
                Message = ROVDMSG_LSteerWheelRepaired;
                bLeftSteerWheelDestroyed = false;

                if( VehHitZones[ZoneIndexUpdated].ZoneHealth == default.VehHitZones[ZoneIndexUpdated].ZoneHealth )
                {
                    bLeftSteerWheelDamaged = false;
                }
            }
            else if( VehHitZones[ZoneIndexUpdated].ZoneName == 'RIGHTTURNINGWHEEL' )
            {
                Message = ROVDMSG_RSteerWheelRepaired;
                bRightSteerWheelDestroyed = false;

                if( VehHitZones[ZoneIndexUpdated].ZoneHealth == default.VehHitZones[ZoneIndexUpdated].ZoneHealth )
                {
                    bRightSteerWheelDamaged = false;
                }
            }
        }
    }
    else if( VehHitZones[ZoneIndexUpdated].VehicleHitZoneType == VHT_Ammo )
    {
        if ( VehHitZones[ZoneIndexUpdated].VisibleFrom <= 7 )
        {
             bLeftAmmoDestroyed = false;
             Message = ROVDMSG_AmmoStorageRepaired;
        }
        else
        {
             bRightAmmoDestroyed = false;
             Message = ROVDMSG_AmmoStorageRepaired;
        }
    }
    else if( VehHitZones[ZoneIndexUpdated].VehicleHitZoneType == VHT_Fuel )
    {
        if ( VehHitZones[ZoneIndexUpdated].VisibleFrom < 8 )
        {
             bLeftFuelTankDestroyed = false;
             Message = ROVDMSG_FuelTankRepaired;
        }
        else if ( VehHitZones[ZoneIndexUpdated].VisibleFrom < 15 )
        {
             bRightFuelTankDestroyed = false;
             Message = ROVDMSG_FuelTankRepaired;
        }
        else
        {
             bCenterFuelTankDestroyed = false;
             Message = ROVDMSG_FuelTankRepaired;
        }
    }

    // Send the players in the tank damage messages
    if( Message >= 0 && Role == ROLE_Authority )
    {
        DamageMessageQueue[DamageMessageQueue.Length] = Message;

        if( !IsTimerActive('ProcessDamageMessageQueue') )
        {
            SetTimer(0.1, false, 'ProcessDamageMessageQueue');
        }
    }
}

simulated function bool CanEnterVehicle(Pawn P)
{
    return !bDeadVehicle && super.CanEnterVehicle(P);
}

/** Turn the vehicle interior visibility on or off. */
simulated function SetInteriorVisibility(bool bVisible)
{
    // local int i;

    super.SetInteriorVisibility(False);

    /*
    if ( bVisible && !bGeneratedInteriorMICs )
    {
        ReplacedInteriorMICs.AddItem(MaterialInstanceConstant(GetVehicleMeshAttachment('IntDriverSide1Component').GetMaterial(1)));
        ReplacedInteriorMICs.AddItem(MaterialInstanceConstant(GetVehicleMeshAttachment('IntDriverSide1Component').GetMaterial(2)));
        ReplacedInteriorMICs.AddItem(MaterialInstanceConstant(GetVehicleMeshAttachment('TurretComponent').GetMaterial(0)));
        ReplacedInteriorMICs.AddItem(MaterialInstanceConstant(GetVehicleMeshAttachment('TurretCuppolaComponent').GetMaterial(2)));

        for ( i = 0; i < ReplacedInteriorMICs.Length; i++ )
        {
            InteriorMICs[i] = new class'MaterialInstanceConstant';
            InteriorMICs[i].SetParent(ReplacedInteriorMICs[i]);
        }

        // Replace MIC for vehicle skeletal mesh
        ReplaceInteriorMICs(mesh);

        // Replcace MIC for the interior static mesh attachments
        ReplaceInteriorMICs(GetVehicleMeshAttachment('IntBodyComponent'));
        ReplaceInteriorMICs(GetVehicleMeshAttachment('IntMainAmmoComponent'));
        ReplaceInteriorMICs(GetVehicleMeshAttachment('IntHullSide1Component'));
        ReplaceInteriorMICs(GetVehicleMeshAttachment('IntDriverSide1Component'));
        ReplaceInteriorMICs(GetVehicleMeshAttachment('IntHullMGComponent'));
        ReplaceInteriorMICs(GetVehicleMeshAttachment('TurretComponent'));
        ReplaceInteriorMICs(GetVehicleMeshAttachment('TurretGunGaseComponent'));
        ReplaceInteriorMICs(GetVehicleMeshAttachment('TurretCuppolaComponent'));
        ReplaceInteriorMICs(GetVehicleMeshAttachment('TurretDetails1Component'));
        ReplaceInteriorMICs(GetVehicleMeshAttachment('TurretBasketComponent'));

        bGeneratedInteriorMICs = true;
    }
    */
}

DefaultProperties
{
    LeftTrackMaterialIndex=1
    RightTrackMaterialIndex=2
    CachedWheelRadius=15
}
