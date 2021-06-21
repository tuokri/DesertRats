class DRVehicleTank extends ROVehicleTank
    abstract;

//? `include(DesertRats\Classes\DRVehicle_Common.uci)

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

/*
simulated function WeaponRotationChanged(int SeatIndex)
{
    super.WeaponRotationChanged(SeatIndex);
    `log("WeaponRotationChanged(): SeatIndex=" $ SeatIndex,, 'DRDEV');
}
*/

function PossessedBy(Controller C, bool bVehicleTransition)
{
    super.PossessedBy(C, bVehicleTransition);

    // `log("DRVehicleTank.PossessedBy()",, 'DRDEV');

    // Reset camera.
    if (ROPlayerController(C) != None)
    {
        ROPlayerController(C).SetRotation(rot(0, 0, 0));
    }
}

/*
simulated function OnTurretTraverseStatusChange(bool bTurretMoving, bool bHighSpeed)
{
    `log(self $ ": OnTurretTraverseStatusChange: bTurretMoving=" $ bTurretMoving
        $ " bHighSpeed=" $ bHighSpeed);

    if ( TurretTraverseSound != None )
    {
        if ( bTurretMoving && !bHighSpeed )
        {
            TurretTraverseSound.FadeIn(0.1, 1.0);
        }
        else if ( TurretTraverseSound.IsPlaying() )
        {
            if ( TurretTraverseSound.FadeOutStartTime == 0.0 )
            {
                TurretTraverseSound.FadeOut(0.2, 0.0);
            }
        }
    }

    if (TurretMotorTraverseSound != None)
    {
        if ( bTurretMoving && bHighSpeed )
        {
            TurretMotorTraverseSound.FadeIn(0.1, 1.0);
        }
        else if ( TurretMotorTraverseSound.IsPlaying() )
        {
            if ( TurretMotorTraverseSound.FadeOutStartTime == 0.0 )
            {
                TurretMotorTraverseSound.FadeOut(0.2, 0.0);
            }
        }
    }
}
*/

/*
simulated function OnTurretElevationStatusChange(bool bTurretMoving, bool bHighSpeed)
{
    `log(self $ ": OnTurretElevationStatusChange: bTurretMoving=" $ bTurretMoving
        $ " bHighSpeed=" $ bHighSpeed);

    if ( TurretElevationSound != None )
    {
        if ( bTurretMoving )
        {
            TurretElevationSound.FadeIn(0.1, 1.0);
        }
        else if ( TurretElevationSound.IsPlaying() )
        {
            if ( TurretElevationSound.FadeOutStartTime == 0.0 )
            {
                TurretElevationSound.FadeOut(0.2, 0.0);
            }
        }
    }
}
*/

/*
simulated event Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    `log("Seats[GetGunnerSeatIndex()].TurretControllers[0].DesiredBoneRotation="
        $ Seats[GetGunnerSeatIndex()].TurretControllers[0].DesiredBoneRotation,,'DRDEV');
    `log("Seats[GetGunnerSeatIndex()].TurretControllers[1].DesiredBoneRotation="
        $ Seats[GetGunnerSeatIndex()].TurretControllers[1].DesiredBoneRotation,,'DRDEV');

    `log("Seats[GetGunnerSeatIndex()].TurretControllers[0].DeltaRotation="
        $ Seats[GetGunnerSeatIndex()].TurretControllers[0].DeltaRotation,,'DRDEV');
    `log("Seats[GetGunnerSeatIndex()].TurretControllers[1].DeltaRotation="
        $ Seats[GetGunnerSeatIndex()].TurretControllers[1].DeltaRotation,,'DRDEV');
}
*/
