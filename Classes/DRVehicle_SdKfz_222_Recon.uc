class DRVehicle_SdKfz_222_Recon extends DRVehicleTransport
    abstract;

var array<MaterialInstanceConstant> ReplacedInteriorMICs;
var MaterialInstanceConstant        InteriorMICs[2];        // 0 = ...
var bool                            bGeneratedInteriorMICs;

var array<MaterialInstanceConstant> ReplacedExteriorMICs;
var MaterialInstanceConstant        ExteriorMICs[2];        // 0 = Exterior Texture...
var bool                            bGeneratedExteriorMICs;

var MaterialInterface DestroyedMaterial2;
var MaterialInterface DestroyedMaterial3;

// Replicated information about the passenger positions
var repnotify byte PassengerOneCurrentPositionIndex;
var repnotify bool bDrivingPassengerOne;

/** Seat proxy death hit info */
var repnotify TakeHitInfo DeathHitInfo_ProxyDriver;
var repnotify TakeHitInfo DeathHitInfo_ProxyHullMG;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassOne;

replication
{
    if (bNetDirty)
        PassengerOneCurrentPositionIndex,bDrivingPassengerOne,DeathHitInfo_ProxyDriver,
        DeathHitInfo_ProxyHullMG, DeathHitInfo_ProxyPassOne;
}

simulated event PostBeginPlay()
{
    local int i;

    super.PostBeginPlay();

    if ( !bGeneratedExteriorMICs )
    {
        ReplacedExteriorMICs.AddItem(MaterialInstanceConstant(Mesh.GetMaterial(0)));

        for ( i = 0; i < ReplacedExteriorMICs.Length; i++ )
        {
            ExteriorMICs[i] = new class'MaterialInstanceConstant';
            ExteriorMICs[i].SetParent(ReplacedExteriorMICs[i]);
        }

        ReplaceExteriorMICs(GetVehicleMeshAttachment('ExtBodyComponent'));
        ReplaceExteriorMICs(Mesh);

        bGeneratedExteriorMICs = true;
    }

    if ( !bGeneratedInteriorMICs )
    {
        ReplacedInteriorMICs.AddItem(MaterialInstanceConstant(GetVehicleMeshAttachment('IntBodyComponent').GetMaterial(0)));
        ReplacedInteriorMICs.AddItem(MaterialInstanceConstant(GetVehicleMeshAttachment('IntBodyComponent').GetMaterial(1)));

        for ( i = 0; i < ReplacedInteriorMICs.Length; i++ )
        {
            InteriorMICs[i] = new class'MaterialInstanceConstant';
            InteriorMICs[i].SetParent(ReplacedInteriorMICs[i]);
        }

        // Replace MIC for vehicle skeletal mesh
        ReplaceInteriorMICs(mesh);

        // Replace MIC for the interior static mesh attachments
        ReplaceInteriorMICs(GetVehicleMeshAttachment('IntBodyComponent'));

        bGeneratedInteriorMICs = true;
    }

    if( WorldInfo.NetMode != NM_DedicatedServer )
    {
        mesh.MinLodModel = 1;
    }
}

/**
 * This event is triggered when a repnotify variable is received
 *
 * @param   VarName     The name of the variable replicated
 */
simulated event ReplicatedEvent(name VarName)
{
    
    if (VarName == 'DeathHitInfo_ProxyDriver')
    {
        PlaySeatProxyDeathHitEffects(0, DeathHitInfo_ProxyDriver);
    }
    else if (VarName == 'DeathHitInfo_ProxyHullMG')
    {
        PlaySeatProxyDeathHitEffects(1, DeathHitInfo_ProxyHullMG);
    }
    else if (VarName == 'DeathHitInfo_ProxyPassOne')
    {
        PlaySeatProxyDeathHitEffects(2, DeathHitInfo_ProxyPassOne);
    }
    else
    {
       super.ReplicatedEvent(VarName);
    }
}

