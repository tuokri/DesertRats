class DRWeap_C96_Pistol extends ROProjectileWeapon
    abstract;

// `include(ROGameIndices.uci)

DefaultProperties
{
    //? RoleSelectionImage(0)=Texture2D'ROP_UI_Textures.WeaponTex.Ger_C96_UPGD1'
    //? RoleSelectionImage(1)=Texture2D'ROP_UI_Textures.WeaponTex.Ger_C96_UPGD2'
    //? RoleSelectionImage(2)=Texture2D'ROP_UI_Textures.WeaponTex.Ger_C96_UPGD3'
    WeaponContentClass(0)="DesertRats.DRWeap_C96_Pistol_Content"
    //? WeaponContentClass(1)="DesertRats.DRWeap_C96_Pistol_Level2"
    //? WeaponContentClass(2)="DesertRats.DRWeap_C96_Pistol_Level3"

    WeaponClassType=ROWCT_HandGun
    TeamIndex=`AXIS_TEAM_INDEX

    Category=ROIC_Secondary //ROIC_Primary
    Weight=1.25           //KG
    InvIndex=`DRII_C96_PISTOL

    InventoryWeight=1
    RoleEncumbranceModifier=0.0

    PlayerIronSightFOV=60.0

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponSingleFiring
    WeaponFireTypes(0)=EWFT_Custom
    FireInterval(0)=+0.15
    WeaponProjectiles(0)=class'DRBullet_C96'
    Spread(0)=0.011
    //? WeaponDryFireSnd=SoundCue'AUD_Firearms.DryFire.DryFire_Pistol_Cue'

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=none
    //WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
    FireInterval(ALTERNATE_FIREMODE)=+0.15
    WeaponProjectiles(ALTERNATE_FIREMODE)=none
    Spread(ALTERNATE_FIREMODE)=0

    PreFireTraceLength=1250 //25 Meters

    ShoulderedSpreadMod=6.0
    HippedSpreadMod=10.0

    // AI
    MinBurstAmount=1
    MaxBurstAmount=3
    BurstWaitTime=1.5
    AISpreadScale=20.0

    //Recoil
    maxRecoilPitch=750
    minRecoilPitch=600
    maxRecoilYaw=130
    minRecoilYaw=-85
    RecoilRate=0.125
    RecoilMaxYawLimit=500
    RecoilMinYawLimit=65035
    RecoilMaxPitchLimit=750
    RecoilMinPitchLimit=64785
    RecoilISMaxYawLimit=500
    RecoilISMinYawLimit=65035
    RecoilISMaxPitchLimit=500
    RecoilISMinPitchLimit=65035
    RecoilBlendOutRatio=0.65

    InstantHitDamage(0)=50
    InstantHitDamage(1)=50

    InstantHitDamageTypes(0)=class'DRDmgType_C96Bullet'
    InstantHitDamageTypes(1)=class'DRDmgType_C96Bullet'

    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_Pistol'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    //? ShellEjectPSCTemplate=ParticleSystem'RP_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_C96'

    //? WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_RO2_WEP_C96_RO2.Play_Pistol_C96_Fire_Single', FirstPersonCue=AkEvent'WW_RO2_WEP_C96_RO2.Play_Pistol_C96_Single_Sur_01')
    //? WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_RO2_WEP_C96_RO2.Play_Pistol_C96_Fire_Single', FirstPersonCue=AkEvent'WW_RO2_WEP_C96_RO2.Play_Pistol_C96_Single_Sur_01')

    bHasIronSights=true;

    //Equip and putdown
    // TODO: These anims are missing!!!
    WeaponPutDownAnim=C96_Putaway
    WeaponEquipAnim=C96_Pullout
    WeaponDownAnim=C96_Down
    WeaponUpAnim=C96_Up

    // Fire Anims
    //Hip fire
    // TODO: Replace the shoulder anim with the proper hip anim if we add that back in
    WeaponFireAnim(0)=C96_shoulder_shoot
    WeaponFireAnim(1)=C96_shoulder_shoot
    WeaponFireLastAnim=C96_shoulder_shootLAST
    //Shouldered fire
    WeaponFireShoulderedAnim(0)=C96_shoulder_shoot
    WeaponFireShoulderedAnim(1)=C96_shoulder_shoot
    WeaponFireLastShoulderedAnim=C96_shoulder_shootLAST
    //Fire using iron sights
    WeaponFireSightedAnim(0)=C96_iron_shoot
    WeaponFireSightedAnim(1)=C96_iron_shoot
    WeaponFireLastSightedAnim=C96_iron_shootLAST

    // Idle Anims
    // Hip Idle
    // TODO: Replace the shoulder anim with the proper hip anim
    WeaponIdleAnims(0)=C96_Shoulder_Idle
    WeaponIdleAnims(1)=C96_Shoulder_Idle
    // Shouldered idle
    WeaponIdleShoulderedAnims(0)=C96_Shoulder_Idle
    WeaponIdleShoulderedAnims(1)=C96_Shoulder_Idle
    // Sighted Idle
    WeaponIdleSightedAnims(0)=C96_Iron_Idle
    WeaponIdleSightedAnims(1)=C96_Iron_Idle

    // Prone Crawl
    WeaponCrawlingAnims(0)=C96_CrawlF
    WeaponCrawlStartAnim=C96_Crawl_into
    WeaponCrawlEndAnim=C96_Crawl_out

    // Reloading
    WeaponReloadEmptyMagAnim=C96_reloadempty
    WeaponRestReloadEmptyMagAnim=C96_reloadempty_rest
    // Ammo check
    WeaponAmmoCheckAnim=C96_ammocheck
    WeaponRestAmmoCheckAnim=C96_ammocheck_rest

    WeaponSpotEnemyAnim=enemyspot
    WeaponSpotEnemySightedAnim=enemyspot_ironsight

    // Sprinting
    WeaponSprintStartAnim=C96_sprint_into
    WeaponSprintLoopAnim=C96_Sprint
    WeaponSprintEndAnim=C96_sprint_out

    // Mantling
    WeaponMantleOverAnim=C96_Mantle

    // Cover/Blind Fire Anims
    WeaponRestAnim=C96_rest_idle
    WeaponEquipRestAnim=C96_pullout_rest
    WeaponPutDownRestAnim=C96_putaway_rest
    WeaponBlindFireRightAnim=C96_BF_Right_Shoot
    WeaponBlindFireLeftAnim=C96_BF_Left_Shoot
    WeaponBlindFireUpAnim=C96_BF_up_Shoot
    WeaponIdleToRestAnim=C96_idleTOrest
    WeaponRestToIdleAnim=C96_restTOidle
    WeaponRestToBlindFireRightAnim=C96_restTOBF_Right
    WeaponRestToBlindFireLeftAnim=C96_restTOBF_Left
    WeaponRestToBlindFireUpAnim=C96_restTOBF_up
    WeaponBlindFireRightToRestAnim=C96_BF_Right_TOrest
    WeaponBlindFireLeftToRestAnim=C96_BF_Left_TOrest
    WeaponBlindFireUpToRestAnim=C96_BF_up_TOrest
    WeaponBFLeftToUpTransAnim=C96_BFleft_toBFup
    WeaponBFRightToUpTransAnim=C96_BFright_toBFup
    WeaponBFUpToLeftTransAnim=C96_BFup_toBFleft
    WeaponBFUpToRightTransAnim=C96_BFup_toBFright
    // Blind Fire ready
    WeaponBF_Rest2LeftReady=C96_restTO_L_ready
    WeaponBF_LeftReady2LeftFire=C96_L_readyTOBF_L
    WeaponBF_LeftFire2LeftReady=C96_BF_LTO_L_ready
    WeaponBF_LeftReady2Rest=C96_L_readyTOrest
    WeaponBF_Rest2RightReady=C96_restTO_R_ready
    WeaponBF_RightReady2RightFire=C96_R_readyTOBF_R
    WeaponBF_RightFire2RightReady=C96_BF_RTO_R_ready
    WeaponBF_RightReady2Rest=C96_R_readyTOrest
    WeaponBF_Rest2UpReady=C96_restTO_Up_ready
    WeaponBF_UpReady2UpFire=C96_Up_readyTOBF_Up
    WeaponBF_UpFire2UpReady=C96_BF_UpTO_Up_ready
    WeaponBF_UpReady2Rest=C96_Up_readyTOrest
    WeaponBF_LeftReady2Up=C96_L_ready_toUp_ready
    WeaponBF_LeftReady2Right=C96_L_ready_toR_ready
    WeaponBF_UpReady2Left=C96_Up_ready_toL_ready
    WeaponBF_UpReady2Right=C96_Up_ready_toR_ready
    WeaponBF_RightReady2Up=C96_R_ready_toUp_ready
    WeaponBF_RightReady2Left=C96_R_ready_toL_ready
    WeaponBF_LeftReady2Idle=C96_L_readyTOidle
    WeaponBF_RightReady2Idle=C96_R_readyTOidle
    WeaponBF_UpReady2Idle=C96_Up_readyTOidle
    WeaponBF_Idle2UpReady=C96_idleTO_Up_ready
    WeaponBF_Idle2LeftReady=C96_idleTO_L_ready
    WeaponBF_Idle2RightReady=C96_idleTO_R_ready

    // Melee anims
    WeaponMeleeAnims(0)=C96_Bash
    WeaponMeleeHardAnim=C96_BashHard
    MeleePullbackAnim=C96_Pullback
    MeleeHoldAnim=C96_Pullback_Hold

    EquipTime=+0.50
    PutDownTime=+0.33

    bDebugWeapon = false

    BoltControllerNames[0]=SlideControl_C96

    ISFocusDepth=20
    ISFocusBlendRadius=8

    // Ammo
    MaxAmmoCount=10
    AmmoClass=class'DRAmmo_763x25_C96Stripper'
    bUsesMagazines=true
    InitialNumPrimaryMags=6
    bPlusOneLoading=false
    bCanReloadNonEmptyMag=false
    bCanLoadStripperClip=false
    bCanLoadSingleBullet=false
    //StripperClipBulletCount=10
    PenetrationDepth=11.43
    MaxPenetrationTests=3
    MaxNumPenetrations=2
    PerformReloadPct=0.91f

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
    FullFreeAimISMaxYaw=250
    FullFreeAimISMinYaw=65285
    FullFreeAimISMaxPitch=175
    FullFreeAimISMinPitch=65360
    FreeAimSpeedScale=0.35
    FreeAimISSpeedScale=0.4
    FreeAimHipfireOffsetX=25

    Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
        Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.120)
    End Object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1

    CollisionCheckLength=22.0

    FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_C96_Shoot'
    FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_C96_Shoot'

    SuppressionPower=2.5

    AIRating=0.3

}
