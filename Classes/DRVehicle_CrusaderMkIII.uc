class DRVehicle_CrusaderMkIII extends DRVehicleTank
    abstract;

/** ambient sound component for machine gun */
var AudioComponent HullMGAmbient;
/** Sound to play when maching gun stops firing. */
var SoundCue HullMGStopSound;

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
var ROSkelControlCustomAttach MGController;

/** Currently selected cuppola position */
var repnotify byte CuppolaCurrentPositionIndex;
var repnotify bool bDrivingCuppola;

/** Seat proxy death hit info */
var repnotify TakeHitInfo DeathHitInfo_ProxyDriver;
var repnotify TakeHitInfo DeathHitInfo_ProxyCommander;
var repnotify TakeHitInfo DeathHitInfo_ProxyHullMG;
var repnotify TakeHitInfo DeathHitInfo_ProxyLoader;
var repnotify TakeHitInfo DeathHitInfo_ProxyGunner;

/** Scope material. Caching it here so that it does not get cooked out */
var MaterialInstanceConstant ScopeLensMIC;

var DRDestroyedTankTrack DestroyedLeftTrack;
var DRDestroyedTankTrack DestroyedRightTrack;

replication
{
    if (bNetDirty)
        DeathHitInfo_ProxyDriver, DeathHitInfo_ProxyCommander, DeathHitInfo_ProxyHullMG, DeathHitInfo_ProxyLoader, DeathHitInfo_ProxyGunner, CuppolaCurrentPositionIndex, bDrivingCuppola;
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
            PlaySeatProxyDeathHitEffects(0, DeathHitInfo_ProxyDriver);
        }
    }
    else if (VarName == 'DeathHitInfo_ProxyCommander')
    {
        if( IsLocalPlayerInThisVehicle() )
        {
            PlaySeatProxyDeathHitEffects(1, DeathHitInfo_ProxyCommander);
        }
    }
    else if (VarName == 'DeathHitInfo_ProxyHullMG')
    {
        if( IsLocalPlayerInThisVehicle() )
        {
            PlaySeatProxyDeathHitEffects(2, DeathHitInfo_ProxyHullMG);
        }
    }
    else if (VarName == 'DeathHitInfo_ProxyLoader')
    {
        if( IsLocalPlayerInThisVehicle() )
        {
            PlaySeatProxyDeathHitEffects(3, DeathHitInfo_ProxyLoader);
        }
    }
    else if (VarName == 'DeathHitInfo_ProxyGunner')
    {
        if( IsLocalPlayerInThisVehicle() )
        {
            PlaySeatProxyDeathHitEffects(4, DeathHitInfo_ProxyGunner);
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
        Mesh.AttachComponentToSocket(HullMGAmbient, 'MG_Barrel');
        Mesh.AttachComponentToSocket(CoaxMGAmbient, 'CoaxMG');
    }

    // Shell controller
    ShellController = ROSkelControlCustomAttach(mesh.FindSkelControl('ShellCustomAttach'));
    MGController = ROSkelControlCustomAttach(mesh.FindSkelControl('InteriorMGAttach'));

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
    HullMGAmbient.Stop();
    CoaxMGAmbient.Stop();

    Super.TornOff();
}

/** turns off all sounds */
simulated function StopVehicleSounds()
{
    Super.StopVehicleSounds();

    // Clear the ambient firing sounds
    HullMGAmbient.Stop();
    CoaxMGAmbient.Stop();
}

/**
 * Request using a new pending position index
 *
 * @param   SeatIndex             The seat index that the Interaction is being requested for
 * @param   PositionIndex         The position index that is being requested
 */
simulated function RequestPosition(byte SeatIndex, byte DesiredIndex, optional bool bViaInteraction)
{
    local ROWeaponPawn ROWP;

    // Allow position switching to take us to/from the gunner/cuppola position for easy of use
    if( SeatIndex == 1 && DesiredIndex == 3 )
    {
        ROWP = ROWeaponPawn(Seats[SeatIndex].SeatPawn);
        if( ROWP != none )
        {
            // Go to gunner
            ROWP.SwitchWeapon(3);
        }
    }
    else if( SeatIndex == 2 && DesiredIndex == 255 )
    {
        ROWP = ROWeaponPawn(Seats[SeatIndex].SeatPawn);
        if( ROWP != none )
        {
            // Go to cuppola
            ROWP.SwitchWeapon(2);
        }
    }
    else
    {
        super.RequestPosition(SeatIndex, DesiredIndex, bViaInteraction);
    }
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

    if (SeatIndex == GetHullMGSeatIndex() && SeatFiringMode(SeatIndex,,true) == 0 && !HullMGAmbient.bWasPlaying)
    {
        HullMGAmbient.Play();
    }
    else if (SeatIndex == GetGunnerSeatIndex() && SeatFiringMode(SeatIndex,,true) == 1 && !CoaxMGAmbient.bWasPlaying)
    {
        CoaxMGAmbient.Play();
    }
}

