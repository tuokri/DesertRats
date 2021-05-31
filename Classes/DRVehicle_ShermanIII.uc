class DRVehicle_ShermanIII extends DRVehicleTank
	abstract;

var localized string UsePeriscodeString;

/** ambient sound component for machine gun */
var AudioComponent HullMGAmbient;
/** Sound to play when maching gun stops firing. */
var SoundCue HullMGStopSound;

/** ambient sound component for machine gun */
var AudioComponent CoaxMGAmbient;
/** Sound to play when maching gun stops firing. */
var SoundCue CoaxMGStopSound;

var	array<MaterialInstanceConstant>	ReplacedExteriorMICs;
var	array<Material>	materials;
var	array<MaterialInstanceConstant>	mic;
var	MaterialInstanceConstant		ExteriorMICs[2];		// 0 = Exterior Texture, 1 = Unused
var	bool							bGeneratedExteriorMICs;

var	array<MaterialInstanceConstant>	ReplacedInteriorMICs;
var	MaterialInstanceConstant		InteriorMICs[4];		// 0 = Walls, 1 = Cuppola, 2 = Turret, 3 = Driver/HullMG
var	bool							bGeneratedInteriorMICs;

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
// var MaterialInstanceConstant ScopeLensMaterial;

simulated function SetVehicleDepthToForeground()
{
	SetVehicleDepthToWorld();
}

replication
{
	if (bNetDirty)
		CuppolaCurrentPositionIndex, bDrivingCuppola;

	if (bNetDirty)
		DeathHitInfo_ProxyDriver, DeathHitInfo_ProxyCommander, DeathHitInfo_ProxyHullMG, DeathHitInfo_ProxyLoader, DeathHitInfo_ProxyGunner;
}

/**
 * This event is triggered when a repnotify variable is received
 *
 * @param	VarName		The name of the variable replicated
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
 * @param	SeatIndex             The seat index that the Interaction is being requested for
 * @param   PositionIndex		  The position index that is being requested
 */
