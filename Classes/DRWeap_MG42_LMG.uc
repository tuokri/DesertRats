class DRWeap_MG42_LMG extends ROMGWeapon
    abstract;

// `include(ROGameIndices.uci)

/**
 * Handle the sight index setting being updated
 */
simulated function SightIndexUpdated()
{
    if( SightRotController != none )
    {
        SightRotController.BoneRotation.Pitch = SightRanges[SightRangeIndex].SightPitch * -1;
    }
    if( SightSlideController != none )
    {
        SightSlideController.BoneTranslation.Z = SightRanges[SightRangeIndex].SightSlideOffset;
    }
    IronSightPosition.Z=SightRanges[SightRangeIndex].SightPositionOffset;
    PlayerViewOffset.Z=SightRanges[SightRangeIndex].SightPositionOffset;
}

simulated function bool OverrideAllowFocusZoom()
{
    return bUsingSights;
}

simulated function PlayBarrelChange()
{
    Local float FastAnimTimer;

    AnimTimer = SkeletalMeshComponent(Mesh).GetAnimLength(BarrelChangeAnim);

    // Speed up the ChangeBarrelComplete call on the MG42 when prone since the animations are a bit too long
    if( !ROPawn(Instigator).IsInCover() )
    {
       FastAnimTimer = AnimTimer * 0.85;
    }
    else
    {
       FastAnimTimer = AnimTimer;
    }

    if ( WorldInfo.NetMode == NM_DedicatedServer || (WorldInfo.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()) )
    {
        SetTimer(FastAnimTimer - (FastAnimTimer * 0.1), false, 'ChangeBarrelComplete');
    }
    else
    {
        SetTimer(FastAnimTimer, false, 'ChangeBarrelComplete');
        PlayAnimation(BarrelChangeAnim, AnimTimer);
    }
}

