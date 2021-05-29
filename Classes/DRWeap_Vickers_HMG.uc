class DRWeap_Vickers_HMG extends ROFixedMGWeapon;

// `include(ROGameIndices.uci)

var name Bullets[18];

simulated function bool OverrideAllowFocusZoom()
{
    return true;
}

simulated function FireAmmunition()
{
    Super.FireAmmunition();

    // Hide a bullet from the ammo clip every time we fire a round
    if ( WorldInfo.NetMode != NM_DedicatedServer && AmmoBeltMesh != None && AmmoCount < ArrayCount(Bullets) )
    {
        AmmoBeltMesh.HideBoneByName(Bullets[AmmoCount], PBO_None);
    }
}

exec simulated function AmmoBeltShowAllOnNotify()
{
    Super.AmmoBeltShowAllOnNotify();
    UnHideBulletsNotify();
}

/**
 * Unhide entire ammo clip
 */
simulated function UnHideBulletsNotify()
{
    local int i;

    if( WorldInfo.NetMode != NM_DedicatedServer )
    {
        for( i=0; i<ArrayCount(Bullets); i++ )
        {
            AmmoBeltMesh.UnHideBoneByName(Bullets[i]);
        }
    }
}

DefaultProperties
{
    InvIndex=`DRII_VICKERS_HMG

    ArmsSocketName=Player_HandHub
    MountWeaponAnimName=Maxim_GetOn

    AmmoBeltSocket=AmmoBeltSocket

    Category=ROIC_Primary
    Weight=9.2 //KG

    PlayerIronSightFOV=55.0

    Bullets[0]=BONE_BELT_01
    Bullets[1]=BONE_BELT_02
    Bullets[2]=BONE_BELT_03
    Bullets[3]=BONE_BELT_04
    Bullets[4]=BONE_BELT_05
    Bullets[5]=BONE_BELT_06
    Bullets[6]=BONE_BELT_07
    Bullets[7]=BONE_BELT_08
    Bullets[8]=BONE_BELT_09
    Bullets[9]=BONE_BELT_10
    Bullets[10]=BONE_BELT_11
    Bullets[11]=BONE_BELT_12
    Bullets[12]=BONE_BELT_13
    Bullets[13]=BONE_BELT_14
    Bullets[14]=BONE_BELT_15
    Bullets[15]=BONE_BELT_16
    Bullets[16]=BONE_BELT_17
    Bullets[17]=BONE_BELT_18

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponFiring
    WeaponFireTypes(0)=EWFT_Custom
    WeaponProjectiles(0)=class'DRBullet_Vickers_Turret'
    FireInterval(0)=+0.1    // 600 RPM
    Spread(0)=0.0002//0.0003

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
    WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRBullet_Vickers_Turret'
    FireInterval(ALTERNATE_FIREMODE)=+0.1   // 600 RPM
    Spread(ALTERNATE_FIREMODE)=0.0002//0.0018

    PreFireTraceLength=2500 //50 Meters
    FireTweenTime=0.025

    ShoulderedSpreadMod=6.0
    HippedSpreadMod=10.0

    // AI
    MinBurstAmount=3
    MaxBurstAmount=6
    BurstWaitTime=1.0

    // Recoil
    maxRecoilPitch=130
    minRecoilPitch=85
    maxRecoilYaw=50
    minRecoilYaw=-40
    RecoilRate=0.07
    RecoilMaxYawLimit=1500
    RecoilMinYawLimit=64035
    RecoilMaxPitchLimit=1500
    RecoilMinPitchLimit=64785
    RecoilISMaxYawLimit=500
    RecoilISMinYawLimit=65035
    RecoilISMaxPitchLimit=350
    RecoilISMinPitchLimit=65035
    RecoilBlendOutRatio=0.75
    PostureHippedRecoilModifer=5.5
    PostureShoulderRecoilModifer=2.0
    RecoilViewRotationScale=0.45

    InstantHitDamage(0)=115
    InstantHitDamage(1)=115

    InstantHitDamageTypes(0)=class'DRDmgType_VickersBullet'
    InstantHitDamageTypes(1)=class'DRDmgType_VickersBullet'

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_DShK'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'RP_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Sov_Maxim'

    // needed to show muzzle flashes
    bShowFireFXWhenHidden=true

    // WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_RO2_WEP_MAXIM_RO2.Play_MG_1910_Fire_Single_M_Cue', FirstPersonCue=AkEvent'WW_RO2_WEP_MAXIM_RO2.Play_MG_1910_Fire_Single_Sur')
    // WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_RO2_WEP_MAXIM_RO2.Play_MG_1910_Fire_Single_M_Cue', FirstPersonCue=AkEvent'WW_RO2_WEP_MAXIM_RO2.Play_MG_1910_Fire_Single_Sur')

    WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1919_A6.Play_WEP_M1919A6_Loop_3P', FirstPersonCue=AkEvent'WW_WEP_M1919_A6.Play_WEP_M1919A6_Auto_LP')
    WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1918.Play_WEP_M1918_Single_3P', FirstPersonCue=AkEvent'WW_WEP_M1918.Play_WEP_M1918_Fire_Single')

    bLoopingFireSnd(DEFAULT_FIREMODE)=true
    WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1919_A6.Play_WEP_M1919A6_Tail_3P', FirstPersonCue=AkEvent'WW_WEP_M1919_A6.Play_WEP_M1919A6_Auto_Tail')
    bLoopHighROFSounds(DEFAULT_FIREMODE)=true

    bHasIronSights=true

    WeaponFireAnim(0)=Maxim_Shoot
    WeaponFireAnim(1)=Maxim_Shoot
//  WeaponFireLastAnim=Maxim_shootLAST
    WeaponIdleAnims(0)=Maxim_Idle
    WeaponIdleAnims(1)=Maxim_Idle
    WeaponFireSightedAnim(0)=Maxim_Shoot
    WeaponFireSightedAnim(1)=Maxim_Shoot
//  WeaponFireLastSightedAnim=Maxim_iron_shootLAST
    WeaponIdleSightedAnims(0)=Maxim_Idle
    WeaponIdleSightedAnims(1)=Maxim_Idle
    WeaponReloadEmptyMagAnim=Maxim_Reloadempty
    WeaponReloadNonEmptyMagAnim=Maxim_Reloadempty
    WeaponAmmoCheckAnim=Maxim_Reloadempty
//  WeaponSprintStartAnim=Maxim_sprint_into
//  WeaponSprintLoopAnim=Maxim_Sprint
//  WeaponSprintEndAnim=Maxim_sprint_out

//  WeaponPutDownAnim=Maxim_putaway
//  WeaponEquipAnim=Maxim_pullout

    WeaponIdleShoulderedAnims(0)=Maxim_Idle
    WeaponIdleShoulderedAnims(1)=Maxim_Idle
    WeaponFireShoulderedAnim(0)=Maxim_Shoot
    WeaponFireShoulderedAnim(1)=Maxim_Shoot
//  WeaponFireLastShoulderedAnim=Maxim_shootLAST

    EquipTime=+1.00
    PutDownTime=+0.75

    ISFocusDepth=30
    ISFocusBlendRadius=16

    // Ammo
    AmmoClass=class'DRAmmo_77x56R_VickersBelt'
    MaxAmmoCount=250
    bUsesMagazines=true
    InitialNumPrimaryMags=4
    bPlusOneLoading=false
    bCanReloadNonEmptyMag=false
    PenetrationDepth=22.35
    MaxPenetrationTests=3
    MaxNumPenetrations=2
    // Tracers
    TracerClass=class'DRBullet_Vickers_TurretTracer'
    TracerFrequency=5

    PlayerViewOffset=(X=0.0,Y=8.0,Z=-5)
    ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
    ShoulderedTime=0.35
    ShoulderedPosition=(X=0.5,Y=4.0,Z=-2.0)// (X=0,Y=1,Z=-1.4)
    ShoulderRotation=(Pitch=-500,Yaw=0,Roll=2500)

    bUsesFreeAim=true

    // Free Aim variables
    FreeAimMaxYawLimit=2000
    FreeAimMinYawLimit=63535
    FreeAimMaxPitchLimit=1500
    FreeAimMinPitchLimit=64035
    FreeAimISMaxYawLimit=500
    FreeAimISMinYawLimit=65035
    FreeAimISMaxPitchLimit=350
    FreeAimISMinPitchLimit=65185
    FullFreeAimISMaxYaw=350
    FullFreeAimISMinYaw=65185
    FullFreeAimISMaxPitch=250
    FullFreeAimISMinPitch=65285
    FreeAimSpeedScale=0.35
    FreeAimISSpeedScale=0.4
    FreeAimHipfireOffsetX=40

    Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
        Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
    End Object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1

    CollisionCheckLength=50.0 //TODO:Put the real value here?

    FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    ShakeScaleControlled=0.65

    SightSlideControlName=Sight_Slide

    SightRanges[0]=(SightRange=200,SightSlideOffset=0.0,SightPositionOffset=0.0,AddedPitch=175)
    SightRanges[1]=(SightRange=300,SightSlideOffset=0.09,SightPositionOffset=-0.022,AddedPitch=165)
    SightRanges[2]=(SightRange=400,SightSlideOffset=0.20,SightPositionOffset=-0.061,AddedPitch=155)
    SightRanges[3]=(SightRange=500,SightSlideOffset=0.31,SightPositionOffset=-0.102,AddedPitch=145)
    SightRanges[4]=(SightRange=600,SightSlideOffset=0.43,SightPositionOffset=-0.139,AddedPitch=135)
    SightRanges[5]=(SightRange=700,SightSlideOffset=0.55,SightPositionOffset=-0.179,AddedPitch=125)
    SightRanges[6]=(SightRange=800,SightSlideOffset=0.69,SightPositionOffset=-0.231,AddedPitch=120)
    SightRanges[7]=(SightRange=900,SightSlideOffset=0.85,SightPositionOffset=-0.289,AddedPitch=110)
    SightRanges[8]=(SightRange=1000,SightSlideOffset=1.01,SightPositionOffset=-0.348,AddedPitch=110)
    // All ranges below here have not been dialed in, and are just estimates
    SightRanges[9]=(SightRange=1100,SightSlideOffset=1.19,SightPositionOffset=-0.402,AddedPitch=110)
    SightRanges[10]=(SightRange=1200,SightSlideOffset=1.38,SightPositionOffset=-0.471,AddedPitch=115)
    SightRanges[11]=(SightRange=1400,SightSlideOffset=1.60,SightPositionOffset=-0.542,AddedPitch=120)
    SightRanges[12]=(SightRange=1500,SightSlideOffset=1.89,SightPositionOffset=-0.648,AddedPitch=125)
    SightRanges[13]=(SightRange=1600,SightSlideOffset=2.19,SightPositionOffset=-0.752,AddedPitch=135)
    SightRanges[14]=(SightRange=1700,SightSlideOffset=2.72,SightPositionOffset=-0.915,AddedPitch=145)
    SightRanges[15]=(SightRange=1800,SightSlideOffset=3.20,SightPositionOffset=-1.090,AddedPitch=155)
    SightRanges[16]=(SightRange=1900,SightSlideOffset=3.70,SightPositionOffset=-1.260,AddedPitch=165)
    SightRanges[17]=(SightRange=2000,SightSlideOffset=4.18,SightPositionOffset=-1.425,AddedPitch=175)

    SuppressionPower=15
}
