class DRWeap_TNT extends ROSatchelChargeWeapon
    abstract;

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_TNT_Content"
    RoleSelectionImage(0)=Texture'ui_textures.Textures.sov_wp_f1nade'

    InvIndex=`DRII_TNT

    PlayerViewOffset=(X=1,Y=5,Z=-2)
    //? ShoulderedPosition=(X=3,Y=3.5,Z=-1.0)
    //? ShoulderRotation=(Pitch=-300,Yaw=500,Roll=1500)
    //? RoleEncumbranceModifier=0.25

    FuzeLength=10.0

    AmmoClass=class'DRAmmo_TNT'

    ThrowingBattleChatterIndex=`BATTLECHATTER_ThrowingGrenade

    // Anims
    WeaponPullPinAnim=M37Satchel_pullpin
    WeaponPutDownAnim=M37Satchel_Putaway
    WeaponEquipAnim=M37Satchel_Pullout
    WeaponDownAnim=M37Satchel_Down
    WeaponUpAnim=M37Satchel_Up

    // Prone Crawl
    WeaponCrawlingAnims(0)=M37Satchel_CrawlF
    WeaponCrawlStartAnim=M37Satchel_Crawl_into
    WeaponCrawlEndAnim=M37Satchel_Crawl_out

    // Sprinting
    WeaponSprintStartAnim=M37Satchel_sprint_into
    WeaponSprintLoopAnim=M37Satchel_Sprint
    WeaponSprintEndAnim=M37Satchel_sprint_out

    // Mantling
    WeaponMantleOverAnim=M37Satchel_Mantle

    // Cover/Blind Fire Anims
    WeaponBF_LeftPullpin=M37Satchel_L_Pullpin
    WeaponBF_RightPullpin=M37Satchel_R_Pullpin
    WeaponBF_UpPullpin=M37Satchel_Up_Pullpin
    // Blind Fire ready
    WeaponBF_Rest2LeftReady=M37Satchel_idleTO_L_ready
    WeaponBF_Rest2RightReady=M37Satchel_idleTO_R_ready
    WeaponBF_Rest2UpReady=M37Satchel_idleTO_Up_ready
    WeaponBF_LeftReady2Rest=M37Satchel_L_readyTOidle
    WeaponBF_RightReady2Rest=M37Satchel_R_readyTOidle
    WeaponBF_UpReady2Rest=M37Satchel_Up_readyTOidle
    WeaponBF_LeftReady2Up=M37Satchel_L_ready_toUp_ready
    WeaponBF_LeftReady2Right=M37Satchel_Up_ready_toL_ready
    WeaponBF_UpReady2Left=M37Satchel_Up_ready_toL_ready
    WeaponBF_UpReady2Right=M37Satchel_Up_ready_toR_ready
    WeaponBF_RightReady2Up=M37Satchel_R_ready_toUp_ready
    WeaponBF_RightReady2Left=M37Satchel_R_ready_toL_ready
    WeaponBF_LeftReady2Idle=M37Satchel_L_readyTOidle
    WeaponBF_RightReady2Idle=M37Satchel_R_readyTOidle
    WeaponBF_UpReady2Idle=M37Satchel_Up_readyTOidle
    WeaponBF_Idle2UpReady=M37Satchel_idleTO_Up_ready
    WeaponBF_Idle2LeftReady=M37Satchel_idleTO_L_ready
    WeaponBF_Idle2RightReady=M37Satchel_idleTO_R_ready
    // Blind Fire ready (Armed)
    ArmedBF_Rest2LeftReady=M37Satchel_idleHold_TO_L_Hold
    ArmedBF_Rest2RightReady=M37Satchel_idleHold_TO_R_Hold
    ArmedBF_Rest2UpReady=M37Satchel_idleHold_TO_Up_Hold
    ArmedBF_LeftReady2Rest=M37Satchel_L_HoldTOidleHold
    ArmedBF_RightReady2Rest=M37Satchel_R_HoldTOidleHold
    ArmedBF_UpReady2Rest=M37Satchel_Up_HoldTOidleHold
    ArmedBF_LeftReady2Up=M37Satchel_L_Hold_toUp_Hold
    ArmedBF_LeftReady2Right=M37Satchel_LHold_ready_toR_Hold
    ArmedBF_UpReady2Left=M37Satchel_Up_Hold_toL_Hold
    ArmedBF_UpReady2Right=M37Satchel_Up_Hold_toR_Hold
    ArmedBF_RightReady2Up=M37Satchel_R_Hold_toUp_Hold
    ArmedBF_RightReady2Left=M37Satchel_R_Hold_toL_Hold
    ArmedBF_LeftReady2Idle=M37Satchel_L_HoldTOidleHold
    ArmedBF_RightReady2Idle=M37Satchel_R_HoldTOidleHold
    ArmedBF_UpReady2Idle=M37Satchel_Up_HoldTOidleHold
    ArmedBF_Idle2UpReady=M37Satchel_idleHold_TO_Up_Hold
    ArmedBF_Idle2LeftReady=M37Satchel_idleHold_TO_L_Hold
    ArmedBF_Idle2RightReady=M37Satchel_idleHold_TO_R_Hold

    // Melee anims
    WeaponMeleeAnims(0)=M37Satchel_Bash
    WeaponMeleeHardAnim=M37Satchel_BashHard
    MeleePullbackAnim=M37Satchel_Pullback
    MeleeHoldAnim=M37Satchel_Pullback_Hold

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponSingleFiring
    WeaponProjectiles(0)=class'DRProjectile_TNT'
    WeaponThrowAnim(0)=M37Satchel_throw
    WeaponIdleAnims(0)=M37Satchel_idle
    ExplosiveBlindFireRightAnim(0)=M37Satchel_R_throw
    ExplosiveBlindFireLeftAnim(0)=M37Satchel_L_throw
    ExplosiveBlindFireUpAnim(0)=M37Satchel_Up_throw

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRProjectile_TNT'
    WeaponThrowAnim(ALTERNATE_FIREMODE)=M37Satchel_toss
    WeaponIdleAnims(ALTERNATE_FIREMODE)=M37Satchel_idle
    ExplosiveBlindFireRightAnim(ALTERNATE_FIREMODE)=M37Satchel_R_toss
    ExplosiveBlindFireLeftAnim(ALTERNATE_FIREMODE)=M37Satchel_L_throw
    ExplosiveBlindFireUpAnim(ALTERNATE_FIREMODE)=M37Satchel_toss
}