/** Turn the vehicle interior visibility on or off. */
simulated function SetInteriorVisibility(bool bVisible)
{
    local int i;

    super.SetInteriorVisibility(bVisible);

    if ( bVisible && !bGeneratedInteriorMICs )
    {
        ReplacedInteriorMICs.AddItem(MaterialInstanceConstant(GetVehicleMeshAttachment('IntBodyComponent').GetMaterial(0)));
        ReplacedInteriorMICs.AddItem(MaterialInstanceConstant(GetVehicleMeshAttachment('IntBodyComponent').GetMaterial(1)));

        for ( i = 0; i < ReplacedInteriorMICs.Length; i++ )
        {
            InteriorMICs[i] = new class'MaterialInstanceConstant';
            InteriorMICs[i].SetParent(ReplacedInteriorMICs[i]);
        }

        // Replace MIC for vehicle skeletal mesh
        ReplaceInteriorMICs(mesh);

        // Replace MIC for the interior static mesh attachments
        ReplaceInteriorMICs(GetVehicleMeshAttachment('IntBodyComponent'));

        bGeneratedInteriorMICs = true;
    }
}

simulated function ReplaceInteriorMICs(MeshComponent MeshComp)
{
    local MaterialInterface MeshMaterial;
    local int i, j;

    for ( i = 0; i < MeshComp.GetNumElements(); i++ )
    {
        MeshMaterial = MeshComp.GetMaterial(i);

        if ( MeshMaterial != none )
        {
            for ( j = 0; j < ReplacedInteriorMICs.Length; j++ )
            {
                if ( MeshMaterial == ReplacedInteriorMICs[j] )
                {
                    MeshComp.SetMaterial(i, InteriorMICs[j]);
                }
            }
        }
    }
}

simulated function ReplaceExteriorMICs(MeshComponent MeshComp)
{
    local MaterialInterface MeshMaterial;
    local int i, j;

    for ( i = 0; i < MeshComp.GetNumElements(); i++ )
    {
        MeshMaterial = MeshComp.GetMaterial(i);

        if ( MeshMaterial != none )
        {
            for ( j = 0; j < ReplacedExteriorMICs.Length; j++ )
            {
                if ( MeshMaterial == ReplacedExteriorMICs[j] )
                {
                    MeshComp.SetMaterial(i, ExteriorMICs[j]);
                }
            }
        }
    }
}

/** Leave blood splats on a specific area in a vehicle
 * @param InSeatIndex The seat around which we should leave blood splats
 */
simulated function LeaveBloodSplats(int InSeatIndex)
{
    if( InSeatIndex < Seats.Length )
    {
        // This vehicle only has one interior mesh with two MIC indexes so just set them for the whole thing
        InteriorMICs[0].SetScalarParameterValue(Seats[InSeatIndex].VehicleBloodMICParameterName, 1.0);
        InteriorMICs[1].SetScalarParameterValue(Seats[InSeatIndex].VehicleBloodMICParameterName, 1.0);
        // This vehicle is open, so set gore on exterior mesh as well for external viewers
        ExteriorMICs[0].SetScalarParameterValue(Seats[InSeatIndex].VehicleBloodMICParameterName, 1.0);
    }
}

// Overridden to no
simulated exec function SwitchFireMode()
{
    //no
}

//Redefined in ROVehicle_Halftrack to disable the tracks in the simulation
simulated function DisableLeftTrack()
{
    local ROVehicleSimHalftrack ROVSH;
    ROVSH = ROVehicleSimHalftrack(SimObj);
    if(ROVSH != none)
    {
        ROVSH.bLeftTrackDestroyed = true;
    }
}
//Redefined in ROVehicle_Halftrack to disable the tracks in the simulation
simulated function DisableRightTrack()
{
    local ROVehicleSimHalftrack ROVSH;
    ROVSH = ROVehicleSimHalftrack(SimObj);
    if(ROVSH != none)
    {
        ROVSH.bRightTrackDestroyed = true;
    }
}

//Redefined in ROVehicle_Halftrack to disable the turning wheel in the simulation
simulated function DisableRightTurningWheel()
{
    if(Wheels[1] != none)
    {
        Wheels[1].SteerFactor = 0.0f;
    }
}

//Redefined in ROVehicle_Halftrack to disable the turning wheel in the simulation
simulated function DisableLeftTurningWheel()
{
    if(Wheels[3] != none)
    {
        Wheels[3].SteerFactor = 0.0f;
    }
}

// SdkFz has unusual texture slots for the destroyed mesh. Handle it here.
simulated state DyingVehicle
{
    /** client-side only effects */
    simulated function PlayDeathEffects()
    {
        SwapToDestroyedMesh();

        if ( DestroyedMaterial != none )
        {
            Mesh.SetMaterial(0, DestroyedMaterial);
        }

        if ( DestroyedMaterial2 != none )
        {
            Mesh.SetMaterial(1, DestroyedMaterial2);
        }

        if ( DestroyedMaterial3 != none )
        {
            Mesh.SetMaterial(2, DestroyedMaterial3);
        }

        // need to set this here because ReplaceInteriorMICs() will override the default
        if ( DestroyedFXMaterial != none )
        {
            Mesh.SetMaterial(3, DestroyedFXMaterial);
        }

        PlayVehicleExplosion(false);

        VehicleEvent('Destroyed');
    }
}

