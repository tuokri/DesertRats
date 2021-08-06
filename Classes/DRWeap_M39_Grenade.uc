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

    InvIndex=`DRII_M39_Grenade
    InventoryWeight=0

    Category=ROIC_Grenade

    PlayerViewOffset=(X=5,Y=4.5,Z=-1.75)

    // Anims
    WeaponPullPinAnim=Eihnadgranate_Pullpin
    WeaponPutDownAnim=F1_Putaway
    WeaponEquipAnim=F1_Pullout
    WeaponDownAnim=F1_Down
    WeaponUpAnim=F1_Up

    // Prone Crawl
    WeaponCrawlingAnims(0)=F1_CrawlF
    WeaponCrawlStartAnim=F1_Crawl_into
    WeaponCrawlEndAnim=F1_Crawl_out

    // Sprinting
    WeaponSprintStartAnim=F1_sprint_into
    WeaponSprintLoopAnim=F1_Sprint
    WeaponSprintEndAnim=F1_sprint_out

    // Mantling
    WeaponMantleOverAnim=F1_Mantle

    // Cover/Blind Fire Anims
    WeaponBF_LeftPullpin=F1_L_Pullpin
    WeaponBF_RightPullpin=F1_R_Pullpin
    WeaponBF_UpPullpin=F1_Up_Pullpin
    // Blind Fire ready
    WeaponBF_Rest2LeftReady=F1_idleTO_L_ready
    WeaponBF_Rest2RightReady=F1_idleTO_R_ready
    WeaponBF_Rest2UpReady=F1_idleTO_Up_ready
    WeaponBF_LeftReady2Rest=F1_L_readyTOidle
    WeaponBF_RightReady2Rest=F1_R_readyTOidle
    WeaponBF_UpReady2Rest=F1_Up_readyTOidle
    WeaponBF_LeftReady2Up=F1_L_ready_toUp_ready
    WeaponBF_LeftReady2Right=F1_Up_ready_toL_ready
    WeaponBF_UpReady2Left=F1_Up_ready_toL_ready
    WeaponBF_UpReady2Right=F1_Up_ready_toR_ready
    WeaponBF_RightReady2Up=F1_R_ready_toUp_ready
    WeaponBF_RightReady2Left=F1_R_ready_toL_ready
    WeaponBF_LeftReady2Idle=F1_L_readyTOidle
    WeaponBF_RightReady2Idle=F1_R_readyTOidle
    WeaponBF_UpReady2Idle=F1_Up_readyTOidle
    WeaponBF_Idle2UpReady=F1_idleTO_Up_ready
    WeaponBF_Idle2LeftReady=F1_idleTO_L_ready
    WeaponBF_Idle2RightReady=F1_idleTO_R_ready
    // Blind Fire ready (Armed)
    ArmedBF_Rest2LeftReady=F1_idleHold_TO_L_Hold
    ArmedBF_Rest2RightReady=F1_idleHold_TO_R_Hold
    ArmedBF_Rest2UpReady=F1_idleHold_TO_Up_Hold
    ArmedBF_LeftReady2Rest=F1_L_HoldTOidleHold
    ArmedBF_RightReady2Rest=F1_R_HoldTOidleHold
    ArmedBF_UpReady2Rest=F1_Up_HoldTOidleHold
    ArmedBF_LeftReady2Up=F1_L_Hold_toUp_Hold
    ArmedBF_LeftReady2Right=F1_LHold_ready_toR_Hold
    ArmedBF_UpReady2Left=F1_Up_Hold_toL_Hold
    ArmedBF_UpReady2Right=F1_Up_Hold_toR_Hold
    ArmedBF_RightReady2Up=F1_R_Hold_toUp_Hold
    ArmedBF_RightReady2Left=F1_R_Hold_toL_Hold
    ArmedBF_LeftReady2Idle=F1_L_HoldTOidleHold
    ArmedBF_RightReady2Idle=F1_R_HoldTOidleHold
    ArmedBF_UpReady2Idle=F1_Up_HoldTOidleHold
    ArmedBF_Idle2UpReady=F1_idleHold_TO_Up_Hold
    ArmedBF_Idle2LeftReady=F1_idleHold_TO_L_Hold
    ArmedBF_Idle2RightReady=F1_idleHold_TO_R_Hold

    // Enemy Spotting
    WeaponSpotEnemyAnim=F1_SpotEnemy

    // Melee anims
    WeaponMeleeAnims(0)=F1_Bash
    WeaponMeleeHardAnim=F1_BashHard
    MeleePullbackAnim=F1_Pullback
    MeleeHoldAnim=F1_Pullback_Hold

    // Sounds
    PrimeSound=AkEvent'WW_EXP_Shared.Play_EXP_Grenade_Safety_Release'

    FuzeLength=4.5

    MuzzleFlashSocket=none

    AmmoClass=class'DRAmmo_M39_Grenade'

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponSingleFiring
    WeaponProjectiles(0)=class'DRProjectile_M39Grenade'
    WeaponThrowAnim(0)=F1_throw
    WeaponIdleAnims(0)=F1_idle
    ExplosiveBlindFireRightAnim(0)=F1_R_throw
    ExplosiveBlindFireLeftAnim(0)=F1_L_throw
    ExplosiveBlindFireUpAnim(0)=F1_Up_throw

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRProjectile_M39Grenade'
    WeaponThrowAnim(ALTERNATE_FIREMODE)=F1_toss
    WeaponIdleAnims(ALTERNATE_FIREMODE)=F1_idle
    ExplosiveBlindFireRightAnim(ALTERNATE_FIREMODE)=F1_R_toss
    ExplosiveBlindFireLeftAnim(ALTERNATE_FIREMODE)=F1_L_throw
    ExplosiveBlindFireUpAnim(ALTERNATE_FIREMODE)=F1_toss

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