simulated exec function SwitchFireMode()
{
    ROMGOperation();
}

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_MG42_LMG_Content"
    WeaponContentClass(1)="DesertRats.DRWeap_MG42_LMG_Level2_Content"
    WeaponContentClass(2)="DesertRats.DRWeap_MG42_LMG_Level3_Content"

    //? RoleSelectionImage(0)=Texture2D'ROP_UI_Textures.WeaponTex.Ger_MG42'
    //? RoleSelectionImage(1)=Texture2D'ROP_UI_Textures.WeaponTex.Ger_MG42_UPGD3'
    //? RoleSelectionImage(2)=Texture2D'ROP_UI_Textures.WeaponTex.Ger_MG42_UPGD3'

    // RO Classic Mode

    // Enemy Spotting
    WeaponSpotEnemyAnim=enemyspot_shoulder
    WeaponSpotEnemySightedAnim=enemyspot_deployed
    WeaponSpotEnemyDeployedAnim=enemyspot_deployed

    WeaponClassType=ROWCT_LMG
    TeamIndex=`AXIS_TEAM_INDEX

    Category=ROIC_Primary
    Weight=11.6 //KG
    RoleEncumbranceModifier=0.35
    InvIndex=`DRII_MG42_LMG

    InventoryWeight=3

    PlayerIronSightFOV=55.0

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponFiring
    WeaponFireTypes(0)=EWFT_Custom
    WeaponProjectiles(0)=class'DRBullet_MG42'

    FireInterval(0)=+0.05 // 1200 RPM
    DelayedRecoilTime(0)=0.0
    Spread(0)=0.000175

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=none
    //WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
    WeaponProjectiles(ALTERNATE_FIREMODE)=none
    //bLoopHighROFSounds(ALTERNATE_FIREMODE)=true
    FireInterval(ALTERNATE_FIREMODE)=+0.05 // 1200 RPM
    DelayedRecoilTime(ALTERNATE_FIREMODE)=0.0
    Spread(ALTERNATE_FIREMODE)=0.000175

    PreFireTraceLength=2500 //50 Meters
    FireTweenTime=0.025

    ShoulderedSpreadMod=6.0
    HippedSpreadMod=10.0

    // AI
    MinBurstAmount=3
    MaxBurstAmount=6
    BurstWaitTime=1.0

    // Recoil
    maxRecoilPitch=60
    minRecoilPitch=50
    maxRecoilYaw=35
    minRecoilYaw=-35
    RecoilRate=.045
    RecoilMaxYawLimit=1500
    RecoilMinYawLimit=64035
    RecoilMaxPitchLimit=1500
    RecoilMinPitchLimit=64785
    RecoilISMaxYawLimit=500
    RecoilISMinYawLimit=65035
    RecoilISMaxPitchLimit=450
    RecoilISMinPitchLimit=65035
    RecoilBlendOutRatio=0.75
    PostureHippedRecoilModifer=20.0
    PostureShoulderRecoilModifer=10.0
    RecoilViewRotationScale=0.45

    InstantHitDamage(0)=115
    InstantHitDamage(1)=115

    InstantHitDamageTypes(0)=class'DRDmgType_MG42Bullet'
    InstantHitDamageTypes(1)=class'DRDmgType_MG42Bullet'

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_WEP_Gun_Two.MuzzleFlashes.FX_WEP_Gun_A_MuzzleFlash_1stP_MG'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'


    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'RP_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_MG34'

    //? WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_RO2_WEP_MG42_RO2.Play_MG_MG42_Fire_LP', FirstPersonCue=AkEvent'WW_RO2_WEP_MG42_RO2.Play_MG_MG42_Fire_Loop_Sur_01')

    // Advanced (High RPM) Fire Effects
    bLoopingFireSnd(DEFAULT_FIREMODE)=true
    //? WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_RO2_WEP_MG42_RO2.Play_MG_MG42_Fire_End', FirstPersonCue=AkEvent'WW_RO2_WEP_MG42_RO2.Play_MG_MG42_Fire_LoopEnd_Sur')
    bLoopHighROFSounds(DEFAULT_FIREMODE)=true

    bHasIronSights=true;

    //Equip and putdown
    WeaponPutDownAnim=MG42_putaway
    WeaponEquipAnim=MG42_pullout
    WeaponDownAnim=MG42_Down
    WeaponUpAnim=MG42_Up

    // Fire Anims
    //Hip fire
    WeaponFireAnim(0)=MG42_shoulder_shoot
    WeaponFireAnim(1)=MG42_shoulder_shoot
    WeaponFireLastAnim=MG42_shoulder_shoot
    //Shouldered fire
    WeaponFireShoulderedAnim(0)=MG42_shoulder_shoot
    WeaponFireShoulderedAnim(1)=MG42_shoulder_shoot
    WeaponFireLastShoulderedAnim=MG42_shoulder_shoot
    //Fire using iron sights
    WeaponFireSightedAnim(0)=MG42_deploy_shoot
    WeaponFireSightedAnim(1)=MG42_deploy_shoot
    WeaponFireLastSightedAnim=MG42_deploy_shoot

    // Idle Anims
    //Hip Idle
    WeaponIdleAnims(0)=MG42_shoulder_idle
    WeaponIdleAnims(1)=MG42_shoulder_idle
    // Shouldered idle
    WeaponIdleShoulderedAnims(0)=MG42_shoulder_idle
    WeaponIdleShoulderedAnims(1)=MG42_shoulder_idle
    //Sighted Idle
    WeaponIdleSightedAnims(0)=MG42_deploy_idle
    WeaponIdleSightedAnims(1)=MG42_deploy_idle

    // Prone Crawl
    WeaponCrawlingAnims(0)=MG42_CrawlF
    WeaponCrawlStartAnim=MG42_Crawl_into
    WeaponCrawlEndAnim=MG42_Crawl_out
    // Deployed Prone Crawl
    RedeployCrawlingAnims(0)=MG42_Deployed_CrawlF

    //Reloading
    WeaponReloadEmptyMagAnim=MG42_reloadempty_crouch
    WeaponReloadNonEmptyMagAnim=MG42_reloadhalf_crouch
    WeaponRestReloadEmptyMagAnim=MG42_reloadempty_rest
    WeaponRestReloadNonEmptyMagAnim=MG42_reloadhalf_rest
    DeployReloadEmptyMagAnim=MG42_deploy_reloadempty
    DeployReloadHalfMagAnim=MG42_deploy_reloadhalf
    // Ammo check
    WeaponAmmoCheckAnim=MG42_ammocheck_crouch
    WeaponRestAmmoCheckAnim=MG42_ammocheck_rest
    DeployAmmoCheckAnim=MG42_deploy_ammocheck

    // Sprinting
    WeaponSprintStartAnim=MG42_sprint_into
    WeaponSprintLoopAnim=MG42_Sprint
    WeaponSprintEndAnim=MG42_sprint_out
    Weapon1HSprintStartAnim=MG42_ger_sprint_into
    Weapon1HSprintLoopAnim=MG42_ger_sprint
    Weapon1HSprintEndAnim=MG42_ger_sprint_out

    // Mantling
    WeaponMantleOverAnim=MG42_Mantle

    // Cover/Blind Fire Anims
    WeaponRestAnim=MG42_rest_idle
    WeaponEquipRestAnim=MG42_pullout_rest
    WeaponPutDownRestAnim=MG42_putaway_rest
    WeaponIdleToRestAnim=MG42_shoulderTOrest
    WeaponRestToIdleAnim=MG42_restTOshoulder

    ReloadMagazinEmptyCameraAnim=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_reloadempty'

    EquipTime=+1.00
    PutDownTime=+0.75

    bDebugWeapon = false

    ISFocusDepth=30
    ISFocusBlendRadius=16

    // Ammo
    AmmoClass=class'DRAmmo_792x57_MG42Drum'
    MaxAmmoCount=50
    bUsesMagazines=true
    InitialNumPrimaryMags=4
    bPlusOneLoading=false
    bCanReloadNonEmptyMag=true
    PenetrationDepth=23.5
    MaxPenetrationTests=3
    MaxNumPenetrations=2
    // Tracers
    TracerClass=class'DRBullet_MG42_Tracer'
    TracerFrequency=10

    PlayerViewOffset=(X=0.0,Y=8.0,Z=-5)
    ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
    ShoulderedTime=0.35
    ShoulderedPosition=(X=0.5,Y=4.0,Z=-2.0)// (X=0,Y=1,Z=-1.4)
    ShoulderRotation=(Pitch=-500,Yaw=0,Roll=2500)
    IronSightPosition=(X=0,Y=0,Z=0.0)

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
    FreeAimHipfireOffsetX=55

    Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
        Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
    End Object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1

    CollisionCheckLength=56.0

    DeployedSwayScale=0.05

    YawControlName=YawControl
    PitchControlName=PitchControl
    BipodZCheckDist=25.0
    bHasBipod=true
    bCanBlindFire=false
    DeployAnimName=MG42_shoulderTOdeploy
    UnDeployAnimName=MG42_deployTOshoulder
    RestDeployAnimName=MG42_restTOdeploy
    RestUnDeployAnimName=MG42_deployTOrest
    DeployToShuffleAnimName=MG42_Deploy_TO_Shuffle
    ShuffleIdleAnimName=MG42_Shuffle_idle
    ShuffleToDeployAnimName=MG42_Shuffle_TO_Deploy
    RedeployProneTurnAnimName=MG42_prone_turn_TO_Deploy
    UnDeployProneTurnAnimName=MG42_prone_Deploy_TO_turn
    ProneTurningIdleAnimName=MG42_prone_Deploy_turn_idle
    BipodPivotBoneName=Bipod_hinge_Yaw
    BipodOffset=(X=35.80)   // Fake the bipod location so that the gun aims like the DP28

    // 19.5 Z offset to ground from 0,0,0

    FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    ShakeScaleControlled=0.65

    //SightSlideControlName=Sight_Slide
    SightRotControlName=Sight_Rotation

    SightRanges[0]=(SightRange=200,SightPitch=0,SightPositionOffset=0,AddedPitch=14)
    SightRanges[1]=(SightRange=400,SightPitch=333,SightPositionOffset=-0.222,AddedPitch=-14)
    SightRanges[2]=(SightRange=500,SightPitch=500,SightPositionOffset=-0.333,AddedPitch=-24)
    SightRanges[3]=(SightRange=600,SightPitch=666,SightPositionOffset=-0.444,AddedPitch=-37)
    SightRanges[4]=(SightRange=700,SightPitch=833,SightPositionOffset=-0.556,AddedPitch=-48)
    SightRanges[5]=(SightRange=800,SightPitch=1000,SightPositionOffset=-0.667,AddedPitch=-47)
    SightRanges[6]=(SightRange=900,SightPitch=1166,SightPositionOffset=-0.778,AddedPitch=-50)
    SightRanges[7]=(SightRange=1000,SightPitch=1333,SightPositionOffset=-0.889,AddedPitch=-39)
    // All ranges below here have not been dialed in, and are just estimates
    SightRanges[8]=(SightRange=1100,SightPitch=1500,SightPositionOffset=-1,AddedPitch=-58)
    SightRanges[9]=(SightRange=1200,SightPitch=1666,SightPositionOffset=-1.111,AddedPitch=-62)
    SightRanges[10]=(SightRange=1300,SightPitch=1833,SightPositionOffset=-1.222,AddedPitch=-64)
    SightRanges[11]=(SightRange=1400,SightPitch=2000,SightPositionOffset=-1.333,AddedPitch=-66)
    SightRanges[12]=(SightRange=1500,SightPitch=2166,SightPositionOffset=-1.444,AddedPitch=-69)
    SightRanges[13]=(SightRange=1600,SightPitch=2333,SightPositionOffset=-1.556,AddedPitch=-72)
    SightRanges[14]=(SightRange=1700,SightPitch=2500,SightPositionOffset=-1.667,AddedPitch=-74)
    SightRanges[15]=(SightRange=1800,SightPitch=2666,SightPositionOffset=-1.778,AddedPitch=-76)
    SightRanges[16]=(SightRange=1900,SightPitch=2833,SightPositionOffset=-1.889,AddedPitch=-78)
    SightRanges[17]=(SightRange=2000,SightPitch=3000,SightPositionOffset=-2,AddedPitch=-80)



    ROBarrelClass=class'DRMGBarrel_MG42'
    bTrackBarrelHeat=true
    BarrelHeatBone=barrel
    BarrelChangeAnim=MG42_BarrelChange
    InitialBarrels=2

    MaxNumPrimaryMags=6

    SuppressionPower=10

}