/**
 * Handle giving damage to seat proxies
 * @param SeatProxyIndex the Index in the SeatProxies array of the Proxy to Damage
 * @param Damage the base damage to apply
 * @param InstigatedBy the Controller responsible for the damage
 * @param HitLocation world location where the hit occurred
 * @param Momentum force caused by this hit
 * @param DamageType class describing the damage that was done
 * @param DamageCauser the Actor that directly caused the damage (i.e. the Projectile that exploded, the Weapon that fired, etc)
 */
function DamageSeatProxy(int SeatProxyIndex, int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional Actor DamageCauser)
{
    // Update the hit info for each seat proxy pertaining to this vehicle
    switch( SeatProxyIndex )
    {
    case 0:
        // Driver
        DeathHitInfo_ProxyDriver.Damage = Damage;
        DeathHitInfo_ProxyDriver.HitLocation = HitLocation;
        DeathHitInfo_ProxyDriver.Momentum = Momentum;
        DeathHitInfo_ProxyDriver.DamageType = DamageType;
        break;
    
    case 1:
        // HullMG
        DeathHitInfo_ProxyHullMG.Damage = Damage;
        DeathHitInfo_ProxyHullMG.HitLocation = HitLocation;
        DeathHitInfo_ProxyHullMG.Momentum = Momentum;
        DeathHitInfo_ProxyHullMG.DamageType = DamageType;
        break;
    case 2:
        // Passenger One
        DeathHitInfo_ProxyPassOne.Damage = Damage;
        DeathHitInfo_ProxyPassOne.HitLocation = HitLocation;
        DeathHitInfo_ProxyPassOne.Momentum = Momentum;
        DeathHitInfo_ProxyPassOne.DamageType = DamageType;
        break;
    }

    // Call super!
    Super.DamageSeatProxy(SeatProxyIndex, Damage, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}

DefaultProperties
{
    Health=450
    Team=`AXIS_TEAM_INDEX

    bOpenVehicle=true

    ExitRadius=180
    ExitOffset=(X=-150,Y=0,Z=0)

    Begin Object Name=CollisionCylinder
        CollisionHeight=0.0
        CollisionRadius=260.0
        Translation=(X=0.0,Y=0.0,Z=0.0)
    End Object
    CylinderComponent=CollisionCylinder

    bDontUseCollCylinderForRelevancyCheck=true
    RelevancyHeight=0.0
    RelevancyRadius=175.0

    Begin Object class=PointLightComponent name=InteriorLight_0
        Radius=100.0
        LightColor=(R=255,G=170,B=130)
        UseDirectLightMap=FALSE
        Brightness=1.0
        LightingChannels=(Unnamed_1=TRUE,BSP=FALSE,Static=FALSE,Dynamic=FALSE,CompositeDynamic=FALSE)
    End Object

    Begin Object class=PointLightComponent name=InteriorLight_1
        Radius=100.0
        LightColor=(R=255,G=170,B=130)
        UseDirectLightMap=FALSE
        Brightness=1.0
        LightingChannels=(Unnamed_1=TRUE,BSP=FALSE,Static=FALSE,Dynamic=FALSE,CompositeDynamic=FALSE)
    End Object

    VehicleLights(0)={(AttachmentName=InteriorLightComponent0,Component=InteriorLight_0,bAttachToSocket=true,AttachmentTargetName=interior_light_0)}
    VehicleLights(1)={(AttachmentName=InteriorLightComponent1,Component=InteriorLight_1,bAttachToSocket=true,AttachmentTargetName=interior_light_1)}

    Seats(0)={(
        CameraTag=Driver_Camera,
        CameraOffset=-420,
        SeatAnimBlendName=DriverPositionNode,
        bSeatVisible=false,
        SeatBone=Chassis,
        DriverDamageMult=1.0,
        InitialPositionIndex=0,
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        VehicleBloodMICParameterName=Gore02,
        // SeatIconPos=(X=0.33,Y=0.35),
        // MuzzleFlashLightClass=class'UTTankMuzzleFlash',
        // WeaponEffects=((SocketName=TurretFireSocket,Offset=(X=-125),Scale3D=(X=14.0,Y=10.0,Z=10.0))),
        SeatPositions=
        (
            /*
            // 0
            (
                bDriverVisible=true,
                bAllowFocus=true,
                PositionCameraTag=None,
                ViewFOV=70.0,
                PositionUpAnim=Driver_open,
                PositionIdleAnim=Driver_open_idle,
                DriverIdleAnim=Driver_open_idle,
                AlternateIdleAnim=Driver_open_idle_AI,
                SeatProxyIndex=0,
                bIsExterior=true,
                LeftHandIKInfo=(PinEnabled=true),
                RightHandIKInfo=(PinEnabled=true),
                HipsIKInfo=(PinEnabled=true),
                PositionFlinchAnims=(Driver_open_Flinch),
                PositionDeathAnims=(Driver_open_Death)
            ),

            // 1
            (
                bDriverVisible=false,
                bAllowFocus=true,
                PositionCameraTag=None,
                ViewFOV=70.0,
                PositionUpAnim=Driver_portTOclose,
                PositionDownAnim=Driver_close,
                PositionIdleAnim=Driver_close_idle,
                DriverIdleAnim=Driver_close_idle,
                AlternateIdleAnim=Driver_close_idle_AI,
                SeatProxyIndex=0,
                LeftHandIKInfo=
                (
                    IKEnabled=true,
                    DefaultEffectorLocationTargetName=DriverLeftLever,
                    DefaultEffectorRotationTargetName=DriverLeftLever
                ),
                RightHandIKInfo=
                (
                    IKEnabled=true,
                    DefaultEffectorLocationTargetName=DriverRightLever,
                    DefaultEffectorRotationTargetName=DriverRightLever,
                    AlternateEffectorTargets=((
                        Action=DAct_ShiftGears,
                        IKEnabled=true,
                        EffectorLocationTargetName=DriverClutchLever,
                        EffectorRotationTargetName=DriverClutchLever
                    ))
                ),
                LeftFootIKInfo=
                (
                    IKEnabled=false,
                    AlternateEffectorTargets=((
                        Action=DAct_ShiftGears,
                        IKEnabled=true,
                        EffectorLocationTargetName=DriverBreakPedal,
                        EffectorRotationTargetName=DriverBreakPedal
                    ))
                ),
                RightFootIKInfo=
                (
                    IKEnabled=true,
                    DefaultEffectorLocationTargetName=DriverGasPedal,
                    DefaultEffectorRotationTargetName=DriverGasPedal
                ),
                HipsIKInfo=(PinEnabled=true),
                PositionFlinchAnims=(Driver_close_Flinch),
                PositionDeathAnims=(Driver_close_Death),
                PositionInteractions=((
                    InteractionIdleAnim=Driver_sideport_Idle,
                    StartInteractionAnim=Driver_closeTOsideport,
                    EndInteractionAnim=Driver_sideportTOclose,
                    FlinchInteractionAnim=Driver_sideport_Flinch,
                    ViewFOV=70,
                    bAllowFocus=true,
                    InteractionSocketTag=DriverLeftViewPort,
                    InteractDotAngle=0.95,
                    bUseDOF=true
                ))
            ),
            */

            // 0 (old 2)
            (
                bDriverVisible=false,
                bAllowFocus=false,
                PositionCameraTag=Driver_Camera,
                ViewFOV=70.0,
                bViewFromCameraTag=true,
                bDrawOverlays=true,
                PositionDownAnim=Driver_close_idle,
                PositionIdleAnim=Driver_close_idle,
                DriverIdleAnim=Driver_close_idle,
                AlternateIdleAnim=Driver_close_idle,
                SeatProxyIndex=`CRUSADER_DRIVER_SPI,
                LeftHandIKInfo=
                (
                    IKEnabled=false,
                    /*
                    DefaultEffectorLocationTargetName=DriverLeftLever,
                    DefaultEffectorRotationTargetName=DriverLeftLever
                    */
                ),
                RightHandIKInfo=
                (
                    IKEnabled=false,
                    /*
                    DefaultEffectorLocationTargetName=DriverRightLever,
                    DefaultEffectorRotationTargetName=DriverRightLever,
                    AlternateEffectorTargets=((
                        Action=DAct_ShiftGears,
                        IKEnabled=false,
                        EffectorLocationTargetName=DriverClutchLever,
                        EffectorRotationTargetName=DriverClutchLever
                    ))
                    */
                ),
                LeftFootIKInfo=
                (
                    IKEnabled=false,
                    /*
                    AlternateEffectorTargets=((
                        Action=DAct_ShiftGears,
                        IKEnabled=false,
                        EffectorLocationTargetName=DriverBreakPedal,
                        EffectorRotationTargetName=DriverBreakPedal
                    ))
                    */
                ),
                RightFootIKInfo=
                (
                    IKEnabled=false,
                    /*
                    DefaultEffectorLocationTargetName=DriverGasPedal,
                    DefaultEffectorRotationTargetName=DriverGasPedal
                    */
                ),
                PositionFlinchAnims=(Driver_close_idle),
                PositionDeathAnims=(Driver_close_idle)
            )
        )
    )}



    // PassengerAnimTree=AnimTree'CHR_Playeranimtree_Master.CHR_Tanker_animtree'
    // CrewAnimSet=AnimSet'WF_Vehicles_Jeep50Cal.Anims.CHR_Jeep_Anims'

    LeftSteerableWheelIndex=0
    RightSteerableWheelIndex=0
    LeftSteerableSimWheelIndex=3
    RightSteerableSimWheelIndex=1
    MaxVisibleSteeringAngle=45.0

    LeftWheels.Empty
    RightWheels.Empty

    LeftWheels(0)="L_Wheel_00"
    LeftWheels(1)="L_Wheel_01"
    //
    RightWheels(0)="R_Wheel_00"
    RightWheels(1)="R_Wheel_01"

    /** Physics Wheels */
    Wheels.Empty

    // Right Rear Wheel
    Begin Object Name=RRWheel
        BoneName="R_Wheel_01"
        BoneOffset=(X=0.0,Y=0.0,Z=-10.0)
        WheelRadius=22
        SteerFactor=-0.1
        SuspensionTravel=25
        bPoweredWheel=True
    End Object
    Wheels(0)=RRWheel

    // Right Front Wheel
    Begin Object Name=RFWheel
        BoneName="R_Wheel_00"
        BoneOffset=(X=0.0,Y=0.0,Z=-10.0)
        WheelRadius=22
        SteerFactor=1.0
        SuspensionTravel=25
        bPoweredWheel=True
    End Object
    Wheels(1)=RFWheel

    // Left Rear Wheel
    Begin Object Name=LRWheel
        BoneName="L_Wheel_01"
        BoneOffset=(X=0.0,Y=0.0,Z=-10.0)
        WheelRadius=22
        SteerFactor=-0.1
        SuspensionTravel=25
        bPoweredWheel=True
    End Object
    Wheels(2)=LRWheel

    // Left Front Wheel
    Begin Object Name=LFWheel
        BoneName="L_Wheel_00"
        BoneOffset=(X=0.0,Y=0.0,Z=-10.0)
        WheelRadius=22
        SteerFactor=1.0
        SuspensionTravel=25
        bPoweredWheel=True
    End Object
    Wheels(3)=LFWheel

    Begin Object class=ROVehicleSimHalftrack Name=SimObjectHalfTrack
        WheelSuspensionStiffness=350
        WheelSuspensionDamping=25.0
        WheelSuspensionBias=0.1
        WheelLongExtremumSlip=1.5
        ChassisTorqueScale=1.0//0.0
        StopThreshold=50
        EngineBrakeFactor=0.00001
        EngineDamping=2.0
        InsideTrackTorqueFactor=0.4
        TurnInPlaceThrottle=0.0
        CollisionGripFactor=0.18
        TurnMaxGripReduction=0.9//995//0.97
        TurnGripScaleRate=1.0
        MaxEngineTorque=15000//7800.0
        EqualiseTrackSpeed=30.0//10.0
        MaxTreadSteerAngleCurve=(Points=((InVal=0,OutVal=0),(InVal=200.0,OutVal=0.0),(InVal=300.0,OutVal=1.0),(InVal=500.0,OutVal=1.2),(InVal=1500.0,OutVal=1.5)))
        MaxSteerAngleCurve=(Points=((InVal=0,OutVal=30.0f),(InVal=200.0,OutVal=25.0),(InVal=300.0,OutVal=20.0),(InVal=500.0,OutVal=15),(InVal=1500.0,OutVal=10)))
        //MaxSteerAngleCurve=(Points=((InVal=0,OutVal=45),(InVal=600.0,OutVal=15.0),(InVal=1100.0,OutVal=10.0),(InVal=1300.0,OutVal=6.0),(InVal=1600.0,OutVal=1.0)))
        bTurnInPlaceOnSteer=False
        SteerSpeed=40
        TurningLongSlipFactor=500
        // Transmission - GearData
        ShiftingThrottle=0.71
        ChangeUpPoint=2650.000000
        ChangeDownPoint=700.000000
        GearShiftSlopeThreshold=0.25
        GearShiftDownSlopeThreshold=0.3
        SteepHillTopGear=2
        MinTimeAtChangePoint=0.9
        GearArray(0)={(
            GearRatio=-5.64,
            AccelRate=10.25,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=-2500),
                (InVal=300,OutVal=-1750),
                (InVal=2800,OutVal=-2500),
                (InVal=3000,OutVal=-1000),
                (InVal=3200,OutVal=-0.0)
                )}),
            TurningThrottle=1.0
            )}
        GearArray(1)={(
            // [N/A]  reserved for neutral
            )}
        GearArray(2)={(
            // Real world - [4.37] ~10.0 kph
            GearRatio=5.0,
            AccelRate=6.50,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=2500),
                (InVal=300,OutVal=2750),
                (InVal=2800,OutVal=5000),
                (InVal=3000,OutVal=1500),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=1.0
            )}
        GearArray(3)={(
            // Real world - [2.18] ~20.0 kph
            GearRatio=3.5,
            AccelRate=5.00,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=4000),
                (InVal=2800,OutVal=8200),
                (InVal=3000,OutVal=2800),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=1.0
            )}
        GearArray(4)={(
            // Real world - [1.46] ~30.0 kph
            GearRatio=2.25,
            AccelRate=4.50,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=5000),
                (InVal=2800,OutVal=12700),
                (InVal=3000,OutVal=5000),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=1.0
            )}
        GearArray(5)={(
            // Real world - [1.09] ~40.0 kph
            GearRatio=1.95,
            AccelRate=4.00,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=6500),
                (InVal=2800,OutVal=16200),
                (InVal=3000,OutVal=8000),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=1.0
            )}
        // Transmission - Misc
        FirstForwardGear=2
    End Object
    Components.Remove(SimObject)
    SimObj=SimObjectHalfTrack
    Components.Add(SimObjectHalfTrack)

    bInfantryCanUse=true

    DrivingPhysicalMaterial=PhysicalMaterial'DR_VH_DAK_PanzerIV_F.Phys.PhysMat_PanzerIVG'
    DefaultPhysicalMaterial=PhysicalMaterial'DR_VH_DAK_PanzerIV_F.Phys.PhysMat_PanzerIVG_Moving'

    TreadSpeedParameterName=Tank_Tread_Speed
    TrackSoundParamScale=0.000033
    TreadSpeedScale=2.5

    /*
    RPM3DGaugeMaxAngle=52793
    EngineIdleRPM=0 // Lowest marker on visible speedo is 300
    EngineNormalRPM=2700
    EngineMaxRPM=3500 // 3200+300
    Speedo3DGaugeMaxAngle=101944 //50972 // HUD speedo goes to 100, physical only does 50, so divide this value by 0.5
    EngineOil3DGaugeMinAngle=12000
    EngineOil3DGaugeMaxAngle=29768
    EngineOil3DGaugeDamageAngle=4096
    GearboxOil3DGaugeMinAngle=15000
    GearboxOil3DGaugeNormalAngle=22500
    GearboxOil3DGaugeMaxAngle=32768
    GearboxOil3DGaugeDamageAngle=5000
    EngineTemp3DGaugeNormalAngle=10923
    EngineTemp3DGaugeEngineDamagedAngle=16748
    EngineTemp3DGaugeFireDamagedAngle=20025
    EngineTemp3DGaugeFireDestroyedAngle=22756
    */

    // Muzzle Flashes
    VehicleEffects(TankVFX_Firing1)=(EffectStartTag=HTHullMG,EffectTemplate=ParticleSystem'FX_MuzzleFlashes.Emitters.muzzleflash_3rdP',EffectSocket=MG_Barrel)
    // Shell Ejects
    VehicleEffects(TankVFX_Firing2)=(EffectStartTag=HTHullMG,EffectTemplate=ParticleSystem'FX_Vehicles_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_MG34_HT',EffectSocket=MG_ShellEject,bInteriorEffect=true,bNoKillOnRestart=true)
    // Driving effects
    VehicleEffects(TankVFX_Exhaust)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,EffectTemplate=ParticleSystem'FX_Vehicles_Two.SDKfZ.FX_SdKfz_exhaust',EffectSocket=Exhaust)
    VehicleEffects(TankVFX_TreadWing)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bStayActive=true,EffectTemplate=ParticleSystem'FX_VEH_Tank_Three.FX_VEH_Tank_A_Wing_Dirt_T34',EffectSocket=FX_Master)
    // Damage
    VehicleEffects(TankVFX_DmgSmoke)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'FX_Vehicles_Two.SDKfZ.FX_SdKfz_damaged_burning_new',EffectSocket=attachments_engine)
    VehicleEffects(TankVFX_DmgInterior)=(EffectStartTag=DamageInterior,EffectEndTag=NoInternalSmoke,bRestartRunning=false,bInteriorEffect=true,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_Interior_Penetrate',EffectSocket=attachments_body)
    // Death
    VehicleEffects(TankVFX_DeathSmoke1)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke1)
    VehicleEffects(TankVFX_DeathSmoke2)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke2)
    VehicleEffects(TankVFX_DeathSmoke3)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke3)

    BigExplosionSocket=FX_Fire
    ExplosionTemplate=ParticleSystem'FX_Vehicles_Two.SDKfZ.FX_SdKfz_destroyed'

    ExplosionDamageType=class'RODmgType_VehicleExplosion'
    ExplosionDamage=100.0
    ExplosionRadius=300.0
    ExplosionMomentum=60000
    ExplosionInAirAngVel=1.5
    InnerExplosionShakeRadius=400.0
    OuterExplosionShakeRadius=1000.0
    ExplosionLightClass=class'ROGame.ROGrenadeExplosionLight'
    MaxExplosionLightDistance=4000.0
    TimeTilSecondaryVehicleExplosion=0//2.0f
    SecondaryExplosion=none//ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_C_Explosion_Ammo'
    bHasTurretExplosion=false

    EngineStartOffsetSecs=2.0
    EngineStopOffsetSecs=0.5

    ArmorTextureOffsets(0)=(PositionOffset=(X=36,Y=-3,Z=0),MySizeX=68,MYSizeY=68)
    ArmorTextureOffsets(1)=(PositionOffset=(X=36,Y=74,Z=0),MySizeX=68,MYSizeY=68)
    ArmorTextureOffsets(2)=(PositionOffset=(X=41,Y=36,Z=0),MySizeX=16,MYSizeY=74)
    ArmorTextureOffsets(3)=(PositionOffset=(X=81,Y=36,Z=0),MySizeX=16,MYSizeY=74)

    SprocketTextureOffsets(0)=(PositionOffset=(X=45,Y=44,Z=0),MySizeX=8,MYSizeY=16)
    SprocketTextureOffsets(1)=(PositionOffset=(X=86,Y=44,Z=0),MySizeX=8,MYSizeY=16)

    TransmissionTextureOffset=(PositionOffset=(X=51,Y=35,Z=0),MySizeX=38,MYSizeY=36)

    TreadTextureOffsets(0)=(PositionOffset=(X=36,Y=50,Z=0),MySizeX=8,MYSizeY=80)
    TreadTextureOffsets(1)=(PositionOffset=(X=94,Y=50,Z=0),MySizeX=8,MYSizeY=80)
    SteerWheelTextureOffsets(0)=(PositionOffset=(X=85,Y=12,Z=0),MySizeX=8,MYSizeY=16)
    SteerWheelTextureOffsets(1)=(PositionOffset=(X=45,Y=12,Z=0),MySizeX=8,MYSizeY=16)

    //AmmoStorageTextureOffsets(0)=(PositionOffset=(X=41,Y=56,Z=0),MySizeX=16,MYSizeY=16)
    //AmmoStorageTextureOffsets(1)=(PositionOffset=(X=82,Y=56,Z=0),MySizeX=16,MYSizeY=16)

    FuelTankTextureOffsets(0)=(PositionOffset=(X=62,Y=83,Z=0),MySizeX=16,MYSizeY=16)

    EngineTextureOffset=(PositionOffset=(X=58,Y=20,Z=0),MySizeX=24,MYSizeY=24)

    //CoaxMGTextureOffset=(PositionOffset=(X=+3,Y=-26,Z=0),MySizeX=6,MYSizeY=14)

    SeatTextureOffsets(0)=(PositionOffSet=(X=-9,Y=0,Z=0),bTurretPosition=0)
    SeatTextureOffsets(1)=(PositionOffSet=(X=0,Y=15,Z=0),bTurretPosition=0)
    SeatTextureOffsets(2)=(PositionOffSet=(X=13,Y=0,Z=0),bTurretPosition=0)

    SpeedoMinDegree=5461
    SpeedoMaxDegree=56000
    SpeedoMaxSpeed=1365 //100 km/h

    CabinL_FXSocket=Sound_Cabin_L
    CabinR_FXSocket=Sound_Cabin_R
    Exhaust_FXSocket=Exhaust
    TreadL_FXSocket=Sound_L
    TreadR_FXSocket=Sound_R

    //VehHitZones(2)=(ZoneName=MGAMMOBOX,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.4,VisibleFrom=8)

    VehHitZones(0)=(ZoneName=FUELTANK,DamageMultiplier=5.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=50,KillPercentage=0.3,VisibleFrom=15)
    VehHitZones(1)=(ZoneName=GEARBOX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=20,VisibleFrom=15)
    VehHitZones(2)=(ZoneName=ENGINEBLOCK,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=20,VisibleFrom=13)

    VehHitZones(3)=(ZoneName=PASSBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=2,SeatProxyIndex=2,CrewBoneName=Passanger1Body)
    VehHitZones(4)=(ZoneName=PASSHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=2,SeatProxyIndex=2,CrewBoneName=Passanger1Head)
    
    VehHitZones(5)=(ZoneName=MGGUNNERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=Passanger2Head)
    VehHitZones(6)=(ZoneName=MGGUNNERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=Passanger2Body)

    VehHitZones(7)=(ZoneName=DRIVERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=DriverHitbox)
    VehHitZones(8)=(ZoneName=DRIVERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=DRIVERHEAD)

    VehHitZones(9)=(ZoneName=LEFTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=100)
    VehHitZones(10)=(ZoneName=RIGHTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=100)
    VehHitZones(11)=(ZoneName=LEFTTURNINGWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=100)
    VehHitZones(12)=(ZoneName=RIGHTTURNINGWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=100)

    CrewHitZoneStart=3
    CrewHitZoneEnd=8

    ArmorHitZones(0)=(ZoneName=FRONTRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHT)
    ArmorHitZones(1)=(ZoneName=FRONTLEFT,PhysBodyBoneName=Chassis,ArmorPlateName=LEFT)
    ArmorHitZones(2)=(ZoneName=BACKLEFT,PhysBodyBoneName=Chassis,ArmorPlateName=LEFT)
    ArmorHitZones(3)=(ZoneName=BACKRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHT)
    ArmorHitZones(4)=(ZoneName=back,PhysBodyBoneName=Chassis,ArmorPlateName=BACK)
    ArmorHitZones(5)=(ZoneName=TOPFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=TOP)
    ArmorHitZones(6)=(ZoneName=Front,PhysBodyBoneName=Chassis,ArmorPlateName=FRONT)
    ArmorHitZones(7)=(ZoneName=UNDERPLATE,PhysBodyBoneName=Chassis,ArmorPlateName=UNDER)
    ArmorHitZones(8)=(ZoneName=BACKTOP,PhysBodyBoneName=Chassis,ArmorPlateName=TOP)

    ArmorPlates(0)=(PlateName=TOP,ArmorZoneType=AZT_Roof,PlateThickness=5,OverallHardness=400,bHighHardness=true)
    ArmorPlates(1)=(PlateName=LEFT,ArmorZoneType=AZT_Left,PlateThickness=5,OverallHardness=400,bHighHardness=true)
    ArmorPlates(2)=(PlateName=RIGHT,ArmorZoneType=AZT_Right,PlateThickness=5,OverallHardness=400,bHighHardness=true)
    ArmorPlates(3)=(PlateName=FRONT,ArmorZoneType=AZT_Front,PlateThickness=5,OverallHardness=400,bHighHardness=false)
    ArmorPlates(4)=(PlateName=BACK,ArmorZoneType=AZT_Back,PlateThickness=5,OverallHardness=400,bHighHardness=true)
    ArmorPlates(5)=(PlateName=UNDER,ArmorZoneType=AZT_Floor,PlateThickness=5,OverallHardness=400,bHighHardness=true)

    MaxSpeed=1000   // Faster than 53 km/h, 723

    bDestroyedTracksCauseTurn=false

    RanOverDamageType=WFDmgType_RunOverJeep
    TransportType=ROTT_Halftrack
}
