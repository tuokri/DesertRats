class DRVehicle_Valentine extends DRVehicleTank
    abstract;

var AudioComponent CoaxMGAmbient;
var SoundCue CoaxMGStopSound;

var repnotify TakeHitInfo DeathHitInfo_ProxyDriver;
var repnotify TakeHitInfo DeathHitInfo_ProxyCommander;

replication
{
    if (bNetDirty)
        DeathHitInfo_ProxyDriver, DeathHitInfo_ProxyCommander;
}

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
    else
    {
        super.ReplicatedEvent(VarName);
    }
}

// @fluudah - it would be better to put these functions in the common base
// DRVehicleTank class instead of copypasting them for every single vehicle
// simulated function DisableLeftTrack()
// simulated function DisableRightTrack()

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    if( WorldInfo.NetMode != NM_DedicatedServer )
    {
        Mesh.AttachComponentToSocket(CoaxMGAmbient, 'CoaxMG');
    }
}

simulated event TornOff()
{
    CoaxMGAmbient.Stop();
    super.TornOff();
}

simulated function StopVehicleSounds()
{
    super.StopVehicleSounds();
    CoaxMGAmbient.Stop();
}

simulated function int GetCommanderSeatIndex()
{
    return GetSeatIndexFromPrefix("Turret");
}

simulated function int GetGunnerSeatIndex()
{
    return GetSeatIndexFromPrefix("Turret");
}

simulated function int GetLoaderSeatIndex()
{
    return GetSeatIndexFromPrefix("Turret");
}

simulated function int GetHullMGSeatIndex()
{
    return -1;
}

simulated function VehicleWeaponFireEffects(vector HitLocation, int SeatIndex)
{
    super.VehicleWeaponFireEffects(HitLocation, SeatIndex);

    if (SeatIndex == GetGunnerSeatIndex() && SeatFiringMode(SeatIndex,,true) == 1 && !CoaxMGAmbient.bWasPlaying)
    {
        CoaxMGAmbient.Play();
    }
}

simulated function VehicleWeaponStoppedFiring(bool bViaReplication, int SeatIndex)
{
    super.VehicleWeaponStoppedFiring(bViaReplication, SeatIndex);

    if ( SeatIndex == GetGunnerSeatIndex() )
    {
        if ( CoaxMGAmbient.bWasPlaying || !CoaxMGAmbient.bFinished )
        {
            CoaxMGAmbient.Stop();
            PlaySound(CoaxMGStopSound, TRUE, FALSE, FALSE, CoaxMGAmbient.CurrentLocation, FALSE);
        }
    }
}

