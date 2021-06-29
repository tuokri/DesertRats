class DRVehicle_SdKfz_251_Halftrack extends DRVehicleTransport
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
var repnotify byte PassengerTwoCurrentPositionIndex;
var repnotify bool bDrivingPassengerTwo;
var repnotify byte PassengerThreeCurrentPositionIndex;
var repnotify bool bDrivingPassengerThree;
var repnotify byte PassengerFourCurrentPositionIndex;
var repnotify bool bDrivingPassengerFour;
var repnotify byte PassengerFiveCurrentPositionIndex;
var repnotify bool bDrivingPassengerFive;
var repnotify byte PassengerSixCurrentPositionIndex;
var repnotify bool bDrivingPassengerSix;

/** Seat proxy death hit info */
var repnotify TakeHitInfo DeathHitInfo_ProxyDriver;
var repnotify TakeHitInfo DeathHitInfo_ProxyHullMG;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassOne;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassTwo;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassThree;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassFour;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassFive;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassSix;

replication
{
    if (bNetDirty)
        PassengerOneCurrentPositionIndex, PassengerTwoCurrentPositionIndex,
        PassengerThreeCurrentPositionIndex, PassengerFourCurrentPositionIndex,
        PassengerFiveCurrentPositionIndex, PassengerSixCurrentPositionIndex,
        bDrivingPassengerOne,bDrivingPassengerTwo,bDrivingPassengerThree,
        bDrivingPassengerFour, bDrivingPassengerFive, bDrivingPassengerSix,
        DeathHitInfo_ProxyDriver, DeathHitInfo_ProxyHullMG, DeathHitInfo_ProxyPassOne,
        DeathHitInfo_ProxyPassTwo, DeathHitInfo_ProxyPassThree, DeathHitInfo_ProxyPassFour,
        DeathHitInfo_ProxyPassFive, DeathHitInfo_ProxyPassSix;
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
    else if (VarName == 'DeathHitInfo_ProxyPassTwo')
    {
        PlaySeatProxyDeathHitEffects(3, DeathHitInfo_ProxyPassTwo);
    }
    else if (VarName == 'DeathHitInfo_ProxyPassThree')
    {
        PlaySeatProxyDeathHitEffects(4, DeathHitInfo_ProxyPassThree);
    }
    else if (VarName == 'DeathHitInfo_ProxyPassFour')
    {
        PlaySeatProxyDeathHitEffects(5, DeathHitInfo_ProxyPassFour);
    }
    else if (VarName == 'DeathHitInfo_ProxyPassFive')
    {
        PlaySeatProxyDeathHitEffects(6, DeathHitInfo_ProxyPassFive);
    }
    else if (VarName == 'DeathHitInfo_ProxyPassSix')
    {
        PlaySeatProxyDeathHitEffects(7, DeathHitInfo_ProxyPassSix);
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

// Overridden to switch to the 6th seat position instead of changing fire mode
simulated exec function SwitchFireMode()
{
    ServerChangeSeat(5);
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
    if(Wheels[2] != none)
    {
        Wheels[2].SteerFactor = 0.0f;
    }
}

//Redefined in ROVehicle_Halftrack to disable the turning wheel in the simulation
simulated function DisableLeftTurningWheel()
{
    if(Wheels[5] != none)
    {
        Wheels[5].SteerFactor = 0.0f;
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
    case 3:
        // Passenger Two
        DeathHitInfo_ProxyPassTwo.Damage = Damage;
        DeathHitInfo_ProxyPassTwo.HitLocation = HitLocation;
        DeathHitInfo_ProxyPassTwo.Momentum = Momentum;
        DeathHitInfo_ProxyPassTwo.DamageType = DamageType;
        break;
    case 4:
        // Passenger Three
        DeathHitInfo_ProxyPassThree.Damage = Damage;
        DeathHitInfo_ProxyPassThree.HitLocation = HitLocation;
        DeathHitInfo_ProxyPassThree.Momentum = Momentum;
        DeathHitInfo_ProxyPassThree.DamageType = DamageType;
        break;
    case 5:
        // Passenger Four
        DeathHitInfo_ProxyPassFour.Damage = Damage;
        DeathHitInfo_ProxyPassFour.HitLocation = HitLocation;
        DeathHitInfo_ProxyPassFour.Momentum = Momentum;
        DeathHitInfo_ProxyPassFour.DamageType = DamageType;
        break;
    case 6:
        // Passenger Five
        DeathHitInfo_ProxyPassFive.Damage = Damage;
        DeathHitInfo_ProxyPassFive.HitLocation = HitLocation;
        DeathHitInfo_ProxyPassFive.Momentum = Momentum;
        DeathHitInfo_ProxyPassFive.DamageType = DamageType;
        break;
    case 7:
        // Passenger Six
        DeathHitInfo_ProxyPassSix.Damage = Damage;
        DeathHitInfo_ProxyPassSix.HitLocation = HitLocation;
        DeathHitInfo_ProxyPassSix.Momentum = Momentum;
        DeathHitInfo_ProxyPassSix.DamageType = DamageType;
        break;
    }

    // Call super!
    Super.DamageSeatProxy(SeatProxyIndex, Damage, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}

DefaultProperties
{
    Health=1000
    Team=`AXIS_TEAM_INDEX

    bOpenVehicle=true

    ExitRadius=180
    ExitOffset=(X=-150,Y=0,Z=0)

    Begin Object Name=CollisionCylinder
        CollisionHeight=60.0
        CollisionRadius=260.0
        Translation=(X=0.0,Y=0.0,Z=0.0)
    End Object
    CylinderComponent=CollisionCylinder

    bDontUseCollCylinderForRelevancyCheck=true
    RelevancyHeight=90.0
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

    Seats(0)={( CameraTag=none,
                CameraOffset=-420,
                SeatAnimBlendName=DriverPositionNode,
                                // Open, leaning forward
                SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=70.0,PositionUpAnim=Driver_LeanIN_open,PositionIdleAnim=Driver_LeanIN_open_Idle,DriverIdleAnim=Driver_LeanIN_open_Idle,AlternateIdleAnim=Driver_LeanIN_open_Idle_AI,SeatProxyIndex=0,
                                    bIsExterior=true,
                                    LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverLeftSteer,DefaultEffectorRotationTargetName=IK_DriverLeftSteer),
                                    RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverRightSteer,DefaultEffectorRotationTargetName=IK_DriverRightSteer,
                                        AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchLever,EffectorRotationTargetName=IK_DriverClutchLever))),
                                    LeftFootIKInfo=(IKEnabled=false,
                                        AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchPedal,EffectorRotationTargetName=IK_DriverClutchPedal))),
                                    RightFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverGasPedal,DefaultEffectorRotationTargetName=IK_DriverGasPedal),
                                    HipsIKInfo=(PinEnabled=true),
                                    PositionFlinchAnims=(Driver_open_Flinch),
                                    PositionDeathAnims=(Driver_Death)),
                                // Open, leaning back
                               (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=70.0,PositionUpAnim=Driver_Open,PositionDownAnim=Driver_LeanBACK_open,PositionIdleAnim=Driver_open_Idle,DriverIdleAnim=Driver_open_Idle,AlternateIdleAnim=Driver_open_Idle_AI,SeatProxyIndex=0,
                                    bIsExterior=true,
                                    LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverLeftSteer,DefaultEffectorRotationTargetName=IK_DriverLeftSteer),
                                    RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverRightSteer,DefaultEffectorRotationTargetName=IK_DriverRightSteer,
                                        AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchLever,EffectorRotationTargetName=IK_DriverClutchLever))),
                                    LeftFootIKInfo=(IKEnabled=false,
                                        AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchPedal,EffectorRotationTargetName=IK_DriverClutchPedal))),
                                    RightFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverGasPedal,DefaultEffectorRotationTargetName=IK_DriverGasPedal),
                                    HipsIKInfo=(PinEnabled=true),
                                    PositionFlinchAnims=(Driver_open_Flinch),
                                    PositionDeathAnims=(Driver_Death),
                                    // Sideport Interaction
                                    PositionInteractions=((InteractionIdleAnim=Driver_Side_Idle_Open,StartInteractionAnim=Driver_TurnToSide_Open,EndInteractionAnim=Driver_TurnTOFront_Open,FlinchInteractionAnim=Driver_sideport_Flinch,
                                    ViewFOV=70,bAllowFocus=true,InteractionSocketTag=DriverLeftViewPort,InteractDotAngle=0.95,bUseDOF=true))),
                                // Closed, leaning back
                                (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=70.0,PositionDownAnim=Driver_Close,PositionUpAnim=Driver_LeanBACK_closed,PositionIdleAnim=Driver_close_idle,DriverIdleAnim=Driver_close_idle,AlternateIdleAnim=Driver_close_idle_AI,SeatProxyIndex=0,
                                    bIsExterior=false,
                                    LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverLeftSteer,DefaultEffectorRotationTargetName=IK_DriverLeftSteer),
                                    RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverRightSteer,DefaultEffectorRotationTargetName=IK_DriverRightSteer,
                                        AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchLever,EffectorRotationTargetName=IK_DriverClutchLever))),
                                    LeftFootIKInfo=(IKEnabled=false,
                                        AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchPedal,EffectorRotationTargetName=IK_DriverClutchPedal))),
                                    RightFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverGasPedal,DefaultEffectorRotationTargetName=IK_DriverGasPedal),
                                    HipsIKInfo=(PinEnabled=true),
                                    PositionFlinchAnims=(Driver_open_Flinch),
                                    PositionDeathAnims=(Driver_Death),
                                    // Sideport Interaction
                                    PositionInteractions=((InteractionIdleAnim=Driver_Side_Idle,StartInteractionAnim=Driver_TurnToSide,EndInteractionAnim=Driver_TurnTOFront,FlinchInteractionAnim=Driver_sideport_Flinch,
                                    ViewFOV=70,bAllowFocus=true,InteractionSocketTag=DriverLeftViewPort,InteractDotAngle=0.95,bUseDOF=true))),
                                // Closed, leaning forward
                                (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=70.0,PositionDownAnim=Driver_LeanIN_closed,PositionIdleAnim=Driver_LeanIN_closed_idle,DriverIdleAnim=Driver_LeanIN_closed_Idle,AlternateIdleAnim=Driver_LeanIN_closed_Idle_AI,SeatProxyIndex=0,
                                    bIsExterior=false,
                                    LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverLeftSteer,DefaultEffectorRotationTargetName=IK_DriverLeftSteer),
                                    RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverRightSteer,DefaultEffectorRotationTargetName=IK_DriverRightSteer,
                                        AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchLever,EffectorRotationTargetName=IK_DriverClutchLever))),
                                    LeftFootIKInfo=(IKEnabled=false,
                                        AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchPedal,EffectorRotationTargetName=IK_DriverClutchPedal))),
                                    RightFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverGasPedal,DefaultEffectorRotationTargetName=IK_DriverGasPedal),
                                    PositionFlinchAnims=(Driver_open_Flinch),
                                    PositionDeathAnims=(Driver_Death))),
            bSeatVisible=true,
            DriverDamageMult=1.0,
            SeatBone=Root_Driver_ATTACH,
            InitialPositionIndex=2,
            SeatRotation=(Pitch=0,Yaw=0,Roll=0),
            VehicleBloodMICParameterName=Gore03
            )}

    Seats(1)={( GunClass=class'DRVWeap_HT_HullMG',
                //SightOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_mg',
                //VignetteOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_vignette',
                GunSocket=(MG_Barrel),
                GunPivotPoints=(MG_Pitch),
                TurretVarPrefix="HullMG",
                TurretControls=(MG_Rot_Yaw,MG_Rot_Pitch),
                CameraTag=None,
                CameraOffset=-420,
                bSeatVisible=true,
                DriverDamageMult=1.0,
                SeatBone=Root_MG_ATTACH,
                SeatAnimBlendName=HullMGPositionNode,
                SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=70.0,bRotateGunOnCommand=true,PositionUpAnim=MG_LeanBack,PositionIdleAnim=MG_Idle_Lean,DriverIdleAnim=MG_Idle_Lean,AlternateIdleAnim=MG_Idle_Lean,SeatProxyIndex=1,bIgnoreWeapon=true,
                                    bIsExterior=true,
                                    LeftHandIKInfo=(PinEnabled=true),
                                    RightHandIKInfo=(PinEnabled=true),//(IKEnabled=true,DefaultEffectorLocationTargetName=IK_HullMGRightHand,DefaultEffectorRotationTargetName=IK_HullMGRightHand),
                                    HipsIKInfo=(PinEnabled=true),
                                    LeftFootIKInfo=(PinEnabled=true),
                                    RightFootIKInfo=(PinEnabled=true),
                                    PositionFlinchAnims=(MG_close_Flinch),
                                    PositionDeathAnims=(MG_Death)),
                               (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=MG_Camera,ViewFOV=55.0,bCamRotationFollowSocket=true,bViewFromCameraTag=true,bDrawOverlays=false,bUseDOF=true,
                                    bIsExterior=true,
                                    PositionDownAnim=MG_LeanIN,PositionIdleAnim=MG_idle,bConstrainRotation=false,YawContraintIndex=0,PitchContraintIndex=1,DriverIdleAnim=MG_idle,AlternateIdleAnim=MG_Idle_AI,SeatProxyIndex=1,
                                    LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_HullMGLeftHand,DefaultEffectorRotationTargetName=IK_HullMGLeftHand),
                                    RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_HullMGRightHand,DefaultEffectorRotationTargetName=IK_HullMGRightHand),
                                    HipsIKInfo=(PinEnabled=true),
                                    LeftFootIKInfo=(PinEnabled=true),
                                    RightFootIKInfo=(PinEnabled=true),
                                    PositionFlinchAnims=(MG_close_Flinch),
                                    PositionDeathAnims=(MG_Death),
                                    ChestIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_HullMGChest,DefaultEffectorRotationTargetName=IK_HullMGChest))),
                DriverDamageMult=1.0,
                InitialPositionIndex=1,
                FiringPositionIndex=1,
                SeatRotation=(Pitch=0,Yaw=0,Roll=0),
                VehicleBloodMICParameterName=Gore03,
                TracerFrequency=5,
                //? WeaponTracerClass=(class'MG34_HTBulletTracer',class'MG34_HTBulletTracer'),
                MuzzleFlashLightClass=(class'ROVehicleMGMuzzleFlashLight',class'ROVehicleMGMuzzleFlashLight'),
                VehicleBloodMICParameterName=Gore01
                )}

    Seats(2)={( CameraTag=None,
        CameraOffset=-420,
        SeatAnimBlendName=Pass1PositionNode,
        SeatPositions=((bDriverVisible=true,bIsExterior=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionUpAnim=Passenger1_SitIdleTOStandIdle,PositionIdleAnim=Passenger1_StandIdle,DriverIdleAnim=Passenger1_StandIdle,AlternateIdleAnim=Passenger1_StandIdle_AI,SeatProxyIndex=2,
                            bIsExterior=true,
                            PositionFlinchAnims=(MG_close_Flinch),
                            PositionDeathAnims=(Passenger1_StandDeath)),
                       (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger1_StandIdleTOSitIdle,PositionIdleAnim=Passenger1_Sit_Idle,DriverIdleAnim=Passenger1_Sit_Idle,AlternateIdleAnim=Passenger1_Sit_Idle,SeatProxyIndex=2,
                            bIsExterior=true,
                            PositionFlinchAnims=(MG_close_Flinch),
                            PositionDeathAnims=(Passenger1_SitDeath))),
        TurretVarPrefix="PassengerOne",
        bSeatVisible=true,
        DriverDamageMult=1.0,
        InitialPositionIndex=1,
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        SeatBone=Root_pass_l_1,
        VehicleBloodMICParameterName=Gore04
        )}

    Seats(3)={( CameraTag=None,
        CameraOffset=-420,
        SeatAnimBlendName=Pass2PositionNode,
        SeatPositions=((bDriverVisible=true,bIsExterior=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionUpAnim=Passenger4_SitIdleTOStandIdle,PositionIdleAnim=Passenger4_StandIdle,DriverIdleAnim=Passenger4_StandIdle,AlternateIdleAnim=Passenger4_StandIdle_AI,SeatProxyIndex=3,
                            bIsExterior=true,
                            PositionFlinchAnims=(MG_close_Flinch),
                            PositionDeathAnims=(Passenger4_StandDeath)),
                       (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger4_StandIdleTOSitIdle,PositionIdleAnim=Passenger4_Sit_Idle,DriverIdleAnim=Passenger4_Sit_Idle,AlternateIdleAnim=Passenger4_Sit_Idle,SeatProxyIndex=3,
                            bIsExterior=true,
                            PositionFlinchAnims=(MG_close_Flinch),
                            PositionDeathAnims=(Passenger4_SitDeath))),
        TurretVarPrefix="PassengerTwo",
        bSeatVisible=true,
        DriverDamageMult=1.0,
        InitialPositionIndex=1,
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        SeatBone=Root_pass_r_1,
        VehicleBloodMICParameterName=Gore02
        )}

    Seats(4)={( CameraTag=None,
        CameraOffset=-420,
        SeatAnimBlendName=Pass3PositionNode,
        SeatPositions=((bDriverVisible=true,bIsExterior=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionUpAnim=Passenger2_SitIdleTOStandIdle,PositionIdleAnim=Passenger2_StandIdle,DriverIdleAnim=Passenger2_StandIdle,AlternateIdleAnim=Passenger2_StandIdle_AI,SeatProxyIndex=4,
                            bIsExterior=true,
                            PositionFlinchAnims=(MG_close_Flinch),
                            PositionDeathAnims=(Passenger2_StandDeath)),
                       (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger2_StandIdleTOSitIdle,PositionIdleAnim=Passenger2_Sit_Idle,DriverIdleAnim=Passenger2_Sit_Idle,AlternateIdleAnim=Passenger2_Sit_Idle,SeatProxyIndex=4,
                            bIsExterior=true,
                            PositionFlinchAnims=(MG_close_Flinch),
                            PositionDeathAnims=(Passenger2_SitDeath))),
        TurretVarPrefix="PassengerThree",
        bSeatVisible=true,
        DriverDamageMult=1.0,
        InitialPositionIndex=1,
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        SeatBone=Root_pass_l_2,
        VehicleBloodMICParameterName=Gore04
        )}

    Seats(5)={( CameraTag=None,
        CameraOffset=-420,
        SeatAnimBlendName=Pass4PositionNode,
        SeatPositions=((bDriverVisible=true,bIsExterior=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionUpAnim=Passenger5_SitIdleTOStandIdle,PositionIdleAnim=Passenger5_StandIdle,DriverIdleAnim=Passenger5_StandIdle,AlternateIdleAnim=Passenger5_StandIdle_AI,SeatProxyIndex=5,
                            bIsExterior=true,
                            PositionFlinchAnims=(MG_close_Flinch),
                            PositionDeathAnims=(Passenger5_StandDeath)),
                       (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger5_StandIdleTOSitIdle,PositionIdleAnim=Passenger5_Sit_Idle,DriverIdleAnim=Passenger5_Sit_Idle,AlternateIdleAnim=Passenger5_Sit_Idle,SeatProxyIndex=5,
                            bIsExterior=true,
                            PositionFlinchAnims=(MG_close_Flinch),
                            PositionDeathAnims=(Passenger5_SitDeath))),
        TurretVarPrefix="PassengerFour",
        bSeatVisible=true,
        DriverDamageMult=1.0,
        InitialPositionIndex=1,
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        SeatBone=Root_pass_r_2,
        VehicleBloodMICParameterName=Gore02
        )}

    Seats(6)={( CameraTag=None,
        CameraOffset=-420,
        SeatAnimBlendName=Pass5PositionNode,
        SeatPositions=((bDriverVisible=true,bIsExterior=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionUpAnim=Passenger3_SitIdleTOStandIdle,PositionIdleAnim=Passenger3_StandIdle,DriverIdleAnim=Passenger3_StandIdle,AlternateIdleAnim=Passenger3_StandIdle_AI,SeatProxyIndex=6,
                            bIsExterior=true,
                            PositionFlinchAnims=(MG_close_Flinch),
                            PositionDeathAnims=(Passenger3_StandDeath)),
                       (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger3_StandIdleTOSitIdle,PositionIdleAnim=Passenger3_Sit_Idle,DriverIdleAnim=Passenger3_Sit_Idle,AlternateIdleAnim=Passenger3_Sit_Idle,SeatProxyIndex=6,
                            bIsExterior=true,
                            PositionFlinchAnims=(MG_close_Flinch),
                            PositionDeathAnims=(Passenger3_SitDeath))),
        TurretVarPrefix="PassengerFive",
        bSeatVisible=true,
        DriverDamageMult=1.0,
        InitialPositionIndex=1,
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        SeatBone=Root_pass_l_3,
        VehicleBloodMICParameterName=Gore04
        )}

    Seats(7)={( CameraTag=None,
        CameraOffset=-420,
        SeatAnimBlendName=Pass6PositionNode,
        SeatPositions=((bDriverVisible=true,bIsExterior=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionUpAnim=Passenger6_SitIdleTOStandIdle,PositionIdleAnim=Passenger6_StandIdle,DriverIdleAnim=Passenger6_StandIdle,AlternateIdleAnim=Passenger6_StandIdle_AI,SeatProxyIndex=7,
                            bIsExterior=true,
                            PositionFlinchAnims=(MG_close_Flinch),
                            PositionDeathAnims=(Passenger6_StandDeath)),
                       (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger6_StandIdleTOSitIdle,PositionIdleAnim=Passenger6_Sit_Idle,DriverIdleAnim=Passenger6_Sit_Idle,AlternateIdleAnim=Passenger6_Sit_Idle,SeatProxyIndex=7,
                            bIsExterior=true,
                            PositionFlinchAnims=(MG_close_Flinch),
                            PositionDeathAnims=(Passenger6_SitDeath))),
        TurretVarPrefix="PassengerSix",
        bSeatVisible=true,
        DriverDamageMult=1.0,
        InitialPositionIndex=1,
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        SeatBone=Root_pass_r_3,
        VehicleBloodMICParameterName=Gore02
        )}

    PassengerAnimTree=AnimTree'CHR_Playeranimtree_Master.CHR_Tanker_animtree'
    CrewAnimSet=AnimSet'DR_VH_DAK_SdKfz.Anim.CHR_SdkFz_Anim_Master'

    LeftSteerableWheelIndex=0
    RightSteerableWheelIndex=0
    LeftSteerableSimWheelIndex=5
    RightSteerableSimWheelIndex=2
    MaxVisibleSteeringAngle=45.0

    LeftWheels(0)="L1_Wheel"
    LeftWheels(1)="L2_Wheel"
    LeftWheels(2)="L3_Wheel"
    LeftWheels(3)="L4_Wheel"
    LeftWheels(4)="L5_Wheel"
    LeftWheels(5)="L6_Wheel"
    LeftWheels(6)="L7_Wheel"
    LeftWheels(7)="L8_Wheel"
    LeftWheels(8)="L9_Wheel"
    //
    RightWheels(0)="R1_Wheel"
    RightWheels(1)="R2_Wheel"
    RightWheels(2)="R3_Wheel"
    RightWheels(3)="R4_Wheel"
    RightWheels(4)="R5_Wheel"
    RightWheels(5)="R6_Wheel"
    RightWheels(6)="R7_Wheel"
    RightWheels(7)="R8_Wheel"
    RightWheels(8)="R9_Wheel"

/** Physics Wheels */

    // Right Rear Wheel
    Begin Object Name=RRWheel
        BoneName="R_Wheel_08"
        BoneOffset=(X=0.0,Y=0.0,Z=0.0)
        WheelRadius=20
        SteerFactor=0.1f
    End Object

    // Right middle wheel
    Begin Object Name=RMWheel
        BoneName="R_Wheel_04"
        BoneOffset=(X=0.0,Y=0.0,Z=0.0)
        WheelRadius=20
        SteerFactor=0.0f
    End Object

    // Right Front Wheel
    Begin Object Name=RFWheel
        BoneName="R_Wheel_01"
        BoneOffset=(X=0.0,Y=0.0,Z=0.0)
        WheelRadius=24
        SteerFactor=1.0f
    End Object

    // Left Rear Wheel
    Begin Object Name=LRWheel
        BoneName="L_Wheel_08"
        BoneOffset=(X=0.0,Y=0.0,Z=0.0)
        WheelRadius=20
        SteerFactor=0.1f
    End Object

    // Left Middle Wheel
    Begin Object Name=LMWheel
        BoneName="L_Wheel_04"
        BoneOffset=(X=0.0,Y=0.0,Z=0.0)
        WheelRadius=20
        SteerFactor=0.0f
    End Object

    // Left Front Wheel
    Begin Object Name=LFWheel
        BoneName="L_Wheel_01"
        BoneOffset=(X=0.0,Y=0.0,Z=0.0)
        WheelRadius=24
        SteerFactor=1.0f
    End Object

    Begin Object class=ROVehicleSimHalftrack Name=SimObjectHalfTrack
        WheelSuspensionStiffness=350
        WheelSuspensionDamping=25.0
        WheelSuspensionBias=0.1
        WheelLongExtremumSlip=1.5
        ChassisTorqueScale=1.0//0.0
        StopThreshold=50
        EngineBrakeFactor=0.00001
        EngineDamping=3.8
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
            GearRatio=4.37,
            AccelRate=12.50,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=2500),
                (InVal=300,OutVal=1750),
                (InVal=2800,OutVal=3000),
                (InVal=3000,OutVal=1000),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=1.0
            )}
        GearArray(3)={(
            // Real world - [2.18] ~20.0 kph
            GearRatio=2.18,
            AccelRate=10.00,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=3000),
                (InVal=2800,OutVal=6200),
                (InVal=3000,OutVal=2000),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=1.0
            )}
        GearArray(4)={(
            // Real world - [1.46] ~30.0 kph
            GearRatio=1.46,
            AccelRate=10.00,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=3500),
                (InVal=2800,OutVal=9700),
                (InVal=3000,OutVal=3500),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=1.0
            )}
        GearArray(5)={(
            // Real world - [1.09] ~40.0 kph
            GearRatio=1.00,
            AccelRate=10.00,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=5000),
                (InVal=2800,OutVal=12200),
                (InVal=3000,OutVal=6000),
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

    DrivingPhysicalMaterial=PhysicalMaterial'DR_VH_DAK_SdKfz.Phys.PhysMat_HT_Moving'
    DefaultPhysicalMaterial=PhysicalMaterial'DR_VH_DAK_SdKfz.Phys.PhysMat_HT'

    TreadSpeedParameterName=Tank_Tread_Speed
    TrackSoundParamScale=0.000033
    TreadSpeedScale=-2.5

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

    // TODO: 251 effects.
    // // Muzzle Flashes
    // VehicleEffects(TankVFX_Firing1)=(EffectStartTag=HTHullMG,EffectTemplate=ParticleSystem'FX_MuzzleFlashes.Emitters.muzzleflash_3rdP',EffectSocket=MG_Barrel)
    // // Shell Ejects
    // VehicleEffects(TankVFX_Firing2)=(EffectStartTag=HTHullMG,EffectTemplate=ParticleSystem'FX_Vehicles_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_MG34_HT',EffectSocket=MG_ShellEject,bInteriorEffect=true,bNoKillOnRestart=true)
    // // Driving effects
    // VehicleEffects(TankVFX_Exhaust)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,EffectTemplate=ParticleSystem'FX_Vehicles_Two.SDKfZ.FX_SdKfz_exhaust',EffectSocket=Exhaust)
    // VehicleEffects(TankVFX_TreadWing)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bStayActive=true,EffectTemplate=ParticleSystem'FX_VEH_Tank_Three.FX_VEH_Tank_A_Wing_Dirt_T34',EffectSocket=FX_Master)
    // // Damage
    // VehicleEffects(TankVFX_DmgSmoke)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'FX_Vehicles_Two.SDKfZ.FX_SdKfz_damaged_burning_new',EffectSocket=attachments_engine)
    // VehicleEffects(TankVFX_DmgInterior)=(EffectStartTag=DamageInterior,EffectEndTag=NoInternalSmoke,bRestartRunning=false,bInteriorEffect=true,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_Interior_Penetrate',EffectSocket=attachments_body)
    // // Death
    // VehicleEffects(TankVFX_DeathSmoke1)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke1)
    // VehicleEffects(TankVFX_DeathSmoke2)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke2)
    // VehicleEffects(TankVFX_DeathSmoke3)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke3)

    BigExplosionSocket=FX_Fire
    //? ExplosionTemplate=ParticleSystem'FX_Vehicles_Two.SDKfZ.FX_SdKfz_destroyed'

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

    SeatTextureOffsets(0)=(PositionOffSet=(X=-9,Y=-3,Z=0),bTurretPosition=0)
    SeatTextureOffsets(1)=(PositionOffSet=(X=0,Y=4,Z=0),bTurretPosition=0)
    SeatTextureOffsets(2)=(PositionOffSet=(X=-9,Y=15,Z=0),bTurretPosition=0)
    SeatTextureOffsets(3)=(PositionOffSet=(X=8,Y=15,Z=0),bTurretPosition=0)
    SeatTextureOffsets(4)=(PositionOffSet=(X=-9,Y=28,Z=0),bTurretPosition=0)
    SeatTextureOffsets(5)=(PositionOffSet=(X=8,Y=28,Z=0),bTurretPosition=0)
    SeatTextureOffsets(6)=(PositionOffSet=(X=-9,Y=41,Z=0),bTurretPosition=0)
    SeatTextureOffsets(7)=(PositionOffSet=(X=8,Y=41,Z=0),bTurretPosition=0)

    SpeedoMinDegree=5461
    SpeedoMaxDegree=56000
    SpeedoMaxSpeed=1365 //100 km/h

    CabinL_FXSocket=Sound_Cabin_L
    CabinR_FXSocket=Sound_Cabin_R
    Exhaust_FXSocket=Exhaust
    TreadL_FXSocket=Sound_Tread_L
    TreadR_FXSocket=Sound_Tread_R


    //VehHitZones(2)=(ZoneName=MGAMMOBOX,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.4,VisibleFrom=8)



    VehHitZones(0)=(ZoneName=LEFTTRACKONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(1)=(ZoneName=LEFTTRACKTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(2)=(ZoneName=LEFTTRACKTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(3)=(ZoneName=LEFTTRACKFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(4)=(ZoneName=LEFTTRACKFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(5)=(ZoneName=LEFTTRACKSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(6)=(ZoneName=LEFTTRACKSEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(7)=(ZoneName=LEFTTRACKEIGHT,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(8)=(ZoneName=LEFTTRACKNINE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(9)=(ZoneName=LEFTTRACKTEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(10)=(ZoneName=LEFTTRACKELEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(11)=(ZoneName=RIGHTTRACKONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(12)=(ZoneName=RIGHTTRACKTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(13)=(ZoneName=RIGHTTRACKTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(14)=(ZoneName=RIGHTTRACKFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(15)=(ZoneName=RIGHTTRACKFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(16)=(ZoneName=RIGHTTRACKSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(17)=(ZoneName=RIGHTTRACKSEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(18)=(ZoneName=RIGHTTRACKEIGHT,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(19)=(ZoneName=RIGHTTRACKNINE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(20)=(ZoneName=RIGHTTRACKTEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(21)=(ZoneName=RIGHTTRACKELEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(22)=(ZoneName=LEFTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
    VehHitZones(23)=(ZoneName=RIGHTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
    VehHitZones(24)=(ZoneName=LEFTTURNINGWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
    VehHitZones(25)=(ZoneName=RIGHTTURNINGWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
    VehHitZones(26)=(ZoneName=RIGHTBRAKE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=9)
    VehHitZones(27)=(ZoneName=LEFTBRAKE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=5)
    VehHitZones(28)=(ZoneName=FUELTANK,DamageMultiplier=5.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=200,KillPercentage=0.3,VisibleFrom=15)
    VehHitZones(29)=(ZoneName=GEARBOX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=100,VisibleFrom=15)
    VehHitZones(30)=(ZoneName=GEARBOXCORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=200,VisibleFrom=15)
    VehHitZones(31)=(ZoneName=ENGINEBLOCK,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=100,VisibleFrom=13)
    VehHitZones(32)=(ZoneName=ENGINECORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=300,VisibleFrom=13)
    VehHitZones(33)=(ZoneName=PASS1BODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=2,SeatProxyIndex=2,CrewBoneName=Root_pass_l1_HITBOX)
    VehHitZones(34)=(ZoneName=PASS1HEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=2,SeatProxyIndex=2,CrewBoneName=pass_l1_head_HITBOX)
    VehHitZones(35)=(ZoneName=PASS2BODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=3,SeatProxyIndex=3,CrewBoneName=Root_pass_r1_HITBOX)
    VehHitZones(36)=(ZoneName=PASS2HEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=3,SeatProxyIndex=3,CrewBoneName=pass_r1_head_HITBOX)
    VehHitZones(37)=(ZoneName=PASS3BODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=4,SeatProxyIndex=4,CrewBoneName=Root_pass_l2_HITBOX)
    VehHitZones(38)=(ZoneName=PASS3HEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=4,SeatProxyIndex=4,CrewBoneName=pass_l2_head_HITBOX)
    VehHitZones(39)=(ZoneName=PASS4BODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=5,SeatProxyIndex=5,CrewBoneName=Root_pass_r2_HITBOX)
    VehHitZones(40)=(ZoneName=PASS4HEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=5,SeatProxyIndex=5,CrewBoneName=pass_r2_head_HITBOX)
    VehHitZones(41)=(ZoneName=PASS5BODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=6,SeatProxyIndex=6,CrewBoneName=Root_pass_l3_HITBOX)
    VehHitZones(42)=(ZoneName=PASS5HEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=6,SeatProxyIndex=6,CrewBoneName=pass_l3_head_HITBOX)
    VehHitZones(43)=(ZoneName=PASS6BODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=7,SeatProxyIndex=7,CrewBoneName=Root_pass_r3_HITBOX)
    VehHitZones(44)=(ZoneName=PASS6HEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=7,SeatProxyIndex=7,CrewBoneName=pass_r3_head_HITBOX)
    VehHitZones(45)=(ZoneName=MGGUNNERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=Root_MG_HITBOX)
    VehHitZones(46)=(ZoneName=MGGUNNERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=MG_head_HITBOX)
    VehHitZones(47)=(ZoneName=DRIVERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Root_Driver_HITBOX)
    VehHitZones(48)=(ZoneName=DRIVERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Driver_head_HITBOX)

    CrewHitZoneStart=33
    CrewHitZoneEnd=48

    ArmorHitZones(0)=(ZoneName=BONNETRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=BONNET)
    ArmorHitZones(1)=(ZoneName=BONNETMID,PhysBodyBoneName=Chassis,ArmorPlateName=BONNET)
    ArmorHitZones(2)=(ZoneName=BONNETLEFT,PhysBodyBoneName=Chassis,ArmorPlateName=BONNET)
    ArmorHitZones(3)=(ZoneName=FRONTLOWER,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTPLATE)
    ArmorHitZones(4)=(ZoneName=FRONTLOWERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTPLATE)
    ArmorHitZones(5)=(ZoneName=REARUNDERSIDE,PhysBodyBoneName=Chassis,ArmorPlateName=UNDERSIDE)
    ArmorHitZones(6)=(ZoneName=REARUNDERSIDETWO,PhysBodyBoneName=Chassis,ArmorPlateName=UNDERSIDE)
    ArmorHitZones(7)=(ZoneName=CENTRALUNDERSIDE,PhysBodyBoneName=Chassis,ArmorPlateName=UNDERSIDE)
    ArmorHitZones(8)=(ZoneName=MIDFORWARDUNDERSIDE,PhysBodyBoneName=Chassis,ArmorPlateName=UNDERSIDE)
    ArmorHitZones(9)=(ZoneName=FORWARDUNDERSIDE,PhysBodyBoneName=Chassis,ArmorPlateName=UNDERSIDE)
    ArmorHitZones(10)=(ZoneName=REARDOORFRAMEONE,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(11)=(ZoneName=REARDOORFRAMETWO,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(12)=(ZoneName=REARDOORFRAMETHREE,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(13)=(ZoneName=REARDOORFRAMEFOUR,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(14)=(ZoneName=REARDOORFRAMEFIVE,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(15)=(ZoneName=REARDOORFRAMESIX,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(16)=(ZoneName=REARDOORFRAMESEVEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(17)=(ZoneName=REARDOORFRAMEEIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(18)=(ZoneName=REARDOORFRAMENINE,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(19)=(ZoneName=REARDOORFRAMETEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(20)=(ZoneName=REARDOORFRAMEELEVEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(21)=(ZoneName=REARDOORFRAMETWELVE,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(22)=(ZoneName=REARDOORFRAMETHIRTEEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(23)=(ZoneName=REARDOORFRAMEFOURTEEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(24)=(ZoneName=REARDOORFRAMEFIFTEEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(25)=(ZoneName=REARDOORFRAMESIXTEEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(26)=(ZoneName=REARDOORFRAMESEVENTEEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(27)=(ZoneName=REARDOORFRAMEEIGHTEEN,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORFRAME)
    ArmorHitZones(28)=(ZoneName=LEFTREARUPPER,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARUPPER)
    ArmorHitZones(29)=(ZoneName=LEFTREARUPPERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARUPPER)
    ArmorHitZones(30)=(ZoneName=LEFTREARMIDONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARMID)
    ArmorHitZones(31)=(ZoneName=LEFTREARLOWERONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARLOWER)
    ArmorHitZones(32)=(ZoneName=LEFTREARLOWERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARLOWER)
    ArmorHitZones(33)=(ZoneName=LEFTREARLOWERTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARLOWER)
    ArmorHitZones(34)=(ZoneName=LEFTFRONTLOWERONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTLOWER)
    ArmorHitZones(35)=(ZoneName=LEFTFRONTLOWERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTLOWER)
    ArmorHitZones(36)=(ZoneName=LEFTFRONTLOWERTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTLOWER)
    ArmorHitZones(37)=(ZoneName=LEFTFRONTLOWERFOUR,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTLOWER)
    ArmorHitZones(38)=(ZoneName=LEFTFRONTUPPERONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTUPPER)
    ArmorHitZones(39)=(ZoneName=LEFTFRONTUPPERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTUPPER)
    ArmorHitZones(40)=(ZoneName=RIGHTFRONTUPPERONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTUPPER)
    ArmorHitZones(41)=(ZoneName=RIGHTFRONTUPPERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTUPPER)
    ArmorHitZones(42)=(ZoneName=RIGHTFRONTLOWERONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTLOWER)
    ArmorHitZones(43)=(ZoneName=RIGHTFRONTLOWERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTLOWER)
    ArmorHitZones(44)=(ZoneName=RIGHTFRONTLOWERTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTLOWER)
    ArmorHitZones(45)=(ZoneName=RIGHTFRONTLOWERFOUR,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTLOWER)
    ArmorHitZones(46)=(ZoneName=RIGHTREARLOWERONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARLOWER)
    ArmorHitZones(47)=(ZoneName=RIGHTREARLOWERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARLOWER)
    ArmorHitZones(48)=(ZoneName=RIGHTREARLOWERTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARLOWER)
    ArmorHitZones(49)=(ZoneName=RIGHTREARUPPER,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTREARUPPER)
    ArmorHitZones(50)=(ZoneName=RIGHTREARUPPERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTREARUPPER)
    ArmorHitZones(51)=(ZoneName=RIGHTREARMIDONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTREARMID)
    ArmorHitZones(52)=(ZoneName=FRONTUPPERRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTSIDEUPPER)
    ArmorHitZones(53)=(ZoneName=FRONTUPPERCENTER,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTSIDEUPPER)
    ArmorHitZones(54)=(ZoneName=FRONTUPPERLEFT,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTSIDEUPPER)
    ArmorHitZones(55)=(ZoneName=SIDEVIEWSLITLEFT,PhysBodyBoneName=Chassis,ArmorPlateName=SIDEVIEWSLITLEFT)
    ArmorHitZones(56)=(ZoneName=SIDEVIEWSLITRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=SIDEVIEWSLITRIGHT)
    ArmorHitZones(57)=(ZoneName=FRONTVIEWSLITRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTVIEWSLITRIGHT)
    ArmorHitZones(58)=(ZoneName=REARDOORUPPER,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORS)
    ArmorHitZones(59)=(ZoneName=REARDOORLOWER,PhysBodyBoneName=Chassis,ArmorPlateName=REARDOORS)
    ArmorHitZones(60)=(ZoneName=DRIVERHATCHARMOR,PhysBodyBoneName=Driver_hatch,ArmorPlateName=DRIVERHATCH)
    ArmorHitZones(61)=(ZoneName=DRIVERHATCHOPENING,PhysBodyBoneName=Driver_hatch,bInstaPenetrateZone=true)


    ArmorPlates(0)=(PlateName=BONNET,ArmorZoneType=AZT_Front,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(1)=(PlateName=FRONTSIDEUPPER,ArmorZoneType=AZT_Front,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(2)=(PlateName=FRONTPLATE,ArmorZoneType=AZT_Front,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(3)=(PlateName=REARDOORS,ArmorZoneType=AZT_Back,PlateThickness=6,OverallHardness=400,bHighHardness=false)
    ArmorPlates(4)=(PlateName=REARDOORFRAME,ArmorZoneType=AZT_Back,PlateThickness=10,OverallHardness=400,bHighHardness=true)
    ArmorPlates(5)=(PlateName=INTERNALFLOOR,ArmorZoneType=AZT_Front,PlateThickness=6,OverallHardness=400,bHighHardness=true)
    ArmorPlates(6)=(PlateName=UNDERSIDE,ArmorZoneType=AZT_Floor,PlateThickness=6,OverallHardness=400,bHighHardness=true)
    ArmorPlates(7)=(PlateName=LEFTREARUPPER,ArmorZoneType=AZT_Left,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(8)=(PlateName=LEFTREARMID,ArmorZoneType=AZT_Left,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(9)=(PlateName=LEFTREARLOWER,ArmorZoneType=AZT_Left,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(10)=(PlateName=RIGHTREARUPPER,ArmorZoneType=AZT_Right,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(11)=(PlateName=RIGHTREARMID,ArmorZoneType=AZT_Right,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(12)=(PlateName=RIGHTREARLOWER,ArmorZoneType=AZT_Right,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(13)=(PlateName=RIGHTFRONTLOWER,ArmorZoneType=AZT_Right,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(14)=(PlateName=RIGHTFRONTUPPER,ArmorZoneType=AZT_Right,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(15)=(PlateName=LEFTFRONTUPPER,ArmorZoneType=AZT_Left,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(16)=(PlateName=LEFTFRONTLOWER,ArmorZoneType=AZT_Left,PlateThickness=14,OverallHardness=400,bHighHardness=true)
    ArmorPlates(17)=(PlateName=SIDEVIEWSLITLEFT,ArmorZoneType=AZT_WeakSpots,PlateThickness=5,OverallHardness=150,bHighHardness=false)
    ArmorPlates(18)=(PlateName=SIDEVIEWSLITRIGHT,ArmorZoneType=AZT_WeakSpots,PlateThickness=5,OverallHardness=150,bHighHardness=false)
    ArmorPlates(20)=(PlateName=FRONTVIEWSLITRIGHT,ArmorZoneType=AZT_Front,PlateThickness=10,OverallHardness=340,bHighHardness=false)
    ArmorPlates(21)=(PlateName=DRIVERHATCH,ArmorZoneType=AZT_Front,PlateThickness=10,OverallHardness=340,bHighHardness=false)

    MaxSpeed=723    // 53 km/h

    bDestroyedTracksCauseTurn=false

    //? RanOverDamageType=RODmgType_RunOver_HT
    TransportType=ROTT_Halftrack
}
