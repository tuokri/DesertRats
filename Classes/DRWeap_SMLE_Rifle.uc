class DRWeap_SMLE_Rifle extends ROProjectileWeapon
    abstract;

var(Animations) name ReloadStripperDoubleAnim;
var(Animations) name RestReloadStripperDoubleAnim;

// @TEMP - triple spread for most handheld weapons?
simulated function float GetSpreadMod()
{
    return 3 * super.GetSpreadMod();
}

/*
simulated function SetupArmsAnim()
{
    super.SetupArmsAnim();

    // ArmsMesh.AnimSets has slots 0-2-3 filled, so we need to back fill slot 1 and then move to slot 4.
    ROPawn(Instigator).ArmsMesh.AnimSets[1] = SkeletalMeshComponent(Mesh).AnimSets[0];
    ROPawn(Instigator).ArmsMesh.AnimSets[4] = SkeletalMeshComponent(Mesh).AnimSets[1];
}
*/

simulated function bool ShouldLoadStripperClip()
{
    if((AmmoCount == 0) && NumFullStripperClips == 1)
    {
        return false;
    }

    return super(ROWeapon).ShouldLoadStripperClip();
}

simulated function bool ShouldLoadTwoStripperClips()
{
    if(NumFullStripperClips >= 2)
    {
        if(ShouldLoseRoundOnReload())
        {
            if(((MaxAmmoCount - AmmoCount) + 1) >= (2 * StripperClipBulletCount))
            {
                return true;
            }
        }
        else
        {
            if((MaxAmmoCount - AmmoCount) >= (2 * StripperClipBulletCount))
            {
                return true;
            }
        }
    }
    return false;
}

simulated function name GetReloadStripperX2AnimName()
{
    if(ROPawn(Instigator).IsInCover())
    {
        return RestReloadStripperDoubleAnim;
    }
    else
    {
        return ReloadStripperDoubleAnim;
    }
}

simulated function SightIndexUpdated()
{
    if(SightRotController != none)
    {
        SightRotController.BoneRotation.Pitch = SightRanges[SightRangeIndex].SightPitch;
    }

    if(SightSlideController != none)
    {
        SightSlideController.BoneTranslation.X = SightRanges[SightRangeIndex].SightSlideOffset;
    }

    IronSightPosition.Z = SightRanges[SightRangeIndex].SightPositionOffset;
    PlayerViewOffset.Z = SightRanges[SightRangeIndex].SightPositionOffset;
}

