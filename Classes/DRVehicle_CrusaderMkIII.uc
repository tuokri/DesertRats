class DRVehicle_CrusaderMkIII extends DRVehicleTank
    abstract;

/** ambient sound component for machine gun */
// var AudioComponent HullMGAmbient;
/** Sound to play when maching gun stops firing. */
// var SoundCue HullMGStopSound;

/** ambient sound component for machine gun */
var AudioComponent CoaxMGAmbient;
/** Sound to play when maching gun stops firing. */
var SoundCue CoaxMGStopSound;

var array<MaterialInstanceConstant> ReplacedExteriorMICs;
var MaterialInstanceConstant        ExteriorMICs[2];        // 0 = Exterior Texture, 1 = Unused
var bool                            bGeneratedExteriorMICs;

var array<MaterialInstanceConstant> ReplacedInteriorMICs;
var MaterialInstanceConstant        InteriorMICs[4];        // 0 = Walls, 1 = Driver/HullMG, 2 = Turret, 3 = Cuppola
var bool                            bGeneratedInteriorMICs;

var int TempInt;

/** Controller used to reset the pitch and yaw so that it fits in the gun properly when reloaded */
// var ROSkelControlCustomAttach MGController;

/** Currently selected cuppola position */
var repnotify byte CuppolaCurrentPositionIndex;
var repnotify bool bDrivingCuppola;

/** Seat proxy death hit info */
var repnotify TakeHitInfo DeathHitInfo_ProxyDriver;
var repnotify TakeHitInfo DeathHitInfo_ProxyCommander;
// var repnotify TakeHitInfo DeathHitInfo_ProxyHullMG;
// var repnotify TakeHitInfo DeathHitInfo_ProxyLoader;
var repnotify TakeHitInfo DeathHitInfo_ProxyGunner;

/** Scope material. Caching it here so that it does not get cooked out */
var MaterialInstanceConstant ScopeLensMIC;

// TODO:
var DRDestroyedTankTrack DestroyedLeftTrack;
var DRDestroyedTankTrack DestroyedRightTrack;

