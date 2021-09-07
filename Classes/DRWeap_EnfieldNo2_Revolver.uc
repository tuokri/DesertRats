class DRWeap_EnfieldNo2_Revolver extends ROWeap_M1917_Pistol
    abstract;

`include(DesertRats\Classes\DRWeaponPickupMessagesOverride.uci)

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_EnfieldNo2_Revolver_Content"

    RoleSelectionImage(0)=Texture2D'DR_UI.WP_Render.WP_Render_EnfieldNo2'

    TeamIndex=`ALLIES_TEAM_INDEX

    InvIndex=`DRII_ENFIELDNO2_REVOLVER

    WeaponEquipAnim=M1917_pullout
    WeaponPutDownAnim=M1917_Putaway

    WeaponUpAnim=M1917_pullout//M1917_Up
    WeaponDownAnim=M1917_Putaway//M1917_Down
    WeaponDownSightedAnim=M1917_Putaway//M1917_Down

    WeaponFireAnim(0)=M1917_shoot
    WeaponFireAnim(1)=M1917_Single_shoot
    WeaponFireLastAnim=M1917_shoot

    WeaponFireShoulderedAnim(0)=M1917_shoot
    WeaponFireShoulderedAnim(1)=M1917_Single_shoot
    WeaponFireLastShoulderedAnim=M1917_shoot

    WeaponFireSightedAnim(0)=M1917_shoot
    WeaponFireSightedAnim(1)=M1917_Single_shoot
    WeaponFireLastSightedAnim=M1917_shoot

    WeaponFireLastSingleAnim=M1917_Single_shoot
    WeaponFireLastSightedSingleAnim=M1917_Single_shoot

    WeaponIdleAnims(0)=M1917_shoulder_idle
    WeaponIdleAnims(1)=M1917_shoulder_idle
    WeaponIdleShoulderedAnims(0)=M1917_shoulder_idle
    WeaponIdleShoulderedAnims(1)=M1917_shoulder_idle

    WeaponIdleSightedAnims(0)=M1917_iron_idle
    WeaponIdleSightedAnims(1)=M1917_iron_idle

    WeaponCrawlingAnims(0)=M1917_CrawlF
    WeaponCrawlStartAnim=M1917_Crawl_into
    WeaponCrawlEndAnim=M1917_Crawl_out

    WeaponReloadStripperAnim=M1917_reload_uncocked
    ReloadStripperDoubleAnim=M1917_reload_uncocked
    WeaponAltReloadStripperAnim=M1917_reload
    WeaponAltReloadStripperIronAnim=M1917_reload

    WeaponReloadEmptyMagIronAnim=M1917_reload_uncocked
    WeaponReloadNonEmptyMagIronAnim=M1917_reload_uncocked

    WeaponAmmoCheckAnim=M1917_ammocheck
    WeaponAmmoCheckIronAnim=M1917_ammocheck
    WeaponAltAmmoCheckAnim=M1917_Ammocheck//_uncocked
    WeaponAltAmmoCheckIronAnim=M1917_Ammocheck//_uncocked

    WeaponSprintStartAnim=M1917_sprint_into
    WeaponSprintLoopAnim=M1917_Sprint
    WeaponSprintEndAnim=M1917_sprint_out

    WeaponMantleOverAnim=M1917_Mantle

    WeaponSwitchToAltFireModeAnim=M1917_Manual_Hammer
    WeaponSightedSwitchToAltFireModeAnim=M1917_Manual_Hammer

    WeaponSpotEnemyAnim=M1917_SpotEnemy
    WeaponSpotEnemySightedAnim=M1917_SpotEnemy_ironsight

    WeaponMeleeAnims(0)=M1917_Bash

    MeleePullbackAnim=M1917_Pullback
    MeleeHoldAnim=M1917_Pullback_Hold
    WeaponMeleeHardAnim=M1917_BashHard

    WeaponDryFireAnim=M1917_DryFire
    WeaponDryFireSightedAnim=M1917_DryFire

    bUsesIronSightAnims=false
    bUsesIronsightMeleeAnim=false

    DoubleActionFireDelay=0.07 //0.17

    ZoomInTime=0.25
    ZoomOutTime=0.25

    bDebugWeapon = false

    PlayerViewOffset=(X=4.0,Y=6.5,Z=-2.75)
    ShoulderedPosition=(X=4.0,Y=4.0,Z=-2.0)
    IronSightPosition=(X=3.5,Y=0.02,Z=-0.35)

    MaxAmmoCount=6
    AmmoClass=class'DRAmmo_Webley'
    bUsesMagazines=false
    InitialNumPrimaryMags=4
    bPlusOneLoading=false
    bCanReloadNonEmptyMag=false
    bCanLoadStripperClip=true
    bCanLoadSingleBullet=false
    StripperClipBulletCount=6
    PenetrationDepth=10
    MaxPenetrationTests=3
    MaxNumPenetrations=2
    PerformReloadPct=0.73f

    BoltControllerNames.Empty
    BoltControllerNames[0]=Hammer_M1917
//  BoltControllerNames[1]=Cylinder_M1917

    SightRanges.Empty
}
