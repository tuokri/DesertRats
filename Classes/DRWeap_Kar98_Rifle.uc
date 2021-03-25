class DRWeap_Kar98_Rifle extends ROProjectileWeapon
      abstract;


// @TEMP - triple spread for most handheld weapons?
simulated function float GetSpreadMod()
{
    return 3 * super.GetSpreadMod();
}

exec function TweenTest()
{
    PlayAnimation(WeaponReloadStripperAnim, 1.25);
    SetTimer(0.6,false,'TweenTestPartTwo');
}

event TweenTestPartTwo()
{
    PlayAnimation(WeaponAmmoCheckAnim, 1.0);
}

/*
DEMO SHIT
simulated function PlayAnimation(name Sequence, optional float fDesiredDuration,
    optional bool bLoop, optional float TweenTime = 0.1)
{
    super.PlayAnimation(Sequence, fDesiredDuration * 0.3, bLower, TweenTime);
}
*/

/*
DEMO SHIT
simulated function PlayManualBolt()
{
    local name AnimName;
    local float Duration;

    AnimName = GetManualBoltAnimName();
    Duration = SkeletalMeshComponent(Mesh).GetAnimLength(AnimName) * 0.3;

    if ( WorldInfo.NetMode != NM_DedicatedServer )
    {
        PlayAnimation(AnimName, Duration);
    }

    // EndState - 68% based on 'AnimNotify' for K98
    SetTimer(Duration * 0.68f, false, 'BoltingComplete');
}
*/

/*
// TODO: Experimental shit.
simulated function PlayFiringSound(byte FireModeNum)
{
    MakeNoise(1.0, 'PlayerFiring'); // AI

    if( !bPlayingLoopingFireSnd )
    {
        if( FireModeNum < WeaponFireSnd.Length )
        {
            if(Instigator.IsLocallyControlled() && Instigator.IsFirstPerson())
            {
                Instigator.PlaySoundBase(AkEvent'WW_WEP_SVD.Play_WEP_SVD_Fire_Single', true, false, false);
            }
            WeaponPlayFireSound(WeaponFireSnd[FireModeNum].DefaultCue, AkEvent'WW_WEP_RPD.Play_WEP_RPD_Tail');
        }
    }
}
*/