function DamageSeatProxy(int SeatProxyIndex, int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional Actor DamageCauser)
{
    switch( SeatProxyIndex )
    {
    case 0:
        DeathHitInfo_ProxyDriver.Damage = Damage;
        DeathHitInfo_ProxyDriver.HitLocation = HitLocation;
        DeathHitInfo_ProxyDriver.Momentum = Momentum;
        DeathHitInfo_ProxyDriver.DamageType = DamageType;
        break;
    case 1:
        DeathHitInfo_ProxyCommander.Damage = Damage;
        DeathHitInfo_ProxyCommander.HitLocation = HitLocation;
        DeathHitInfo_ProxyCommander.Momentum = Momentum;
        DeathHitInfo_ProxyCommander.DamageType = DamageType;
        break;
    }

    Super.DamageSeatProxy(SeatProxyIndex, Damage, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}

DefaultProperties
{
    Team=`ALLIES_TEAM_INDEX

    Health=600
    MaxSpeed=573

    Begin Object Name=CollisionCylinder
        CollisionHeight=60.0
        CollisionRadius=260.0
        Translation=(X=0.0,Y=0.0,Z=0.0)
    End Object
    CylinderComponent=CollisionCylinder

    bDontUseCollCylinderForRelevancyCheck=true
    RelevancyHeight=90.0
    RelevancyRadius=155.0

    Seats(0)={(
        CameraOffset=-420,
        SeatAnimBlendName=DriverPositionNode,
        SeatPositions=(
            (
                bDriverVisible=false,
                bAllowFocus=false,
                PositionCameraTag=Driver_Camera,
                ViewFOV=70,
                bViewFromCameraTag=true,
                // bDrawOverlays=true,
                bDrawOverlays=false,
                PositionUpAnim=MG_Hull_Idle_AI,
                PositionIdleAnim=MG_Hull_Idle_AI,
                DriverIdleAnim=MG_Hull_Idle_AI,
                AlternateIdleAnim=MG_Hull_Idle_AI,
                SeatProxyIndex=0,
                bIsExterior=false,
                PositionFlinchAnims=(MG_Hull_Idle_AI),
                PositionDeathAnims=(MG_Hull_Idle_AI)
            )
        ),
        bSeatVisible=false,
        SeatBone=Root_Driver,
        DriverDamageMult=1.0,
        InitialPositionIndex=0
    )}

    Seats(1)={(
        CameraOffset=-420,
        SeatAnimBlendName=CommanderPositionNode,
        GunClass=class'DRVWeap_CrusaderMkIII_Turret',
        RangeOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_optics_Crusader',
        PeriscopeRangeTexture=none,
        VignetteOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_optics_vignette',
        BinocOverlayTexture=Texture2D'DR_UI.VehicleOptics.ui_hud_vehicle_optics_vignette',
        GunSocket=(Barrel,CoaxMG),
        GunPivotPoints=(gun_base,gun_base),
        TurretVarPrefix="Turret",
        TurretControls=(Turret_Gun,Turret_Main),
        SeatPositions=(
            (
                bDriverVisible=false,
                bAllowFocus=false,
                bIgnoreWeapon=true,
                bRotateGunOnCommand=true,
                PositionCameraTag=Camera_Gunner_Alt,
                bViewFromCameraTag=true,
                ViewFOV=70,
                bCamRotationFollowSocket=true,
                // bDrawOverlays=true,
                bDrawOverlays=false,
                PositionUpAnim=MG_Hull_Idle_AI,
                PositionDownAnim=MG_Hull_Idle_AI,
                PositionIdleAnim=MG_Hull_Idle_AI,
                DriverIdleAnim=MG_Hull_Idle_AI,
                AlternateIdleAnim=MG_Hull_Idle_AI,
                SeatProxyIndex=1,
                bIsExterior=false,
                PositionFlinchAnims=(MG_Hull_Idle_AI),
                PositionDeathAnims=(MG_Hull_Idle_AI)
            ),
            (
                bDriverVisible=false,
                bAllowFocus=false,
                PositionCameraTag=Camera_Gunner,
                bViewFromCameraTag=true,
                ViewFOV=20,
                bCamRotationFollowSocket=true,
                // bDrawOverlays=true,
                bDrawOverlays=false,
                PositionUpAnim=MG_Hull_Idle_AI,
                PositionDownAnim=MG_Hull_Idle_AI,
                PositionIdleAnim=MG_Hull_Idle_AI,
                DriverIdleAnim=MG_Hull_Idle_AI,
                AlternateIdleAnim=MG_Hull_Idle_AI,
                SeatProxyIndex=1,
                bIsExterior=false,
                PositionFlinchAnims=(MG_Hull_Idle_AI),
                PositionDeathAnims=(MG_Hull_Idle_AI)
            )
        ),
        bSeatVisible=false,
        SeatBone=Turret,
        DriverDamageMult=1.0,
        InitialPositionIndex=1,
        FiringPositionIndex=1,
        TracerFrequency=5,
        WeaponTracerClass=(none,class'M1919BulletTracer'),
        MuzzleFlashLightClass=(none,none),
    )}

    CrewAnimSet=AnimSet'VH_VN_ARVN_M113_APC.Anim.CHR_M113_Anim_Master'

    LeftWheels.Empty
    LeftWheels(0)="L_Wheel_Static_01"
    LeftWheels(1)="L_Wheel_02"
    LeftWheels(2)="L_Wheel_03A"
    LeftWheels(3)="L_Wheel_03B"
    LeftWheels(4)="L_Wheel_04A"
    LeftWheels(5)="L_Wheel_04B"
    LeftWheels(6)="L_Wheel_05"
    LeftWheels(7)="L_Wheel_Static_02"

    RightWheels.Empty
    RightWheels(0)="R_Wheel_Static_01"
    RightWheels(1)="R_Wheel_02"
    RightWheels(2)="R_Wheel_03A"
    RightWheels(3)="R_Wheel_03B"
    RightWheels(4)="R_Wheel_04A"
    RightWheels(5)="R_Wheel_04B"
    RightWheels(6)="R_Wheel_05"
    RightWheels(7)="R_Wheel_Static_02"

    Begin Object Name=LFWheel
        BoneName="L_Wheel_02"
        BoneOffset=(X=0,Y=0,Z=-20)
        WheelRadius=44
        SuspensionTravel=17.5
    End Object

    Begin Object Name=LRWheel
        BoneName="L_Wheel_05"
        BoneOffset=(X=0,Y=0,Z=-20)
        WheelRadius=44
        SuspensionTravel=17.5
    End Object

    Begin Object Name=RFWheel
        BoneName="R_Wheel_02"
        BoneOffset=(X=0,Y=0,Z=-20)
        WheelRadius=44
        SuspensionTravel=17.5
    End Object

    Begin Object Name=RRWheel
        BoneName="R_Wheel_05"
        BoneOffset=(X=0,Y=0,Z=-20)
        WheelRadius=44
        SuspensionTravel=17.5
    End Object

    Wheels.Empty
    Wheels(0)=LFWheel
    Wheels(1)=LRWheel
    Wheels(2)=RFWheel
    Wheels(3)=RRWheel

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
        FirstForwardGear=2
    End Object

    TreadSpeedScale=1.5

    // Commented out because package DR_VH_FX is either missing or not updated
    // VehicleEffects(TankVFX_Firing1)=(EffectStartTag=PanzerIVGCannon,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_B_TankMuzzle',EffectSocket=Barrel,bRestartRunning=true)
    // VehicleEffects(TankVFX_Firing2)=(EffectStartTag=PanzerIVGCannon,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_B_TankCannon_Dust',EffectSocket=attachments_body_ground,bRestartRunning=true)
    VehicleEffects(TankVFX_Firing4)=(EffectStartTag=PanzerIVGCoaxMG,EffectTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_split',EffectSocket=CoaxMG)

    // VehicleEffects(TankVFX_Exhaust)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_A_TankExhaust',EffectSocket=Exhaust)
    // VehicleEffects(TankVFX_TreadWing)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bStayActive=true,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_A_Wing_Dirt_PZ4',EffectSocket=attachments_body_ground)

    // VehicleEffects(TankVFX_DmgSmoke)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_A_Damage',EffectSocket=attachments_engine)

    // VehicleEffects(TankVFX_DeathSmoke1)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_1)
    // VehicleEffects(TankVFX_DeathSmoke2)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_2)
    // VehicleEffects(TankVFX_DeathSmoke3)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke_3)

    TrackSoundParamScale=0.00004

    SquealThreshold=250.0
    EngineStartOffsetSecs=2.0
    EngineStopOffsetSecs=0.0//1.0

    BigExplosionSocket=FX_Fire
    // ExplosionTemplate=ParticleSystem'DR_VH_FX.FX_VEH_Tank_C_Explosion'

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
    // SecondaryExplosion=ParticleSystem'DR_VH_FX.FX_VEH_Tank_C_Explosion_Ammo'
    bHasTurretExplosion=true
    TurretExplosiveForce=15000

    TreadSpeedParameterName=Tank_Tread_Speed

    DrivingPhysicalMaterial=PhysicalMaterial'DR_VH_DAK_PanzerIV_F.Phys.PhysMat_PanzerIVG'
    DefaultPhysicalMaterial=PhysicalMaterial'DR_VH_DAK_PanzerIV_F.Phys.PhysMat_PanzerIVG_Moving'

    bDebugPenetration=false

    EngineIdleRPM=500
    EngineNormalRPM=1800
    EngineMaxRPM=2500

    SeatTextureOffsets(0)=(PositionOffSet=(X=+10,Y=-10,Z=0),bTurretPosition=0)
    SeatTextureOffsets(1)=(PositionOffSet=(X=-7,Y=+2,Z=0),bTurretPosition=1)

    SpeedoMinDegree=5461
    SpeedoMaxDegree=60075
    SpeedoMaxSpeed=1365

    RanOverDamageType=DRDmgType_RunOver_PanzerIV

    bInfantryCanUse=true
}