simulated function RequestPosition(byte SeatIndex, byte DesiredIndex, optional bool bViaInteraction)
{


		// NO!
	if( SeatIndex == 1 && DesiredIndex != 1 )
	{
		return;
	}
	else
	{
		super.RequestPosition(SeatIndex, DesiredIndex, bViaInteraction);
	}

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
	local int i;

	super.SetInteriorVisibility(bVisible);

	if ( bVisible && !bGeneratedInteriorMICs )
	{
		ReplacedInteriorMICs.AddItem(MaterialInstanceConstant(GetVehicleMeshAttachment('IntBodyComponent').GetMaterial(3))); // Tile
		ReplacedInteriorMICs.AddItem(MaterialInstanceConstant(GetVehicleMeshAttachment('IntBodyComponent').GetMaterial(2))); // Cuppola
		ReplacedInteriorMICs.AddItem(MaterialInstanceConstant(GetVehicleMeshAttachment('IntBodyComponent').GetMaterial(1))); // Turret
		ReplacedInteriorMICs.AddItem(MaterialInstanceConstant(GetVehicleMeshAttachment('IntBodyComponent').GetMaterial(0))); // Driver

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
		ReplaceInteriorMICs(GetVehicleMeshAttachment('IntHullMGComponent'));
		ReplaceInteriorMICs(GetVehicleMeshAttachment('TurretComponent'));
		ReplaceInteriorMICs(GetVehicleMeshAttachment('TurretGunGaseComponent'));
		ReplaceInteriorMICs(GetVehicleMeshAttachment('TurretCuppolaComponent'));
		ReplaceInteriorMICs(GetVehicleMeshAttachment('TurretDetails1Component'));
		ReplaceInteriorMICs(GetVehicleMeshAttachment('TurretBasketComponent'));

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
	local int MICIndex;

	if( InSeatIndex < Seats.Length )
	{
		// The following mapping is done based on the way the InteriorMICs array is set up
		// 0 = Walls, 1 = Cuppola, 2 = Turret, 3 = Driver/HullMG
		switch( InSeatIndex )
		{
		case 0 : MICIndex = 3; break;
		case 1 : MICIndex = 1; break;
		case 2 : MICIndex = 2; break;
		case 3 : MICIndex = 3; break;
		case 4 : MICIndex = 2; break;
		}

		InteriorMICs[0].SetScalarParameterValue(Seats[InSeatIndex].VehicleBloodMICParameterName, 1.0); // Tile
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
 * @param	HitArmorZoneType  The index of the ArmorPlateZoneHealths whose health changed
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
		/*	if ( Mesh.ForcedLodModel == 1 )
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
			}*/

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
 * @param	DriverPawn	      The pawn driver that is transitioning seats
 * @param	NewSeatIndex      The SeatIndex the pawn is moving to
 * @param	OldSeatIndex      The SeatIndex the pawn is moving from
 * @param	bInstantTransition    True if this is an instant transition not an animated transition
 * Network: Called on network clients when the ROPawn Driver's VehicleSeatTransition
 * is changed. HandleSeatTransition is called directly on the server and in standalone
 */
simulated function HandleSeatTransition(ROPawn DriverPawn, int NewSeatIndex, int OldSeatIndex, bool bInstantTransition)
{
	local bool bAttachDriverPawn, bUseExteriorAnim;
	local float AnimTimer;
	local name TransitionAnim, TimerName;
	local ROPlayerController ROPC;

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
			TimerName = 'SeatTransitioningDriverToCommander';
		}
		// Transition from driver to gunner
		else if( NewSeatIndex == 2 )
		{
			TimerName = 'SeatTransitioningDriverToGunner';
		}
		// Transition from driver to hull MG
		else if( NewSeatIndex == 3 )
		{
			TimerName = 'SeatTransitioningDriverToHullMG';
		}
	}
	// moving into the driver seat
	else if( NewSeatIndex == 0 )
	{
		// Transition from commander to driver
		if( OldSeatIndex == 1 )
		{
		    // Commander
		    TimerName = 'SeatTransitioningCommanderToTurretGoalDriver';

		    if( bUseExteriorAnim )
			{
				TransitionAnim = 'Com_close';
			}
		}
		// Transition from gunner to driver
		else if( OldSeatIndex == 2 )
		{
		    // Gunner
			TimerName = 'SeatTransitioningGunnerToDriver';
		}
		// Transition from hull MG to driver
		else if( OldSeatIndex == 3 )
		{
			TimerName = 'SeatTransitioningHullMGToDriver';
		}
	}
	// Transition to Commander
	else if( NewSeatIndex == 1 )
	{
		// Transition from gunner to commander
		if( OldSeatIndex == 2 )
		{
		    // Gunner
			TimerName = 'SeatTransitioningGunnerToCommander';
		}
		// Transition from hull MG to commander
		else if( OldSeatIndex == 3 )
		{
		    // Hull MG
			TimerName = 'SeatTransitioningHullMGToCommander';
		}
	}
	// Transition to gunner
	else if( NewSeatIndex == 2 )
	{
		// Transition from commander to gunner
		if( OldSeatIndex == 1 )
		{
		    // Commander
		    TimerName = 'SeatTransitioningCommanderToTurretGoalGunner';

			if( bUseExteriorAnim )
			{
				TransitionAnim = 'Com_close';
			}
		}
		// Transition from hull MG to gunner
		else if( OldSeatIndex == 3 )
		{
		    // Commander
			TimerName = 'SeatTransitioningHullMGToGunner';
		}
	}
	// Transition to Hull MG
	else if( NewSeatIndex == 3 )
	{
		// Transition from commander to hull MG
		if( OldSeatIndex == 1 )
		{
			TimerName = 'SeatTransitioningCommanderToTurretGoalMG';

			if( bUseExteriorAnim )
			{
				TransitionAnim = 'Com_close';
			}
		}
		// Transition from gunner to hull mg
		else if( OldSeatIndex == 2 )
		{
			TimerName = 'SeatTransitioningGunnerToHullMG';
		}
	}

	/** So what's going on here? Originally a transition that didn't need to hatch down was handled instantly, however there's a nasty replication bug
	 * for transitions between weapon pawns (it's ok if it's to or from the base vehicle) where the pawn doesn't actually exist on the client at the moment
	 * of transition. That results in a reset which disables all the transition settings below (the freeze, the fade out, etc) after 0.2 seconds. By
	 * forcing an animation in the old seat for a short period, we delay the apparent (i.e. visible) transition until the client is guaranteed to have
	 * spawned a new local pawn. Only then do we start the fade out, after the reset danger point has passed.
	 */
	if( TransitionAnim == '' )
	{
		// if we're not hatching down, just play the alt idle anim as it has enough length to not end before we fade the camera out
		TransitionAnim = Seats[OldSeatIndex].SeatPositions[Seats[OldSeatIndex].InitialPositionIndex].AlternateIdleAnim;
	}
	// Setting this value will block the dead proxy in the old seat from being unhidden before the camera has moved to the new seat
	Seats[OldSeatIndex].bTransitioningFromSeat = true;

	Seats[NewSeatIndex].SeatTransitionBoneName = Seats[OldSeatIndex].SeatBone;
	Seats[NewSeatIndex].bPreparingToTrans = true;

	// On this vehicle, every seat has a unique bone, so we'll always need to reattach the pawn
	bAttachDriverPawn = true;

	// If this transition requires us to attach the driver to a different bone, do that here
	if( bAttachDriverPawn )
	{
		DriverPawn.SetBase( Self, , Mesh, Seats[NewSeatIndex].SeatTransitionBoneName);
		DriverPawn.SetRelativeLocation( Seats[OldSeatIndex].SeatOffset );
		DriverPawn.SetRelativeRotation( Seats[OldSeatIndex].SeatRotation );
	}

	// Find the local playercontroller for this transition
	if( Seats[OldSeatIndex].SeatPawn != none )
	{
	   ROPC = ROPlayerController(Seats[OldSeatIndex].SeatPawn.Controller);
	}

	if( ROPC == none && Seats[NewSeatIndex].SeatPawn != none )
	{
		ROPC = ROPlayerController(Seats[NewSeatIndex].SeatPawn.Controller);
	}

	// Store a reference to the driver pawn making the transition so we can use
	// it for the second part of timer driven transitions
	Seats[NewSeatIndex].TransitionPawn = DriverPawn;

	Seats[OldSeatIndex].PositionBlend.HandleAnimPlay(TransitionAnim, false);
	DriverPawn.PlayFullBodyAnimation(TransitionAnim);
	Seats[NewSeatIndex].PositionBlend.HandleAnimPlay(Seats[NewSeatIndex].SeatPositions[Seats[NewSeatIndex].InitialPositionIndex].PositionIdleAnim, false);

	// Only use the full anim length if we're hatching down, otherwise just go long enough to get past the replication reset with a small fade out buffer
	if( bUseExteriorAnim )
		AnimTimer = DriverPawn.Mesh.GetAnimLength(TransitionAnim);
	else
		AnimTimer = 0.5;

	// Fade out vision, lock movement and set timer to fade it back in again at the end of the transition
	if( ROPC != none && LocalPlayer(ROPC.Player) != none )
	{
		ROPC.SetTimer(AnimTimer - 0.25, false, 'FreezePreVehicleTransition'); // Fade out slightly early to hide the sudden position switch
		ROPC.SetTimer(AnimTimer + Seats[OldSeatIndex].FadedTransTimes[NewSeatIndex], false, 'UnFreezePostVehicleTransition');
	}

	// Set up the transition and animation
	Seats[NewSeatIndex].bTransitioningToSeat = true;
	HandlePostInstantSeatTransition(OldSeatIndex);

	// Set up the timer for ending the transition
	SetTimer(AnimTimer, false, TimerName);
}

/**
 * Handle SeatProxy transitions between seats in the vehicle which need to be
 * animated or swap meshes. When called on the server the subclasses handle
 * replicating the information so the animations happen on the client
 * Since the transitions are very vehicle specific, all of the actual animations,
 * etc must be implemented in subclasses
 * @param	NewSeatIndex          The SeatIndex the proxy is moving to
 * @param	OldSeatIndex          The SeatIndex the proxy is moving from
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
			TimerName = 'SeatTransitioningOne';
		}
		// Transition from driver to gunner
		else if( NewSeatIndex == 2 )
		{
			TimerName = 'SeatTransitioningTwo';
		}
		// Transition from driver to hull MG
		else if( NewSeatIndex == 3 )
		{
			TimerName = 'SeatTransitioningThree';
		}
		// Transition from driver to Loader
		else if( NewSeatIndex == 4 )
		{
			TimerName = 'SeatTransitioningFour';
		}
	}
	// moving into the driver seat
	else if( NewSeatIndex == 0 )
	{
		// Transition from commander to driver
		if( OldSeatIndex == 1 )
		{
		    // Commander
			if( bUseExteriorAnim )
			{
				TimerName = 'SeatTransitioningCommanderToTurretGoalDriver';
				TransitionAnim = 'Com_close';
				bAttachProxy = true;
			}
			else
			{
				TimerName = 'SeatTransitioningZero';
			}
		}
		// Transition from gunner to driver
		else if( OldSeatIndex == 2 )
		{
		    // Gunner
			TimerName = 'SeatTransitioningZero';
		}
		// Transition from hull MG to driver
		else if( OldSeatIndex == 3 )
		{
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
			TimerName = 'SeatTransitioningOne';
		}
		// Transition from hull MG to commander
		else if( OldSeatIndex == 3 )
		{
		    // Commander
			TimerName = 'SeatTransitioningOne';
		}
	}
	// Transition to gunner
	else if( NewSeatIndex == 2 )
	{
		// Transition from commander to gunner
		if( OldSeatIndex == 1 )
		{
		    // Commander
			if( bUseExteriorAnim )
			{
				TimerName = 'SeatTransitioningCommanderToTurretGoalDriver';
				TransitionAnim = 'Com_close';
				bAttachProxy = true;
			}
			else
			{
				TimerName = 'SeatTransitioningTwo';
			}
		}
		// Transition from hull MG to gunner
		else if( OldSeatIndex == 3 )
		{
		    // Hull MG
			TimerName = 'SeatTransitioningTwo';
		}
	}
	// Transition to Hull MG
	else if( NewSeatIndex == 3 )
	{
		// Transition from commander to hull MG
		if( OldSeatIndex == 1 )
		{
			if( bUseExteriorAnim )
			{
				TimerName = 'SeatTransitioningCommanderToTurretGoalDriver';
				TransitionAnim = 'Com_close';
				bAttachProxy = true;
			}
			else
			{
				TimerName = 'SeatTransitioningThree';
			}
		}
		// Transition from gunner to hull mg
		else if( OldSeatIndex == 2 )
		{
			TimerName = 'SeatTransitioningThree';
		}
	}
	// Transition to Loader
	else if( NewSeatIndex == 4 )
	{
		// Transition from commander to loader
		if( OldSeatIndex == 1 )
		{
			if( bUseExteriorAnim )
			{
				TimerName = 'SeatTransitioningCommanderToTurretGoalDriver';
				TransitionAnim = 'Com_close';
				bAttachProxy = true;
			}
			else
			{
				TimerName = 'SeatTransitioningFour';
			}
		}
		// Transition from gunner to loader
		else if( OldSeatIndex == 2 )
		{
			TimerName = 'SeatTransitioningFour';
		}
		// Transition from hull MG to loader
		else if( OldSeatIndex == 3 )
		{
		    // Commander
			TimerName = 'SeatTransitioningFour';
		}
	}

	// Set the new attach bone based on whether we need to play a hatch close animation first or not
	if( bUseExteriorAnim )
	{
		Seats[NewSeatIndex].SeatTransitionBoneName = Seats[OldSeatIndex].SeatBone;
		Seats[NewSeatIndex].bPreparingToTrans = true;
	}
	else
	{
		TransitionAnim = '';
	}

	// If this transition requires us to attach the driver to a different bone, do that here
	if( bAttachProxy && !bTransitionWithoutProxy )
	{
		VCP.SetBase( Self, , Mesh, Seats[NewSeatIndex].SeatTransitionBoneName);
		VCP.SetRelativeLocation( Seats[OldSeatIndex].SeatOffset );
		VCP.SetRelativeRotation( Seats[OldSeatIndex].SeatRotation );
	}

	if( TransitionAnim != '' )
	{
		// Store a reference to the driver pawn making the transition so we can use
		// it for the second part of timer driven transitions
		Seats[NewSeatIndex].TransitionProxy = VCP;

		Seats[OldSeatIndex].PositionBlend.HandleAnimPlay(TransitionAnim, false);
		Seats[NewSeatIndex].PositionBlend.HandleAnimPlay(Seats[NewSeatIndex].SeatPositions[Seats[NewSeatIndex].InitialPositionIndex].PositionIdleAnim, false);

		if( bTransitionWithoutProxy )
		{
			// Set up the transition timer
			AnimTimer = SeatProxyAnimSet.GetAnimLength(TransitionAnim);
		}
		else
		{
			// Set up the transition and animation
			AnimTimer = VCP.Mesh.GetAnimLength(TransitionAnim);
			VCP.PlayFullBodyAnimation(TransitionAnim);
		}
	}
	else
	{
		// Use our preset times rather than the incorrect animation lengths
		AnimTimer = Seats[OldSeatIndex].FadedTransTimes[NewSeatIndex];
		// Play the idle anim to prevent clipping through the tank
		VCP.PlayFullBodyAnimation(Seats[NewSeatIndex].SeatPositions[Seats[NewSeatIndex].InitialPositionIndex].DriverIdleAnim);
	}

	Seats[NewSeatIndex].bTransitioningToSeat = true;
	HandlePostInstantSeatTransition(OldSeatIndex);

	// Set up the timer for ending the transition
	SetTimer(AnimTimer, false, TimerName);
}

/**
 * Finish a faded non-animated transition to Seat Index 0
 */
simulated function SeatTransitioningZero()
{
	FinishFadedTransition(0);
}

/**
 * Finish a faded non-animated transition to Seat Index 1
 */
simulated function SeatTransitioningOne()
{
	FinishFadedTransition(1);
}

/**
 * Finish a faded non-animated transition to Seat Index 2
 */
simulated function SeatTransitioningTwo()
{
	FinishFadedTransition(2);
}

/**
 * Finish a faded non-animated transition to Seat Index 3
 */
simulated function SeatTransitioningThree()
{
	FinishFadedTransition(3);
}

/**
 * Finish a faded non-animated transition to Seat Index 4
 */
simulated function SeatTransitioningFour()
{
	FinishFadedTransition(4);
}

/**
 * Handle the second half of a visible animated transition from the Driver
 * position to the Commander position.
 */
simulated function SeatTransitioningDriverToCommander()
{
	ContinueNonAnimTransition(Seats[1].SeatBone, 0, 1, 'SeatTransitioningOne');
}

/**
 * Handle the second half of a visible animated transition from the Driver
 * position to the Gunner position.
 */
simulated function SeatTransitioningDriverToGunner()
{
	ContinueNonAnimTransition(Seats[2].SeatBone, 0, 2, 'SeatTransitioningTwo');
}

/**
 * Handle the second half of a visible animated transition from the Driver
 * position to the Hull MG position.
 */
simulated function SeatTransitioningDriverToHullMG()
{
	ContinueNonAnimTransition(Seats[3].SeatBone, 0, 3, 'SeatTransitioningThree');
}

/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the driver position.
 */
simulated function SeatTransitioningCommanderToTurretGoalDriver()
{
	ContinueNonAnimTransition(Seats[0].SeatBone, 1, 0, 'SeatTransitioningZero');
}

/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the gunner position.
 */
simulated function SeatTransitioningCommanderToTurretGoalGunner()
{
	ContinueNonAnimTransition(Seats[2].SeatBone, 1, 2, 'SeatTransitioningTwo');
}

/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the hull MG position.
 */
simulated function SeatTransitioningCommanderToTurretGoalMG()
{
	ContinueNonAnimTransition(Seats[3].SeatBone, 1, 3, 'SeatTransitioningThree');
}

/**
 * Handle the second half of a visible animated transition from the Gunner
 * position to the Driver position.
 */
simulated function SeatTransitioningGunnerToDriver()
{
	ContinueNonAnimTransition(Seats[0].SeatBone, 2, 0, 'SeatTransitioningZero');
}

/**
 * Handle the second half of a visible animated transition from the Gunner
 * position to the Commander position.
 */
simulated function SeatTransitioningGunnerToCommander()
{
	ContinueNonAnimTransition(Seats[1].SeatBone, 2, 1, 'SeatTransitioningOne');
}

/**
 * Handle the second half of a visible animated transition from the Gunner
 * position to the HullMG position.
 */
simulated function SeatTransitioningGunnerToHullMG()
{
	ContinueNonAnimTransition(Seats[3].SeatBone, 2, 3, 'SeatTransitioningThree');
}

/**
 * Handle the second half of a visible animated transition from the Hull MG
 * position to the driver position.
 */
simulated function SeatTransitioningHullMGToDriver()
{
	ContinueNonAnimTransition(Seats[0].SeatBone, 3, 0, 'SeatTransitioningZero');
}

/**
 * Handle the second half of a visible animated transition from the Hull MG
 * position to the Commander position.
 */
simulated function SeatTransitioningHullMGToCommander()
{
	ContinueNonAnimTransition(Seats[1].SeatBone, 3, 1, 'SeatTransitioningOne');
}

/**
 * Handle the second half of a visible animated transition from the Hull MG
 * position to the Gunner position.
 */
simulated function SeatTransitioningHullMGToGunner()
{
	ContinueNonAnimTransition(Seats[2].SeatBone, 3, 2, 'SeatTransitioningTwo');
}


/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the driver position.
 */
simulated function SeatProxyTransitioningCommanderToTurretGoalDriver()
{
	ContinueNonAnimTransition(Seats[0].SeatBone, 1, 0, 'SeatTransitioningZero', true);
}

/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the gunner position.
 */
simulated function SeatProxyTransitioningCommanderToTurretGoalGunner()
{
	ContinueNonAnimTransition(Seats[2].SeatBone, 1, 2, 'SeatTransitioningTwo', true);
}

/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the hull MG position.
 */
simulated function SeatProxyTransitioningCommanderToTurretGoalMG()
{
	ContinueNonAnimTransition(Seats[3].SeatBone, 1, 3, 'SeatTransitioningThree', true);
}

/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the hull MG position.
 */
simulated function SeatProxyTransitioningCommanderToTurretGoalLoader()
{
	ContinueNonAnimTransition(Seats[4].SeatBone, 1, 4, 'SeatTransitioningFour', true);
}

simulated function PositionIndexUpdated(int SeatIndex, byte NewPositionIndex)
{

	local ROPlayerController ROPC;
	local name UseKeyBinding;

	if( SeatIndex == GetHullMGSeatIndex() )
	{
		if ( NewPositionIndex == Seats[SeatIndex].FiringPositionIndex )
		{
			if( MGController != none )
			{
                MGController.SetSkelControlActive(true);
            }
		}
		else
		{
			if( MGController != none )
			{
                MGController.SetSkelControlActive(false);
            }

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
	else if( SeatIndex == GetCommanderSeatIndex() )
	{
		if ( IsInPeriscope(SeatIndex, NewPositionIndex) )
		{
			ROPC = ROPlayerController(Seats[SeatIndex].SeatPawn.Controller);
			if ( ROPC != None && LocalPlayer(ROPC.Player) != none )
			{
				if ( !ROPC.PlayerInput.FindKeyNameForCommand("Interact", UseKeyBinding, true) )
				{
					ROPC.PlayerInput.FindKeyNameForCommand("UseKey", UseKeyBinding, true);
				}
				ROPC.ClientMessage(repl(UsePeriscodeString, "%KEY%", UseKeyBinding));
			}

			LinkPeriscope(false, true);
		}
	}

	if(SeatIndex != GetCommanderSeatIndex() )
		LinkPeriscope(true, true);


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

function TankIntDamTest(int MIC, int DamageArea, float Amount)
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

simulated function bool IsInPeriscope(byte SeatIndex, byte PositionIndex)
{
	if ( SeatIndex != GetCommanderSeatIndex() )
		return false;
	if ( Seats[SeatIndex].bPositionTransitioning )
		return false;

	return true;
}



/**
 * Network: Server and Local Player
 *
 * @design - Should we seperate the periscope into two positions?
 */
simulated function LinkPeriscope(bool bNewIsLinked, optional bool bIsPendingPosition)
{
	local ROWeaponPawn ROWP;
	local ROPlayerController ROPC;
	local byte SeatIdx, PositionIdx;
	local rotator NewViewRotation;

	SeatIdx = GetGunnerSeatIndex();
	PositionIdx = (Seats[SeatIdx].SeatPositions.Length - 1);

	ROWP = ROWeaponPawn(Seats[SeatIdx].SeatPawn);
	ROPC = ROPlayerController(Seats[SeatIdx].SeatPawn.Controller);

	// Setup position
	if ( bNewIsLinked )
	{
		Seats[SeatIdx].SeatPositions[PositionIdx].bRotateGunOnCommand = false;
		Seats[SeatIdx].SeatPositions[PositionIdx].bConstrainRotation = false;
		Seats[SeatIdx].SeatPositions[PositionIdx].bCamRotationFollowSocket = true;

		ROWP.bAllowCameraRotation = false;
		Seats[SeatIdx].CameraTag = Seats[SeatIdx].SeatPositions[PositionIdx].PositionCameraTag;


		// Update the desired aim to lock the gun into place
		ROPC.DesiredVehicleAim = SeatWeaponRotation(SeatIdx,,true);
	}
	else
	{
		Seats[SeatIdx].SeatPositions[PositionIdx].bRotateGunOnCommand = true;
		Seats[SeatIdx].SeatPositions[PositionIdx].bConstrainRotation = true;
		Seats[SeatIdx].SeatPositions[PositionIdx].bCamRotationFollowSocket = false;

		if ( !bIsPendingPosition )
		{
			ROWP.bAllowCameraRotation = true;
			Seats[SeatIdx].CameraTag = Seats[SeatIdx].SeatPositions[PositionIdx].PositionCameraTag;

			// zero yaw offset onto the periscope socket
			NewViewRotation = ROPC.Rotation;
			NewViewRotation.Yaw = 0;
			ROPC.SetRotation( NewViewRotation );
		}
	}
}


DefaultProperties
{
	Team=`ALLIES_TEAM_INDEX
	Health=600
	MaxSpeed=680 // ~42 km/h

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

	Begin Object class=PointLightComponent name=InteriorLight_0
		Radius=75.0
		LightColor=(R=255,G=170,B=130)
		UseDirectLightMap=FALSE
		Brightness=1.0
		LightingChannels=(Unnamed_1=TRUE,BSP=FALSE,Static=FALSE,Dynamic=FALSE,CompositeDynamic=FALSE)
	End Object

	Begin Object class=PointLightComponent name=InteriorLight_1
		Radius=75.0
		LightColor=(R=255,G=170,B=130)
		UseDirectLightMap=FALSE
		Brightness=1.0
		LightingChannels=(Unnamed_1=TRUE,BSP=FALSE,Static=FALSE,Dynamic=FALSE,CompositeDynamic=FALSE)
	End Object

	VehicleLights(0)={(AttachmentName=InteriorLightComponent0,Component=InteriorLight_0,bAttachToSocket=true,AttachmentTargetName=interior_light_0)}
	VehicleLights(1)={(AttachmentName=InteriorLightComponent1,Component=InteriorLight_1,bAttachToSocket=true,AttachmentTargetName=interior_light_1)}

	CrewAnimSet=AnimSet'DR_VH_UK_M4A1Sherman.Anim.CHR_Sherman_Anim_Master'
	bNoAnimTransition=true

	Seats(0)={(	CameraTag=None,
				CameraOffset=-420,
				SeatAnimBlendName=DriverPositionNode,
				SeatPositions=((bDriverVisible=false,bAllowFocus=false,PositionCameraTag=Driver_Camera,ViewFOV=70.0,bViewFromCameraTag=true,bDrawOverlays=true,
									PositionDownAnim=Driver_port_idle,PositionIdleAnim=Driver_port_idle,DriverIdleAnim=Driver_port_idle,AlternateIdleAnim=Driver_port_idle,SeatProxyIndex=0,
									LeftHandIKInfo=(PinEnabled=true),
				                    			RightHandIKInfo=(PinEnabled=true),
									HipsIKInfo=(PinEnabled=true),
									LeftFootIKInfo=(PinEnabled=true),
				                 			RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(Driver_port_idle),
									PositionDeathAnims=(Driver_open_Death))
								),
				bSeatVisible=true,
				SeatBone=DriverSeatBone,
				DriverDamageMult=1.0,
				InitialPositionIndex=0,
				SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
				VehicleBloodMICParameterName=Gore02,
				FadedTransTimes=(0,6.5,6.25,4,6.25),
				)}

	Seats(1)={(	TurretVarPrefix="Cuppola",
	            BinocOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_vignette',
	            BarTexture=Texture2D'ui_textures.Textures.button_128grey',
				RangeOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_T34_range',
				PeriscopeRangeTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_T34_Periscope_range',
				VignetteOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_vignette',
				CameraTag=None,
				CameraOffset=-420,
				bSeatVisible=true,
				SeatBone=CommanderSeatBone,
				SeatAnimBlendName=CommanderPositionNode,
				SeatPositions=(	   // Periscope
								(bDriverVisible=false,bBinocsPosition=true,bAllowFocus=false,PositionCameraTag=Camera_Periscope,ViewFOV=20.5,bRotateGunOnCommand=true,bViewFromCameraTag=true,bDrawOverlays=true,SeatProxyIndex=1,
								    PositionDownAnim=Driver_port_idle,PositionUpAnim=Driver_port_idle,PositionIdleAnim=Driver_port_idle,DriverIdleAnim=Driver_port_idle,AlternateIdleAnim=Driver_port_idle,
									bConstrainRotation=false,YawContraintIndex=1,PitchContraintIndex=0,
									LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_GunnerLeftHand,DefaultEffectorRotationTargetName=IK_GunnerLeftHand),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_GunnerRightHand,DefaultEffectorRotationTargetName=IK_GunnerRightHand),
									LeftFootIKInfo=(IKEnabled=false),
									RightFootIKInfo=(IKEnabled=false),
									PositionFlinchAnims=(Driver_port_idle),
									PositionDeathAnims=(Driver_open_Death)),		   // Periscope
								(bDriverVisible=false,bBinocsPosition=true,bAllowFocus=false,PositionCameraTag=Camera_Periscope,ViewFOV=20.5,bRotateGunOnCommand=true,bViewFromCameraTag=true,bDrawOverlays=true,SeatProxyIndex=1,
								    PositionDownAnim=Driver_port_idle,PositionUpAnim=Driver_port_idle,PositionIdleAnim=Driver_port_idle,DriverIdleAnim=Driver_port_idle,AlternateIdleAnim=Driver_port_idle,
									bConstrainRotation=false,YawContraintIndex=1,PitchContraintIndex=0,
									LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_GunnerLeftHand,DefaultEffectorRotationTargetName=IK_GunnerLeftHand),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_GunnerRightHand,DefaultEffectorRotationTargetName=IK_GunnerRightHand),
									LeftFootIKInfo=(IKEnabled=false),
									RightFootIKInfo=(IKEnabled=false),
									PositionFlinchAnims=(Driver_port_idle),
									PositionDeathAnims=(Driver_open_Death))),
				DriverDamageMult=1.0,
				InitialPositionIndex=1,
				SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
				VehicleBloodMICParameterName=Gore04,
				FadedTransTimes=(6.5,0,1.5,6.5,1.5),
				)}

	Seats(2)={(	GunClass=class'DRVWeap_ShermanIII_Turret',
				SightOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_optics_M4A1',
				NeedleOverlayTexture=none,
				RangeOverlayTexture=none,
				VignetteOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_vignette',
				GunSocket=(Barrel,CoaxMG),
				GunPivotPoints=(gun_base,gun_base),
				TurretVarPrefix="Turret",
				TurretControls=(Turret_Gun,Turret_Main),
				CameraTag=None,
				CameraOffset=-420,
				bSeatVisible=true,
				SeatBone=GunnerSeatBone,
				SeatAnimBlendName=GunnerPositionNode,
				SeatPositions=(  (bDriverVisible=false,bAllowFocus=false,PositionCameraTag=Camera_Gunner,ViewFOV=13.5,bCamRotationFollowSocket=true,bViewFromCameraTag=true,bDrawOverlays=true,PositionDownAnim=Driver_port_idle,PositionIdleAnim=Driver_port_idle,DriverIdleAnim=Driver_port_idle,AlternateIdleAnim=Driver_port_idle,SeatProxyIndex=2,
												LeftHandIKInfo=(PinEnabled=true),
				                    RightHandIKInfo=(PinEnabled=true),
									HipsIKInfo=(PinEnabled=true),
									LeftFootIKInfo=(PinEnabled=true),
				                    RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(Driver_port_idle),
									PositionDeathAnims=(Driver_open_Death))),
				DriverDamageMult=1.0,
				InitialPositionIndex=0,
				FiringPositionIndex=0,
				TracerFrequency=5,
				WeaponTracerClass=(none,class'RSGame.M1919BulletTracer'),
				MuzzleFlashLightClass=(class'ROGrenadeExplosionLight',class'ROVehicleMGMuzzleFlashLight'),
				SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
				VehicleBloodMICParameterName=Gore01,
				FadedTransTimes=(6.25,1.5,0,6.25,5),
				)}

	Seats(3)={(	GunClass=class'DRVWeap_M4A3_HullMG',
				SightOverlayTexture=none,
				VignetteOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_optics_vignette',
				GunSocket=(MG_Barrel),
				GunPivotPoints=(MG_Pitch),
				TurretVarPrefix="HullMG",
				TurretControls=(Hull_MG_Yaw,Hull_MG_Pitch),
				CameraTag=None,
				CameraOffset=-420,
				bSeatVisible=true,
				SeatBone=HullMGSeatBone,
				SeatAnimBlendName=HullMGPositionNode,
				SeatPositions=((bDriverVisible=false,bAllowFocus=true,PositionCameraTag=MG_Camera,ViewFOV=35.0,bCamRotationFollowSocket=true,bViewFromCameraTag=true,bDrawOverlays=true,bUseDOF=true,
									PositionDownAnim=Driver_port_idle,PositionIdleAnim=Driver_port_idle,bConstrainRotation=false,YawContraintIndex=0,PitchContraintIndex=1,DriverIdleAnim=Driver_port_idle,AlternateIdleAnim=Driver_port_idle,SeatProxyIndex=3,       //2.0x zoom should be 16.25, for gameplay trying less zoom for now
												LeftHandIKInfo=(PinEnabled=true),
				                    RightHandIKInfo=(PinEnabled=true),
									HipsIKInfo=(PinEnabled=true),
									LeftFootIKInfo=(PinEnabled=true),
				                    RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(Driver_port_idle),
									PositionDeathAnims=(Driver_open_Death))),
				DriverDamageMult=1.0,
				InitialPositionIndex=0,
				FiringPositionIndex=0,
				SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
				VehicleBloodMICParameterName=Gore03,
				TracerFrequency=5,
				WeaponTracerClass=(class'M1919BulletTracer',class'M1919BulletTracer'),
				MuzzleFlashLightClass=(class'ROVehicleMGMuzzleFlashLight',class'ROVehicleMGMuzzleFlashLight'),
				FadedTransTimes=(4,6.5,6.25,0,6.25),
				)}

	Seats(4)={(	bNonEnterable=true,
				SeatAnimBlendName=LoaderPositionNode,
				TurretVarPrefix="Loader",
				SeatPositions=((bDriverVisible=false,PositionIdleAnim=Driver_port_idle,AlternateIdleAnim=Driver_port_idle,SeatProxyIndex=4,
				                    LeftHandIKInfo=(PinEnabled=true),
				                    RightHandIKInfo=(PinEnabled=true),
				                    HipsIKInfo=(PinEnabled=true),
				                    PositionFlinchAnims=(Driver_port_idle),
									PositionDeathAnims=(Driver_open_Death),
				                    HeightInfo=(HeightDisplacementEnabled=false,
										AlternateHeightTargets=((Action=DAct_ReloadCoaxMG,HeightDisplacementEnabled=true,OriginalHeightTargetName=DefualtMGReload,ModifiedHeightTargetName=CurrentMGReload))),
									LeftHandIKInfo=(IKEnabled=false,
										AlternateEffectorTargets=((Action=DAct_CannonReload_LH1,IKEnabled=true,PinEnabled=false,EffectorLocationTargetName=LoaderLHCannon1,EffectorRotationTargetName=LoaderLHCannon1),
																  (Action=DAct_CannonReload_LH2,IKEnabled=true,PinEnabled=false,EffectorLocationTargetName=LoaderLHCannon2,EffectorRotationTargetName=LoaderLHCannon2),
																  (Action=DAct_CannonReload_LH3,IKEnabled=true,PinEnabled=false,EffectorLocationTargetName=LoaderLHCannonBreech1,EffectorRotationTargetName=LoaderLHCannonBreech1),
																  (Action=DAct_CannonReload_LHOff,IKEnabled=false,PinEnabled=true))),
									RightHandIKInfo=(IKEnabled=false,
										AlternateEffectorTargets=((Action=DAct_CannonReload_RH1,IKEnabled=true,PinEnabled=false,EffectorLocationTargetName=LoaderRHCannon1,EffectorRotationTargetName=LoaderRHCannon1),
																  (Action=DAct_CannonReload_RH2,IKEnabled=true,PinEnabled=false,EffectorLocationTargetName=LoaderRHCannonMG1,EffectorRotationTargetName=LoaderRHCannonMG1),
																  (Action=DAct_CannonReload_RHOff,IKEnabled=false,PinEnabled=true)))
								)),
				bSeatVisible=true,
				SeatBone=LoaderSeatBone,
				SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
				VehicleBloodMICParameterName=Gore01,
				FadedTransTimes=(6.25,1.5,6.25,1.5,0),
				)}

	SeatIndexPassRotateOnCommandToOtherSeat=1
	SeatIndexToRotateOnCommandFromOtherSeat=2



	//_________________________
	// ROSkelControlTankWheels
	//
	LeftWheels(0)="L0_Wheel"
	LeftWheels(1)="L1_Wheel"
	LeftWheels(2)="L2_Wheel"
	LeftWheels(3)="L3_Wheel"
	LeftWheels(4)="L4_Wheel"
	LeftWheels(5)="L5_Wheel"
	LeftWheels(6)="L6_Wheel"
	LeftWheels(7)="L7_Wheel"
	LeftWheels(11)="L8_9_10_Wheel"
	//
	RightWheels(0)="R0_Wheel"
	RightWheels(1)="R1_Wheel"
	RightWheels(2)="R2_Wheel"
	RightWheels(3)="R3_Wheel"
	RightWheels(4)="R4_Wheel"
	RightWheels(5)="R5_Wheel"
	RightWheels(6)="R6_Wheel"
	RightWheels(7)="R7_Wheel"
	RightWheels(11)="R8_9_10_Wheel"

	/** Physics Wheels */

	// Right Rear Wheel
	Begin Object Name=RRWheel
		BoneName="R_Wheel_06"
		BoneOffset=(X=-10.0,Y=0,Z=0.0)
		WheelRadius=12
		SuspensionTravel=16
	End Object
	Wheels(0)=RRWheel

	// Right middle wheel
	Begin Object Name=RMWheel
		BoneName="R_Wheel_04"
		BoneOffset=(X=5.0,Y=0,Z=0.0)
		WheelRadius=12
		SuspensionTravel=5
	End Object
	Wheels(1)=RMWheel

	// Right Front Wheel
	Begin Object Name=RFWheel
		BoneName="R_Wheel_01"
		WheelRadius=12
		SuspensionTravel=5
	End Object
	Wheels(2)=RFWheel

	// Left Rear Wheel
	Begin Object Name=LRWheel
		BoneName="L_Wheel_06"
		BoneOffset=(X=-10.0,Y=0,Z=0.0)
		WheelRadius=12
		SuspensionTravel=16
	End Object
	Wheels(3)=LRWheel

	// Left Middle Wheel
	Begin Object Name=LMWheel
		BoneName="L_Wheel_04"
		BoneOffset=(X=5.0,Y=0,Z=0.0)
		WheelRadius=12
		SuspensionTravel=5
	End Object
	Wheels(4)=LMWheel

	// Left Front Wheel
	Begin Object Name=LFWheel
		BoneName="L_Wheel_01"
		WheelRadius=12
		SuspensionTravel=5
	End Object
	Wheels(5)=LFWheel


	/** Vehicle Sim */
	Begin Object Name=SimObject
		// Transmission - GearData
		// for gear ratios, bear in mind that the drive wheel's diameter is 42uu as opposed to the wheels touching the ground, which are 30uu
		GearArray(0)={(
			// Real world - [5.64] 5.5 kph reverse
			GearRatio=-5.0759997,
			AccelRate=7.5,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=-3899.9998),
				(InVal=300,OutVal=-1300.0),
				(InVal=2800,OutVal=-3899.9998),
				(InVal=3000,OutVal=-1300.0),
				(InVal=3200,OutVal=-0.0)
				)}),
			TurningThrottle=0.81700003
			)}
		GearArray(1)={(
			// [N/A]  reserved for neutral
			)}
		GearArray(2)={(
			// Real world - [6.89] 4.5 kph at 2800rpm
			GearRatio=4.959,
			AccelRate=8,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=4160.0),
				(InVal=300,OutVal=3899.9998),
				(InVal=2800,OutVal=4160.0),
				(InVal=3000,OutVal=1404.0),
				(InVal=3200,OutVal=0.0)
				)}),
			TurningThrottle=0.8075
			)}
		GearArray(3)={(
			// Real world - [3.60] 8.6 kph
			GearRatio=2.592,
			AccelRate=9,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=5304.0),
				(InVal=300,OutVal=4212.0),
				(InVal=2800,OutVal=5460.0),
				(InVal=3000,OutVal=1560.0),
				(InVal=3200,OutVal=0.0)
				)}),
			TurningThrottle=0.8075
			)}
		GearArray(4)={(
			// Real world - [2.14] 14.5 kph
			GearRatio=1.539,
			AccelRate=9.35,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=7799.9995),
				(InVal=300,OutVal=4680.0),
				(InVal=2800,OutVal=9360.0),
				(InVal=3000,OutVal=3120.0),
				(InVal=3200,OutVal=0.0)
				)}),
			TurningThrottle=0.7125
			)}
		GearArray(5)={(
			// Real world - [1.42] 21.9 kph
			GearRatio=1.017,
			AccelRate=11.00,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=9360.0),
				(InVal=300,OutVal=5460.0),
				(InVal=2800,OutVal=12168.0),
				(InVal=3000,OutVal=6240.0),
				(InVal=3200,OutVal=0.0)
				)}),
			TurningThrottle=0.8075
			)}
		GearArray(6)={(
			// Real world - [1.00] 31.0 kph
			GearRatio=0.71999997,
			AccelRate=11.20,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=10920.0),
				(InVal=300,OutVal=6240.0),
				(InVal=2800,OutVal=16848.0),
				(InVal=3000,OutVal=8580.0),
				(InVal=3200,OutVal=0.0)
				)}),
			TurningThrottle=0.76
			)}
		GearArray(7)={(
			// Real world - [0.78] 40.0 kph
			GearRatio=0.55799997,
			AccelRate=11.20,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=12480.0),
				(InVal=300,OutVal=7019.9995),
				(InVal=2800,OutVal=21372.0),
				(InVal=3000,OutVal=9048.0),
				(InVal=3200,OutVal=0.0)
				)}),
			TurningThrottle=0.76
			)}


		// Transmission - Misc
		FirstForwardGear=2
		ChangeUpPoint=2600.000000
		WheelSuspensionBias=0.3


	End Object

	TreadSpeedScale=-2.75

	// Muzzle Flashes
	VehicleEffects(TankVFX_Firing1)=(EffectStartTag=PanzerIIIMCannon,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_B_TankMuzzle',EffectSocket=Barrel,bRestartRunning=true)
	VehicleEffects(TankVFX_Firing2)=(EffectStartTag=PanzerIIIMCannon,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_B_TankCannon_Dust',EffectSocket=attachments_body_ground,bRestartRunning=true)
	VehicleEffects(TankVFX_Firing3)=(EffectStartTag=PanzerIIIMHullMG,EffectTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_split',EffectSocket=MG_Barrel)
	VehicleEffects(TankVFX_Firing4)=(EffectStartTag=PanzerIIIMCoaxMG,EffectTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_split',EffectSocket=CoaxMG)
	// Driving effects
	VehicleEffects(TankVFX_Exhaust)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,EffectTemplate=ParticleSystem'FX_VEH_Tank.FX_VEH_Tank_A_TankExhaust',EffectSocket=Exhaust)
	VehicleEffects(TankVFX_TreadWing)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bStayActive=true,EffectTemplate=ParticleSystem'FX_VEH_Tank_Three.FX_VEH_LightTank_A_Wing_Dirt',EffectSocket=attachments_body_ground)
	// Damage
	VehicleEffects(TankVFX_DmgSmoke)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_Damage',EffectSocket=attachments_engine)
	VehicleEffects(TankVFX_DmgInterior)=(EffectStartTag=DamageInterior,EffectEndTag=NoInternalSmoke,bRestartRunning=false,bInteriorEffect=true,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_Interior_Penetrate',EffectSocket=attachments_body)
	// Death
	VehicleEffects(TankVFX_DeathSmoke1)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_1)
	VehicleEffects(TankVFX_DeathSmoke2)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_2)
	VehicleEffects(TankVFX_DeathSmoke3)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_3)

	TrackSoundParamScale=0.00004	// top speed : 25,000

	// Initialize sound parameters.
	SquealThreshold=250.0
	EngineStartOffsetSecs=2.0
	EngineStopOffsetSecs=0.0

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

	TreadSpeedParameterName=Tank_Tread_Speed

	DrivingPhysicalMaterial=PhysicalMaterial'DR_VH_DAK_PanzerIV_F.Phys.PhysMat_PanzerIVG'
    DefaultPhysicalMaterial=PhysicalMaterial'DR_VH_DAK_PanzerIV_F.Phys.PhysMat_PanzerIVG_Moving'

	CannonFireImpulseMag=20000
	CannonFireTorqueMag=9375

	BaseEyeHeight=60.0

	bDebugPenetration=false

	VehHitZones(0)=(ZoneName=ENGINEBLOCK,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=100,VisibleFrom=14)
	VehHitZones(1)=(ZoneName=ENGINECORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=300,VisibleFrom=14)
	VehHitZones(2)=(ZoneName=MGAMMOSTOREONE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.4,VisibleFrom=5)
	VehHitZones(3)=(ZoneName=MGAMMOSTORETWO,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=9)
	VehHitZones(4)=(ZoneName=AMMOSTOREONE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=20,KillPercentage=0.4,VisibleFrom=5)
	VehHitZones(5)=(ZoneName=AMMOSTORETWO,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=9)
	VehHitZones(6)=(ZoneName=AMMOSTORETHREE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=4)
	VehHitZones(7)=(ZoneName=AMMOSTOREFOUR,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=8)
	VehHitZones(8)=(ZoneName=FUELTANKONE,DamageMultiplier=10.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=100,KillPercentage=0.3,VisibleFrom=6)
	VehHitZones(9)=(ZoneName=FUELTANKTWO,DamageMultiplier=10.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=100,KillPercentage=0.3,VisibleFrom=10)
	VehHitZones(10)=(ZoneName=GEARBOX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=100,VisibleFrom=1)
	VehHitZones(11)=(ZoneName=GEARBOXCORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=200,VisibleFrom=1)
	VehHitZones(12)=(ZoneName=LEFTBRAKES,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=5)
	VehHitZones(13)=(ZoneName=RIGHTBRAKES,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=9)
	VehHitZones(14)=(ZoneName=TURRETRINGONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=13)
	VehHitZones(15)=(ZoneName=TURRETRINGTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=9)
	VehHitZones(16)=(ZoneName=TURRETRINGTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=10)
	VehHitZones(17)=(ZoneName=TURRETRINGFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=5)
	VehHitZones(18)=(ZoneName=TURRETRINGFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=6)
	VehHitZones(19)=(ZoneName=TURRETRINGSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=14)
	VehHitZones(20)=(ZoneName=COAXIALMG,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25)
	VehHitZones(21)=(ZoneName=MAINCANNONREAR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=50,KillPercentage=0.3)
	VehHitZones(22)=(ZoneName=DRIVERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=DriverSeatbone)
	VehHitZones(23)=(ZoneName=DRIVERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Driver_bone)
	VehHitZones(24)=(ZoneName=HULLMGBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=3,SeatProxyIndex=2,CrewBoneName=HullMGSeatBone)
	VehHitZones(25)=(ZoneName=HULLMGHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=3,SeatProxyIndex=2,CrewBoneName=Hullgunner_Bone)
	VehHitZones(26)=(ZoneName=COMMANDERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=CommanderSeatBone)
	VehHitZones(27)=(ZoneName=COMMANDERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=Commander_Bone)
	VehHitZones(28)=(ZoneName=LOADERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=4,SeatProxyIndex=3,CrewBoneName=LoaderSeatBone)
	VehHitZones(29)=(ZoneName=LOADERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=4,SeatProxyIndex=3,CrewBoneName=Loader_Bone)
	VehHitZones(30)=(ZoneName=GUNNERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=2,SeatProxyIndex=4,CrewBoneName=gunnerSeatBone)
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

	// Armor Hits
	ArmorHitZones(0)=(ZoneName=FRONTGLACISUPPER,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTGLACISUP)
	ArmorHitZones(1)=(ZoneName=FRONTRIGHTHATCHAPPLIQUEARMOUR,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTHATCHRIGHT)
	ArmorHitZones(2)=(ZoneName=FRONTLEFTHATCHAPPLIQUEARMOUR,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTHATCHLEFT)
	ArmorHitZones(3)=(ZoneName=FRONTGLACISLOWER,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTGLACISLOW)

	ArmorHitZones(4)=(ZoneName=LEFTSIDEARMOUR,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTMAIN)
	ArmorHitZones(5)=(ZoneName=LEFTSIDEARMOURTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTMAIN)
	ArmorHitZones(6)=(ZoneName=LEFTSIDEARMOURTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTMAIN)
	ArmorHitZones(7)=(ZoneName=LEFTOVERHANGARMOUR,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTMAIN)

	ArmorHitZones(8)=(ZoneName=LEFTSIDEARMOURFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONT)
	ArmorHitZones(9)=(ZoneName=LEFTARMOURFRONTTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONT)

	ArmorHitZones(10)=(ZoneName=LEFTSIDEFORWARDAPPLIQUEARMOUR,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTAPPLIQUE)

	ArmorHitZones(11)=(ZoneName=REARLEFTCHASSISROOF,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREAR)


	ArmorHitZones(12)=(ZoneName=RIGHTSIDEARMOUR,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTMAIN)
	ArmorHitZones(13)=(ZoneName=RIGHTSIDEARMOURTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTMAIN)
	ArmorHitZones(14)=(ZoneName=RIGHTSIDEARMOURTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTMAIN)
	ArmorHitZones(15)=(ZoneName=RIGHTOVERHANGARMOUR,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTMAIN)

	ArmorHitZones(16)=(ZoneName=RIGHTSIDEARMOURFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONT)
	ArmorHitZones(17)=(ZoneName=RIGHTARMOURFRONTTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONT)

	ArmorHitZones(18)=(ZoneName=RIGHTSIDEFORWARDAPPLIQUEARMOUR,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTAPPLIQUE1)
	ArmorHitZones(19)=(ZoneName=RIGHTSIDEREARAPPLIQUEARMOUR,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTAPPLIQUE2)

	ArmorHitZones(20)=(ZoneName=REARRIGHTCHASSISROOF,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTREAR)

	ArmorHitZones(21)=(ZoneName=REARARMOURLEFT,PhysBodyBoneName=Chassis,ArmorPlateName=REARMAIN)
	ArmorHitZones(22)=(ZoneName=REARARMOURRIGHT,PhysBodyBoneName=Chassis,ArmorPlateName=REARMAIN)
	ArmorHitZones(23)=(ZoneName=REARARMOURCENTER,PhysBodyBoneName=Chassis,ArmorPlateName=REARMAIN)

	ArmorHitZones(24)=(ZoneName=REARCHASSISROOF,PhysBodyBoneName=Chassis,ArmorPlateName=ENGINEROOF)
	ArmorHitZones(25)=(ZoneName=FRONTCHASSISROOF,PhysBodyBoneName=Chassis,ArmorPlateName=CHASSISROOF)

	ArmorHitZones(26)=(ZoneName=FRONTBOTTOMPLATE,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTGLACISLOW2)
	ArmorHitZones(27)=(ZoneName=LEFTSIDEUNDERPLATE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTLOWER)
	ArmorHitZones(28)=(ZoneName=RIGHTSIDEUNDERPLATE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTLOWER)
	ArmorHitZones(29)=(ZoneName=FLOORARMOUR,PhysBodyBoneName=Chassis,ArmorPlateName=FLOOR)

	ArmorHitZones(30)=(ZoneName=UPPERGUNMANTLET,PhysBodyBoneName=Chassis,ArmorPlateName=MANLETUP)
	ArmorHitZones(31)=(ZoneName=LOWERGUNMANTLET,PhysBodyBoneName=Chassis,ArmorPlateName=MANLETDOWN)
	ArmorHitZones(32)=(ZoneName=TURRETFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=TURRETFRONT)

	ArmorHitZones(33)=(ZoneName=TURRETRIGHTSIDEONE,PhysBodyBoneName=Chassis,ArmorPlateName=TURRETRIGHT)
	ArmorHitZones(34)=(ZoneName=TURRETRIGHTSIDETWO,PhysBodyBoneName=Chassis,ArmorPlateName=TURRETRIGHT)
	ArmorHitZones(35)=(ZoneName=TURRETRIGHTSIDETHREE,PhysBodyBoneName=Chassis,ArmorPlateName=TURRETRIGHT2)


	ArmorHitZones(36)=(ZoneName=TURRETLEFTSIDEONE,PhysBodyBoneName=Chassis,ArmorPlateName=TURRETLEFT)
	ArmorHitZones(37)=(ZoneName=TURRETLEFTSIDETWO,PhysBodyBoneName=Chassis,ArmorPlateName=TURRETLEFT)
	ArmorHitZones(38)=(ZoneName=TURRETLEFTSIDETHREE,PhysBodyBoneName=Chassis,ArmorPlateName=TURRETLEFT2)

	ArmorHitZones(39)=(ZoneName=TURRETREARPLATE,PhysBodyBoneName=Chassis,ArmorPlateName=TURRETREAR1)
	ArmorHitZones(40)=(ZoneName=TURRETROOFREAR,PhysBodyBoneName=Chassis,ArmorPlateName=TURRETREAR2)

	ArmorHitZones(41)=(ZoneName=TURRETROOFFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=TURRETROOF1)
	ArmorHitZones(42)=(ZoneName=COMMANDERHATCH,PhysBodyBoneName=Chassis,ArmorPlateName=TURRETROOF2)


	// Armor plates that store the info for the actual plates
	ArmorPlates(0)=(PlateName=FRONTGLACISUP,ArmorZoneType=AZT_Front,PlateThickness=51,OverallHardness=255,bHighHardness=false)
	ArmorPlates(1)=(PlateName=FRONTHATCHRIGHT,ArmorZoneType=AZT_Front,PlateThickness=38,OverallHardness=255,bHighHardness=false)
	ArmorPlates(2)=(PlateName=FRONTHATCHLEFT,ArmorZoneType=AZT_Front,PlateThickness=38,OverallHardness=255,bHighHardness=false)
	ArmorPlates(3)=(PlateName=FRONTGLACISLOW,ArmorZoneType=AZT_Front,PlateThickness=51,OverallHardness=255,bHighHardness=false)

	ArmorPlates(4)=(PlateName=LEFTMAIN,ArmorZoneType=AZT_Left,PlateThickness=38,OverallHardness=255,bHighHardness=false)
	ArmorPlates(5)=(PlateName=LEFTFRONT,ArmorZoneType=AZT_Left,PlateThickness=38,OverallHardness=255,bHighHardness=false)
	ArmorPlates(6)=(PlateName=LEFTAPPLIQUE,ArmorZoneType=AZT_Left,PlateThickness=25,OverallHardness=255,bHighHardness=false)
	ArmorPlates(7)=(PlateName=LEFTREAR,ArmorZoneType=AZT_Left,PlateThickness=38,OverallHardness=255,bHighHardness=false)

	ArmorPlates(8)=(PlateName=RIGHTMAIN,ArmorZoneType=AZT_Right,PlateThickness=38,OverallHardness=255,bHighHardness=false)
	ArmorPlates(9)=(PlateName=RIGHTFRONT,ArmorZoneType=AZT_Right,PlateThickness=38,OverallHardness=255,bHighHardness=false)
	ArmorPlates(10)=(PlateName=RIGHTAPPLIQUE1,ArmorZoneType=AZT_Right,PlateThickness=25,OverallHardness=255,bHighHardness=false)
	ArmorPlates(11)=(PlateName=RIGHTAPPLIQUE2,ArmorZoneType=AZT_Right,PlateThickness=25,OverallHardness=255,bHighHardness=false)
	ArmorPlates(12)=(PlateName=RIGHTREAR,ArmorZoneType=AZT_Right,PlateThickness=38,OverallHardness=255,bHighHardness=false)

	ArmorPlates(13)=(PlateName=REARMAIN,ArmorZoneType=AZT_Back,PlateThickness=38,OverallHardness=255,bHighHardness=false)

	ArmorPlates(14)=(PlateName=CHASSISROOF,ArmorZoneType=AZT_Roof,PlateThickness=19,OverallHardness=255,bHighHardness=false)

	ArmorPlates(15)=(PlateName=ENGINEROOF,ArmorZoneType=AZT_WeakSpots,PlateThickness=19,OverallHardness=255,bHighHardness=false)
	ArmorPlates(16)=(PlateName=FRONTGLACISLOW2,ArmorZoneType=AZT_Front,PlateThickness=51,OverallHardness=255,bHighHardness=false)

	ArmorPlates(17)=(PlateName=LEFTLOWER,ArmorZoneType=AZT_Left,PlateThickness=19,OverallHardness=255,bHighHardness=false)
	ArmorPlates(18)=(PlateName=RIGHTLOWER,ArmorZoneType=AZT_Right,PlateThickness=19,OverallHardness=255,bHighHardness=false)

	ArmorPlates(19)=(PlateName=FLOOR,ArmorZoneType=AZT_Floor,PlateThickness=19,OverallHardness=255,bHighHardness=false)

	ArmorPlates(20)=(PlateName=MANLETUP,ArmorZoneType=AZT_TurretFront,PlateThickness=75,OverallHardness=255,bHighHardness=false)
	ArmorPlates(21)=(PlateName=MANLETDOWN,ArmorZoneType=AZT_TurretFront,PlateThickness=75,OverallHardness=255,bHighHardness=false)
	ArmorPlates(22)=(PlateName=TURRETFRONT,ArmorZoneType=AZT_TurretFront,PlateThickness=75,OverallHardness=255,bHighHardness=false)

	ArmorPlates(23)=(PlateName=TURRETRIGHT,ArmorZoneType=AZT_TurretRight,PlateThickness=51,OverallHardness=255,bHighHardness=false)
	ArmorPlates(24)=(PlateName=TURRETRIGHT2,ArmorZoneType=AZT_TurretRight,PlateThickness=51,OverallHardness=255,bHighHardness=false)

	ArmorPlates(25)=(PlateName=TURRETLEFT,ArmorZoneType=AZT_TurretLeft,PlateThickness=51,OverallHardness=255,bHighHardness=false)
	ArmorPlates(26)=(PlateName=TURRETLEFT2,ArmorZoneType=AZT_TurretLeft,PlateThickness=51,OverallHardness=255,bHighHardness=false)

	ArmorPlates(27)=(PlateName=TURRETREAR1,ArmorZoneType=AZT_TurretBack,PlateThickness=51,OverallHardness=255,bHighHardness=false)
	ArmorPlates(28)=(PlateName=TURRETREAR2,ArmorZoneType=AZT_TurretBack,PlateThickness=19,OverallHardness=255,bHighHardness=false)

	ArmorPlates(29)=(PlateName=TURRETROOF1,ArmorZoneType=AZT_TurretRoof,PlateThickness=19,OverallHardness=255,bHighHardness=false)
	ArmorPlates(30)=(PlateName=TURRETROOF2,ArmorZoneType=AZT_TurretRoof,PlateThickness=25,OverallHardness=255,bHighHardness=false)


	RPM3DGaugeMaxAngle=58982
	EngineIdleRPM=300
	EngineNormalRPM=2400
	EngineMaxRPM=3200
	Speedo3DGaugeMaxAngle=109227
	EngineOil3DGaugeMinAngle=16384
	EngineOil3DGaugeMaxAngle=35000
	EngineOil3DGaugeDamageAngle=5462
/*	GearboxOil3DGaugeMinAngle=15000
	GearboxOil3DGaugeNormalAngle=22500
	GearboxOil3DGaugeMaxAngle=30000
	GearboxOil3DGaugeDamageAngle=5000*/
	EngineTemp3DGaugeNormalAngle=-910
	EngineTemp3DGaugeEngineDamagedAngle=850
	EngineTemp3DGaugeFireDamagedAngle=3296
	EngineTemp3DGaugeFireDestroyedAngle=6554

	ArmorTextureOffsets(0)=(PositionOffset=(X=40,Y=0,Z=0),MySizeX=64,MYSizeY=68)
	ArmorTextureOffsets(1)=(PositionOffset=(X=27,Y=72,Z=0),MySizeX=90,MYSizeY=70)
	ArmorTextureOffsets(2)=(PositionOffset=(X=43,Y=20,Z=0),MySizeX=18,MYSizeY=98)
	ArmorTextureOffsets(3)=(PositionOffset=(X=82,Y=28,Z=0),MySizeX=18,MYSizeY=98)

	SprocketTextureOffsets(0)=(PositionOffset=(X=46,Y=36,Z=0),MySizeX=8,MYSizeY=16)
	SprocketTextureOffsets(1)=(PositionOffset=(X=86,Y=36,Z=0),MySizeX=8,MYSizeY=16)

	TransmissionTextureOffset=(PositionOffset=(X=51,Y=30,Z=0),MySizeX=38,MYSizeY=36)

	TreadTextureOffsets(0)=(PositionOffset=(X=41,Y=40,Z=0),MySizeX=8,MYSizeY=69)
	TreadTextureOffsets(1)=(PositionOffset=(X=92,Y=40,Z=0),MySizeX=8,MYSizeY=69)

	AmmoStorageTextureOffsets(0)=(PositionOffset=(X=46,Y=75,Z=0),MySizeX=16,MYSizeY=16)
	AmmoStorageTextureOffsets(1)=(PositionOffset=(X=79,Y=75,Z=0),MySizeX=16,MYSizeY=16)

	FuelTankTextureOffsets(0)=(PositionOffset=(X=45,Y=92,Z=0),MySizeX=16,MYSizeY=16)
	FuelTankTextureOffsets(1)=(PositionOffset=(X=80,Y=92,Z=0),MySizeX=16,MYSizeY=16)

	TurretRingTextureOffset=(PositionOffset=(X=51,Y=55,Z=0),MySizeX=38,MYSizeY=38)

	EngineTextureOffset=(PositionOffset=(X=57,Y=85,Z=0),MySizeX=28,MYSizeY=28)

	TurretArmorTextureOffsets(0)=(PositionOffset=(X=-0,Y=-9,Z=0),MySizeX=40,MYSizeY=20)
	TurretArmorTextureOffsets(1)=(PositionOffset=(X=-0,Y=+16,Z=0),MySizeX=38,MYSizeY=19)
	TurretArmorTextureOffsets(2)=(PositionOffset=(X=-10,Y=+2,Z=0),MySizeX=16,MYSizeY=32)
	TurretArmorTextureOffsets(3)=(PositionOffset=(X=+11,Y=+2,Z=0),MySizeX=16,MYSizeY=32)

	MainGunTextureOffset=(PositionOffset=(X=-0,Y=-32,Z=0),MySizeX=14,MYSizeY=37)
	CoaxMGTextureOffset=(PositionOffset=(X=+4,Y=-20,Z=0),MySizeX=6,MYSizeY=14)

	SeatTextureOffsets(0)=(PositionOffSet=(X=-9,Y=-25,Z=0),bTurretPosition=0)//driver
	SeatTextureOffsets(1)=(PositionOffSet=(X=+9,Y=+2,Z=0),bTurretPosition=1)//commander
	SeatTextureOffsets(2)=(PositionOffSet=(X=+9,Y=-5,Z=0),bTurretPosition=1)//gunner
	SeatTextureOffsets(3)=(PositionOffSet=(X=+10,Y=-25,Z=0),bTurretPosition=0)//hull mg
	SeatTextureOffsets(4)=(PositionOffSet=(X=-7,Y=-5,Z=0),bTurretPosition=1)//loader

	SpeedoMinDegree=5461
	SpeedoMaxDegree=60075
	SpeedoMaxSpeed=1365 //100 km/h

	// ScopeLensMaterial=MaterialInstanceConstant'WP_VN_VC_SVD.Materials.VC_SVD_LenseMat'

	// TODO:
	RanOverDamageType=DRDmgType_RunOver_PanzerIV

	TankControllerClass=class'CCSTankControllerPIII'

	materials(0)=Material'VH_VN_ARVN_M113_APC.Materials.M113_APC_LTread'
	materials(1)=Material'VH_VN_ARVN_M113_APC.Materials.M113_APC_RTread'

	// TODO: Remove.
	bInfantryCanUse=True
}