DefaultProperties
{
    AltFireModeType=ROAFT_Bayonet

    WeaponContentClass(0)="DesertRats.DRWeap_Kar98_Rifle_Content"

    //? RoleSelectionImage(0)=Texture2D'ROP_UI_Textures.WeaponTex.Ger_K98_UPGD3'

    WeaponClassType=ROWCT_Rifle
    TeamIndex=`AXIS_TEAM_INDEX

    Category=ROIC_Primary   //ROIC_Primary
    Weight=3.7              //KG
    InvIndex=`DRII_KAR98_RIFLE
    InventoryWeight=0

    PlayerIronSightFOV=40.0

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponSingleFiring
    WeaponFireTypes(0)=EWFT_Custom
    WeaponProjectiles(0)=class'DRBullet_Kar98'
    FireInterval(0)=1.1//+1.25
    DelayedRecoilTime(0)=0.01
    Spread(0)=0.00015

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=WeaponManualSingleFiring
    WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRBullet_Kar98'
    FireInterval(ALTERNATE_FIREMODE)=1.1//+1.25
    DelayedRecoilTime(ALTERNATE_FIREMODE)=0.01
    Spread(ALTERNATE_FIREMODE)=0.00015

    PreFireTraceLength=2500 //50 Meters

    ShoulderedSpreadMod=6.0
    HippedSpreadMod=10.0


    // AI
    MinBurstAmount=1
    MaxBurstAmount=1
    BurstWaitTime=1.5
    AILongDistanceScale=1.25f
    AIMediumDistanceScale=0.5f
    AISpreadScale=200.0
    AISpreadNoSeeScale=2.0
    AISpreadNMEStillScale=0.5
    AISpreadNMESprintScale=1.5

    // Recoil
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

    InstantHitDamageTypes(0)=class'DRDmgType_Kar98Bullet'
    InstantHitDamageTypes(1)=class'DRDmgType_Kar98Bullet'

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_Rifles_round'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'RP_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_Kar98'

    //? WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_RO2_WEP_K98_RO2.Play_Rifle_K98_Fire_Single_M_Cue', FirstPersonCue=AkEvent'WW_RO2_WEP_K98_RO2.Play_Rifle_K98_Fire_Single_Sur')
    //? WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_RO2_WEP_K98_RO2.Play_Rifle_K98_Fire_Single_M_Cue', FirstPersonCue=AkEvent'WW_RO2_WEP_K98_RO2.Play_Rifle_K98_Fire_Single_Sur')

    bHasIronSights=True
    bHasManualBolting=True

    //Equip and putdown
    WeaponPutDownAnim=K98_Putaway
    WeaponEquipAnim=K98_Pullout
    WeaponDownAnim=K98_Down
    WeaponUpAnim=K98_Up

    // Fire Anims
    //Hip fire
    WeaponFireAnim(0)=K98_Hip_Bolt
    WeaponFireAnim(1)=K98_Hip_Bolt
    WeaponFireLastAnim=K98_Hip_ShootLAST
    //Shouldered fire
    WeaponFireShoulderedAnim(0)=K98_Hip_Bolt
    WeaponFireShoulderedAnim(1)=K98_Hip_Bolt
    WeaponFireLastShoulderedAnim=K98_Hip_ShootLAST
    //Fire using iron sights
    WeaponFireSightedAnim(0)=K98_Iron_Bolt
    WeaponFireSightedAnim(1)=K98_Iron_Bolt
    WeaponFireLastSightedAnim=K98_Iron_ShootLAST
    //Manual bolting
    WeaponManualBoltAnim=K98_Iron_Manual_Bolt
    WeaponManualBoltRestAnim=K98_Iron_Manual_Bolt_rest

    // Idle Anims
    // Hip Idle
    WeaponIdleAnims(0)=K98_Hip_Idle
    WeaponIdleAnims(1)=K98_Hip_Idle
    // Shouldered idle
    WeaponIdleShoulderedAnims(0)=K98_Hip_Idle
    WeaponIdleShoulderedAnims(1)=K98_Hip_Idle
    // Sighted Idle
    WeaponIdleSightedAnims(0)=K98_Iron_Idle
    WeaponIdleSightedAnims(1)=K98_Iron_Idle

    // Prone Crawl
    WeaponCrawlingAnims(0)=K98_CrawlF
    WeaponCrawlStartAnim=K98_Crawl_into
    WeaponCrawlEndAnim=K98_Crawl_out

    //Reloading
    WeaponReloadStripperAnim=K98_Reload
    WeaponReloadSingleBulletAnim=K98_Rsingle_Insert
    WeaponReloadEmptySingleBulletAnim=K98_Rsingle_Insert_empty
    WeaponOpenBoltAnim=K98_Rsingle_Boltopen
    WeaponOpenBoltEmptyAnim=K98_Rsingle_Boltopen_empty
    WeaponCloseBoltAnim=K98_Rsingle_Boltclose
    WeaponRestReloadStripperAnim=K98_Reload_rest
    WeaponRestReloadSingleBulletAnim=K98_Rsingle_Insert_rest
    WeaponRestReloadEmptySingleBulletAnim=K98_Rsingle_Insert_empty_rest
    WeaponRestOpenBoltAnim=K98_Rsingle_Boltopen_rest
    WeaponRestOpenBoltEmptyAnim=K98_Rsingle_Boltopen_empty_rest
    WeaponRestCloseBoltAnim=K98_Rsingle_Boltclose_rest
    // Ammo check
    WeaponAmmoCheckAnim=K98_ammocheck
    WeaponRestAmmoCheckAnim=K98_Ammocheck_rest

    // Sprinting
    WeaponSprintStartAnim=K98_sprint_into
    WeaponSprintLoopAnim=K98_Sprint
    WeaponSprintEndAnim=K98_sprint_out
    Weapon1HSprintStartAnim=K98_ger_sprint_into
    Weapon1HSprintLoopAnim=K98_ger_sprint
    Weapon1HSprintEndAnim=K98_ger_sprint_out

    // Mantling
    WeaponMantleOverAnim=K98_Mantle

    // Cover/Blind Fire Anims
    WeaponRestAnim=K98_rest_idle
    WeaponEquipRestAnim=K98_pullout_rest
    WeaponPutDownRestAnim=K98_putaway_rest
    WeaponBlindFireRightAnim=K98_BF_Right_Shoot
    WeaponBlindFireLeftAnim=K98_BF_Left_Shoot
    WeaponBlindFireUpAnim=K98_BF_up_Shoot
    WeaponIdleToRestAnim=K98_idleTOrest
    WeaponRestToIdleAnim=K98_restTOidle
    WeaponRestToBlindFireRightAnim=K98_restTOBF_Right
    WeaponRestToBlindFireLeftAnim=K98_restTOBF_Left
    WeaponRestToBlindFireUpAnim=K98_restTOBF_up
    WeaponBlindFireRightToRestAnim=K98_BF_Right_TOrest
    WeaponBlindFireLeftToRestAnim=K98_BF_Left_TOrest
    WeaponBlindFireUpToRestAnim=K98_BF_up_TOrest
    WeaponBFLeftToUpTransAnim=K98_BFleft_toBFup
    WeaponBFRightToUpTransAnim=K98_BFright_toBFup
    WeaponBFUpToLeftTransAnim=K98_BFup_toBFleft
    WeaponBFUpToRightTransAnim=K98_BFup_toBFright
    // Blind Fire ready
    WeaponBF_Rest2LeftReady=K98_restTO_L_ready
    WeaponBF_LeftReady2LeftFire=K98_L_readyTOBF_L
    WeaponBF_LeftFire2LeftReady=K98_BF_LTO_L_ready
    WeaponBF_LeftReady2Rest=K98_L_readyTOrest
    WeaponBF_Rest2RightReady=K98_restTO_R_ready
    WeaponBF_RightReady2RightFire=K98_R_readyTOBF_R
    WeaponBF_RightFire2RightReady=K98_BF_RTO_R_ready
    WeaponBF_RightReady2Rest=K98_R_readyTOrest
    WeaponBF_Rest2UpReady=K98_restTO_Up_ready
    WeaponBF_UpReady2UpFire=K98_Up_readyTOBF_Up
    WeaponBF_UpFire2UpReady=K98_BF_UpTO_Up_ready
    WeaponBF_UpReady2Rest=K98_Up_readyTOrest
    WeaponBF_LeftReady2Up=K98_L_ready_toUp_ready
    WeaponBF_LeftReady2Right=K98_L_ready_toR_ready
    WeaponBF_UpReady2Left=K98_Up_ready_toL_ready
    WeaponBF_UpReady2Right=K98_Up_ready_toR_ready
    WeaponBF_RightReady2Up=K98_R_ready_toUp_ready
    WeaponBF_RightReady2Left=K98_R_ready_toL_ready
    WeaponBF_LeftReady2Idle=K98_L_readyTOidle
    WeaponBF_RightReady2Idle=K98_R_readyTOidle
    WeaponBF_UpReady2Idle=K98_Up_readyTOidle
    WeaponBF_Idle2UpReady=K98_idleTO_Up_ready
    WeaponBF_Idle2LeftReady=K98_idleTO_L_ready
    WeaponBF_Idle2RightReady=K98_idleTO_R_ready

    // Melee anims
    WeaponMeleeAnims(0)=K98_Bash
    WeaponMeleeHardAnim=K98_BashHard
    MeleePullbackAnim=K98_Pullback
    MeleeHoldAnim=K98_Pullback_Hold

    WeaponBayonetMeleeAnims(0)=K98_Stab
    WeaponBayonetMeleeHardAnim=K98_StabHard

    WeaponAttachBayonetAnim=Bayonet_attach
    WeaponDetachBayonetAnim=Bayonet_detach

    BayonetSkelControlName=Bayonet_K98
    bHasBayonet=true
    BayonetAttackRange=73.0
    WeaponBayonetLength=9.8

    EquipTime=+0.75
    PutDownTime=+0.50

    bDebugWeapon=false

    BoltControllerNames[0]=BoltSlide_Kar98

    ISFocusDepth=30
    ISFocusBlendRadius=12

    // Ammo
    MaxAmmoCount=5
    AmmoClass=class'DRAmmo_792x57_Kar98Stripper'
    bUsesMagazines=false
    InitialNumPrimaryMags=8
    bLosesRoundOnReload=true
    bPlusOneLoading=false
    bCanReloadNonEmptyMag=true
    bCanLoadStripperClip=true
    bCanLoadSingleBullet=true
    StripperClipBulletCount=5
    PenetrationDepth=23.5
    MaxPenetrationTests=3
    MaxNumPenetrations=2

    PlayerViewOffset=(X=0.0,Y=8.0,Z=-5)
    ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
    ShoulderedTime=0.35
    ShoulderedPosition=(X=0.5,Y=4.0,Z=-2.0)// (X=0,Y=1,Z=-1.4)
    ShoulderRotation=(Pitch=-500,Yaw=0,Roll=2500)
    IronSightPosition=(X=0,Y=0,Z=-0.05)

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

    //? FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_KAR98_Shoot'
    //? FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_KAR98_Shoot'

    FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MN9130_Shoot'
    FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MN9130_Shoot'

    SightSlideControlName=Sight_Slide
    SightRotControlName=Sight_Rotation

    SightRanges[0]=(SightRange=100,SightPitch=60,SightSlideOffset=0.0,SightPositionOffset=-0.05)//85
    SightRanges[1]=(SightRange=200,SightPitch=165,SightSlideOffset=0.2,SightPositionOffset=-0.1)
    SightRanges[2]=(SightRange=300,SightPitch=280,SightSlideOffset=0.36,SightPositionOffset=-0.17)
    SightRanges[3]=(SightRange=400,SightPitch=400,SightSlideOffset=0.48,SightPositionOffset=-0.24)
    SightRanges[4]=(SightRange=500,SightPitch=545,SightSlideOffset=0.64,SightPositionOffset=-0.33)
    // All ranges below here have not been dialed in, and are just estimates
    SightRanges[5]=(SightRange=600,SightPitch=650,SightSlideOffset=0.76,SightPositionOffset=-0.385)
    SightRanges[6]=(SightRange=700,SightPitch=800,SightSlideOffset=0.93,SightPositionOffset=-0.50)
    SightRanges[7]=(SightRange=800,SightPitch=1050,SightSlideOffset=1.05,SightPositionOffset=-0.65)
    SightRanges[8]=(SightRange=900,SightPitch=1425,SightSlideOffset=1.2,SightPositionOffset=-0.87)// dialed in
    SightRanges[9]=(SightRange=1000,SightPitch=1950,SightSlideOffset=1.32,SightPositionOffset=-1.2)// dialed in
    SightRanges[10]=(SightRange=1100,SightPitch=2150,SightSlideOffset=1.47,SightPositionOffset=-1.315)
    SightRanges[11]=(SightRange=1200,SightPitch=2300,SightSlideOffset=1.6,SightPositionOffset=-1.430)
    SightRanges[12]=(SightRange=1300,SightPitch=2550,SightSlideOffset=1.75,SightPositionOffset=-1.55)
    SightRanges[13]=(SightRange=1400,SightPitch=2750,SightSlideOffset=1.88,SightPositionOffset=-1.675)
    SightRanges[14]=(SightRange=1500,SightPitch=2900,SightSlideOffset=2.03,SightPositionOffset=-1.78)
    SightRanges[15]=(SightRange=1600,SightPitch=3125,SightSlideOffset=2.15,SightPositionOffset=-1.9)
    SightRanges[16]=(SightRange=1700,SightPitch=3450,SightSlideOffset=2.3,SightPositionOffset=-2.1)
    SightRanges[17]=(SightRange=1800,SightPitch=3550,SightSlideOffset=2.42,SightPositionOffset=-2.15)
    SightRanges[18]=(SightRange=1900,SightPitch=3900,SightSlideOffset=2.57,SightPositionOffset=-2.35)
    SightRanges[19]=(SightRange=2000,SightPitch=4150,SightSlideOffset=2.7,SightPositionOffset=-2.5)

    SuppressionPower=20

    WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Mosin.Play_WEP_Mosin_Fire_Single_3P',FirstPersonCue=AkEvent'WW_WEP_Mosin.Play_WEP_Mosin_Fire_Single')
    WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Mosin.Play_WEP_Mosin_Fire_Single_3P',FirstPersonCue=AkEvent'WW_WEP_Mosin.Play_WEP_Mosin_Fire_Single')
}
