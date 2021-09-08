class DRWeap_EnfieldNo2_Revolver extends ROWeap_M1917_Pistol
    abstract;

// `include(DesertRats\Classes\DRWeaponPickupMessagesOverride.uci)

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_EnfieldNo2_Revolver_Content"

    RoleSelectionImage(0)=Texture2D'DR_UI.WP_Render.WP_Render_EnfieldNo2'

    PlayerViewOffset=(X=6.0,Y=4.5,Z=-2.75)
    ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
    ShoulderedPosition=(X=5.0,Y=2.0,Z=-2.0)
    IronSightPosition=(X=0,Y=0,Z=0.2)

    SightRanges[0]=(SightRange=0,SightPitch=0,SightPositionOffset=0.6,AddedPitch=250)

    TeamIndex=`ALLIES_TEAM_INDEX

    InvIndex=`DRII_ENFIELDNO2_REVOLVER

    WeaponFireTypes(1)=EWFT_None

    WeaponEquipAnim=SelectTo
    WeaponPutDownAnim=SelectOut

    WeaponUpAnim=SelectTo//M1917_Up
    WeaponDownAnim=SelectOut//M1917_Down
    WeaponDownSightedAnim=SelectOut//M1917_Down

    WeaponFireAnim(0)=FireDouble
    WeaponFireAnim(1)=FireDouble
    WeaponFireLastAnim=FireDouble

    WeaponFireShoulderedAnim(0)=FireDouble
    WeaponFireShoulderedAnim(1)=FireDouble
    WeaponFireLastShoulderedAnim=FireDouble

    WeaponFireSightedAnim(0)=FireDouble
    WeaponFireSightedAnim(1)=FireDouble
    WeaponFireLastSightedAnim=FireDouble

    WeaponFireLastSingleAnim=FireDouble
    WeaponFireLastSightedSingleAnim=FireDouble

    WeaponIdleAnims(0)=Idle
    WeaponIdleAnims(1)=Idle
    WeaponIdleShoulderedAnims(0)=Idle
    WeaponIdleShoulderedAnims(1)=Idle

    WeaponIdleSightedAnims(0)=Idle
    WeaponIdleSightedAnims(1)=Idle

    WeaponCrawlingAnims(0)=ProneLoop
    WeaponCrawlStartAnim=ProneInitial
    WeaponCrawlEndAnim=ProneEnd

    WeaponReloadStripperAnim=Reload
    ReloadStripperDoubleAnim=Reload
    WeaponAltReloadStripperAnim=Reload
    WeaponAltReloadStripperIronAnim=Reload

    WeaponReloadEmptyMagIronAnim=Reload
    WeaponReloadNonEmptyMagIronAnim=Reload

    WeaponAmmoCheckAnim=M1917_ammocheck
    WeaponAmmoCheckIronAnim=M1917_ammocheck
    WeaponAltAmmoCheckAnim=M1917_Ammocheck//_uncocked
    WeaponAltAmmoCheckIronAnim=M1917_Ammocheck//_uncocked

    WeaponSprintStartAnim=RunInitial
    WeaponSprintLoopAnim=RunLoop
    WeaponSprintEndAnim=RunEnd

    WeaponMantleOverAnim=Vault

    WeaponSwitchToAltFireModeAnim=M1917_Manual_Hammer
    WeaponSightedSwitchToAltFireModeAnim=M1917_Manual_Hammer

    WeaponSpotEnemyAnim=M1917_SpotEnemy
    WeaponSpotEnemySightedAnim=M1917_SpotEnemy_ironsight

    WeaponMeleeAnims(0)=Melee

    MeleePullbackAnim=ChargeBegin
    MeleeHoldAnim=ChargeLoop
    WeaponMeleeHardAnim=ChargeEnd

    WeaponDryFireAnim=FireDouble
    WeaponDryFireSightedAnim=FireDouble

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
    BoltControllerNames[0]=EnfieldNo2_Hammer
    BoltControllerNames[1]=EnfieldNo2_Cylinder

    RoundBoneNames(0)=Enfield_Bullet1
    RoundBoneNames(1)=Enfield_Bullet2
    RoundBoneNames(2)=Enfield_Bullet3
    RoundBoneNames(3)=Enfield_Bullet4
    RoundBoneNames(4)=Enfield_Bullet5
    RoundBoneNames(5)=Enfield_Bullet6

    SightRanges.Empty
}