replication
{
    if (bNetDirty)
        DeathHitInfo_ProxyDriver, DeathHitInfo_ProxyCommander, /*DeathHitInfo_ProxyHullMG DeathHitInfo_ProxyLoader,*/
        DeathHitInfo_ProxyGunner, CuppolaCurrentPositionIndex, bDrivingCuppola;
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
        if( IsLocalPlayerInThisVehicle() )
        {
            PlaySeatProxyDeathHitEffects(`CRUSADER_DRIVER_SPI, DeathHitInfo_ProxyDriver);
        }
    }
    else if (VarName == 'DeathHitInfo_ProxyCommander')
    {
        if( IsLocalPlayerInThisVehicle() )
        {
            PlaySeatProxyDeathHitEffects(`CRUSADER_COMMANDER_SPI, DeathHitInfo_ProxyCommander);
        }
    }
    else if (VarName == 'DeathHitInfo_ProxyGunner')
    {
        if( IsLocalPlayerInThisVehicle() )
        {
            PlaySeatProxyDeathHitEffects(`CRUSADER_GUNNER_SPI, DeathHitInfo_ProxyGunner);
        }
    }
    else
    {
       super.ReplicatedEvent(VarName);
    }
}

simulated function DisableLeftTrack()
{
    local vector SpawnLoc;
    local rotator SpawnRot;

    super.DisableLeftTrack();

    Mesh.GetSocketWorldLocationAndRotation('Destroyed_Track_Spawn_Left', SpawnLoc, SpawnRot);

    Mesh.SetMaterial(1, Material'M_VN_Common_Characters.Materials.M_Hair_NoTransp');
    DestroyedLeftTrack = Spawn(class'DRDestroyedTankTrack', self,, SpawnLoc, SpawnRot);

    `dr("DestroyedLeftTrack = " $ DestroyedLeftTrack);
}

simulated function DisableRightTrack()
{
    local vector SpawnLoc;
    local rotator SpawnRot;

    super.DisableRightTrack();

    Mesh.GetSocketWorldLocationAndRotation('Destroyed_Track_Spawn_Right', SpawnLoc, SpawnRot);

    Mesh.SetMaterial(2, Material'M_VN_Common_Characters.Materials.M_Hair_NoTransp');
    DestroyedRightTrack = Spawn(class'DRDestroyedTankTrack', self,, SpawnLoc, SpawnRot);

    `dr("DestroyedRightTrack = " $ DestroyedRightTrack);
}

simulated event PostBeginPlay()
{
    local int i;

    super.PostBeginPlay();

    // Attach sound cues
    // @todo: Get real locations, for now just attach to wherever our ROVWeap
    if( WorldInfo.NetMode != NM_DedicatedServer )
    {
        // Mesh.AttachComponentToSocket(HullMGAmbient, 'MG_Barrel');
        Mesh.AttachComponentToSocket(CoaxMGAmbient, 'CoaxMG');
    }

    // Shell controller
    // ShellController = ROSkelControlCustomAttach(mesh.FindSkelControl('ShellCustomAttach'));
    // MGController = ROSkelControlCustomAttach(mesh.FindSkelControl('InteriorMGAttach'));

    if ( !bGeneratedExteriorMICs )
    {
        ReplacedExteriorMICs.AddItem(MaterialInstanceConstant(Mesh.GetMaterial(0)));

        for ( i = 0; i < ReplacedExteriorMICs.Length; i++ )
        {
            ExteriorMICs[i] = new class'MaterialInstanceConstant';
            ExteriorMICs[i].SetParent(ReplacedExteriorMICs[i]);
        }

        ReplaceExteriorMICs(GetVehicleMeshAttachment('ExtBodyComponent'));
        ReplaceExteriorMICs(GetVehicleMeshAttachment('ExtTurretComponent'));
        ReplaceExteriorMICs(GetVehicleMeshAttachment('ExtGunBaseComponent'));
        ReplaceExteriorMICs(GetVehicleMeshAttachment('ExtBarrelComponent'));
        ReplaceExteriorMICs(GetVehicleMeshAttachment('ExtMGComponent'));
        ReplaceExteriorMICs(Mesh);

        bGeneratedExteriorMICs = true;
    }

    if( WorldInfo.NetMode != NM_DedicatedServer )
    {
        mesh.MinLodModel = 1;
    }
}

/**
 * This event is called when the pawn is torn off
 */
simulated event TornOff()
{
    // Clear the ambient firing sounds
    // HullMGAmbient.Stop();
    CoaxMGAmbient.Stop();

    Super.TornOff();
}

/** turns off all sounds */
simulated function StopVehicleSounds()
{
    Super.StopVehicleSounds();

    // Clear the ambient firing sounds
    // HullMGAmbient.Stop();
    CoaxMGAmbient.Stop();
}

simulated function int GetLoaderSeatIndex()
{
    return GetSeatIndexFromPrefix("Cuppola");
}

simulated function int GetCommanderSeatIndex()
{
    return GetSeatIndexFromPrefix("Cuppola");
}

/**
 * Request using a new pending position index
 *
 * @param   SeatIndex             The seat index that the Interaction is being requested for
 * @param   PositionIndex         The position index that is being requested
 */
simulated function RequestPosition(byte SeatIndex, byte DesiredIndex, optional bool bViaInteraction)
{
    // TODO:

    /*
    local ROWeaponPawn ROWP;

    // Allow position switching to take us to/from the gunner/cuppola position for easy of use
    if( SeatIndex == 1 && DesiredIndex == 2)
    {
        ROWP = ROWeaponPawn(Seats[SeatIndex].SeatPawn);
        if( ROWP != none )
        {
            // Go to gunner
            ROWP.SwitchWeapon(2);
        }
    }
    else if(SeatIndex == 2 && DesiredIndex == 255)
    {
        ROWP = ROWeaponPawn(Seats[SeatIndex].SeatPawn);
        if( ROWP != none )
        {
            // Go to cuppola
            ROWP.SwitchWeapon(1);
        }
    }
    else
    {
        super.RequestPosition(SeatIndex, DesiredIndex, bViaInteraction);
    }
    */

    super.RequestPosition(SeatIndex, DesiredIndex, bViaInteraction);
}

/** Check vehicle state for realistic driving restricti
ons */
simulated function bool EnforceDrivingLimitations()
{
    local ROGameReplicationInfo ROGRI;

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);
    if ( ROGRI != None && ROGRI.bRealisticDrivingRestrictions )
    {
        return !IsPositionInsideVehicle();
    }

    return false;
}

simulated function VehicleWeaponFireEffects(vector HitLocation, int SeatIndex)
{
    Super.VehicleWeaponFireEffects(HitLocation, SeatIndex);

    /*
    if (SeatIndex == GetHullMGSeatIndex() && SeatFiringMode(SeatIndex,,true) == 0 && !HullMGAmbient.bWasPlaying)
    {
        HullMGAmbient.Play();
    }
    */
    if (SeatIndex == GetGunnerSeatIndex() && SeatFiringMode(SeatIndex,,true) == 1 && !CoaxMGAmbient.bWasPlaying)
    {
        CoaxMGAmbient.Play();
    }
}

simulated function VehicleWeaponStoppedFiring(bool bViaReplication, int SeatIndex)
{
    Super.VehicleWeaponStoppedFiring(bViaReplication, SeatIndex);

    /*
    if ( SeatIndex == GetHullMGSeatIndex() )
    {
        if ( HullMGAmbient.bWasPlaying || !HullMGAmbient.bFinished )
        {
            HullMGAmbient.Stop();
            PlaySound(HullMGStopSound, TRUE, FALSE, FALSE, HullMGAmbient.CurrentLocation, FALSE);
        }
    }
    */
    if ( SeatIndex == GetGunnerSeatIndex() )
    {
        if ( CoaxMGAmbient.bWasPlaying || !CoaxMGAmbient.bFinished )
        {
            CoaxMGAmbient.Stop();
            PlaySound(CoaxMGStopSound, TRUE, FALSE, FALSE, CoaxMGAmbient.CurrentLocation, FALSE);
        }
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
    case `CRUSADER_DRIVER_SPI:
        // Driver
        DeathHitInfo_ProxyDriver.Damage = Damage;
        DeathHitInfo_ProxyDriver.HitLocation = HitLocation;
        DeathHitInfo_ProxyDriver.Momentum = Momentum;
        DeathHitInfo_ProxyDriver.DamageType = DamageType;
        break;
    case `CRUSADER_COMMANDER_SPI:
        // Commander
        DeathHitInfo_ProxyCommander.Damage = Damage;
        DeathHitInfo_ProxyCommander.HitLocation = HitLocation;
        DeathHitInfo_ProxyCommander.Momentum = Momentum;
        DeathHitInfo_ProxyCommander.DamageType = DamageType;
        break;
    case `CRUSADER_GUNNER_SPI:
        // Gunner
        DeathHitInfo_ProxyGunner.Damage = Damage;
        DeathHitInfo_ProxyGunner.HitLocation = HitLocation;
        DeathHitInfo_ProxyGunner.Momentum = Momentum;
        DeathHitInfo_ProxyGunner.DamageType = DamageType;
        break;
    }

    Super.DamageSeatProxy(SeatProxyIndex, Damage, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
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

function int GetLoaderHitZoneIndex()
{
    return VehHitZones.Find('ZoneName', 'COMMANDERHEAD');
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

    if (MeshComp != None)
    {
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
}

/** Leave blood splats on a specific area in a vehicle
 * @param InSeatIndex The seat around which we should leave blood splats
 */
simulated function LeaveBloodSplats(int InSeatIndex)
{
}

simulated function int GetHullMGSeatIndex()
{
    // Mk III has no hull MG.
    return INDEX_NONE;
}

simulated function ZoneHealthDamaged(int ZoneIndexUpdated, optional Controller DamageInstigator)
{
    local float ZoneHealthPercentage;

    super.ZoneHealthDamaged(ZoneIndexUpdated, DamageInstigator);

    if ( WorldInfo.NetMode != NM_DedicatedServer )
    {
        if ( VehHitZones[ZoneIndexUpdated].ZoneName == 'MAINCANNONREAR' )
        {
            ZoneHealthPercentage = float(VehHitzones[ZoneIndexUpdated].ZoneHealth) / float(default.VehHitzones[ZoneIndexUpdated].ZoneHealth);

            if ( Mesh.ForcedLodModel == 1 )
            {
                // Main gun
                InteriorMICs[2].SetScalarParameterValue('damage01', 1.0 - ZoneHealthPercentage);
            }
        }
    }
}

simulated function ZoneHealthRepaired(int ZoneIndexUpdated)
{
    local float ZoneHealthPercentage;

    super.ZoneHealthRepaired(ZoneIndexUpdated);

    if ( WorldInfo.NetMode != NM_DedicatedServer )
    {
        if ( VehHitZones[ZoneIndexUpdated].ZoneName == 'MAINCANNONREAR' )
        {
            ZoneHealthPercentage = float(VehHitzones[ZoneIndexUpdated].ZoneHealth) / float(default.VehHitzones[ZoneIndexUpdated].ZoneHealth);

            if ( Mesh.ForcedLodModel == 1 )
            {
                // Main gun
                InteriorMICs[2].SetScalarParameterValue('damage01', 1.0 - ZoneHealthPercentage);
            }
        }
    }
}

/**
 * Called when the health of a ArmorPlateZoneHealths changes. Called directly on
 * the server and through replication of ArmorPlateZoneHealthsCompressed on the
 * client.
 *
 * @param   HitArmorZoneType  The index of the ArmorPlateZoneHealths whose health changed
 */
simulated function ArmorZoneHealthUpdated(int HitArmorZoneType)
{
    local float FrontHealthPercentage, BackHealthPercentage;
    local float LeftHealthPercentage, RightHealthPercentage;
    local float TurretHealthPercentage;
    local int MostDamagedTurretZone;

    super.ArmorZoneHealthUpdated(HitArmorZoneType);

    if ( WorldInfo.NetMode != NM_DedicatedServer )
    {
        if( HitArmorZoneType == AZT_Front || HitArmorZoneType == AZT_Left || HitArmorZoneType == AZT_Right )
        {
            FrontHealthPercentage = float(ArmorPlateZoneHealths[AZT_Front]) / float(default.ArmorPlateZoneHealths[AZT_Front]);
            LeftHealthPercentage = float(Max(ArmorPlateZoneHealths[AZT_Left],0)) / float(default.ArmorPlateZoneHealths[AZT_Left]);
            RightHealthPercentage = float(Max(ArmorPlateZoneHealths[AZT_Right],0)) / float(default.ArmorPlateZoneHealths[AZT_Right]);

            // Handle Interior damage
            if ( Mesh.ForcedLodModel == 1 )
            {
                if( FrontHealthPercentage < LeftHealthPercentage || FrontHealthPercentage < RightHealthPercentage )
                {
                    //Damage the whole interior front if the front is more damaged than the sides
                    // Driver area
                    InteriorMICs[0].SetScalarParameterValue('damage02', 1.0 - FrontHealthPercentage);
                    InteriorMICs[1].SetScalarParameterValue('damage02', 1.0 - FrontHealthPercentage);
                    // Hull MG Area
                    InteriorMICs[0].SetScalarParameterValue('damage03', 1.0 - FrontHealthPercentage);
                    InteriorMICs[1].SetScalarParameterValue('damage03', 1.0 - FrontHealthPercentage);
                }
                else
                {
                    // Driver area
                    InteriorMICs[0].SetScalarParameterValue('damage02', 1.0 - LeftHealthPercentage);
                    InteriorMICs[1].SetScalarParameterValue('damage02', 1.0 - LeftHealthPercentage);
                    // Hull MG Area
                    InteriorMICs[0].SetScalarParameterValue('damage03', 1.0 - RightHealthPercentage);
                    InteriorMICs[1].SetScalarParameterValue('damage03', 1.0 - RightHealthPercentage);
                }
            }

            // Exterior damage
            ExteriorMICs[0].SetScalarParameterValue('Damage01', 1.0 - FrontHealthPercentage);
            ExteriorMICs[0].SetScalarParameterValue('Damage02', 1.0 - LeftHealthPercentage);
            ExteriorMICs[0].SetScalarParameterValue('Damage03', 1.0 - RightHealthPercentage);
        }
        else if( HitArmorZoneType == AZT_Back )
        {
            BackHealthPercentage = float(Max(ArmorPlateZoneHealths[AZT_Back],0)) / float(default.ArmorPlateZoneHealths[AZT_Back]);

            // Exterior damage
            ExteriorMICs[0].SetScalarParameterValue('Damage04', 1.0 - BackHealthPercentage);
        }
        else if( HitArmorZoneType == AZT_TurretFront || HitArmorZoneType == AZT_TurretBack ||
            HitArmorZoneType == AZT_TurretLeft || HitArmorZoneType == AZT_TurretRight )
        {
            MostDamagedTurretZone = AZT_TurretFront;

            if( ArmorPlateZoneHealths[AZT_TurretBack] < ArmorPlateZoneHealths[AZT_TurretFront] )
            {
                MostDamagedTurretZone = AZT_TurretBack;
            }

            if( ArmorPlateZoneHealths[AZT_TurretLeft] < ArmorPlateZoneHealths[MostDamagedTurretZone] )
            {
                MostDamagedTurretZone = AZT_TurretLeft;
            }

            if( ArmorPlateZoneHealths[AZT_TurretRight] < ArmorPlateZoneHealths[MostDamagedTurretZone] )
            {
                MostDamagedTurretZone = AZT_TurretRight;
            }

            TurretHealthPercentage = float(Max(ArmorPlateZoneHealths[MostDamagedTurretZone],0)) / float(default.ArmorPlateZoneHealths[MostDamagedTurretZone]);

            // Handle Interior damage
            if ( Mesh.ForcedLodModel == 1 )
            {
                // Turret area
                InteriorMICs[0].SetScalarParameterValue('damage01', 1.0 - TurretHealthPercentage);
            }

            // Exterior damage
            ExteriorMICs[0].SetScalarParameterValue('Damage05', 1.0 - TurretHealthPercentage);
        }
    }
}

/**
 * Handle transitions between seats in the vehicle which need to be animated or
 * swap meshes. Here we handle the specific per vehicle implementation of the
 * visible animated transitions between seats or the mesh swapped proxy mesh
 * instant transitions. For animated transitions that involve the turret area,
 * it performs the first half of the transition, moving them to a position
 * under the turret area. These transitions must be split into two parts,
 * since the turret can rotate, we move the players to a position under the
 * turret that will always be in the same place no matter which direction the
 * turret is rotated. Then the second half of the transition starts from this
 * position.
 *
 * @param   DriverPawn        The pawn driver that is transitioning seats
 * @param   NewSeatIndex      The SeatIndex the pawn is moving to
 * @param   OldSeatIndex      The SeatIndex the pawn is moving from
 * @param   bInstantTransition    True if this is an instant transition not an animated transition
 * Network: Called on network clients when the ROPawn Driver's VehicleSeatTransition
 * is changed. HandleSeatTransition is called directly on the server and in standalone
 */
simulated function HandleSeatTransition(ROPawn DriverPawn, int NewSeatIndex, int OldSeatIndex, bool bInstantTransition)
{
    local bool bAttachDriverPawn, bUseExteriorAnim;
    local float AnimTimer;
    local name TransitionAnim, TimerName;

    super.HandleSeatTransition(DriverPawn, NewSeatIndex, OldSeatIndex, bInstantTransition);

    `log("HandleSeatTransition(): DriverPawn=" $ DriverPawn $ " NewSeatIndex=" $ NewSeatIndex
        $ " OldSeatIndex=" $ OldSeatIndex $ " bInstantTransition=" $ bInstantTransition);

    if( bInstantTransition )
    {
        return;
    }

    bUseExteriorAnim = IsSeatPositionOutsideTank(OldSeatIndex);

    // Moving out of the driver seat
    if( OldSeatIndex == 0 )
    {
        // Transition from driver to commander
        if( NewSeatIndex == 1 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Driver_Open_TranTurret' : 'Driver_TranTurret';
            TimerName = 'SeatTransitioningDriverToTurretGoalCommander';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            bAttachDriverPawn = true;
        }
        // Transition from driver to gunner
        else if( NewSeatIndex == 2 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Driver_Open_TranTurret' : 'Driver_TranTurret';
            TimerName = 'SeatTransitioningDriverToTurretGoalGunner';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            bAttachDriverPawn = true;
        }
        /*
        // Transition from driver to hull MG
        else if( NewSeatIndex == 3 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Driver_Open_TranMG' : 'Driver_TranMg';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            TimerName = 'SeatTransitioningThree';
        }
        */
    }
    // moving into the driver seat
    else if( NewSeatIndex == 0 )
    {
        // Transition from commander to driver
        if( OldSeatIndex == 1 )
        {
            // Commander
            TransitionAnim = (bUseExteriorAnim) ? 'Com_Open_TranTurret' : 'Com_TranTurret';
            TimerName = 'SeatTransitioningCommanderToTurretGoalDriver';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
            bAttachDriverPawn = true;
        }
        // Transition from gunner to driver
        else if( OldSeatIndex == 2 )
        {
            // Gunner
            TransitionAnim = 'Gunner_TranTurret';
            TimerName = 'SeatTransitioningGunnerToTurretGoalDriver';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
            bAttachDriverPawn = true;
        }
        /*
        // Transition from hull MG to driver
        else if( OldSeatIndex == 3 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'MG_Open_TranDriver' : 'MG_TranDriver';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            TimerName = 'SeatTransitioningZero';
        }
        */
    }
    // Transition to Commander
    else if( NewSeatIndex == 1 )
    {
        // Transition from gunner to commander
        if( OldSeatIndex == 2 )
        {
            // Gunner
            TransitionAnim = 'Com_gunnerTOclose';
            TimerName = 'SeatTransitioningOne';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
            //bAttachDriverPawn = true;
        }
        /*
        // Transition from hull MG to commander
        else if( OldSeatIndex == 3 )
        {
            // Commander
            TransitionAnim = (bUseExteriorAnim) ? 'MG_Open_TranTurret' : 'MG_TranTurret';
            TimerName = 'SeatTransitioningMGToTurretGoalCommander';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            bAttachDriverPawn = true;
        }
        */
    }
    // Transition to gunner
    else if( NewSeatIndex == 2 )
    {
        // Transition from commander to gunner
        if( OldSeatIndex == 1 )
        {
            // Gunner
            TransitionAnim = 'Com_closeTOgunner';
            TimerName = 'SeatTransitioningTwo';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
            //bAttachDriverPawn = true;
        }
        /*
        // Transition from hull MG to gunner
        else if( OldSeatIndex == 3 )
        {
            // Commander
            TransitionAnim = (bUseExteriorAnim) ? 'MG_Open_TranTurret' : 'MG_TranTurret';
            TimerName = 'SeatTransitioningMGToTurretGoalGunner';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            bAttachDriverPawn = true;
        }
        */
    }
    /*
    // Transition to Hull MG
    else if( NewSeatIndex == 3 )
    {
        // Transition from commander to hull MG
        if( OldSeatIndex == 1 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Com_Open_TranTurret' : 'Com_TranTurret';
            TimerName = 'SeatTransitioningCommanderToTurretGoalMG';
        }
        // Transition from gunner to hull mg
        else if( OldSeatIndex == 2 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Com_Open_TranTurret' : 'Com_TranTurret';
            TimerName = 'SeatTransitioningGunnerToTurretGoalMG';
        }

        Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
        bAttachDriverPawn = true;
    }
    */

    // Store a reference to the driver pawn making the transition so we can use
    // it for the second part of timer driven transitions
    Seats[NewSeatIndex].TransitionPawn = DriverPawn;

    // If this transition requires us to attach the driver to a different bone, do that here
    if( bAttachDriverPawn )
    {
        DriverPawn.SetBase( Self, , Mesh, Seats[NewSeatIndex].SeatTransitionBoneName);
        DriverPawn.SetRelativeLocation( Seats[NewSeatIndex].SeatOffset );
        DriverPawn.SetRelativeRotation( Seats[NewSeatIndex].SeatRotation );
    }

    Seats[OldSeatIndex].PositionBlend.HandleAnimPlay(TransitionAnim, false);

    // Set up the transition and animation
    Seats[NewSeatIndex].bTransitioningToSeat = true;
    Seats[NewSeatIndex].PositionBlend.HandleAnimPlay(TransitionAnim, false);

    AnimTimer = DriverPawn.Mesh.GetAnimLength(TransitionAnim);
    DriverPawn.PlayFullBodyAnimation(TransitionAnim);

    // Set up the timer for ending the transition
    SetTimer(AnimTimer, false, TimerName);
}

/**
 * Handle SeatProxy transitions between seats in the vehicle which need to be
 * animated or swap meshes. When called on the server the subclasses handle
 * replicating the information so the animations happen on the client
 * Since the transitions are very vehicle specific, all of the actual animations,
 * etc must be implemented in subclasses
 * @param   NewSeatIndex          The SeatIndex the proxy is moving to
 * @param   OldSeatIndex          The SeatIndex the proxy is moving from
 * Network: Called on network clients when the ProxyTransition variables
 * implemented in subclassare are changed. HandleProxySeatTransition is called
 * directly on the server and in standalone
 */
simulated function HandleProxySeatTransition(int NewSeatIndex, int OldSeatIndex)
{
    local bool bAttachProxy;
    local float AnimTimer;
    local name TransitionAnim, TimerName;
    local DRVehicleCrewProxy VCP;
    local bool bTransitionWithoutProxy;
    local bool bUseExteriorAnim;

    super.HandleProxySeatTransition(NewSeatIndex, OldSeatIndex);

    VCP = DRVehicleCrewProxy(SeatProxies[GetSeatProxyIndexForSeatIndex(NewSeatIndex)].ProxyMeshActor);

    bUseExteriorAnim = IsSeatPositionOutsideTank(OldSeatIndex);

    // if there is no proxy it is likely the dedicated server. Set a flag
    // so we know we are doing the transition without a proxy
    if( VCP == none )
    {
        bTransitionWithoutProxy = true;
    }

    // Moving out of the driver seat
    if( OldSeatIndex == 0 )
    {
        // Transition from driver to commander
        if( NewSeatIndex == 1 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Driver_Open_TranTurret' : 'Driver_TranTurret';
            TimerName = 'SeatProxyTransitioningDriverToTurretGoalCommander';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            bAttachProxy = true;
        }
        // Transition from driver to gunner
        else if( NewSeatIndex == 2 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Driver_Open_TranTurret' : 'Driver_TranTurret';
            TimerName = 'SeatProxyTransitioningDriverToTurretGoalGunner';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            bAttachProxy = true;
        }
        /*
        // Transition from driver to hull MG
        else if( NewSeatIndex == 3 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Driver_Open_TranMG' : 'Driver_TranMg';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            TimerName = 'SeatTransitioningThree';
        }
        // Transition from driver to Loader
        else if( NewSeatIndex == 4 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Driver_Open_TranTurret' : 'Driver_TranTurret';
            TimerName = 'SeatProxyTransitioningDriverToTurretGoalLoader';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            bAttachProxy = true;
        }
        */
    }
    // moving into the driver seat
    else if( NewSeatIndex == 0 )
    {
        // Transition from commander to driver
        if( OldSeatIndex == 1 )
        {
            // Commander
            TransitionAnim = (bUseExteriorAnim) ? 'Com_Open_TranTurret' : 'Com_TranTurret';
            TimerName = 'SeatProxyTransitioningCommanderToTurretGoalDriver';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
            bAttachProxy = true;
        }
        // Transition from gunner to driver
        else if( OldSeatIndex == 2 )
        {
            // Gunner
            TransitionAnim = 'Gunner_TranTurret';
            TimerName = 'SeatProxyTransitioningGunnerToTurretGoalDriver';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
            bAttachProxy = true;
        }
        /*
        // Transition from hull MG to driver
        else if( OldSeatIndex == 3 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'MG_Open_TranDriver' : 'MG_TranDriver';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            TimerName = 'SeatTransitioningZero';
        }
        */
    }
    // Transition to Commander
    else if( NewSeatIndex == 1 )
    {
        // Transition from gunner to commander
        if( OldSeatIndex == 2 )
        {
            // Gunner
            TransitionAnim = 'Com_gunnerTOclose';
            TimerName = 'SeatTransitioningOne';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
        }
        // Transition from hull MG to commander
        else if( OldSeatIndex == 3 )
        {
            // Commander
            TransitionAnim = (bUseExteriorAnim) ? 'MG_Open_TranTurret' : 'MG_TranTurret';
            TimerName = 'SeatProxyTransitioningMGToTurretGoalCommander';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            bAttachProxy = true;
        }
    }
    // Transition to gunner
    else if( NewSeatIndex == 2 )
    {
        // Transition from commander to gunner
        if( OldSeatIndex == 1 )
        {
            // Gunner
            TransitionAnim = 'Com_closeTOgunner';
            TimerName = 'SeatTransitioningTwo';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
        }
        // Transition from hull MG to gunner
        else if( OldSeatIndex == 3 )
        {
            // Commander
            TransitionAnim = (bUseExteriorAnim) ? 'MG_Open_TranTurret' : 'MG_TranTurret';
            TimerName = 'SeatProxyTransitioningMGToTurretGoalGunner';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            bAttachProxy = true;
        }
    }
    /*
    // Transition to Hull MG
    else if( NewSeatIndex == 3 )
    {
        // Transition from commander to hull MG
        if( OldSeatIndex == 1 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Com_Open_TranTurret' : 'Com_TranTurret';
            TimerName = 'SeatProxyTransitioningCommanderToTurretGoalMG';
        }
        // Transition from gunner to hull mg
        else if( OldSeatIndex == 2 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Com_Open_TranTurret' : 'Com_TranTurret';
            TimerName = 'SeatProxyTransitioningGunnerToTurretGoalMG';
        }

        Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
        bAttachProxy = true;
    }
    */
    /*
    // Transition to Loader
    else if( NewSeatIndex == 4 )
    {
        // Transition from commander to loader
        if( OldSeatIndex == 1 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Com_Open_TranLoader' : 'Com_TranLoader';
            TimerName = 'SeatTransitioningFour';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
        }
        // Transition from gunner to loader
        else if( OldSeatIndex == 2 )
        {
            TransitionAnim = 'Gunner_TranLoader';
            TimerName = 'SeatTransitioningFour';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
        }
        // Transition from hull MG to loader
        else if( OldSeatIndex == 3 )
        {
            // Commander
            TransitionAnim = (bUseExteriorAnim) ? 'MG_Open_TranTurret' : 'MG_TranTurret';
            TimerName = 'SeatProxyTransitioningMGToTurretGoalLoader';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            bAttachProxy = true;
        }
    }
    */

    // Store a reference to the driver pawn making the transition so we can use
    // it for the second part of timer driven transitions
    Seats[NewSeatIndex].TransitionProxy = VCP;

    // If this transition requires us to attach the driver to a different bone, do that here
    if( bAttachProxy && !bTransitionWithoutProxy )
    {
        VCP.SetBase( Self, , Mesh, Seats[NewSeatIndex].SeatTransitionBoneName);
        VCP.SetRelativeLocation( Seats[NewSeatIndex].SeatOffset );
        VCP.SetRelativeRotation( Seats[NewSeatIndex].SeatRotation );
    }

    if( bTransitionWithoutProxy )
    {
       // Set up the transition timer
       AnimTimer = SeatProxyAnimSet.GetAnimLength(TransitionAnim);
    }
    else
    {
        // Set up the transition and animation
        AnimTimer = VCP.Mesh.GetAnimLength(TransitionAnim);
    }

    Seats[OldSeatIndex].PositionBlend.HandleAnimPlay(TransitionAnim, false);

    Seats[NewSeatIndex].bTransitioningToSeat = true;
    Seats[NewSeatIndex].PositionBlend.HandleAnimPlay(TransitionAnim, false);

    if( !bTransitionWithoutProxy )
    {
       VCP.PlayFullBodyAnimation(TransitionAnim, 0.f);
    }

    // Set up the timer for ending the transition
    SetTimer(AnimTimer, false, TimerName);
}

/**
 * Finish a visible animated transition to Seat Index 0
 */
simulated function SeatTransitioningZero()
{
    FinishTransition(0);
}

/**
 * Finish a visible animated transition to Seat Index 1
 */
simulated function SeatTransitioningOne()
{
    FinishTransition(1);
}

/**
 * Finish a visible animated transition to Seat Index 2
 */
simulated function SeatTransitioningTwo()
{
    FinishTransition(2);
}

/**
 * Finish a visible animated transition to Seat Index 3
 */
simulated function SeatTransitioningThree()
{
    FinishTransition(3);
}

/**
 * Finish a visible animated transition to Seat Index 3
 */
simulated function SeatTransitioningFour()
{
    FinishTransition(4);
}

/**
 * Handle the second half of a visible animated transition from the driver
 * position to the Commander Cuppola in the turret.
 */
simulated function SeatTransitioningDriverToTurretGoalCommander()
{
    StartTurretTransition('Turret', 'Turret_TranCom', 1, 'SeatTransitioningOne');
}

/**
 * Handle the second half of a visible animated transition from the driver
 * position to the Gunner position in the turret.
 */
simulated function SeatTransitioningDriverToTurretGoalGunner()
{
    StartTurretTransition('Turret', 'Turret_TranGunner', 2, 'SeatTransitioningTwo');
}

/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the driver position.
 */
simulated function SeatTransitioningCommanderToTurretGoalDriver()
{
    StartTurretTransition('Chassis', 'Turret_TranDriver', 0, 'SeatTransitioningZero');
}

/**
 * Handle the second half of a visible animated transition from the gunner
 * position in the turret to the driver position.
 */
simulated function SeatTransitioningGunnerToTurretGoalDriver()
{
    StartTurretTransition('Chassis', 'Turret_TranDriver', 0, 'SeatTransitioningZero');
}

/**
 * Handle the second half of a visible animated transition from the hull MG
 * position to the Commander Cuppola in the turret.
 */
simulated function SeatTransitioningMGToTurretGoalCommander()
{
    StartTurretTransition('Turret', 'Turret_TranCom', 1, 'SeatTransitioningOne');
}

/**
 * Handle the second half of a visible animated transition from the hull MG
 * position to the Gunner position in the turret.
 */
simulated function SeatTransitioningMGToTurretGoalGunner()
{
    StartTurretTransition('Turret', 'Turret_TranGunner', 2, 'SeatTransitioningTwo');
}

/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the hull MG position.
 */
simulated function SeatTransitioningCommanderToTurretGoalMG()
{
    StartTurretTransition('Chassis', 'Turret_TranMG', 3, 'SeatTransitioningThree');
}

/**
 * Handle the second half of a visible animated transition from the gunner
 * position in the turret to the hull MG position.
 */
simulated function SeatTransitioningGunnerToTurretGoalMG()
{
    StartTurretTransition('Chassis', 'Turret_TranMG', 3, 'SeatTransitioningThree');
}

/**
 * Handle the second half of a visible animated transition from the driver
 * position to the Commander Cuppola in the turret.
 */
simulated function SeatProxyTransitioningDriverToTurretGoalCommander()
{
    StartTurretTransition('Turret', 'Turret_TranCom', 1, 'SeatTransitioningOne', true);
}

/**
 * Handle the second half of a visible animated transition from the driver
 * position to the Gunner position in the turret.
 */
simulated function SeatProxyTransitioningDriverToTurretGoalGunner()
{
    StartTurretTransition('Turret', 'Turret_TranGunner', 2, 'SeatTransitioningTwo', true);
}

/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the driver position.
 */
simulated function SeatProxyTransitioningCommanderToTurretGoalDriver()
{
    StartTurretTransition('Chassis', 'Turret_TranDriver', 0, 'SeatTransitioningZero', true);
}

/**
 * Handle the second half of a visible animated transition from the gunner
 * position in the turret to the driver position.
 */
simulated function SeatProxyTransitioningGunnerToTurretGoalDriver()
{
    StartTurretTransition('Chassis', 'Turret_TranDriver', 0, 'SeatTransitioningZero', true);
}

/**
 * Handle the second half of a visible animated transition from the hull MG
 * position to the Commander Cuppola in the turret.
 */
simulated function SeatProxyTransitioningMGToTurretGoalCommander()
{
    StartTurretTransition('Turret', 'Turret_TranCom', 1, 'SeatTransitioningOne', true);
}

/**
 * Handle the second half of a visible animated transition from the hull MG
 * position to the Gunner position in the turret.
 */
simulated function SeatProxyTransitioningMGToTurretGoalGunner()
{
    StartTurretTransition('Turret', 'Turret_TranGunner', 2, 'SeatTransitioningTwo', true);
}

/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the hull MG position.
 */
simulated function SeatProxyTransitioningCommanderToTurretGoalMG()
{
    StartTurretTransition('Chassis', 'Turret_TranMG', 3, 'SeatTransitioningThree', true);
}

/**
 * Handle the second half of a visible animated transition from the gunner
 * position in the turret to the hull MG position.
 */
simulated function SeatProxyTransitioningGunnerToTurretGoalMG()
{
    StartTurretTransition('Chassis', 'Turret_TranMG', 3, 'SeatTransitioningThree', true);
}

/**
 * Handle the second half of a visible animated transition from the hull MG
 * position loader position.
 */
simulated function SeatProxyTransitioningMGToTurretGoalLoader()
{
    StartTurretTransition('Turret', 'Turret_TranLoader', 4, 'SeatTransitioningFour', true);
}

/**
 * Handle the second half of a visible animated transition from the driver
 * position loader position.
 */
simulated function SeatProxyTransitioningDriverToTurretGoalLoader()
{
    StartTurretTransition('Turret', 'Turret_TranLoader', 4, 'SeatTransitioningFour', true);
}

simulated function PositionIndexUpdated(int SeatIndex, byte NewPositionIndex)
{
    /*
    if( SeatIndex == GetHullMGSeatIndex() )
    {
        if ( NewPositionIndex == 2 )
        {
            MGController.SetSkelControlActive(true);
        }
        else
        {
            MGController.SetSkelControlActive(false);
            Seats[SeatIndex].Gun.ForceEndFire();
        }
    }
    */
    if( SeatIndex == GetGunnerSeatIndex() )
    {
        if( NewPositionIndex != Seats[SeatIndex].FiringPositionIndex )
        {
            Seats[SeatIndex].Gun.ForceEndFire();
        }
    }

    super.PositionIndexUpdated(SeatIndex, NewPositionIndex);
}

`ifndef(ShippingPC)
function TankExtDamTest(int DamageArea, Float Amount)
{
     // Front
    if( DamageArea == 1 )
    {
        ExteriorMICs[0].SetScalarParameterValue('Damage01', Amount);
    }
    // Left
    else if( DamageArea == 2 )
    {
        ExteriorMICs[0].SetScalarParameterValue('Damage02', Amount);
    }
    // Right
    else if( DamageArea == 3 )
    {
        ExteriorMICs[0].SetScalarParameterValue('Damage03', Amount);
    }
    // Rear
    else if( DamageArea == 4 )
    {
        ExteriorMICs[0].SetScalarParameterValue('Damage04', Amount);
    }
    // Turret
    else if( DamageArea == 5 )
    {
        ExteriorMICs[0].SetScalarParameterValue('Damage05', Amount);
    }
}

function TankIntDamTest(int MIC, int DamageArea, Float Amount)
{
    // Vehicle-specific
    // Walls?
    if( MIC == 0 )
    {
        // Makes walls look dirty in the turret area
        if( DamageArea == 1 )
        {
            InteriorMICs[MIC].SetScalarParameterValue('Damage01', Amount);
        }
        // Makes walls look dirty in the driver area
        else if( DamageArea == 2 )
        {
            InteriorMICs[MIC].SetScalarParameterValue('Damage02', Amount);
        }
        // Makes walls look dirty in the hull MG area
        else if( DamageArea == 3 )
        {
            InteriorMICs[MIC].SetScalarParameterValue('Damage03', Amount);
        }
        // Makes walls look effed up all over
        else if( DamageArea == 4 )
        {
            InteriorMICs[MIC].SetScalarParameterValue('Damage04', Amount);
        }
    }
    // Front
    else if( MIC == 1 )
    {
        // Makes small items in the front of the tank look dirty/messed up
        if( DamageArea == 1 )
        {
            InteriorMICs[MIC].SetScalarParameterValue('Damage01', Amount);
        }
        // Makes small items in the driver area look dirty/messed up
        else if( DamageArea == 2 )
        {
            InteriorMICs[MIC].SetScalarParameterValue('Damage02', Amount);
        }
        // Makes small items in the hull mg area look dirty/messed up
        else if( DamageArea == 3 )
        {
            InteriorMICs[MIC].SetScalarParameterValue('Damage03', Amount);
        }
        // Makes small items all over the front of the tank look dirty/messed up
        else if( DamageArea == 4 )
        {
            InteriorMICs[MIC].SetScalarParameterValue('Damage04', Amount);
        }
    }
    // Turret
    else if( MIC == 2 )
    {
        // Makes the main gun look dirty/messed up
        if( DamageArea == 1 )
        {
            InteriorMICs[MIC].SetScalarParameterValue('Damage01', Amount);
        }
        // Makes different small items all over the main gun/turret area look dirty/messed up
        else if( DamageArea == 2 )
        {
            InteriorMICs[MIC].SetScalarParameterValue('Damage02', Amount);
        }
        // Makes different small items all over the main gun/turret area look dirty/messed up
        else if( DamageArea == 3 )
        {
            InteriorMICs[MIC].SetScalarParameterValue('Damage03', Amount);
        }
        // Makes various things all over the main gun/turret area look completely messed up
        else if( DamageArea == 4 )
        {
            InteriorMICs[MIC].SetScalarParameterValue('Damage04', Amount);
        }
    }
}

`endif

DefaultProperties
{
    Team=`ALLIES_TEAM_INDEX

    Health=600
    MaxSpeed=573    // 42 km/h

    Begin Object Name=CollisionCylinder
        CollisionHeight=60.0
        CollisionRadius=260.0
        Translation=(X=0.0,Y=0.0,Z=0.0)
    End Object
    CylinderComponent=CollisionCylinder

    bDontUseCollCylinderForRelevancyCheck=true
    RelevancyHeight=90.0
    RelevancyRadius=155.0

    //--------------------------------------------------------
    //                 Interior lights
    //--------------------------------------------------------

    // Begin Object class=PointLightComponent name=InteriorLight_0
    //     Radius=75.0
    //     LightColor=(R=255,G=170,B=130)
    //     UseDirectLightMap=FALSE
    //     Brightness=1.0
    //     LightingChannels=(Unnamed_1=TRUE,BSP=FALSE,Static=FALSE,Dynamic=FALSE,CompositeDynamic=FALSE)
    // End Object

    // Begin Object class=PointLightComponent name=InteriorLight_1
    //     Radius=75.0
    //     LightColor=(R=255,G=170,B=130)
    //     UseDirectLightMap=FALSE
    //     Brightness=1.0
    //     LightingChannels=(Unnamed_1=TRUE,BSP=FALSE,Static=FALSE,Dynamic=FALSE,CompositeDynamic=FALSE)
    // End Object

    // VehicleLights(0)={(AttachmentName=InteriorLightComponent0,Component=InteriorLight_0,bAttachToSocket=true,AttachmentTargetName=interior_light_0)}
    // VehicleLights(1)={(AttachmentName=InteriorLightComponent1,Component=InteriorLight_1,bAttachToSocket=true,AttachmentTargetName=interior_light_1)}

    // once we get the magic bones onto the goliath then we can change the InfluenceBones to be those and this should just work
//  DamageMorphTargets(0)=(InfluenceBone=b_FrontDamage,MorphNodeName=MorphNodeW_Front,LinkedMorphNodeName=none,Health=190,DamagePropNames=(Damage2))
//  DamageMorphTargets(1)=(InfluenceBone=b_RearDamage,MorphNodeName=MorphNodeW_Back,LinkedMorphNodeName=none,Health=190,DamagePropNames=(Damage3))
//  DamageMorphTargets(2)=(InfluenceBone=Suspension_LHS_02,MorphNodeName=MorphNodeW_LHS,LinkedMorphNodeName=none,Health=190,DamagePropNames=(Damage1))
//  DamageMorphTargets(3)=(InfluenceBone=Suspension_RHS_02,MorphNodeName=MorphNodeW_RHS,LinkedMorphNodeName=none,Health=190,DamagePropNames=(Damage1))
//  DamageMorphTargets(4)=(InfluenceBone=Object01,MorphNodeName=MorphNodeW_Turret,LinkedMorphNodeName=none,Health=190,DamagePropNames=(Damage6))
//
//  DamageParamScaleLevels(0)=(DamageParamName=Damage1,Scale=5.0)
//  DamageParamScaleLevels(1)=(DamageParamName=Damage2,Scale=5.0)
//  DamageParamScaleLevels(2)=(DamageParamName=Damage3,Scale=5.0)
//  DamageParamScaleLevels(3)=(DamageParamName=Damage6,Scale=2.0)


//  Begin Object Class=AudioComponent name=AmbientSoundComponent
//      bShouldRemainActiveIfDropped=true
//      bStopWhenOwnerDestroyed=true
//      SoundCue=SoundCue'A_Vehicle_Goliath.SoundCues.A_Vehicle_Goliath_TurretFire_Cue'
//  End Object
//  MachineGunAmbient=AmbientSoundComponent
//  Components.Add(AmbientSoundComponent)

//  MachineGunStopSound=SoundCue'A_Vehicle_Goliath.SoundCues.A_Vehicle_Goliath_TurretFireStop_Cue'

//  DrawScale=1.35

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

    Seats(1)={(
        TurretVarPrefix="Cuppola",
        BinocOverlayTexture=Texture2D'WP_VN_VC_Binoculars.Materials.BINOC_overlay',
        BarTexture=Texture2D'ui_textures.Textures.button_128grey',
        CameraTag=None,
        CameraOffset=-420,
        bSeatVisible=false,
        SeatBone=Turret,
        SeatAnimBlendName=CommanderPositionNode,
        DriverDamageMult=1.0,
        InitialPositionIndex=2,
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        VehicleBloodMICParameterName=Gore04,
        // SeatIconPos=(X=0.33,Y=0.35),
        // WeaponEffects=((SocketName=TurretFireSocket,Offset=(X=-125),Scale3D=(X=14.0,Y=10.0,Z=10.0))),
        SeatPositions=
        (
            // 0
            (
                bDriverVisible=false,
                bAllowFocus=false,
                // bDrawOverlays=true,
                bBinocsPosition=true,
                PositionCameraTag=None,
                ViewFOV=5.4,
                bRotateGunOnCommand=true,
                PositionUpAnim=Com_close_idle,
                PositionIdleAnim=Com_close_idle,
                DriverIdleAnim=Com_close_idle,
                AlternateIdleAnim=Com_close_idle,
                SeatProxyIndex=`CRUSADER_COMMANDER_SPI,
                bIsExterior=false,
                LeftHandIKInfo=(PinEnabled=true),
                RightHandIKInfo=(PinEnabled=true),
                HipsIKInfo=(PinEnabled=true),
                LeftFootIKInfo=(PinEnabled=true),
                RightFootIKInfo=(PinEnabled=true),
                PositionFlinchAnims=(Com_close_idle),
                PositionDeathAnims=(Com_close_idle)
            ),

            // 1
            (
                bDriverVisible=true,
                bAllowFocus=true,
                PositionCameraTag=None,
                ViewFOV=70.0,
                bRotateGunOnCommand=true,
                PositionDownAnim=Com_close_idle,
                PositionUpAnim=Com_close_idle,
                PositionIdleAnim=Com_close_idle,
                DriverIdleAnim=Com_close_idle,
                AlternateIdleAnim=Com_close_idle,
                SeatProxyIndex=`CRUSADER_COMMANDER_SPI,
                bIsExterior=false,
                LeftHandIKInfo=(PinEnabled=true),
                RightHandIKInfo=(PinEnabled=true),
                HipsIKInfo=(PinEnabled=true),
                LeftFootIKInfo=(PinEnabled=true),
                RightFootIKInfo=(PinEnabled=true),
                PositionFlinchAnims=(Com_close_idle),
                PositionDeathAnims=(Com_close_idle)
            ),

            // 2
            (
                bDriverVisible=false,
                bAllowFocus=true,
                PositionCameraTag=None,
                ViewFOV=70.0,
                bRotateGunOnCommand=true,
                PositionDownAnim=Com_close_idle,
                PositionIdleAnim=Com_close_idle,
                DriverIdleAnim=Com_close_idle,
                AlternateIdleAnim=Com_close_idle,
                SeatProxyIndex=`CRUSADER_COMMANDER_SPI,
                PositionUpAnim=Com_close_idle,
                LeftHandIKInfo=(PinEnabled=true),
                RightHandIKInfo=(PinEnabled=true),
                HipsIKInfo=(PinEnabled=true),
                LeftFootIKInfo=(PinEnabled=true),
                RightFootIKInfo=(PinEnabled=true),
                PositionFlinchAnims=(Com_close_idle),
                PositionDeathAnims=(Com_close_idle)
            )
        )
    )}

    Seats(2)={(
        GunClass=class'DRVWeap_CrusaderMkIII_Turret',
        SightOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_optics_Crusader',
        NeedleOverlayTexture=None,
        RangeOverlayTexture=None,
        VignetteOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_optics_vignette',
        GunSocket=(Barrel,CoaxMG),
        GunPivotPoints=(gun_base,gun_base),
        TurretVarPrefix="Turret",
        TurretControls=(Turret_Gun,Turret_Main),
        CameraTag=None,
        CameraOffset=-420,
        bSeatVisible=false,
        SeatBone=Turret,
        SeatAnimBlendName=GunnerPositionNode,
        DriverDamageMult=1.0,
        InitialPositionIndex=0,
        FiringPositionIndex=0,
        TracerFrequency=5,
        WeaponTracerClass=(none, class'M1919BulletTracer'),
        MuzzleFlashLightClass=(class'ROGrenadeExplosionLight', class'ROVehicleMGMuzzleFlashLight'),
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        VehicleBloodMICParameterName=Gore01,
        // SeatIconPos=(X=0.33,Y=0.35),
        // WeaponEffects=((SocketName=TurretFireSocket,Offset=(X=-125),Scale3D=(X=14.0,Y=10.0,Z=10.0))),
        SeatPositions=
        (
            (
                bDriverVisible=false,
                bAllowFocus=false,
                PositionCameraTag=Camera_Gunner,
                ViewFOV=13.5, //2.4x zoom
                bCamRotationFollowSocket=true,
                bViewFromCameraTag=true,
                bDrawOverlays=true,
                PositionDownAnim=Gunner_close_idle,
                PositionIdleAnim=Gunner_close_idle,
                DriverIdleAnim=Gunner_close_idle,
                AlternateIdleAnim=Gunner_close_idle,
                SeatProxyIndex=`CRUSADER_GUNNER_SPI,
                // LookAtInfo=(LookAtEnabled=true,DefaultLookAtTargetName=GunnerTraverseHandle,HeadInfluence=0.0,BodyInfluence=1.0))),
                LeftHandIKInfo=
                (
                    IKEnabled=false,
                    // DefaultEffectorLocationTargetName=GunnerElevationWheel,
                    // DefaultEffectorRotationTargetName=GunnerElevationWheel
                ),
                RightHandIKInfo=
                (
                    IKEnabled=false,
                    // DefaultEffectorLocationTargetName=GunnerTraverseHandle,
                    // DefaultEffectorRotationTargetName=GunnerTraverseHandle
                ),
                LeftFootIKInfo=(IKEnabled=false),
                RightFootIKInfo=(IKEnabled=false),
                PositionFlinchAnims=(Gunner_close_idle),
                PositionDeathAnims=(Gunner_close_idle)
            )
        )
    )}

    SeatIndexPassRotateOnCommandToOtherSeat=2
    SeatIndexToRotateOnCommandFromOtherSeat=1

    //_________________________
    // ROSkelControlTankWheels
    //
    LeftWheels.Empty
    LeftWheels(0)="L_Wheel_01"
    LeftWheels(1)="L_Wheel_02"
    LeftWheels(2)="L_Wheel_03"
    LeftWheels(3)="L_Wheel_04"
    LeftWheels(4)="L_Wheel_05"
    LeftWheels(5)="L_Wheel_06"
    LeftWheels(6)="L_Wheel_07"
    //
    RightWheels.Empty
    RightWheels(0)="R_Wheel_01"
    RightWheels(1)="R_Wheel_02"
    RightWheels(2)="R_Wheel_03"
    RightWheels(3)="R_Wheel_04"
    RightWheels(4)="R_Wheel_05"
    RightWheels(5)="R_Wheel_06"
    RightWheels(6)="R_Wheel_07"

    /** Physics Wheels */
    Wheels.Empty

    // Right Rear Wheel
    Begin Object Name=RRWheel
        BoneName="R_Wheel_06"
        BoneOffset=(X=0.0,Y=0,Z=12.5)
        WheelRadius=44
        SuspensionTravel=17.5
    End Object
    Wheels(0)=RRWheel

    // Right middle wheel
    Begin Object Name=RMWheel
        BoneName="R_Wheel_04"
        BoneOffset=(X=0.0,Y=0,Z=12.5)
        WheelRadius=44
        SuspensionTravel=17.5
    End Object
    Wheels(1)=RMWheel

    // Right Front Wheel
    Begin Object Name=RFWheel
        BoneName="R_Wheel_02"
        BoneOffset=(X=0.0,Y=0,Z=12.5)
        WheelRadius=44
        SuspensionTravel=17.5
    End Object
    Wheels(2)=RFWheel

    // Left Rear Wheel
    Begin Object Name=LRWheel
        BoneName="L_Wheel_06"
        BoneOffset=(X=0.0,Y=0,Z=12.5)
        WheelRadius=44
        SuspensionTravel=17.5
    End Object
    Wheels(3)=LRWheel

    // Left Middle Wheel
    Begin Object Name=LMWheel
        BoneName="L_Wheel_04"
        BoneOffset=(X=0.0,Y=0,Z=12.5)
        WheelRadius=44
        SuspensionTravel=17.5
    End Object
    Wheels(4)=LMWheel

    // Left Front Wheel
    Begin Object Name=LFWheel
        BoneName="L_Wheel_02"
        BoneOffset=(X=0.0,Y=0,Z=12.5)
        WheelRadius=44
        SuspensionTravel=17.5
    End Object
    Wheels(5)=LFWheel

    /** Vehicle Sim */

    Begin Object Name=SimObject
        // Transmission - GearData
        GearArray(0)={(
            // Real world - [5.64] 5.5 kph reverse
            GearRatio=-5.64,
            AccelRate=21.75,//7.5,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=-3000),
                (InVal=300,OutVal=-1000),
                (InVal=2800,OutVal=-3000.0),
                (InVal=3000,OutVal=-1000),
                (InVal=3200,OutVal=-0.0)
                )}),
            TurningThrottle=0.86
            )}
        GearArray(1)={(
            // [N/A]  reserved for neutral
            )}
        GearArray(2)={(
            // Real world - [6.89] 4.5 kph at 2800rpm
            GearRatio=6.89,
            AccelRate=27.55,//9.50,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=12480),
                (InVal=300,OutVal=4000),
                (InVal=2800,OutVal=12480.0),
                (InVal=3000,OutVal=7500.0),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=0.85
            )}
        GearArray(3)={(
            // Real world - [3.60] 8.6 kph
            GearRatio=3.60,
            AccelRate=29.00,//10.00,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=3400),
                (InVal=300,OutVal=2700),
                (InVal=2800,OutVal=3500),
                (InVal=3000,OutVal=1000),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=0.85
            )}
        GearArray(4)={(
            // Real world - [2.14] 14.5 kph
            GearRatio=2.14,
            AccelRate=27.115,//9.35,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=5000),
                (InVal=300,OutVal=3000),
                (InVal=2800,OutVal=6000),
                (InVal=3000,OutVal=2000),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=0.75
            )}
        GearArray(5)={(
            // Real world - [1.42] 21.9 kph
            GearRatio=1.42,
            AccelRate=31.00,//11.00,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=5000),
                (InVal=300,OutVal=3300),
                (InVal=2800,OutVal=7800),
                (InVal=3000,OutVal=4000),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=0.85
            )}
        GearArray(6)={(
            // Real world - [1.00] 31.0 kph
            GearRatio=1.00,
            AccelRate=32.48,//11.20,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=5000),
                (InVal=300,OutVal=3400),
                (InVal=2800,OutVal=10800),
                (InVal=3000,OutVal=5500),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=0.80
            )}
        GearArray(7)={(
            // Real world - [0.78] 40.0 kph
            GearRatio=0.78,
            AccelRate=32.48,//11.20,
            TorqueCurve=(Points={(
                (InVal=0,OutVal=5000),
                (InVal=300,OutVal=3500),
                (InVal=2800,OutVal=13800),
                (InVal=3000,OutVal=6000),
                (InVal=3200,OutVal=0.0)
                )}),
            TurningThrottle=0.80
            )}
        // Transmission - Misc
        FirstForwardGear=3
    End Object

    TreadSpeedScale=2.5 //2.75

    // Muzzle Flashes
    VehicleEffects(TankVFX_Firing1)=(EffectStartTag=PanzerIVGCannon,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_B_TankMuzzle',EffectSocket=Barrel,bRestartRunning=true)
    VehicleEffects(TankVFX_Firing2)=(EffectStartTag=PanzerIVGCannon,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_B_TankCannon_Dust',EffectSocket=attachments_body_ground,bRestartRunning=true)
    //? VehicleEffects(TankVFX_Firing3)=(EffectStartTag=PanzerIVGHullMG,EffectTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_split',EffectSocket=MG_Barrel)
    VehicleEffects(TankVFX_Firing4)=(EffectStartTag=PanzerIVGCoaxMG,EffectTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_split',EffectSocket=CoaxMG)
    // Driving effects
    VehicleEffects(TankVFX_Exhaust)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_A_TankExhaust',EffectSocket=Exhaust)
    VehicleEffects(TankVFX_TreadWing)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bStayActive=true,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_A_Wing_Dirt_PZ4',EffectSocket=attachments_body_ground)
    // Damage
    VehicleEffects(TankVFX_DmgSmoke)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_A_Damage',EffectSocket=attachments_engine)
    // VehicleEffects(TankVFX_DmgInterior)=(EffectStartTag=DamageInterior,EffectEndTag=NoInternalSmoke,bRestartRunning=false,bInteriorEffect=true,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_Interior_Penetrate',EffectSocket=attachments_body)
    // Death
    VehicleEffects(TankVFX_DeathSmoke1)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_1)
    VehicleEffects(TankVFX_DeathSmoke2)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_2)
    VehicleEffects(TankVFX_DeathSmoke3)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_3)

    TrackSoundParamScale=0.00004    // top speed : 25,000

//  CollisionSound=SoundCue'A_Vehicle_Goliath.SoundCues.A_Vehicle_Goliath_Collide'
//  EnterVehicleSound=SoundCue'A_Vehicle_Goliath.SoundCues.A_Vehicle_Goliath_Start'
//  ExitVehicleSound=SoundCue'A_Vehicle_Goliath.SoundCues.A_Vehicle_Goliath_Stop'

//  WheelParticleEffects[0]=(MaterialType=Generic,ParticleTemplate=ParticleSystem'Envy_Level_Effects_2.Vehicle_Dust_Effects.P_Goliath_Wheel_Dust')
//  WheelParticleEffects[1]=(MaterialType=Dirt,ParticleTemplate=ParticleSystem'Envy_Level_Effects_2.Vehicle_Dust_Effects.P_Goliath_Wheel_Dust')
//  WheelParticleEffects[2]=(MaterialType=Water,ParticleTemplate=ParticleSystem'Envy_Level_Effects_2.Vehicle_Water_Effects.P_Goliath_Water_Splash')
//  WheelParticleEffects[3]=(MaterialType=Snow,ParticleTemplate=ParticleSystem'Envy_Level_Effects_2.Vehicle_Dust_Effects.P_Goliath_Wheel_Dust')

    // Initialize sound parameters.
    SquealThreshold=250.0
    EngineStartOffsetSecs=2.0
    EngineStopOffsetSecs=0.0//1.0

//  IconCoords=(U=831,V=0,UL=27,VL=38)

    BigExplosionSocket=FX_Fire
    ExplosionTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_C_Explosion'

    ExplosionDamageType=class'RODmgType_VehicleExplosion'
    ExplosionDamage=100.0
    ExplosionRadius=300.0
    ExplosionMomentum=60000
    ExplosionInAirAngVel=1.5
    InnerExplosionShakeRadius=400.0
    OuterExplosionShakeRadius=1000.0
    ExplosionLightClass=class'ROGame.ROGrenadeExplosionLight'
    MaxExplosionLightDistance=4000.0
    TimeTilSecondaryVehicleExplosion=2.0f
    SecondaryExplosion=ParticleSystem'DR_VH_FX.FX_VEH_Tank_C_Explosion_Ammo'
    bHasTurretExplosion=true
    TurretExplosiveForce=15000

    TreadSpeedParameterName=Tank_Tread_Speed//Veh_Tread_Speed

//  FlagBone=Object01
//  FlagOffset=(X=-95.0,Y=59,Z=50)

    DrivingPhysicalMaterial=PhysicalMaterial'DR_VH_DAK_PanzerIV_F.Phys.PhysMat_PanzerIVG'
    DefaultPhysicalMaterial=PhysicalMaterial'DR_VH_DAK_PanzerIV_F.Phys.PhysMat_PanzerIVG_Moving'

//  BurnOutMaterial[0]=MaterialInterface'VH_Goliath.Materials.MITV_VH_Goliath01_Red_BO'
//  BurnOutMaterial[1]=MaterialInterface'VH_Goliath.Materials.MITV_VH_Goliath01_Blue_BO'
//  BurnOutMaterialTread[0]=MaterialInterface'VH_Goliath.Materials.MITV_VH_Goliath01_Red_Tread_BO'
//  BurnOutMaterialTread[1]=MaterialInterface'VH_Goliath.Materials.MITV_VH_Goliath01_Blue_Tread_BO'

    BaseEyeHeight=60.0

//  LeftTeamMaterials[0]=MaterialInstanceConstant'VH_Goliath.Materials.MI_VH_Goliath02_Treads_Red'
//  LeftTeamMaterials[1]=MaterialInstanceConstant'VH_Goliath.Materials.MI_VH_Goliath02_Treads_Blue'
//  RightTeamMaterials[0]=MaterialInstanceConstant'VH_Goliath.Materials.MI_VH_Goliath03_Treads_Red'
//  RightTeamMaterials[1]=MaterialInstanceConstant'VH_Goliath.Materials.MI_VH_Goliath03_Treads_Blue'

//  VehicleDestroyedSound(0)=SoundNodeWave'A_Character_IGMale.BotStatus.A_BotStatus_IGMale_EnemyGoliathDestroyed'
//  VehicleDestroyedSound(1)=SoundNodeWave'A_Character_Jester.BotStatus.A_BotStatus_Jester_EnemyGoliathDestroyed'
//  VehicleDestroyedSound(2)=SoundNodeWave'A_Character_Othello.BotStatus.A_BotStatus_Othello_EnemyGoliathDestroyed'

//  AIPurpose=AIP_Any

    bDebugPenetration=false

    VehHitZones(0)=(ZoneName=ENGINEBLOCK,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=100,VisibleFrom=14)
    VehHitZones(1)=(ZoneName=ENGINECORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=300,VisibleFrom=14)
    VehHitZones(2)=(ZoneName=AMMOSTOREONE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=13)
    VehHitZones(3)=(ZoneName=AMMOSTORETWO,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=13)
    VehHitZones(4)=(ZoneName=AMMOSTORETHREE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=13)
    VehHitZones(5)=(ZoneName=AMMOSTOREFOUR,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.4)
    VehHitZones(6)=(ZoneName=FUELTANKLEFT,DamageMultiplier=10.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=200,KillPercentage=0.3,VisibleFrom=6)
    VehHitZones(7)=(ZoneName=FUELTANKRIGHT,DamageMultiplier=10.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=200,KillPercentage=0.3,VisibleFrom=10)
    VehHitZones(8)=(ZoneName=GEARBOX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=100,VisibleFrom=2)
    VehHitZones(9)=(ZoneName=GEARBOXCORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=200,VisibleFrom=2)
    VehHitZones(10)=(ZoneName=LEFTBRAKES,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=6)
    VehHitZones(11)=(ZoneName=RIGHTBRAKES,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=10)
    VehHitZones(12)=(ZoneName=TRAVERSEMOTOR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=15)
    VehHitZones(13)=(ZoneName=TURRETRINGONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=13)
    VehHitZones(14)=(ZoneName=TURRETRINGTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=9)
    VehHitZones(15)=(ZoneName=TURRETRINGTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=10)
    VehHitZones(16)=(ZoneName=TURRETRINGFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=5)
    VehHitZones(17)=(ZoneName=TURRETRINGFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=6)
    VehHitZones(18)=(ZoneName=TURRETRINGSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=14)
    VehHitZones(19)=(ZoneName=COAXIALMG,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25)
    VehHitZones(20)=(ZoneName=MAINCANNONREAR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=50,KillPercentage=0.3)
    VehHitZones(21)=(ZoneName=DRIVERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=0,SeatProxyIndex=`CRUSADER_DRIVER_SPI,CrewBoneName=Driver_bone)
    VehHitZones(22)=(ZoneName=DRIVERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=0,SeatProxyIndex=`CRUSADER_DRIVER_SPI,CrewBoneName=Driver_bone)
    VehHitZones(23)=(ZoneName=COMMANDERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=1,SeatProxyIndex=`CRUSADER_COMMANDER_SPI,CrewBoneName=Commander_Bone)
    VehHitZones(24)=(ZoneName=COMMANDERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=1,SeatProxyIndex=`CRUSADER_COMMANDER_SPI,CrewBoneName=Commander_Bone)
    VehHitZones(25)=(ZoneName=GUNNERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=2,SeatProxyIndex=`CRUSADER_GUNNER_SPI,CrewBoneName=Turretgunner_Bone)
    VehHitZones(26)=(ZoneName=GUNNERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=2,SeatProxyIndex=`CRUSADER_GUNNER_SPI,CrewBoneName=Turretgunner_Bone)
    VehHitZones(27)=(ZoneName=LEFTTRACKONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(28)=(ZoneName=LEFTTRACKTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(29)=(ZoneName=LEFTTRACKTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(30)=(ZoneName=LEFTTRACKFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(31)=(ZoneName=LEFTTRACKFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(32)=(ZoneName=LEFTTRACKSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(33)=(ZoneName=LEFTTRACKSEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(34)=(ZoneName=LEFTTRACKEIGHT,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(35)=(ZoneName=LEFTTRACKNINE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(36)=(ZoneName=LEFTTRACKTEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(37)=(ZoneName=RIGHTTRACKONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(38)=(ZoneName=RIGHTTRACKTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(39)=(ZoneName=RIGHTTRACKTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(40)=(ZoneName=RIGHTTRACKFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(41)=(ZoneName=RIGHTTRACKFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(42)=(ZoneName=RIGHTTRACKSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(43)=(ZoneName=RIGHTTRACKSEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(44)=(ZoneName=RIGHTTRACKEIGHT,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(45)=(ZoneName=RIGHTTRACKNINE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(46)=(ZoneName=RIGHTTRACKTEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(47)=(ZoneName=RIGHTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
    VehHitZones(48)=(ZoneName=LEFTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)

  //  VehHitZones(28)=(ZoneName=LOADERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=4,SeatProxyIndex=3,CrewBoneName=Loader_Bone)
  //  VehHitZones(29)=(ZoneName=LOADERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=4,SeatProxyIndex=3,CrewBoneName=Loader_Bone)

    // Hit zones in the physics asset that detect armor hits
    ArmorHitZones(0)=(ZoneName=FRONTUNDERGLACIS,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTUNDER)
    ArmorHitZones(1)=(ZoneName=FRONTNOSE,PhysBodyBoneName=Chassis,ArmorPlateName=NOSE)
    ArmorHitZones(2)=(ZoneName=FRONTGLACISLOWER,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTLOWER)
    ArmorHitZones(3)=(ZoneName=FRONTGLACISCENTRE,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTCENTRE)
    ArmorHitZones(4)=(ZoneName=FRONTGLACISUPPER,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTUPPER)
    ArmorHitZones(5)=(ZoneName=DRIVERFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=DRIVERBOXFRONT)
    ArmorHitZones(6)=(ZoneName=DRIVERLEFTT,PhysBodyBoneName=Chassis,ArmorPlateName=DRIVERBOXLEFT)
    ArmorHitZones(7)=(ZoneName=DRIVERRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=DRIVERBOXRIGHT)
    ArmorHitZones(8)=(ZoneName=DRIVERROOFFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=DRIVERBOXROOF)
    ArmorHitZones(9)=(ZoneName=DRIVERROOFREAR,PhysBodyBoneName=Chassis,ArmorPlateName=DRIVERBOXROOF)
    ArmorHitZones(10)=(ZoneName=HULLROOFMAIN,PhysBodyBoneName=Chassis,ArmorPlateName=HULLROOF)
    ArmorHitZones(11)=(ZoneName=HULLROOFREAR,PhysBodyBoneName=Chassis,ArmorPlateName=HULLROOFENGINE)
    ArmorHitZones(12)=(ZoneName=HULLROOFLEFT,PhysBodyBoneName=Chassis,ArmorPlateName=HULLROOFENGINE)
    ArmorHitZones(13)=(ZoneName=HULLROOFRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=HULLROOFENGINE)
    ArmorHitZones(14)=(ZoneName=HULLREAR,PhysBodyBoneName=Chassis,ArmorPlateName=REARLOUVRES)
    ArmorHitZones(15)=(ZoneName=REARSLATONE,PhysBodyBoneName=Chassis,ArmorPlateName=REARLOUVRES)
    ArmorHitZones(16)=(ZoneName=REARSLATTWO,PhysBodyBoneName=Chassis,ArmorPlateName=REARLOUVRES)
    ArmorHitZones(17)=(ZoneName=REARSLATTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=REARLOUVRES)
    ArmorHitZones(18)=(ZoneName=REARUPPERGLACIS,PhysBodyBoneName=Chassis,ArmorPlateName=HULLREAR)
    ArmorHitZones(19)=(ZoneName=REARLOWERGLACIS,PhysBodyBoneName=Chassis,ArmorPlateName=HULLREAR)
    ArmorHitZones(20)=(ZoneName=FLOORREAR,PhysBodyBoneName=Chassis,ArmorPlateName=REARFLOOR)
    ArmorHitZones(21)=(ZoneName=FLOORFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTFLOOR)
    ArmorHitZones(22)=(ZoneName=RIGHTSIDEINNERONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTSIDEINNER)
    ArmorHitZones(23)=(ZoneName=RIGHTSIDEINNERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTSIDEINNER)
    ArmorHitZones(24)=(ZoneName=RIGHTSIDEINNERTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTSIDEINNER)
    ArmorHitZones(25)=(ZoneName=RIGHTSIDEINNERFOUR,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTSIDEINNER)
    ArmorHitZones(26)=(ZoneName=RIGHTSIDEONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTSIDE)
    ArmorHitZones(27)=(ZoneName=RIGHTSIDETWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTSIDE)
    ArmorHitZones(28)=(ZoneName=RIGHTSIDETHREE,PhysBodyBoneName=Turret,ArmorPlateName=RIGHTSIDE)
    ArmorHitZones(29)=(ZoneName=RIGHTSIDEFOUR,PhysBodyBoneName=Turret,ArmorPlateName=RIGHTSIDE)
    ArmorHitZones(30)=(ZoneName=RIGHTSIDEFIVE,PhysBodyBoneName=Turret,ArmorPlateName=RIGHTSIDE)
    ArmorHitZones(31)=(ZoneName=RIGHTSIDESIX,PhysBodyBoneName=Turret,ArmorPlateName=RIGHTSIDE)
    ArmorHitZones(32)=(ZoneName=RIGHTSIDESEVEN,PhysBodyBoneName=Turret,ArmorPlateName=RIGHTSIDE)
    ArmorHitZones(33)=(ZoneName=LEFTSIDEINNERONE,PhysBodyBoneName=Turret,ArmorPlateName=LEFTSIDEINNER)
    ArmorHitZones(34)=(ZoneName=LEFTSIDEINNERTWO,PhysBodyBoneName=Turret,ArmorPlateName=LEFTSIDEINNER)
    ArmorHitZones(35)=(ZoneName=LEFTSIDEINNERTHREE,PhysBodyBoneName=Turret,ArmorPlateName=LEFTSIDEINNER)
    ArmorHitZones(36)=(ZoneName=LEFTINNERSIDEFOUR,PhysBodyBoneName=Turret,ArmorPlateName=LEFTSIDEINNER)
    ArmorHitZones(37)=(ZoneName=LEFTSIDEONE,PhysBodyBoneName=Turret,ArmorPlateName=LEFTSIDE)
    ArmorHitZones(38)=(ZoneName=LEFTSIDETWO,PhysBodyBoneName=Turret,ArmorPlateName=LEFTSIDE)
    ArmorHitZones(39)=(ZoneName=LEFTSIDETHREE,PhysBodyBoneName=Turret,ArmorPlateName=LEFTSIDE)
    ArmorHitZones(40)=(ZoneName=LEFTSIDEFOUR,PhysBodyBoneName=Turret,ArmorPlateName=LEFTSIDE)
    ArmorHitZones(41)=(ZoneName=LEFTSIDEFIVE,PhysBodyBoneName=Turret,ArmorPlateName=LEFTSIDE)
    ArmorHitZones(42)=(ZoneName=LEFTSIDESIX,PhysBodyBoneName=Turret,ArmorPlateName=LEFTSIDE)
    ArmorHitZones(43)=(ZoneName=LEFTSIDESEVEN,PhysBodyBoneName=Turret,ArmorPlateName=LEFTSIDE)
    ArmorHitZones(44)=(ZoneName=RIGHTSPACERONE,PhysBodyBoneName=gun_base,ArmorPlateName=RIGHTSPACER)
    ArmorHitZones(45)=(ZoneName=RIGHTSPACERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTSPACER)
    ArmorHitZones(46)=(ZoneName=RIGHTSPACERTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTREARSPACER)
    ArmorHitZones(47)=(ZoneName=LEFTSPACERONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTSPACER)
    ArmorHitZones(48)=(ZoneName=LEFTSPACERTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTSPACER)
    ArmorHitZones(49)=(ZoneName=LEFTSPACERTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREARSPACER)
    ArmorHitZones(50)=(ZoneName=MANTLETCENTRE,PhysBodyBoneName=Turret,ArmorPlateName=MANTLET)
    ArmorHitZones(51)=(ZoneName=MANTLETRIGHT,PhysBodyBoneName=Turret,ArmorPlateName=MANTLET)
    ArmorHitZones(52)=(ZoneName=MANTLETLEFT,PhysBodyBoneName=Turret,ArmorPlateName=MANTLET)
    ArmorHitZones(53)=(ZoneName=TURRETRIGHTONE,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRIGHT)
    ArmorHitZones(54)=(ZoneName=TURRETRIGHTTWO,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRIGHT)
    ArmorHitZones(55)=(ZoneName=TURRETRIGHTTHREE,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRIGHT)
    ArmorHitZones(56)=(ZoneName=TURRETRIGHTUNDERONE,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRIGHT)
    ArmorHitZones(57)=(ZoneName=TURRETRIGHTUNDERTWO,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRIGHT)
    ArmorHitZones(58)=(ZoneName=TURRETRIGHTUNDERTHREE,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRIGHT)
    ArmorHitZones(59)=(ZoneName=TURRETLEFTONE,PhysBodyBoneName=Turret,ArmorPlateName=TURRETLEFT)
    ArmorHitZones(60)=(ZoneName=TURRETLEFTTWO,PhysBodyBoneName=Turret,ArmorPlateName=TURRETLEFT)
    ArmorHitZones(61)=(ZoneName=TURRETLEFTTHREE,PhysBodyBoneName=Turret,ArmorPlateName=TURRETLEFT)
    ArmorHitZones(62)=(ZoneName=TURRETLEFTUNDERONE,PhysBodyBoneName=Turret,ArmorPlateName=TURRETLEFT)
    ArmorHitZones(63)=(ZoneName=TURRETLEFTUNDERTWO,PhysBodyBoneName=gun_base,ArmorPlateName=TURRETLEFT)
    ArmorHitZones(64)=(ZoneName=TURRETLEFTUNDERTHREE,PhysBodyBoneName=Turret,ArmorPlateName=TURRETLEFT)
    ArmorHitZones(65)=(ZoneName=TURRETREARCENTRE,PhysBodyBoneName=Turret,ArmorPlateName=CENTRETURRETREAR)
    ArmorHitZones(66)=(ZoneName=TURRETREARLOWER,PhysBodyBoneName=Turret,ArmorPlateName=LOWERTURRETREAR)
    ArmorHitZones(67)=(ZoneName=ROOFMAIN,PhysBodyBoneName=Turret,ArmorPlateName=TURRETROOF)
    ArmorHitZones(68)=(ZoneName=ROOFRIGHT,PhysBodyBoneName=Turret,ArmorPlateName=TURRETROOF)
    ArmorHitZones(69)=(ZoneName=ROOFLEFT,PhysBodyBoneName=Turret,ArmorPlateName=TURRETROOF)
    ArmorHitZones(70)=(ZoneName=ROOFBACK,PhysBodyBoneName=Turret,ArmorPlateName=UPPERTURRETREAR)
    ArmorHitZones(71)=(ZoneName=TURRETRINGARMOURBACKLEFT,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRINGARMOUR)
    ArmorHitZones(72)=(ZoneName=TURRETRINGARMOURBACK,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRINGARMOUR)
    ArmorHitZones(73)=(ZoneName=TURRETRINGARMOURBACKRIGHT,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRINGARMOUR)
    ArmorHitZones(74)=(ZoneName=TURRETRINGARMOURFRONTRIGHT,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRINGARMOUR)
    ArmorHitZones(75)=(ZoneName=TURRETRINGARMOURFRONTLEFT,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRINGARMOUR)
    ArmorHitZones(76)=(ZoneName=TURRETRINGARMOURFRONT,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRINGARMOUR)


    // Armor plates that store the info for the actual plates
    ArmorPlates(0)=(PlateName=FRONTUNDER,ArmorZoneType=AZT_Front,PlateThickness=20,OverallHardness=350,bHighHardness=false)
    ArmorPlates(1)=(PlateName=NOSE,ArmorZoneType=AZT_Front,PlateThickness=49,OverallHardness=350,bHighHardness=false)
    ArmorPlates(2)=(PlateName=FRONTLOWER,ArmorZoneType=AZT_Front,PlateThickness=50,OverallHardness=350,bHighHardness=false)
    ArmorPlates(3)=(PlateName=FRONTCENTRE,ArmorZoneType=AZT_Front,PlateThickness=9,OverallHardness=350,bHighHardness=false)
    ArmorPlates(4)=(PlateName=FRONTUPPER,ArmorZoneType=AZT_Front,PlateThickness=35,OverallHardness=350,bHighHardness=false)
    ArmorPlates(5)=(PlateName=DRIVERBOXFRONT,ArmorZoneType=AZT_Front,PlateThickness=50,OverallHardness=350,bHighHardness=false)
    ArmorPlates(6)=(PlateName=DRIVERBOXLEFT,ArmorZoneType=AZT_Left,PlateThickness=28,OverallHardness=350,bHighHardness=false)
    ArmorPlates(7)=(PlateName=DRIVERBOXRIGHT,ArmorZoneType=AZT_Right,PlateThickness=28,OverallHardness=350,bHighHardness=false)
    ArmorPlates(8)=(PlateName=DRIVERBOXROOF,ArmorZoneType=AZT_Roof,PlateThickness=12,OverallHardness=350,bHighHardness=false)
    ArmorPlates(9)=(PlateName=HULLROOF,ArmorZoneType=AZT_Roof,PlateThickness=9,OverallHardness=400,bHighHardness=true)
    ArmorPlates(10)=(PlateName=HULLROOFENGINE,ArmorZoneType=AZT_Roof,PlateThickness=7,OverallHardness=400,bHighHardness=true)
    ArmorPlates(11)=(PlateName=REARLOUVRES,ArmorZoneType=AZT_Back,PlateThickness=14,OverallHardness=350,bHighHardness=false)
    ArmorPlates(12)=(PlateName=HULLREAR,ArmorZoneType=AZT_Back,PlateThickness=28,OverallHardness=350,bHighHardness=false)
    ArmorPlates(13)=(PlateName=REARFLOOR,ArmorZoneType=AZT_Floor,PlateThickness=6,OverallHardness=400,bHighHardness=true)
    ArmorPlates(14)=(PlateName=FRONTFLOOR,ArmorZoneType=AZT_Floor,PlateThickness=10,OverallHardness=400,bHighHardness=true)
    ArmorPlates(15)=(PlateName=RIGHTSIDEINNER,ArmorZoneType=AZT_Right,PlateThickness=14,OverallHardness=370,bHighHardness=false)
    ArmorPlates(16)=(PlateName=RIGHTSIDE,ArmorZoneType=AZT_Right,PlateThickness=14,OverallHardness=350,bHighHardness=false)
    ArmorPlates(17)=(PlateName=LEFTSIDEINNER,ArmorZoneType=AZT_Left,PlateThickness=14,OverallHardness=370,bHighHardness=false)
    ArmorPlates(18)=(PlateName=LEFTSIDE,ArmorZoneType=AZT_Left,PlateThickness=14,OverallHardness=350,bHighHardness=false)
    ArmorPlates(19)=(PlateName=RIGHTSPACER,ArmorZoneType=AZT_Roof,PlateThickness=9,OverallHardness=400,bHighHardness=true)
    ArmorPlates(20)=(PlateName=RIGHTREARSPACER,ArmorZoneType=AZT_Back,PlateThickness=12,OverallHardness=350,bHighHardness=false)
    ArmorPlates(21)=(PlateName=LEFTSPACER,ArmorZoneType=AZT_Roof,PlateThickness=9,OverallHardness=400,bHighHardness=true)
    ArmorPlates(22)=(PlateName=LEFTREARSPACER,ArmorZoneType=AZT_Back,PlateThickness=12,OverallHardness=350,bHighHardness=false)
    ArmorPlates(23)=(PlateName=MANTLET,ArmorZoneType=AZT_TurretFront,PlateThickness=51,OverallHardness=350,bHighHardness=false)
    ArmorPlates(24)=(PlateName=TURRETRIGHT,ArmorZoneType=AZT_TurretRight,PlateThickness=23,OverallHardness=350,bHighHardness=false)
    ArmorPlates(25)=(PlateName=TURRETLEFT,ArmorZoneType=AZT_TurretLeft,PlateThickness=23,OverallHardness=350,bHighHardness=false)
    ArmorPlates(26)=(PlateName=CENTRETURRETREAR,ArmorZoneType=AZT_TurretBack,PlateThickness=30,OverallHardness=350,bHighHardness=false)
    ArmorPlates(27)=(PlateName=LOWERTURRETREAR,ArmorZoneType=AZT_TurretBack,PlateThickness=20,OverallHardness=350,bHighHardness=false)
    ArmorPlates(28)=(PlateName=TURRETROOF,ArmorZoneType=AZT_TurretRoof,PlateThickness=12,OverallHardness=370,bHighHardness=false)
    ArmorPlates(29)=(PlateName=UPPERTURRETREAR,ArmorZoneType=AZT_TurretBack,PlateThickness=25,OverallHardness=350,bHighHardness=false)
    ArmorPlates(30)=(PlateName=TURRETRINGARMOUR,ArmorZoneType=AZT_Weakspots,PlateThickness=20,OverallHardness=350,bHighHardness=false)


    EngineIdleRPM=500
    EngineNormalRPM=1800
    EngineMaxRPM=2500

    /*
    RPM3DGaugeMaxAngle=40000
    Speedo3DGaugeMaxAngle=103765
    EngineOil3DGaugeMinAngle=16384
    EngineOil3DGaugeMaxAngle=35000
    EngineOil3DGaugeDamageAngle=8192
    GearboxOil3DGaugeMinAngle=15000
    GearboxOil3DGaugeNormalAngle=22500
    GearboxOil3DGaugeMaxAngle=30000
    GearboxOil3DGaugeDamageAngle=5000
    EngineTemp3DGaugeNormalAngle=7500
    EngineTemp3DGaugeEngineDamagedAngle=13000
    EngineTemp3DGaugeFireDamagedAngle=15000
    EngineTemp3DGaugeFireDestroyedAngle=16384
    */

    ArmorTextureOffsets(0)=(PositionOffset=(X=36,Y=6,Z=0),MySizeX=68,MYSizeY=68)
    ArmorTextureOffsets(1)=(PositionOffset=(X=36,Y=63,Z=0),MySizeX=68,MYSizeY=68)
    ArmorTextureOffsets(2)=(PositionOffset=(X=40,Y=38,Z=0),MySizeX=17,MYSizeY=68)
    ArmorTextureOffsets(3)=(PositionOffset=(X=82,Y=38,Z=0),MySizeX=17,MYSizeY=68)

    SprocketTextureOffsets(0)=(PositionOffset=(X=45,Y=24,Z=0),MySizeX=8,MYSizeY=16)
    SprocketTextureOffsets(1)=(PositionOffset=(X=87,Y=24,Z=0),MySizeX=8,MYSizeY=16)

    TransmissionTextureOffset=(PositionOffset=(X=51,Y=19,Z=0),MySizeX=38,MYSizeY=36)

    TreadTextureOffsets(0)=(PositionOffset=(X=36,Y=35,Z=0),MySizeX=8,MYSizeY=69)
    TreadTextureOffsets(1)=(PositionOffset=(X=96,Y=35,Z=0),MySizeX=8,MYSizeY=69)

    AmmoStorageTextureOffsets(0)=(PositionOffset=(X=41,Y=56,Z=0),MySizeX=16,MYSizeY=16)
    AmmoStorageTextureOffsets(1)=(PositionOffset=(X=83,Y=56,Z=0),MySizeX=16,MYSizeY=16)

    FuelTankTextureOffsets(0)=(PositionOffset=(X=62,Y=62,Z=0),MySizeX=16,MYSizeY=16)

    TurretRingTextureOffset=(PositionOffset=(X=51,Y=51,Z=0),MySizeX=38,MYSizeY=38)

    EngineTextureOffset=(PositionOffset=(X=56,Y=88,Z=0),MySizeX=28,MYSizeY=28)

    TurretArmorTextureOffsets(0)=(PositionOffset=(X=-0,Y=-16,Z=0),MySizeX=40,MYSizeY=20)
    TurretArmorTextureOffsets(1)=(PositionOffset=(X=-0,Y=+20,Z=0),MySizeX=38,MYSizeY=19)
    TurretArmorTextureOffsets(2)=(PositionOffset=(X=-10,Y=+2,Z=0),MySizeX=16,MYSizeY=64)
    TurretArmorTextureOffsets(3)=(PositionOffset=(X=+9,Y=0,Z=0),MySizeX=16,MYSizeY=66)

    MainGunTextureOffset=(PositionOffset=(X=-0,Y=-40,Z=0),MySizeX=14,MYSizeY=37)
    CoaxMGTextureOffset=(PositionOffset=(X=+6,Y=-14,Z=0),MySizeX=6,MYSizeY=14)

    SeatTextureOffsets(0)=(PositionOffSet=(X=-16,Y=-21,Z=0),bTurretPosition=0)
    SeatTextureOffsets(1)=(PositionOffSet=(X=0,Y=+10,Z=0),bTurretPosition=1)
    // SeatTextureOffsets(2)=(PositionOffSet=(X=+16,Y=-21,Z=0),bTurretPosition=0)
    // SeatTextureOffsets(3)=(PositionOffSet=(X=+8,Y=-4,Z=0),bTurretPosition=1)
    SeatTextureOffsets(2)=(PositionOffSet=(X=-8,Y=-4,Z=0),bTurretPosition=1)

    SpeedoMinDegree=5461
    SpeedoMaxDegree=60075
    SpeedoMaxSpeed=1365 //100 km/h

    ScopeLensMIC=MaterialInstanceConstant'WP_VN_VC_SVD.Materials.VC_SVD_LenseMat'

    RanOverDamageType=DRDmgType_RunOver_PanzerIV

    // TODO: Disable.
    bInfantryCanUse=True
}
