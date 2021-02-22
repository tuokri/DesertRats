class DRWeap_MG34_Tripod extends ROFixedMGWeapon;

`include(ROGameIndices.uci)

var name Bullets[16];

// Set semi auto if desired (and possible)
reliable client function CheckFireModePreference()
{
    // disallow
}

simulated function bool OverrideAllowFocusZoom()
{
    return true;
}

exec simulated function AmmoBeltShowAllOnNotify()
{
    Super.AmmoBeltShowAllOnNotify();
    UnHideBulletsNotify();
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

simulated function HideBullets()
{   local int i;

    if( WorldInfo.NetMode != NM_DedicatedServer && AmmoBeltMesh != none )
    {
        for( i = AmmoCount; i < ArrayCount(Bullets); i++ )
        {
            AmmoBeltMesh.HideBoneByName(Bullets[i], PBO_None);
        }
    }

}

DefaultProperties
{
    InvIndex=`DRII_MG34_TRIPOD

    ArmsSocketName=Player_HandHub
    MountWeaponAnimName=MG34_Tripod_GetOn

    AmmoBeltSocket=AmmoBeltSocket

    Category=ROIC_Primary
    Weight=3.97 //KG

    PlayerIronSightFOV=55.0

    Bullets[0]=BONE_BELT1
    Bullets[1]=BONE_BELT02
    Bullets[2]=BONE_BELT03
    Bullets[3]=BONE_BELT04
    Bullets[4]=BONE_BELT05
    Bullets[5]=BONE_BELT06
    Bullets[6]=BONE_BELT07
    Bullets[7]=BONE_BELT08
    Bullets[8]=BONE_BELT09
    Bullets[9]=BONE_BELT10
    Bullets[10]=BONE_BELT11
    Bullets[11]=BONE_BELT12
    Bullets[12]=BONE_BELT13
    Bullets[13]=BONE_BELT14
    Bullets[14]=BONE_BELT15
    Bullets[15]=BONE_BELT16


    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponFiring
    WeaponFireTypes(0)=EWFT_Custom
    WeaponProjectiles(0)=class'MG34_TurretBullet'

    FireInterval(0)=+0.075
    Spread(0)=0.000175//0.0003

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
    WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'MG34Bullet'
    FireInterval(ALTERNATE_FIREMODE)=+0.075
    Spread(ALTERNATE_FIREMODE)=0.000175//0.0014

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

    InstantHitDamageTypes(0)=class'ROPDmgType_MG34_TripodBullet'
    InstantHitDamageTypes(1)=class'ROPDmgType_MG34_TripodBullet'

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_WEP_Gun_Two.MuzzleFlashes.FX_WEP_Gun_A_MuzzleFlash_1stP_MG'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'RP_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_MG34'

    // needed to show muzzle flashes
    bShowFireFXWhenHidden=true

    WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_RO2_WEP_MG34_RO2.Play_MG_MG34_Fire_LP_M', FirstPersonCue=AkEvent'WW_RO2_WEP_MG34_RO2.Play_MG_MG34_Fire_Loop_Sur')
    WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_RO2_WEP_MG34_RO2.Play_MG_MG34_Fire_Single_M', FirstPersonCue=AkEvent'WW_RO2_WEP_MG34_RO2.Play_MG_MG34_Fire_Single_Sur')

    // Advanced (High RPM) Fire Effects
    bLoopingFireSnd(DEFAULT_FIREMODE)=true
    WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_RO2_WEP_MG34_RO2.Stop_MG_MG34_Fire_LP_M', FirstPersonCue=AkEvent'WW_RO2_WEP_MG34_RO2.Stop_MG_MG34_Fire_Loop_Sur')
    bLoopHighROFSounds(DEFAULT_FIREMODE)=true


    bHasIronSights=true

    WeaponFireAnim(0)=MG34_Tripod_Shoot
    WeaponFireAnim(1)=MG34_Tripod_Shoot
//  WeaponFireLastAnim=MG34Tripod_shootLAST
    WeaponIdleAnims(0)=MG34_Tripod_Idle
    WeaponIdleAnims(1)=MG34_Tripod_Idle
    WeaponFireSightedAnim(0)=MG34_Tripod_Shoot
    WeaponFireSightedAnim(1)=MG34_Tripod_Shoot