simulated function VehicleWeaponStoppedFiring(bool bViaReplication, int SeatIndex)
{
    Super.VehicleWeaponStoppedFiring(bViaReplication, SeatIndex);

    if ( SeatIndex == GetHullMGSeatIndex() )
    {
        if ( HullMGAmbient.bWasPlaying || !HullMGAmbient.bFinished )
        {
            HullMGAmbient.Stop();
            PlaySound(HullMGStopSound, TRUE, FALSE, FALSE, HullMGAmbient.CurrentLocation, FALSE);
        }
    }
    else if ( SeatIndex == GetGunnerSeatIndex() )
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
    case 0:
        // Driver
        DeathHitInfo_ProxyDriver.Damage = Damage;
        DeathHitInfo_ProxyDriver.HitLocation = HitLocation;
        DeathHitInfo_ProxyDriver.Momentum = Momentum;
        DeathHitInfo_ProxyDriver.DamageType = DamageType;
        break;
    case 1:
        // Commander
        DeathHitInfo_ProxyCommander.Damage = Damage;
        DeathHitInfo_ProxyCommander.HitLocation = HitLocation;
        DeathHitInfo_ProxyCommander.Momentum = Momentum;
        DeathHitInfo_ProxyCommander.DamageType = DamageType;
        break;
    case 2:
        // HullMG
        DeathHitInfo_ProxyHullMG.Damage = Damage;
        DeathHitInfo_ProxyHullMG.HitLocation = HitLocation;
        DeathHitInfo_ProxyHullMG.Momentum = Momentum;
        DeathHitInfo_ProxyHullMG.DamageType = DamageType;
        break;
    case 3:
        // Loader
        DeathHitInfo_ProxyLoader.Damage = Damage;
        DeathHitInfo_ProxyLoader.HitLocation = HitLocation;
        DeathHitInfo_ProxyLoader.Momentum = Momentum;
        DeathHitInfo_ProxyLoader.DamageType = DamageType;
        break;
    case 4:
        // Gunner
        DeathHitInfo_ProxyGunner.Damage = Damage;
        DeathHitInfo_ProxyGunner.HitLocation = HitLocation;
        DeathHitInfo_ProxyGunner.Momentum = Momentum;
        DeathHitInfo_ProxyGunner.DamageType = DamageType;
        break;
    }

    // Call super!
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
    local int MICIndex;

    if( InSeatIndex < Seats.Length )
    {
        // The following mapping is done based on the way the InteriorMICs array is set up
        // 0 = Walls, 1 = Driver/HullMG, 2 = Turret, 3 = Cuppola
        switch( InSeatIndex )
        {
        case 0 : MICIndex = 1; break;
        case 1 : MICIndex = 3; break;
        case 2 : MICIndex = 2; break;
        case 3 : MICIndex = 1; break;
        case 4 : MICIndex = 2; break;
        }

        InteriorMICs[0].SetScalarParameterValue(Seats[InSeatIndex].VehicleBloodMICParameterName, 1.0);
        InteriorMICs[MICIndex].SetScalarParameterValue(Seats[InSeatIndex].VehicleBloodMICParameterName, 1.0);
    }
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
        // Transition from driver to hull MG
        else if( NewSeatIndex == 3 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'Driver_Open_TranMG' : 'Driver_TranMg';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            TimerName = 'SeatTransitioningThree';
        }
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
        // Transition from hull MG to driver
        else if( OldSeatIndex == 3 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'MG_Open_TranDriver' : 'MG_TranDriver';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            TimerName = 'SeatTransitioningZero';
        }
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
        // Transition from hull MG to commander
        else if( OldSeatIndex == 3 )
        {
            // Commander
            TransitionAnim = (bUseExteriorAnim) ? 'MG_Open_TranTurret' : 'MG_TranTurret';
            TimerName = 'SeatTransitioningMGToTurretGoalCommander';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            bAttachDriverPawn = true;
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
            //bAttachDriverPawn = true;
        }
        // Transition from hull MG to gunner
        else if( OldSeatIndex == 3 )
        {
            // Commander
            TransitionAnim = (bUseExteriorAnim) ? 'MG_Open_TranTurret' : 'MG_TranTurret';
            TimerName = 'SeatTransitioningMGToTurretGoalGunner';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            bAttachDriverPawn = true;
        }
    }
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
    local VehicleCrewProxy VCP;
    local bool bTransitionWithoutProxy;
    local bool bUseExteriorAnim;

    super.HandleProxySeatTransition(NewSeatIndex, OldSeatIndex);

    VCP = SeatProxies[GetSeatProxyIndexForSeatIndex(NewSeatIndex)].ProxyMeshActor;

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
        // Transition from hull MG to driver
        else if( OldSeatIndex == 3 )
        {
            TransitionAnim = (bUseExteriorAnim) ? 'MG_Open_TranDriver' : 'MG_TranDriver';
            Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
            TimerName = 'SeatTransitioningZero';
        }
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
    else if( SeatIndex == GetGunnerSeatIndex() )
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
        CameraTag=None,
        CameraOffset=-420,
        SeatAnimBlendName=DriverPositionNode,
        bSeatVisible=true,
        SeatBone=Chassis,
        DriverDamageMult=1.0,
        InitialPositionIndex=0,
        SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
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
                // PositionDownAnim=Driver_closeTOport,
                // PositionIdleAnim=Driver_port_idle,
                // DriverIdleAnim=Driver_port_idle,
                // AlternateIdleAnim=Driver_port_idle_AI,
                SeatProxyIndex=0,
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
                PositionFlinchAnims=(Driver_close_Flinch),
                PositionDeathAnims=(Driver_close_Death)
            )
        )
    )}

    Seats(1)={(
        TurretVarPrefix="Cuppola",
        BinocOverlayTexture=Texture2D'WP_VN_VC_Binoculars.Materials.BINOC_overlay',
        BarTexture=Texture2D'ui_textures.Textures.button_128grey',
        CameraTag=None,
        CameraOffset=-420,
        bSeatVisible=true,
        SeatBone=Turret,
        SeatAnimBlendName=CommanderPositionNode,
        DriverDamageMult=1.0,
        InitialPositionIndex=2,
        SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
        VehicleBloodMICParameterName=Gore04,
        // SeatIconPos=(X=0.33,Y=0.35),
        // WeaponEffects=((SocketName=TurretFireSocket,Offset=(X=-125),Scale3D=(X=14.0,Y=10.0,Z=10.0))),
        SeatPositions=
        (
            // 0
            (
                bDriverVisible=true,
                bAllowFocus=false,
                // bDrawOverlays=true,
                bBinocsPosition=true,
                PositionCameraTag=None,
                ViewFOV=5.4,
                bRotateGunOnCommand=false,
                PositionUpAnim=Com_open_idle,
                PositionIdleAnim=Com_open_idle,
                DriverIdleAnim=Com_open_idle,
                AlternateIdleAnim=Com_open_idle_AI,
                SeatProxyIndex=1,
                bIsExterior=true,
                LeftHandIKInfo=(PinEnabled=true),
                RightHandIKInfo=(PinEnabled=true),
                HipsIKInfo=(PinEnabled=true),
                LeftFootIKInfo=(PinEnabled=true),
                RightFootIKInfo=(PinEnabled=true),
                PositionFlinchAnims=(Com_open_Flinch),
                PositionDeathAnims=(Com_open_Death)
            ),

            // 1
            (
                bDriverVisible=true,
                bAllowFocus=true,
                PositionCameraTag=None,
                ViewFOV=70.0,
                bRotateGunOnCommand=true,
                PositionDownAnim=Com_open_idle,
                PositionUpAnim=Com_open,
                PositionIdleAnim=Com_open_idle,
                DriverIdleAnim=Com_open_idle,
                AlternateIdleAnim=Com_open_idle_AI,
                SeatProxyIndex=1,
                bIsExterior=true,
                LeftHandIKInfo=(PinEnabled=true),
                RightHandIKInfo=(PinEnabled=true),
                HipsIKInfo=(PinEnabled=true),
                LeftFootIKInfo=(PinEnabled=true),
                RightFootIKInfo=(PinEnabled=true),
                PositionFlinchAnims=(Com_open_Flinch),
                PositionDeathAnims=(Com_open_Death)
            ),

            // 2
            (
                bDriverVisible=false,
                bAllowFocus=true,
                PositionCameraTag=None,
                ViewFOV=70.0,
                bRotateGunOnCommand=true,
                PositionDownAnim=Com_close,
                PositionIdleAnim=Com_close_idle,
                DriverIdleAnim=Com_close_idle,
                AlternateIdleAnim=Com_close_idle_AI,
                SeatProxyIndex=1,
                // PositionUpAnim=Com_gunnerTOclose,
                LeftHandIKInfo=(PinEnabled=true),
                RightHandIKInfo=(PinEnabled=true),
                HipsIKInfo=(PinEnabled=true),
                LeftFootIKInfo=(PinEnabled=true),
                RightFootIKInfo=(PinEnabled=true),
                PositionFlinchAnims=(Com_close_Flinch),
                PositionDeathAnims=(Com_close_Death)
            )
        )
    )}

    Seats(2)={(
        GunClass=class'DRVWeapon_PanzerIVF_Turret',
        // SightOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_optics_Crusader',
        NeedleOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_PZIV_optics_bg_TOP',
        RangeOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_PZIV_optics_range',
        VignetteOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_optics_vignette',
        GunSocket=(Barrel,CoaxMG),
        GunPivotPoints=(gun_base,gun_base),
        TurretVarPrefix="Turret",
        TurretControls=(Turret_Gun,Turret_Main),
        CameraTag=None,
        CameraOffset=-420,
        bSeatVisible=true,
        SeatBone=Turret,
        SeatAnimBlendName=GunnerPositionNode,
        DriverDamageMult=1.0,
        InitialPositionIndex=0,
        FiringPositionIndex=0,
        TracerFrequency=5,
        WeaponTracerClass=(none, class'M1919BulletTracer'),
        MuzzleFlashLightClass=(class'ROGrenadeExplosionLight', class'ROVehicleMGMuzzleFlashLight'),
        SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
        VehicleBloodMICParameterName=Gore01,
        // PositionDownAnim=Com_closeTOgunner,
        // SeatIconPos=(X=0.33,Y=0.35),
        // WeaponEffects=((SocketName=TurretFireSocket,Offset=(X=-125),Scale3D=(X=14.0,Y=10.0,Z=10.0))),
        SeatPositions=
        (
            // 0
            /*
            (
                bDriverVisible=false,
                bAllowFocus=true,
                PositionCameraTag=None,
                ViewFOV=70.0,
                bRotateGunOnCommand=true,
                PositionUpAnim=Gunner_portTOclose,
                PositionIdleAnim=Gunner_Close_Idle,
                DriverIdleAnim=Gunner_Close_Idle,
                AlternateIdleAnim=Gunner_Close_Idle_AI,
                SeatProxyIndex=4,
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
                PositionFlinchAnims=(Gunner_close_Flinch),
                PositionDeathAnims=(Gunner_Death),
                //LookAtInfo=(LookAtEnabled=true,DefaultLookAtTargetName=GunnerTraverseHandle,HeadInfluence=0.0,BodyInfluence=1.0),
                PositionInteractions=
                (
                    (
                        InteractionIdleAnim=Gunner_sideport_Idle,
                        StartInteractionAnim=Gunner_closeTOsideport,
                        EndInteractionAnim=Gunner_sideportTOclose,
                        FlinchInteractionAnim=Gunner_sideport_Flinch,
                        ViewFOV=70,
                        bAllowFocus=true,
                        InteractionSocketTag=GunnerViewPort,
                        InteractDotAngle=0.95,
                        bUseDOF=true
                    )
                )
            ),
            */

            // 0 (old 1)
            (
                bDriverVisible=false,
                bAllowFocus=false,
                PositionCameraTag=Camera_Gunner,
                ViewFOV=13.5,
                bCamRotationFollowSocket=true,
                bViewFromCameraTag=true,
                bDrawOverlays=true,
                PositionDownAnim=Gunner_closeTOport,
                PositionIdleAnim=Gunner_port_idle,
                DriverIdleAnim=Gunner_port_idle,
                AlternateIdleAnim=Gunner_port_idle_AI,
                SeatProxyIndex=4,
                // LookAtInfo=(LookAtEnabled=true,DefaultLookAtTargetName=GunnerTraverseHandle,HeadInfluence=0.0,BodyInfluence=1.0))), //2.4x zoom
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
                PositionFlinchAnims=(Gunner_close_Flinch),
                PositionDeathAnims=(Gunner_Death)
            )
        )
    )}

    Seats(3)={(
        GunClass=class'DRVWeapon_PanzerIVF_HullMG',
        SightOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_optics_mg',
        VignetteOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_optics_vignette',
        GunSocket=(MG_Barrel),
        GunPivotPoints=(MG_Pitch),
        TurretVarPrefix="HullMG",
        TurretControls=(Hull_MG_Yaw,Hull_MG_Pitch),
        CameraTag=None,
        CameraOffset=-420,
        bSeatVisible=true,
        SeatBone=Chassis,
        SeatAnimBlendName=HullMGPositionNode,
        DriverDamageMult=1.0,
        InitialPositionIndex=0,
        FiringPositionIndex=0,
        SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
        VehicleBloodMICParameterName=Gore03,
        TracerFrequency=5,
        WeaponTracerClass=(class'M1919BulletTracer',class'M1919BulletTracer'),
        MuzzleFlashLightClass=(class'ROVehicleMGMuzzleFlashLight',class'ROVehicleMGMuzzleFlashLight'),
        // SeatIconPos=(X=0.33,Y=0.35),
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
                bRotateGunOnCommand=true,
                PositionUpAnim=MG_open,
                PositionIdleAnim=MG_open_idle,
                DriverIdleAnim=MG_open_idle,
                AlternateIdleAnim=MG_open_idle_AI,
                SeatProxyIndex=2,
                bIgnoreWeapon=true,
                bIsExterior=true,
                LeftHandIKInfo=(PinEnabled=true),
                RightHandIKInfo=(PinEnabled=true),
                HipsIKInfo=(PinEnabled=true),
                PositionFlinchAnims=(MG_open_Flinch),
                PositionDeathAnims=(MG_open_Death)
            ),

            // 1
            (
                bDriverVisible=false,bAllowFocus=true,
                PositionCameraTag=None,ViewFOV=70.0,
                bRotateGunOnCommand=true,PositionUpAnim=MG_portTOclose,
                PositionDownAnim=MG_close,PositionIdleAnim=MG_close_idle,
                DriverIdleAnim=MG_close_idle,AlternateIdleAnim=MG_close_idle_AI,
                SeatProxyIndex=2,
                bIgnoreWeapon=true,
                LeftHandIKInfo=(PinEnabled=true),
                RightHandIKInfo=(PinEnabled=true),
                HipsIKInfo=(PinEnabled=true),
                LeftFootIKInfo=(PinEnabled=true),
                RightFootIKInfo=(PinEnabled=true),
                PositionFlinchAnims=(MG_close_Flinch),
                PositionDeathAnims=(MG_close_Death),
                PositionInteractions=
                ((
                    InteractionIdleAnim=MG_sideport_Idle,
                    StartInteractionAnim=MG_closeTOsideport,
                    EndInteractionAnim=MG_sideportTOclose,
                    FlinchInteractionAnim=MG_sideport_Flinch,
                    ViewFOV=70,
                    bAllowFocus=true,
                    InteractionSocketTag=MGRightViewPort,
                    InteractDotAngle=0.95,
                    bUseDOF=true
                ))
            ),
            */

            // 0 (old 2)
            (
                bDriverVisible=false,
                bAllowFocus=false,
                PositionCameraTag=MG_Camera,ViewFOV=35.0,
                bCamRotationFollowSocket=true,
                bViewFromCameraTag=true,
                bDrawOverlays=true,
                bUseDOF=true,
                PositionDownAnim=MG_closeTOport,
                PositionIdleAnim=MG_port_idle,
                bConstrainRotation=false,
                YawContraintIndex=0,
                PitchContraintIndex=1,
                DriverIdleAnim=MG_port_idle,
                AlternateIdleAnim=MG_port_idle_AI,
                SeatProxyIndex=2, //2.0x zoom should be 16.25, for gameplay trying less zoom for now
                LeftHandIKInfo=
                (
                    IKEnabled=false,
                    // DefaultEffectorLocationTargetName=HullMGLeftHand,
                    // DefaultEffectorRotationTargetName=HullMGLeftHand
                ),
                RightHandIKInfo=
                (
                    IKEnabled=false,
                    // DefaultEffectorLocationTargetName=HullMGRightHand,
                    // DefaultEffectorRotationTargetName=HullMGRightHand
                ),
                HipsIKInfo=(PinEnabled=true),
                LeftFootIKInfo=(PinEnabled=true),
                RightFootIKInfo=(PinEnabled=true),
                PositionFlinchAnims=(MG_close_Flinch),
                PositionDeathAnims=(MG_close_Death),
                ChestIKInfo=
                (
                    IKEnabled=false,
                    // DefaultEffectorLocationTargetName=DefaultHullMGReload,
                    // DefaultEffectorRotationTargetName=DefaultHullMGReload
                )
            )
        )
    )}

    Seats(4)={(
        bNonEnterable=true,
        SeatAnimBlendName=LoaderPositionNode,
        TurretVarPrefix="Loader",
        bSeatVisible=false,
        SeatBone=Turret,
        SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
        VehicleBloodMICParameterName=Gore01,
        SeatPositions=
        (
            (
                bDriverVisible=false,
                PositionIdleAnim=Loader_idle,
                AlternateIdleAnim=Loader_idle,
                SeatProxyIndex=3,
                /*
                LeftHandIKInfo=(PinEnabled=true),
                RightHandIKInfo=(PinEnabled=true),
                HipsIKInfo=(PinEnabled=true),
                PositionFlinchAnims=(Loader_Flinch),
                PositionDeathAnims=(Loader_Death),
                HeightInfo=
                (
                    HeightDisplacementEnabled=false,
                    AlternateHeightTargets=
                    (
                        (
                            Action=DAct_ReloadCoaxMG,
                            HeightDisplacementEnabled=true,
                            OriginalHeightTargetName=DefualtMGReload,
                            ModifiedHeightTargetName=CurrentMGReload
                        )
                    )
                ),
                LeftHandIKInfo=
                (
                    IKEnabled=false,
                    AlternateEffectorTargets=
                    (
                        (
                            Action=DAct_CannonReload_LH1,
                            IKEnabled=true,
                            PinEnabled=false,
                            EffectorLocationTargetName=LoaderLHCannon1,
                            EffectorRotationTargetName=LoaderLHCannon1
                        ),
                        (
                            Action=DAct_CannonReload_LH2,
                            IKEnabled=true,
                            PinEnabled=false,
                            EffectorLocationTargetName=LoaderLHCannon2,
                            EffectorRotationTargetName=LoaderLHCannon2
                        ),
                        (
                            Action=DAct_CannonReload_LH3,
                            IKEnabled=true,
                            PinEnabled=false,
                            EffectorLocationTargetName=LoaderLHCannonBreech1,
                            EffectorRotationTargetName=LoaderLHCannonBreech1
                        ),
                        (
                            Action=DAct_CannonReload_LHOff,
                            IKEnabled=false,
                            PinEnabled=true
                        )
                    )
                ),
                RightHandIKInfo=
                (
                    IKEnabled=false,
                    AlternateEffectorTargets=
                    (
                        (
                            Action=DAct_CannonReload_RH1,
                            IKEnabled=true,
                            PinEnabled=false,
                            EffectorLocationTargetName=LoaderRHCannon1,
                            EffectorRotationTargetName=LoaderRHCannon1
                        ),
                        (
                            Action=DAct_CannonReload_RH2,
                            IKEnabled=true,
                            PinEnabled=false,
                            EffectorLocationTargetName=LoaderRHCannonMG1,
                            EffectorRotationTargetName=LoaderRHCannonMG1
                        ),
                        (
                            Action=DAct_CannonReload_RHOff,
                            IKEnabled=false,
                            PinEnabled=true
                        )
                    )
                )
                */
            )
        )
    )}

    SeatIndexPassRotateOnCommandToOtherSeat=1
    SeatIndexToRotateOnCommandFromOtherSeat=2

    //_________________________
    // ROSkelControlTankWheels
    //
    LeftWheels(0)="L_Wheel_01"
    LeftWheels(1)="L_Wheel_02"
    LeftWheels(2)="L_Wheel_03"
    LeftWheels(3)="L_Wheel_04"
    LeftWheels(4)="L_Wheel_05"
    LeftWheels(5)="L_Wheel_06"
    LeftWheels(6)="L_Wheel_07"
    //
    RightWheels(0)="R_Wheel_01"
    RightWheels(1)="R_Wheel_02"
    RightWheels(2)="R_Wheel_03"
    RightWheels(3)="R_Wheel_04"
    RightWheels(4)="R_Wheel_05"
    RightWheels(5)="R_Wheel_06"
    RightWheels(6)="R_Wheel_07"

    /** Physics Wheels */

    // Right Rear Wheel
    Begin Object Name=RRWheel
        BoneName="R_Wheel_06"
        // BoneOffset=(X=-10.0,Y=0,Z=0.0)
        WheelRadius=30//15
    End Object
    Wheels(0)=RRWheel

    // Right middle wheel
    Begin Object Name=RMWheel
        BoneName="R_Wheel_04"
        // BoneOffset=(X=5.0,Y=0,Z=0.0)
        WheelRadius=30//15
    End Object
    Wheels(1)=RMWheel

    // Right Front Wheel
    Begin Object Name=RFWheel
        BoneName="R_Wheel_02"
        WheelRadius=30//15
    End Object
    Wheels(2)=RFWheel

    // Left Rear Wheel
    Begin Object Name=LRWheel
        BoneName="L_Wheel_06"
        // BoneOffset=(X=-10.0,Y=0,Z=0.0)
        WheelRadius=30//15
    End Object
    Wheels(3)=LRWheel

    // Left Middle Wheel
    Begin Object Name=LMWheel
        BoneName="L_Wheel_04"
        // BoneOffset=(X=5.0,Y=0,Z=0.0)
        WheelRadius=30//15
    End Object
    Wheels(4)=LMWheel

    // Left Front Wheel
    Begin Object Name=LFWheel
        BoneName="L_Wheel_02"
        WheelRadius=30//15
    End Object
    Wheels(5)=LFWheel

    /*
    Begin Object Class=ROVehicleWheel Name=L_Wheel_0
        WheelRadius=16
        BoneName="L_Wheel_00"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Left
    End Object
    Wheels(0)=L_Wheel_0

    Begin Object Class=ROVehicleWheel Name=L_Wheel_1
        WheelRadius=12
        BoneName="L_Wheel_01"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=1.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Left
    End Object
    Wheels(1)=L_Wheel_1

    Begin Object Class=ROVehicleWheel Name=L_Wheel_2
        WheelRadius=12
        BoneName="L_Wheel_02"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Left
    End Object
    Wheels(2)=L_Wheel_2

    Begin Object Class=ROVehicleWheel Name=L_Wheel_3
        WheelRadius=12
        BoneName="L_Wheel_03"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Left
    End Object
    Wheels(3)=L_Wheel_3

    Begin Object Class=ROVehicleWheel Name=L_Wheel_4
        WheelRadius=12
        BoneName="L_Wheel_04"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Left
    End Object
    Wheels(4)=L_Wheel_4

    Begin Object Class=ROVehicleWheel Name=L_Wheel_5
        WheelRadius=12
        BoneName="L_Wheel_05"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Left
    End Object
    Wheels(5)=L_Wheel_5

    Begin Object Class=ROVehicleWheel Name=L_Wheel_6
        WheelRadius=12
        BoneName="L_Wheel_06"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Left
    End Object
    Wheels(6)=L_Wheel_6

    Begin Object Class=ROVehicleWheel Name=L_Wheel_7
        WheelRadius=12
        BoneName="L_Wheel_07"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Left
    End Object
    Wheels(7)=L_Wheel_7

    Begin Object Class=ROVehicleWheel Name=L_Wheel_8
        WheelRadius=12
        BoneName="L_Wheel_08"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Left
    End Object
    Wheels(8)=L_Wheel_8

    Begin Object Class=ROVehicleWheel Name=L_Wheel_9
        WheelRadius=32
        BoneName="L_Wheel_09"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Left
    End Object
    Wheels(9)=L_Wheel_9

    Begin Object Class=ROVehicleWheel Name=R_Wheel_0
        WheelRadius=16
        BoneName="R_Wheel_00"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Right
    End Object
    Wheels(10)=R_Wheel_0

    Begin Object Class=ROVehicleWheel Name=R_Wheel_1
        WheelRadius=12
        BoneName="R_Wheel_01"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=1.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Right
    End Object
    Wheels(11)=R_Wheel_1

    Begin Object Class=ROVehicleWheel Name=R_Wheel_2
        WheelRadius=12
        BoneName="R_Wheel_02"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Right
    End Object
    Wheels(12)=R_Wheel_2

    Begin Object Class=ROVehicleWheel Name=R_Wheel_3
        WheelRadius=12
        BoneName="R_Wheel_03"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Right
    End Object
    Wheels(13)=R_Wheel_3

    Begin Object Class=ROVehicleWheel Name=R_Wheel_4
        WheelRadius=12
        BoneName="R_Wheel_04"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Right
    End Object
    Wheels(14)=R_Wheel_4

    Begin Object Class=ROVehicleWheel Name=R_Wheel_5
        WheelRadius=12
        BoneName="R_Wheel_05"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Right
    End Object
    Wheels(15)=R_Wheel_5

    Begin Object Class=ROVehicleWheel Name=R_Wheel_6
        WheelRadius=12
        BoneName="R_Wheel_06"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Right
    End Object
    Wheels(16)=R_Wheel_6

    Begin Object Class=ROVehicleWheel Name=R_Wheel_7
        WheelRadius=12
        BoneName="R_Wheel_07"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Right
    End Object
    Wheels(17)=R_Wheel_7

    Begin Object Class=ROVehicleWheel Name=R_Wheel_8
        WheelRadius=12
        BoneName="R_Wheel_08"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Right
    End Object
    Wheels(18)=R_Wheel_8

    Begin Object Class=ROVehicleWheel Name=R_Wheel_9
        WheelRadius=32
        BoneName="R_Wheel_09"
        BoneOffset=(X=0.0,Y=0,Z=0.0)
        SuspensionTravel=25
        SteerFactor=0.0
        LongSlipFactor=1000.0
        LatSlipFactor=20000.0
        HandbrakeLongSlipFactor=150.0
        HandbrakeLatSlipFactor=1000.0
        Side=SIDE_Right
    End Object
    Wheels(19)=R_Wheel_9
    */

    /** Vehicle Sim */

    Begin Object Name=SimObject
        // Transmission - GearData
        GearArray(0)={(
            // Real world - [5.64] 5.5 kph reverse
            GearRatio=-5.64,
            AccelRate=7.5,
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
            AccelRate=9.50,
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
            AccelRate=10.00,
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
            AccelRate=9.35,
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
            AccelRate=11.00,
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
            AccelRate=11.20,
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
            AccelRate=11.20,
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

    TreadSpeedScale=-2.5 //2.75

    // Muzzle Flashes
    VehicleEffects(TankVFX_Firing1)=(EffectStartTag=PanzerIVGCannon,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_B_TankMuzzle',EffectSocket=Barrel,bRestartRunning=true)
    VehicleEffects(TankVFX_Firing2)=(EffectStartTag=PanzerIVGCannon,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_B_TankCannon_Dust',EffectSocket=attachments_body_ground,bRestartRunning=true)
    VehicleEffects(TankVFX_Firing3)=(EffectStartTag=PanzerIVGHullMG,EffectTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_split',EffectSocket=MG_Barrel)
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
    VehHitZones(2)=(ZoneName=AMMOSTOREONE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.4,VisibleFrom=5)
    VehHitZones(3)=(ZoneName=AMMOSTORETWO,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=9)
    VehHitZones(4)=(ZoneName=AMMOSTORETHREE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=10)
    VehHitZones(5)=(ZoneName=AMMOSTOREFOUR,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=10)
    VehHitZones(6)=(ZoneName=AMMOSTOREFIVE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=6)
    VehHitZones(7)=(ZoneName=AMMOSTORESIX,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=5)
    VehHitZones(8)=(ZoneName=FUELTANK,DamageMultiplier=10.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=200,KillPercentage=0.3,VisibleFrom=15)
    VehHitZones(9)=(ZoneName=GEARBOX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=100,VisibleFrom=1)
    VehHitZones(10)=(ZoneName=GEARBOXCORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=200,VisibleFrom=1)
    VehHitZones(11)=(ZoneName=LEFTBRAKES,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=5)
    VehHitZones(12)=(ZoneName=RIGHTBRAKES,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=9)
    VehHitZones(13)=(ZoneName=TRAVERSEMOTOR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=15)
    VehHitZones(14)=(ZoneName=TURRETRINGONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=13)
    VehHitZones(15)=(ZoneName=TURRETRINGTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=9)
    VehHitZones(16)=(ZoneName=TURRETRINGTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=10)
    VehHitZones(17)=(ZoneName=TURRETRINGFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=5)
    VehHitZones(18)=(ZoneName=TURRETRINGFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=6)
    VehHitZones(19)=(ZoneName=TURRETRINGSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=14)
    VehHitZones(20)=(ZoneName=COAXIALMG,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25)
    VehHitZones(21)=(ZoneName=MAINCANNONREAR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=50,KillPercentage=0.3)
    VehHitZones(22)=(ZoneName=DRIVERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Driver_bone)
    VehHitZones(23)=(ZoneName=DRIVERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Driver_bone)
    VehHitZones(24)=(ZoneName=HULLMGBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=3,SeatProxyIndex=2,CrewBoneName=Hullgunner_Bone)
    VehHitZones(25)=(ZoneName=HULLMGHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=3,SeatProxyIndex=2,CrewBoneName=Hullgunner_Bone)
    VehHitZones(26)=(ZoneName=COMMANDERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=Commander_Bone)
    VehHitZones(27)=(ZoneName=COMMANDERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=Commander_Bone)
    VehHitZones(28)=(ZoneName=LOADERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=4,SeatProxyIndex=3,CrewBoneName=Loader_Bone)
    VehHitZones(29)=(ZoneName=LOADERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=4,SeatProxyIndex=3,CrewBoneName=Loader_Bone)
    VehHitZones(30)=(ZoneName=GUNNERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=2,SeatProxyIndex=4,CrewBoneName=Turretgunner_Bone)
    VehHitZones(31)=(ZoneName=GUNNERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=2,SeatProxyIndex=4,CrewBoneName=Turretgunner_Bone)
    VehHitZones(32)=(ZoneName=LEFTTRACKONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200,VisibleFrom=5)
    VehHitZones(33)=(ZoneName=LEFTTRACKTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(34)=(ZoneName=LEFTTRACKTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(35)=(ZoneName=LEFTTRACKFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(36)=(ZoneName=LEFTTRACKFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(37)=(ZoneName=LEFTTRACKSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(38)=(ZoneName=LEFTTRACKSEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(39)=(ZoneName=LEFTTRACKEIGHT,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(40)=(ZoneName=LEFTTRACKNINE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(41)=(ZoneName=LEFTTRACKTEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(42)=(ZoneName=RIGHTTRACKONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200,VisibleFrom=9)
    VehHitZones(43)=(ZoneName=RIGHTTRACKTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
    VehHitZones(44)=(ZoneName=RIGHTTRACKTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(45)=(ZoneName=RIGHTTRACKFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(46)=(ZoneName=RIGHTTRACKFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(47)=(ZoneName=RIGHTTRACKSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(48)=(ZoneName=RIGHTTRACKSEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(49)=(ZoneName=RIGHTTRACKEIGHT,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(50)=(ZoneName=RIGHTTRACKNINE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(51)=(ZoneName=RIGHTTRACKTEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
    VehHitZones(52)=(ZoneName=RIGHTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
    VehHitZones(53)=(ZoneName=LEFTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)

    // Hit zones in the physics asset that detect armor hits
    ArmorHitZones(0)=(ZoneName=FRONTARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTLOWER)
    ArmorHitZones(1)=(ZoneName=FRONTARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTGLACIS)
    ArmorHitZones(2)=(ZoneName=FRONTARMORTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTUPPER)
    ArmorHitZones(3)=(ZoneName=LEFTFRONTARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONT)
    ArmorHitZones(4)=(ZoneName=LEFTFRONTARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONT)
    ArmorHitZones(5)=(ZoneName=LEFTARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTLOWER)
    ArmorHitZones(6)=(ZoneName=LEFTARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTUPPER)
    ArmorHitZones(7)=(ZoneName=LEFTARMORTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTUPPERCENTER)
    ArmorHitZones(8)=(ZoneName=LEFTREARARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTUPPERREAR)
    ArmorHitZones(9)=(ZoneName=LEFTREARARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTLOWERREAR)
    ArmorHitZones(10)=(ZoneName=LEFTOVERHANGARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTOVERHANG)
    ArmorHitZones(11)=(ZoneName=LEFTOVERHANGARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREAROVERHANG)
    ArmorHitZones(12)=(ZoneName=ROOFARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=ROOFREAR)
    ArmorHitZones(13)=(ZoneName=ROOFARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=ROOFFRONT)
    ArmorHitZones(14)=(ZoneName=ROOFARMORLEFTFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=ROOFFRONT)
    ArmorHitZones(15)=(ZoneName=ROOFARMORRIGHTFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=ROOFFRONT)
    ArmorHitZones(16)=(ZoneName=FLOORARMOR,PhysBodyBoneName=Chassis,ArmorPlateName=FLOOR)
    ArmorHitZones(17)=(ZoneName=REARARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=REARLOWER)
    ArmorHitZones(18)=(ZoneName=REARARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=REARUPPER)
    ArmorHitZones(19)=(ZoneName=RIGHTFRONTARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONT)
    ArmorHitZones(20)=(ZoneName=RIGHTFRONTARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONT)
    ArmorHitZones(21)=(ZoneName=RIGHTARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTLOWER)
    ArmorHitZones(22)=(ZoneName=RIGHTARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTUPPER)
    ArmorHitZones(23)=(ZoneName=RIGHTREARARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTUPPERREAR)
    ArmorHitZones(24)=(ZoneName=RIGHTREARARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTLOWERREAR)
    ArmorHitZones(25)=(ZoneName=RIGHTARMORTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTUPPERCENTER)
    ArmorHitZones(26)=(ZoneName=RIGHTOVERHANGARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTOVERHANG)
    ArmorHitZones(27)=(ZoneName=RIGHTOVERHANGARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTREAROVERHANG)
    ArmorHitZones(28)=(ZoneName=TURRETFRONTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETFRONT)
    ArmorHitZones(29)=(ZoneName=TURRETFRONTLEFTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETFRONT)
    ArmorHitZones(30)=(ZoneName=LEFTFRONTTURRETARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETLEFTFRONT)
    ArmorHitZones(31)=(ZoneName=LEFTREARTURRETARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETLEFTREAR)
    ArmorHitZones(32)=(ZoneName=TURRETREARARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETREAR)
    ArmorHitZones(33)=(ZoneName=TURRETREARLEFTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETREAR)
    ArmorHitZones(34)=(ZoneName=TURRETREARRIGHTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETREAR)
    ArmorHitZones(35)=(ZoneName=RIGHTREARTURRETARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRIGHTREAR)
    ArmorHitZones(36)=(ZoneName=RIGHTFRONTTURRETARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRIGHTFRONT)
    ArmorHitZones(37)=(ZoneName=TURRETFRONTRIGHTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETFRONT)
    ArmorHitZones(38)=(ZoneName=TURRETROOFARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETROOF)
    ArmorHitZones(39)=(ZoneName=CUPPOLAARMORONE,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLA)
    ArmorHitZones(40)=(ZoneName=CUPPOLAARMORTWO,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLA)
    ArmorHitZones(41)=(ZoneName=CUPPOLAARMORTHREE,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLA)
    ArmorHitZones(42)=(ZoneName=CUPPOLAARMORFOUR,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLA)
    ArmorHitZones(43)=(ZoneName=CUPPOLAROOFARMOR,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLAROOF)
    ArmorHitZones(44)=(ZoneName=CANNONGLACISARMOR,PhysBodyBoneName=gun_base,ArmorPlateName=CANNONGLACIS)
    ArmorHitZones(45)=(ZoneName=DRIVERFRONTVISIONSLIT,PhysBodyBoneName=Chassis,ArmorPlateName=DRIVERFRONTVISIONSLIT)
    ArmorHitZones(46)=(ZoneName=DRIVERSIDEVISIONSLIT,PhysBodyBoneName=Chassis,ArmorPlateName=DRIVERSIDEVISIONSLIT)
    ArmorHitZones(47)=(ZoneName=HULLMGSIDEVISIONSLIT,PhysBodyBoneName=Chassis,ArmorPlateName=HULLMGSIDEVISIONSLIT)
    ArmorHitZones(48)=(ZoneName=RIGHTENGINEDECKGRATING,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTENGINEDECKGRATING)
    ArmorHitZones(49)=(ZoneName=LEFTENGINEDECKGRATING,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTENGINEDECKGRATING)
    ArmorHitZones(50)=(ZoneName=GUNNERFRONTVISIONSLIT,PhysBodyBoneName=Turret,ArmorPlateName=GUNNERFRONTVISIONSLIT)
    ArmorHitZones(51)=(ZoneName=GUNNERREARVISIONSLIT,PhysBodyBoneName=Turret,ArmorPlateName=GUNNERREARVISIONSLIT)
    ArmorHitZones(52)=(ZoneName=LOADERFRONTVISIONSLIT,PhysBodyBoneName=Turret,ArmorPlateName=LOADERFRONTVISIONSLIT)
    ArmorHitZones(53)=(ZoneName=LOADERREARVISIONSLIT,PhysBodyBoneName=Turret,ArmorPlateName=LOADERREARVISIONSLIT)
    ArmorHitZones(54)=(ZoneName=CUPPOLAVIEWSLITONE,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLAVIEWSLITONE)
    ArmorHitZones(55)=(ZoneName=CUPPOLAVIEWSLITTWO,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLAVIEWSLITTWO)
    ArmorHitZones(56)=(ZoneName=CUPPOLAVIEWSLITTHREE,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLAVIEWSLITTHREE)
    ArmorHitZones(57)=(ZoneName=CUPPOLAVIEWSLITFOUR,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLAVIEWSLITFOUR)
    ArmorHitZones(58)=(ZoneName=CUPPOLAVIEWSLITFIVE,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLAVIEWSLITFIVE)

    // Armor plates that store the info for the actual plates
    ArmorPlates(0)=(PlateName=FRONTLOWER,ArmorZoneType=AZT_Front,PlateThickness=50,OverallHardness=357,bHighHardness=false)
    ArmorPlates(1)=(PlateName=FRONTGLACIS,ArmorZoneType=AZT_Front,PlateThickness=25,OverallHardness=347,bHighHardness=false)
    ArmorPlates(2)=(PlateName=FRONTUPPER,ArmorZoneType=AZT_Front,PlateThickness=50,OverallHardness=357,bHighHardness=false)
    ArmorPlates(3)=(PlateName=LEFTFRONT,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=388,bHighHardness=false)
    ArmorPlates(4)=(PlateName=LEFTLOWER,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=388,bHighHardness=false)
    ArmorPlates(5)=(PlateName=LEFTUPPER,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=388,bHighHardness=false)
    ArmorPlates(6)=(PlateName=LEFTUPPERCENTER,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=388,bHighHardness=false)
    ArmorPlates(7)=(PlateName=LEFTUPPERREAR,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=388,bHighHardness=false)
    ArmorPlates(8)=(PlateName=LEFTLOWERREAR,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=388,bHighHardness=false)
    ArmorPlates(9)=(PlateName=LEFTFRONTOVERHANG,ArmorZoneType=AZT_Left,PlateThickness=10,OverallHardness=450,bHighHardness=true)
    ArmorPlates(10)=(PlateName=LEFTREAROVERHANG,ArmorZoneType=AZT_Left,PlateThickness=10,OverallHardness=450,bHighHardness=true)
    ArmorPlates(11)=(PlateName=ROOFREAR,ArmorZoneType=AZT_Roof,PlateThickness=10,OverallHardness=450,bHighHardness=true)
    ArmorPlates(12)=(PlateName=ROOFFRONT,ArmorZoneType=AZT_Roof,PlateThickness=10,OverallHardness=450,bHighHardness=true)
    ArmorPlates(13)=(PlateName=FLOOR,ArmorZoneType=AZT_Floor,PlateThickness=10,OverallHardness=450,bHighHardness=true)
    ArmorPlates(14)=(PlateName=REARLOWER,ArmorZoneType=AZT_Back,PlateThickness=20,OverallHardness=347,bHighHardness=false)
    ArmorPlates(15)=(PlateName=REARUPPER,ArmorZoneType=AZT_Back,PlateThickness=20,OverallHardness=347,bHighHardness=false)
    ArmorPlates(16)=(PlateName=RIGHTFRONT,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=388,bHighHardness=false)
    ArmorPlates(17)=(PlateName=RIGHTLOWER,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=388,bHighHardness=false)
    ArmorPlates(18)=(PlateName=RIGHTUPPER,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=388,bHighHardness=false)
    ArmorPlates(19)=(PlateName=RIGHTUPPERCENTER,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=388,bHighHardness=false)
    ArmorPlates(20)=(PlateName=RIGHTUPPERREAR,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=388,bHighHardness=false)
    ArmorPlates(21)=(PlateName=RIGHTLOWERREAR,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=388,bHighHardness=false)
    ArmorPlates(22)=(PlateName=RIGHTFRONTOVERHANG,ArmorZoneType=AZT_Right,PlateThickness=10,OverallHardness=450,bHighHardness=true)
    ArmorPlates(23)=(PlateName=RIGHTREAROVERHANG,ArmorZoneType=AZT_Right,PlateThickness=10,OverallHardness=450,bHighHardness=true)
    ArmorPlates(24)=(PlateName=TURRETFRONT,ArmorZoneType=AZT_TurretFront,PlateThickness=50,OverallHardness=357,bHighHardness=false)
    ArmorPlates(25)=(PlateName=TURRETLEFTFRONT,ArmorZoneType=AZT_TurretLeft,PlateThickness=30,OverallHardness=347,bHighHardness=false)
    ArmorPlates(26)=(PlateName=TURRETLEFTREAR,ArmorZoneType=AZT_TurretLeft,PlateThickness=30,OverallHardness=347,bHighHardness=false)
    ArmorPlates(27)=(PlateName=TURRETREAR,ArmorZoneType=AZT_TurretBack,PlateThickness=30,OverallHardness=347,bHighHardness=false)
    ArmorPlates(28)=(PlateName=TURRETRIGHTREAR,ArmorZoneType=AZT_TurretRight,PlateThickness=30,OverallHardness=347,bHighHardness=false)
    ArmorPlates(29)=(PlateName=TURRETRIGHTFRONT,ArmorZoneType=AZT_TurretRight,PlateThickness=30,OverallHardness=347,bHighHardness=false)
    ArmorPlates(30)=(PlateName=TURRETROOF,ArmorZoneType=AZT_TurretRoof,PlateThickness=20,OverallHardness=347,bHighHardness=false)
    ArmorPlates(31)=(PlateName=CUPPOLA,ArmorZoneType=AZT_Cuppola,PlateThickness=50,OverallHardness=331,bHighHardness=false)
    ArmorPlates(32)=(PlateName=CUPPOLAROOF,ArmorZoneType=AZT_Cuppola,PlateThickness=9,OverallHardness=450,bHighHardness=true)
    ArmorPlates(33)=(PlateName=CANNONGLACIS,ArmorZoneType=AZT_TurretFront,PlateThickness=50,OverallHardness=357,bHighHardness=false)
    ArmorPlates(34)=(PlateName=DRIVERFRONTVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=80,OverallHardness=150,bHighHardness=false)
    ArmorPlates(35)=(PlateName=DRIVERSIDEVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
    ArmorPlates(36)=(PlateName=HULLMGSIDEVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
    ArmorPlates(37)=(PlateName=GUNNERFRONTVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
    ArmorPlates(38)=(PlateName=GUNNERREARVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
    ArmorPlates(39)=(PlateName=LOADERFRONTVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
    ArmorPlates(40)=(PlateName=LOADERREARVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
    ArmorPlates(41)=(PlateName=CUPPOLAVIEWSLITONE,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
    ArmorPlates(42)=(PlateName=CUPPOLAVIEWSLITTWO,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
    ArmorPlates(43)=(PlateName=CUPPOLAVIEWSLITTHREE,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
    ArmorPlates(44)=(PlateName=CUPPOLAVIEWSLITFOUR,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
    ArmorPlates(45)=(PlateName=CUPPOLAVIEWSLITFIVE,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
    ArmorPlates(46)=(PlateName=RIGHTENGINEDECKGRATING,ArmorZoneType=AZT_WeakSpots,PlateThickness=10,OverallHardness=150,bHighHardness=false)
    ArmorPlates(47)=(PlateName=LEFTENGINEDECKGRATING,ArmorZoneType=AZT_WeakSpots,PlateThickness=10,OverallHardness=150,bHighHardness=false)

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
    SeatTextureOffsets(2)=(PositionOffSet=(X=+16,Y=-21,Z=0),bTurretPosition=0)
    SeatTextureOffsets(3)=(PositionOffSet=(X=+8,Y=-4,Z=0),bTurretPosition=1)
    SeatTextureOffsets(4)=(PositionOffSet=(X=-8,Y=-4,Z=0),bTurretPosition=1)

    SpeedoMinDegree=5461
    SpeedoMaxDegree=60075
    SpeedoMaxSpeed=1365 //100 km/h

    ScopeLensMIC=MaterialInstanceConstant'WP_VN_VC_SVD.Materials.VC_SVD_LenseMat'

    RanOverDamageType=DRDmgType_RunOver_PanzerIV

    // TODO: Disable.
    bInfantryCanUse=True
}