function bool GiveInitialAmmo(optional bool bResupplyOnly)
{
    local int InitialAmount;
    local bool bGivenAmmo;

    bGivenAmmo = super(ROWeapon).GiveInitialAmmo(bResupplyOnly);

    if((AmmoClass != none) && !bResupplyOnly)
    {
        InitialAmount = AmmoClass.default.InitialAmount;

        if((AddAmmo(InitialAmount)) > 0)
        {
            bGivenAmmo = true;
        }
    }
    return bGivenAmmo;
}

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_SMLE_Rifle_Content"

    RoleSelectionImage(0)=Texture2D'DR_UI.WP_Render.WP_Render_SMLE'

    WeaponClassType=ROWCT_Rifle
    TeamIndex=`ALLIES_TEAM_INDEX

    Category=ROIC_Primary
    Weight=4.0 // kg
    InvIndex=`DRII_SMLE_RIFLE
    InventoryWeight=0

    bDebugWeapon=false

    PlayerIronSightFOV=40.0
    PreFireTraceLength=2500

    FiringStatesArray(0)=WeaponSingleFiring
    WeaponFireTypes(0)=EWFT_Custom
    WeaponProjectiles(0)=class'MN9130Bullet'
    FireInterval(0)=1.1//+1.5
    DelayedRecoilTime(0)=0.01
    Spread(0)=0.00012

    AltFireModeType=ROAFT_Bayonet
    FiringStatesArray(ALTERNATE_FIREMODE)=WeaponManualSingleFiring
    WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'MN9130Bullet'
    FireInterval(ALTERNATE_FIREMODE)=1.1//+1.5
    DelayedRecoilTime(ALTERNATE_FIREMODE)=0.01
    Spread(ALTERNATE_FIREMODE)=0.00012

    MinBurstAmount=1
    MaxBurstAmount=1
    BurstWaitTime=0.5
    AILongDistanceScale=1.25f
    AIMediumDistanceScale=0.5f
    AISpreadScale=200.0
    AISpreadNoSeeScale=2.0
    AISpreadNMEStillScale=0.5
    AISpreadNMESprintScale=1.5

    maxRecoilPitch=850
    minRecoilPitch=725
    maxRecoilYaw=300
    minRecoilYaw=215
    RecoilRate=0.1
    RecoilMaxYawLimit=500
    RecoilMinYawLimit=65035
    RecoilMaxPitchLimit=2000
    RecoilMinPitchLimit=63535
    RecoilISMaxYawLimit=500
    RecoilISMinYawLimit=65035
    RecoilISMaxPitchLimit=1500
    RecoilISMinPitchLimit=64035
    InstantHitDamage(0)=115
    InstantHitDamage(1)=115

    InstantHitDamageTypes(0)=class'RODmgType_MN9130Bullet'
    InstantHitDamageTypes(1)=class'RODmgType_MN9130Bullet'

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_Rifles_round'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_VC_MN9130'

    bHasIronSights=true
    bHasManualBolting=true

    //Equip and putdown
    WeaponPutDownAnim=SMLE_SelectDown
    WeaponEquipAnim=SMLE_SelectUp
    WeaponDownAnim=SMLE_SelectDown
    WeaponUpAnim=SMLE_SelectUp

    // Fire Anims
    //Hip fire
    WeaponFireAnim(0)=SMLE_FireBolt
    WeaponFireAnim(1)=SMLE_FireBolt
    WeaponFireLastAnim=SMLE_Fire
    //Shouldered fire
    WeaponFireShoulderedAnim(0)=SMLE_FireBolt
    WeaponFireShoulderedAnim(1)=SMLE_FireBolt
    WeaponFireLastShoulderedAnim=SMLE_Fire
    //Fire using iron sights
    WeaponFireSightedAnim(0)=SMLE_FireBolt
    WeaponFireSightedAnim(1)=SMLE_FireBolt
    WeaponFireLastSightedAnim=SMLE_Fire
    //Manual bolting
    WeaponManualBoltAnim=SMLE_Bolting
    WeaponManualBoltRestAnim=SMLE_Bolting

    // Idle Anims
    // Hip Idle
    WeaponIdleAnims(0)=SMLE_Idle
    WeaponIdleAnims(1)=SMLE_Idle
    // Shouldered idle
    WeaponIdleShoulderedAnims(0)=SMLE_Idle
    WeaponIdleShoulderedAnims(1)=SMLE_Idle
    // Sighted Idle
    WeaponIdleSightedAnims(0)=SMLE_Idle
    WeaponIdleSightedAnims(1)=SMLE_Idle

    // Prone Crawl
    WeaponCrawlingAnims(0)=SMLE_ProneLoop
    WeaponCrawlStartAnim=SMLE_ProneIn
    WeaponCrawlEndAnim=SMLE_ProneOut

    //Reloading
    WeaponReloadStripperAnim=SMLE_ReloadClip
    WeaponReloadSingleBulletAnim=SMLE_ReloadSingle
    WeaponReloadEmptySingleBulletAnim=SMLE_ReloadSingle
    WeaponOpenBoltAnim=SMLE_Rsingle_Boltopen
    WeaponOpenBoltEmptyAnim=SMLE_ReloadSingle
    WeaponCloseBoltAnim=SMLE_ReloadClose

    WeaponRestReloadStripperAnim=SMLE_ReloadClip
    WeaponRestReloadSingleBulletAnim=SMLE_ReloadSingle
    WeaponRestReloadEmptySingleBulletAnim=SMLE_ReloadSingle
    WeaponRestOpenBoltAnim=SMLE_Rsingle_Boltopen
    WeaponRestOpenBoltEmptyAnim=SMLE_ReloadSingle
    WeaponRestCloseBoltAnim=SMLE_ReloadClose

    // Ammo check
    WeaponAmmoCheckAnim=SMLE_BoltCheck
    WeaponRestAmmoCheckAnim=SMLE_BoltCheck

    // Sprinting
    WeaponSprintStartAnim=SMLE_RunIn
    WeaponSprintLoopAnim=SMLE_Run2Loop
    WeaponSprintEndAnim=SMLE_RunEnd
    Weapon1HSprintStartAnim=SMLE_RunIn
    Weapon1HSprintLoopAnim=SMLE_Run1Loop
    Weapon1HSprintEndAnim=SMLE_RunEnd

    // Mantling
    WeaponMantleOverAnim=SMLE_Vault

    // Melee anims
    WeaponMeleeAnims(0)=SMLE_Bash
    WeaponMeleeHardAnim=SMLE_ChargeBash
    MeleePullbackAnim=SMLE_ChargeIn
    MeleeHoldAnim=SMLE_Idle // TODO: REPLACE ME

    WeaponSpotEnemyAnim=SMLE_Spot
    WeaponSpotEnemySightedAnim=SMLE_SpotAim

    // TODO: Tweak attack range?
    BayonetSkelControlName=Bayonet_SMLE
    bHasBayonet=true
    BayonetAttackRange=73.0
    WeaponBayonetLength=9.8

    WeaponBayonetSpreadScale=0.98

    EquipTime=+0.75
    PutDownTime=+0.50
    BoltControllerNames[0]=Hammer
    ISFocusDepth=30
    ISFocusBlendRadius=12

    AmmoClass=class'ROAmmo_762x54R_MNStripper'
    MaxAmmoCount=10
    bUsesMagazines=false
    InitialNumPrimaryMags=12
    bLosesRoundOnReload=true
    bPlusOneLoading=false
    bCanReloadNonEmptyMag=true
    bCanLoadStripperClip=true
    bCanLoadSingleBullet=true
    StripperClipBulletCount=5

    PenetrationDepth=23.4
    MaxPenetrationTests=3
    MaxNumPenetrations=2
    PerformReloadPct=0.60f

    PlayerViewOffset=(X=2.0,Y=8.0,Z=-5)
    ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
    ShoulderedTime=0.35
    ShoulderedPosition=(X=2.50,Y=4.0,Z=-2.0)
    ShoulderRotation=(Pitch=-500,Yaw=0,Roll=2500)
    IronSightPosition=(X=2.0,Y=0,Z=-0.03)

    bUsesFreeAim=true
    FreeAimMaxYawLimit=2000
    FreeAimMinYawLimit=63535
    FreeAimMaxPitchLimit=1500
    FreeAimMinPitchLimit=64035
    FreeAimISMaxYawLimit=500
    FreeAimISMinYawLimit=65035
    FreeAimISMaxPitchLimit=350
    FreeAimISMinPitchLimit=65185
    FullFreeAimISMaxYaw=250
    FullFreeAimISMinYaw=65285
    FullFreeAimISMaxPitch=175
    FullFreeAimISMinPitch=65360
    FreeAimSpeedScale=0.35
    FreeAimISSpeedScale=0.4
    FreeAimHipfireOffsetX=45

    Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
        Samples(0)=(LeftAmplitude=30,RightAmplitude=50,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.200)
    End Object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1

    CollisionCheckLength=45.5

    FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MN9130_Shoot'
    FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MN9130_Shoot'

    SightSlideControlName=Sight_Translation
    SightRotControlName=Sight_Rotation

    // TODO: proper sight ranges.
    SightRanges[0]=(SightRange=100,SightPitch=0,SightSlideOffset=0.0,SightPositionOffset=0)
    SightRanges[1]=(SightRange=200,SightPitch=0,SightSlideOffset=0.0,SightPositionOffset=-0.047)
    SightRanges[2]=(SightRange=300,SightPitch=0,SightSlideOffset=0.0,SightPositionOffset=-0.088)
    SightRanges[3]=(SightRange=400,SightPitch=16383,SightSlideOffset=0.0,SightPositionOffset=-0.131)

    SuppressionPower=20

    WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M40.Play_WEP_M40_Fire_Single_3P',FirstPersonCue=AkEvent'WW_WEP_M40.Play_WEP_M40_Fire_Single')
    WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M40.Play_WEP_M40_Fire_Single_3P',FirstPersonCue=AkEvent'WW_WEP_M40.Play_WEP_M40_Fire_Single')
}
