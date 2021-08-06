// German egg grenade.
class DRWeap_M39_Grenade extends ROEggGrenadeWeapon
    abstract;

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
    WeaponContentClass(0)="DesertRats.DRWeap_M39_Grenade_Content"

    WeaponClassType=ROWCT_Grenade
    TeamIndex=`AXIS_TEAM_INDEX

    RoleSelectionImage(0)=Texture2D'DR_UI.WP_Render.WP_Render_M39Egg'

    InvIndex=`ROII_M61_Grenade
    InventoryWeight=0

    Category=ROIC_Grenade

    PlayerViewOffset=(X=5,Y=4.5,Z=-1.75)

    // Anims
    WeaponPullPinAnim=M61_pullpin
    WeaponPutDownAnim=M61_Putaway
    WeaponEquipAnim=M61_Pullout
    WeaponDownAnim=M61_Down
    WeaponUpAnim=M61_Up

    // Prone Crawl
    WeaponCrawlingAnims(0)=M61_CrawlF
    WeaponCrawlStartAnim=M61_Crawl_into
    WeaponCrawlEndAnim=M61_Crawl_out

    // Sprinting
    WeaponSprintStartAnim=M61_sprint_into
    WeaponSprintLoopAnim=M61_Sprint
    WeaponSprintEndAnim=M61_sprint_out

    // Mantling
    WeaponMantleOverAnim=M61_Mantle

    // Cover/Blind Fire Anims
    WeaponBF_LeftPullpin=M61_L_Pullpin
    WeaponBF_RightPullpin=M61_R_Pullpin
    WeaponBF_UpPullpin=M61_Up_Pullpin
    // Blind Fire ready
    WeaponBF_Rest2LeftReady=M61_idleTO_L_ready
    WeaponBF_Rest2RightReady=M61_idleTO_R_ready
    WeaponBF_Rest2UpReady=M61_idleTO_Up_ready
    WeaponBF_LeftReady2Rest=M61_L_readyTOidle
    WeaponBF_RightReady2Rest=M61_R_readyTOidle
    WeaponBF_UpReady2Rest=M61_Up_readyTOidle
    WeaponBF_LeftReady2Up=M61_L_ready_toUp_ready
    WeaponBF_LeftReady2Right=M61_Up_ready_toL_ready
    WeaponBF_UpReady2Left=M61_Up_ready_toL_ready
    WeaponBF_UpReady2Right=M61_Up_ready_toR_ready
    WeaponBF_RightReady2Up=M61_R_ready_toUp_ready
    WeaponBF_RightReady2Left=M61_R_ready_toL_ready
    WeaponBF_LeftReady2Idle=M61_L_readyTOidle
    WeaponBF_RightReady2Idle=M61_R_readyTOidle
    WeaponBF_UpReady2Idle=M61_Up_readyTOidle
    WeaponBF_Idle2UpReady=M61_idleTO_Up_ready
    WeaponBF_Idle2LeftReady=M61_idleTO_L_ready
    WeaponBF_Idle2RightReady=M61_idleTO_R_ready
    // Blind Fire ready (Armed)
    ArmedBF_Rest2LeftReady=M61_idleHold_TO_L_Hold
    ArmedBF_Rest2RightReady=M61_idleHold_TO_R_Hold
    ArmedBF_Rest2UpReady=M61_idleHold_TO_Up_Hold
    ArmedBF_LeftReady2Rest=M61_L_HoldTOidleHold
    ArmedBF_RightReady2Rest=M61_R_HoldTOidleHold
    ArmedBF_UpReady2Rest=M61_Up_HoldTOidleHold
    ArmedBF_LeftReady2Up=M61_L_Hold_toUp_Hold
    ArmedBF_LeftReady2Right=M61_LHold_ready_toR_Hold
    ArmedBF_UpReady2Left=M61_Up_Hold_toL_Hold
    ArmedBF_UpReady2Right=M61_Up_Hold_toR_Hold
    ArmedBF_RightReady2Up=M61_R_Hold_toUp_Hold
    ArmedBF_RightReady2Left=M61_R_Hold_toL_Hold
    ArmedBF_LeftReady2Idle=M61_L_HoldTOidleHold
    ArmedBF_RightReady2Idle=M61_R_HoldTOidleHold
    ArmedBF_UpReady2Idle=M61_Up_HoldTOidleHold
    ArmedBF_Idle2UpReady=M61_idleHold_TO_Up_Hold
    ArmedBF_Idle2LeftReady=M61_idleHold_TO_L_Hold
    ArmedBF_Idle2RightReady=M61_idleHold_TO_R_Hold

    // Enemy Spotting
    WeaponSpotEnemyAnim=M61_SpotEnemy

    // Melee anims
    WeaponMeleeAnims(0)=M61_Bash
    WeaponMeleeHardAnim=M61_BashHard
    MeleePullbackAnim=M61_Pullback
    MeleeHoldAnim=M61_Pullback_Hold

    // Sounds
    PrimeSound=AkEvent'WW_EXP_Shared.Play_EXP_Grenade_Safety_Release'

    FuzeLength=4.5

    MuzzleFlashSocket=none

    AmmoClass=class'DRAmmo_M39_Grenade'

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponSingleFiring
    WeaponProjectiles(0)=class'DRProjectile_M39Grenade'
    WeaponThrowAnim(0)=M61_throw
    WeaponIdleAnims(0)=M61_idle
    ExplosiveBlindFireRightAnim(0)=M61_R_throw
    ExplosiveBlindFireLeftAnim(0)=M61_L_throw
    ExplosiveBlindFireUpAnim(0)=M61_Up_throw

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRProjectile_M39Grenade'
    WeaponThrowAnim(ALTERNATE_FIREMODE)=M61_toss
    WeaponIdleAnims(ALTERNATE_FIREMODE)=M61_idle
    ExplosiveBlindFireRightAnim(ALTERNATE_FIREMODE)=M61_R_toss
    ExplosiveBlindFireLeftAnim(ALTERNATE_FIREMODE)=M61_L_throw
    ExplosiveBlindFireUpAnim(ALTERNATE_FIREMODE)=M61_toss

    Weight=0.230 // kg.
    MaxAmmoCount=1
    InitialNumPrimaryMags=2

    ThrowSpawnModifier=0.525//0.368 // 0.55
    TossSpawnModifier=0.4//0.55

    ThrowingBattleChatterIndex=`BATTLECHATTER_ThrowingGrenade

    // AI
    MinBurstAmount=1
    MaxBurstAmount=1
    BurstWaitTime=2.5

    EquipTime=+0.45 //0.35

    bCanBeQuickThrown=true
}

