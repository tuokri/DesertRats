class DRWeap_Mills_Grenade extends ROEggGrenadeWeapon
    abstract;

//? `include(RSVoiceComs.uci)

simulated state WeaponEquipping
{
    simulated function BeginState(Name PreviousStateName)
    {
        local ROPlayerController ROPC;
        super.BeginState(PreviousStateName);

        ROPC = ROPlayerController(Instigator.Controller);
        ROPC.TriggerHint(ROHTrig_CookGrenade);
    }
}

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_Mills_Grenade_Content"

    WeaponClassType=ROWCT_Grenade
    TeamIndex=`ALLIES_TEAM_INDEX

    //? RoleSelectionImage(0)=Texture'ui_textures.Textures.sov_wp_f1nade'

    InvIndex=36
    InventoryWeight=1

    Category=ROIC_Grenade

    InstantHitDamageTypes(0)=class'DRDmgType_MillsGrenade'
    InstantHitDamageTypes(1)=class'DRDmgType_MillsGrenade'

    PlayerViewOffset=(X=-1.557,Y=2.077,Z=-1.914)

    // Anims
    WeaponPullPinAnim=Mills_pullpin
    WeaponPutDownAnim=Mills_Putaway
    WeaponEquipAnim=Mills_Pullout
    WeaponDownAnim=Mills_Down
    WeaponUpAnim=Mills_Up

    // Prone Crawl
    WeaponCrawlingAnims(0)=Mills_CrawlF
    WeaponCrawlStartAnim=Mills_Crawl_into
    WeaponCrawlEndAnim=Mills_Crawl_out

    // Sprinting
    WeaponSprintStartAnim=Mills_sprint_into
    WeaponSprintLoopAnim=Mills_Sprint
    WeaponSprintEndAnim=Mills_sprint_out

    // Mantling
    WeaponMantleOverAnim=Mills_Mantle

    // Cover/Blind Fire Anims
    WeaponBF_LeftPullpin=Mills_L_Pullpin
    WeaponBF_RightPullpin=Mills_R_Pullpin
    WeaponBF_UpPullpin=Mills_Up_Pullpin
    // Blind Fire ready
    WeaponBF_Rest2LeftReady=Mills_idleTO_L_ready
    WeaponBF_Rest2RightReady=Mills_idleTO_R_ready
    WeaponBF_Rest2UpReady=Mills_idleTO_Up_ready
    WeaponBF_LeftReady2Rest=Mills_L_readyTOidle
    WeaponBF_RightReady2Rest=Mills_R_readyTOidle
    WeaponBF_UpReady2Rest=Mills_Up_readyTOidle
    WeaponBF_LeftReady2Up=Mills_L_ready_toUp_ready
    WeaponBF_LeftReady2Right=Mills_Up_ready_toL_ready
    WeaponBF_UpReady2Left=Mills_Up_ready_toL_ready
    WeaponBF_UpReady2Right=Mills_Up_ready_toR_ready
    WeaponBF_RightReady2Up=Mills_R_ready_toUp_ready
    WeaponBF_RightReady2Left=Mills_R_ready_toL_ready
    WeaponBF_LeftReady2Idle=Mills_L_readyTOidle
    WeaponBF_RightReady2Idle=Mills_R_readyTOidle
    WeaponBF_UpReady2Idle=Mills_Up_readyTOidle
    WeaponBF_Idle2UpReady=Mills_idleTO_Up_ready
    WeaponBF_Idle2LeftReady=Mills_idleTO_L_ready
    WeaponBF_Idle2RightReady=Mills_idleTO_R_ready
    // Blind Fire ready (Armed)
    ArmedBF_Rest2LeftReady=Mills_idleHold_TO_L_Hold
    ArmedBF_Rest2RightReady=Mills_idleHold_TO_R_Hold
    ArmedBF_Rest2UpReady=Mills_idleHold_TO_Up_Hold
    ArmedBF_LeftReady2Rest=Mills_L_HoldTOidleHold
    ArmedBF_RightReady2Rest=Mills_R_HoldTOidleHold
    ArmedBF_UpReady2Rest=Mills_Up_HoldTOidleHold
    ArmedBF_LeftReady2Up=Mills_L_Hold_toUp_Hold
    ArmedBF_LeftReady2Right=Mills_LHold_ready_toR_Hold
    ArmedBF_UpReady2Left=Mills_Up_Hold_toL_Hold
    ArmedBF_UpReady2Right=Mills_Up_Hold_toR_Hold
    ArmedBF_RightReady2Up=Mills_R_Hold_toUp_Hold
    ArmedBF_RightReady2Left=Mills_R_Hold_toL_Hold
    ArmedBF_LeftReady2Idle=Mills_L_HoldTOidleHold
    ArmedBF_RightReady2Idle=Mills_R_HoldTOidleHold
    ArmedBF_UpReady2Idle=Mills_Up_HoldTOidleHold
    ArmedBF_Idle2UpReady=Mills_idleHold_TO_Up_Hold
    ArmedBF_Idle2LeftReady=Mills_idleHold_TO_L_Hold
    ArmedBF_Idle2RightReady=Mills_idleHold_TO_R_Hold

    // Melee anims
    WeaponMeleeAnims(0)=Mills_Bash
    WeaponMeleeHardAnim=Mills_BashHard
    MeleePullbackAnim=Mills_Pullback
    MeleeHoldAnim=Mills_Pullback_Hold

    // Sounds
    PrimeSound=AkEvent'WW_EXP_Shared.Play_EXP_Grenade_Safety_Release'

    FuzeLength=4.2

    MuzzleFlashSocket=MuzzleFlashSocket

    AmmoClass=class'DRAmmo_Mills_Grenade'

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponSingleFiring
    WeaponProjectiles(0)=class'DRProjectile_MillsGrenade'
    WeaponThrowAnim(0)=Mills_throw
    WeaponIdleAnims(0)=Mills_idle
    ExplosiveBlindFireRightAnim(0)=Mills_R_throw
    ExplosiveBlindFireLeftAnim(0)=Mills_L_throw
    ExplosiveBlindFireUpAnim(0)=Mills_Up_throw

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRProjectile_MillsGrenade'
    WeaponThrowAnim(ALTERNATE_FIREMODE)=Mills_toss
    WeaponIdleAnims(ALTERNATE_FIREMODE)=Mills_idle
    ExplosiveBlindFireRightAnim(ALTERNATE_FIREMODE)=Mills_R_toss
    ExplosiveBlindFireLeftAnim(ALTERNATE_FIREMODE)=Mills_L_throw
    ExplosiveBlindFireUpAnim(ALTERNATE_FIREMODE)=Mills_toss

    Weight=0.00 //KG

    MaxAmmoCount=1
    InitialNumPrimaryMags=2

    ThrowSpawnModifier=1.5
    TossSpawnModifier=2.8

    ThrowingBattleChatterIndex=`BATTLECHATTER_ThrowingGrenade

    // AI
    MinBurstAmount=1
    MaxBurstAmount=1
    BurstWaitTime=2.5
}