//  WeaponFireLastSightedAnim=MG34Tripod_iron_shootLAST
    WeaponIdleSightedAnims(0)=MG34_Tripod_Idle
    WeaponIdleSightedAnims(1)=MG34_Tripod_Idle
    WeaponReloadEmptyMagAnim=MG34_Tripod_Reloadempty
    WeaponReloadNonEmptyMagAnim=MG34_Tripod_Reloadhalf
    WeaponAmmoCheckAnim=MG34_Tripod_Reloadempty

//  WeaponPutDownAnim=MG34Tripod_putaway
//  WeaponEquipAnim=MG34Tripod_pullout

    WeaponIdleShoulderedAnims(0)=MG34_Tripod_Idle
    WeaponIdleShoulderedAnims(1)=MG34_Tripod_Idle
    WeaponFireShoulderedAnim(0)=MG34_Tripod_Shoot
    WeaponFireShoulderedAnim(1)=MG34_Tripod_Shoot
//  WeaponFireLastShoulderedAnim=MG34Tripod_shootLAST

    EquipTime=+1.00
    PutDownTime=+0.75

    ISFocusDepth=30
    ISFocusBlendRadius=16

    // Ammo
    AmmoClass=class'ROPAmmo_792x57_MG34Belt'
    MaxAmmoCount=200
    bUsesMagazines=true
    InitialNumPrimaryMags=4
    bPlusOneLoading=false
    bCanReloadNonEmptyMag=true
    PenetrationDepth=23.5
    MaxPenetrationTests=3
    MaxNumPenetrations=2//5
    // Tracers
    TracerClass=class'MG34_TurretBulletTracer'
    TracerFrequency=10

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

    FireCameraAnim[0]=CameraAnim'RPtperson_Cameras.Anim.Camera_MG34_Shoot'
    FireCameraAnim[1]=CameraAnim'RPtperson_Cameras.Anim.Camera_MG34_Shoot'
    ShakeScaleControlled=0.65

    SightSlideControlName=Sight_Slide

    SightRanges[0]=(SightRange=200,SightSlideOffset=0.0,SightPositionOffset=0.0,AddedPitch=40)
    SightRanges[1]=(SightRange=400,SightSlideOffset=0.05,SightPositionOffset=-0.095,AddedPitch=58)
    SightRanges[2]=(SightRange=500,SightSlideOffset=0.075,SightPositionOffset=-0.145,AddedPitch=70)
    SightRanges[3]=(SightRange=600,SightSlideOffset=0.11,SightPositionOffset=-0.215,AddedPitch=82)
    SightRanges[4]=(SightRange=700,SightSlideOffset=0.14,SightPositionOffset=-0.275,AddedPitch=96)
    // All ranges below here have not been dialed in, and are just estimates
    SightRanges[5]=(SightRange=800,SightSlideOffset=0.16,SightPositionOffset=-0.315,AddedPitch=114)
    SightRanges[6]=(SightRange=900,SightSlideOffset=0.24,SightPositionOffset=-0.470,AddedPitch=126)
    SightRanges[7]=(SightRange=1000,SightSlideOffset=0.3,SightPositionOffset=-0.575,AddedPitch=136)
    SightRanges[8]=(SightRange=1100,SightSlideOffset=0.37,SightPositionOffset=-0.71,AddedPitch=148)
    SightRanges[9]=(SightRange=1200,SightSlideOffset=0.44,SightPositionOffset=-0.85,AddedPitch=158)
    SightRanges[10]=(SightRange=1300,SightSlideOffset=0.51,SightPositionOffset=-0.99,AddedPitch=170)
    SightRanges[11]=(SightRange=1400,SightSlideOffset=0.59,SightPositionOffset=-1.14,AddedPitch=180)
    SightRanges[12]=(SightRange=1500,SightSlideOffset=0.69,SightPositionOffset=-1.35,AddedPitch=190)
    SightRanges[13]=(SightRange=1600,SightSlideOffset=0.79,SightPositionOffset=-1.55,AddedPitch=200)
    SightRanges[14]=(SightRange=1700,SightSlideOffset=0.9,SightPositionOffset=-1.75,AddedPitch=210)
    SightRanges[15]=(SightRange=1800,SightSlideOffset=1.02,SightPositionOffset=-1.97,AddedPitch=225)
    SightRanges[16]=(SightRange=1900,SightSlideOffset=1.15,SightPositionOffset=-2.22,AddedPitch=240)
    SightRanges[17]=(SightRange=2000,SightSlideOffset=1.28,SightPositionOffset=-2.48,AddedPitch=254)

    SuppressionPower=15
}

