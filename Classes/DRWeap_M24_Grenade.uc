class DRWeap_M24_Grenade extends ROStielGrenadeWeapon
    abstract;

// `include(ROGameIndices.uci)

// `include(ROVoiceComs.uci)

// TODO: ?
/*
simulated state WeaponEquipping
{
    simulated function BeginState(Name PreviousStateName)
    {
        local ROPlayerController ROPC;
        super.BeginState(PreviousStateName);
        Instigator.ReceiveLocalizedMessage(class'ROPLocalMessageGamePickup',
            class'ROPLocalMessageGamePickup'.const.ROMSG_SwitchWeapon,
            ROPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo),,self);

        ROPC = ROPlayerController(Instigator.Controller);
        ROPC.TriggerHint(ROHTrig_AutoCookGrenade);
    }
}
*/

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_M24_Grenade_Content"

    WeaponClassType=ROWCT_Grenade
    TeamIndex=`AXIS_TEAM_INDEX

    //? RoleSelectionImage(0)=Texture2D'ROP_UI_Textures.WeaponTex.Ger_Granate'

    InvIndex=`DRII_M24_GRENADE

    Category=ROIC_Grenade
    InventoryWeight=0

    ShoulderedPosition=(X=3,Y=3.5,Z=-1.0)
    ShoulderRotation=(Pitch=-300,Yaw=500,Roll=1500)
    PlayerViewOffset=(X=-1.557,Y=2.077,Z=-1.914)

    WeaponSpotEnemyAnim=enemyspot
    WeaponSpotEnemySightedAnim=enemyspot_ironsight

    // Anims
    WeaponPullPinAnim=Granate_pullpin
    WeaponPutDownAnim=Granate_Putaway
    WeaponEquipAnim=Granate_Pullout
    WeaponDownAnim=Granate_Down
    WeaponUpAnim=Granate_Up

    // Prone Crawl
    WeaponCrawlingAnims(0)=Granate_CrawlF
    WeaponCrawlStartAnim=Granate_Crawl_into
    WeaponCrawlEndAnim=Granate_Crawl_out

    // Sprinting
    WeaponSprintStartAnim=Granate_sprint_into
    WeaponSprintLoopAnim=Granate_Sprint
    WeaponSprintEndAnim=Granate_sprint_out

    // Mantling
    WeaponMantleOverAnim=Granate_Mantle

    // Cover/Blind Fire Anims
    WeaponBF_LeftPullpin=Granate_L_Pullpin
    WeaponBF_RightPullpin=Granate_R_Pullpin
    WeaponBF_UpPullpin=Granate_Up_Pullpin
    // Blind Fire ready
    WeaponBF_Rest2LeftReady=Granate_idleTO_L_ready
    WeaponBF_Rest2RightReady=Granate_idleTO_R_ready
    WeaponBF_Rest2UpReady=Granate_idleTO_Up_ready
    WeaponBF_LeftReady2Rest=Granate_L_readyTOidle
    WeaponBF_RightReady2Rest=Granate_R_readyTOidle
    WeaponBF_UpReady2Rest=Granate_Up_readyTOidle
    WeaponBF_LeftReady2Up=Granate_L_ready_toUp_ready
    WeaponBF_LeftReady2Right=Granate_Up_ready_toL_ready
    WeaponBF_UpReady2Left=Granate_Up_ready_toL_ready
    WeaponBF_UpReady2Right=Granate_Up_ready_toR_ready
    WeaponBF_RightReady2Up=Granate_R_ready_toUp_ready
    WeaponBF_RightReady2Left=Granate_R_ready_toL_ready
    WeaponBF_LeftReady2Idle=Granate_L_readyTOidle
    WeaponBF_RightReady2Idle=Granate_R_readyTOidle
    WeaponBF_UpReady2Idle=Granate_Up_readyTOidle
    WeaponBF_Idle2UpReady=Granate_idleTO_Up_ready
    WeaponBF_Idle2LeftReady=Granate_idleTO_L_ready
    WeaponBF_Idle2RightReady=Granate_idleTO_R_ready
    // Blind Fire ready (Armed)
    ArmedBF_Rest2LeftReady=Granate_idleHold_TO_L_Hold
    ArmedBF_Rest2RightReady=Granate_idleHold_TO_R_Hold
    ArmedBF_Rest2UpReady=Granate_idleHold_TO_Up_Hold
    ArmedBF_LeftReady2Rest=Granate_L_HoldTOidleHold
    ArmedBF_RightReady2Rest=Granate_R_HoldTOidleHold
    ArmedBF_UpReady2Rest=Granate_Up_HoldTOidleHold
    ArmedBF_LeftReady2Up=Granate_L_Hold_toUp_Hold
    ArmedBF_LeftReady2Right=Granate_LHold_ready_toR_Hold
    ArmedBF_UpReady2Left=Granate_Up_Hold_toL_Hold
    ArmedBF_UpReady2Right=Granate_Up_Hold_toR_Hold
    ArmedBF_RightReady2Up=Granate_R_Hold_toUp_Hold
    ArmedBF_RightReady2Left=Granate_R_Hold_toL_Hold
    ArmedBF_LeftReady2Idle=Granate_L_HoldTOidleHold
    ArmedBF_RightReady2Idle=Granate_R_HoldTOidleHold
    ArmedBF_UpReady2Idle=Granate_Up_HoldTOidleHold
    ArmedBF_Idle2UpReady=Granate_idleHold_TO_Up_Hold
    ArmedBF_Idle2LeftReady=Granate_idleHold_TO_L_Hold
    ArmedBF_Idle2RightReady=Granate_idleHold_TO_R_Hold

    // Melee anims
    WeaponMeleeAnims(0)=Granate_Bash
    WeaponMeleeHardAnim=Granate_BashHard
    MeleePullbackAnim=Granate_Pullback
    MeleeHoldAnim=Granate_Pullback_Hold

    FuzeLength=4.5

    MuzzleFlashSocket=MuzzleFlashSocket

    AmmoClass=class'DRAmmo_M24_Grenade'

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponSingleFiring
    WeaponProjectiles(0)=class'DRProjectile_M24Grenade'
    WeaponThrowAnim(0)=Granate_throw
    WeaponIdleAnims(0)=Granate_idle
    ExplosiveBlindFireRightAnim(0)=Granate_R_throw
    ExplosiveBlindFireLeftAnim(0)=Granate_L_throw
    ExplosiveBlindFireUpAnim(0)=Granate_Up_throw

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=none
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRProjectile_M24Grenade'
    WeaponThrowAnim(ALTERNATE_FIREMODE)=Granate_toss
    WeaponIdleAnims(ALTERNATE_FIREMODE)=Granate_idle
    ExplosiveBlindFireRightAnim(ALTERNATE_FIREMODE)=Granate_R_toss
    ExplosiveBlindFireLeftAnim(ALTERNATE_FIREMODE)=Granate_L_throw
    ExplosiveBlindFireUpAnim(ALTERNATE_FIREMODE)=Granate_toss

    Weight=0.00 //KG
    MaxAmmoCount=1
    InitialNumPrimaryMags=2

    ThrowSpawnModifier=0.525//0.368 // 0.55
    TossSpawnModifier=0.4//0.55

    ThrowingBattleChatterIndex=`BATTLECHATTER_ThrowingGrenade

    // AI
    MinBurstAmount=1
    MaxBurstAmount=1
    BurstWaitTime=3.5
}
