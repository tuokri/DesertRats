//=============================================================================
// DRWeap_Boys_AT.uc
//=============================================================================
// Boys Anti-Tank Rifle
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Authored by adriaN$t3@m
//=============================================================================
class DRWeap_Boys_AT extends ROATWeapon;

simulated function bool CanTransitionToIronSights()
{
	super.CanTransitionToIronSights();

	return (ROPawn(Instigator).bBipodDeployed ||
			ROPawn(Instigator).bBipodDeployedNoCover ||
			ROPawn(Instigator).bCanDeployNoCover ||
			Instigator.bIsProning ||
			bIronSightOnBringUp);
}

/*
// Don't bolt if you are not ADS
simulated function bool AllowManualBolting()
{
	super.AllowManualBolting();

	return (ROPawn(Instigator).bBipodDeployed ||
			ROPawn(Instigator).bBipodDeployedNoCover ||
			ROPawn(Instigator).bCanDeployNoCover ||
			Instigator.bIsProning ||
			bIronSightOnBringUp);
}
*/

defaultproperties
{
	WeaponContentClass(0)="DesertRats.DRWeap_Boys_AT_Content"

	RoleSelectionImage(0)=none //TODO: Give it a picture!

	WeaponClassType=ROWCT_ATRifle
	TeamIndex=`ALLIES_TEAM_INDEX
	Category=ROIC_Primary
	Weight=10.45                  //TODO: Give it proper weight value maybe?
	RoleEncumbranceModifier=0.5
	InvIndex=`DRII_BOYS_AT
	InventoryWeight=4

	PlayerIronSightFOV=55.0 //I usually use 70 but in this case this is not GOM 4! Sticking with default values for now...

	// MAIN FIREMODE
	FiringStatesArray(0)=WeaponSingleFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'DRBullet_Boys'
	FireInterval(0)=4//+1.5
	DelayedRecoilTime(0)=0.01
	Spread(0)=0.000414 // 1.5 MOA

	//ShoulderedSpreadMod=3.0//6.0
	//HippedSpreadMod=5.0//10.0

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=WeaponManualSingleFiring
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRBullet_Boys'
	FireInterval(ALTERNATE_FIREMODE)=4//+1.5
	DelayedRecoilTime(ALTERNATE_FIREMODE)=0.01
	Spread(ALTERNATE_FIREMODE)=0.000414 // 1.5 MOA

    FireModeCanUseClientSideHitDetection[DEFAULT_FIREMODE]=false
    FireModeCanUseClientSideHitDetection[ALTERNATE_FIREMODE]=false
    FireModeCanUseClientSideHitDetection[MELEE_ATTACK_FIREMODE]=false

	// TODO: Fix the pre-fire trace not handling hitting vehicles properly
	PreFireTraceLength=10//2500 //50 Meters
	FireTweenTime=0.025

	ShoulderedSpreadMod=6.0
	HippedSpreadMod=10.0

	// AI
	MinBurstAmount=1
	MaxBurstAmount=1
	BurstWaitTime=2.5

	// Recoil
	maxRecoilPitch=1250
	minRecoilPitch=860
	maxRecoilYaw=180
	minRecoilYaw=-180
	RecoilRate=0.15
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=1500
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=800
	RecoilISMinYawLimit=65035
	RecoilISMaxPitchLimit=900
	RecoilISMinPitchLimit=65035
   	RecoilBlendOutRatio=0.55
   	PostureHippedRecoilModifer=6.15
   	PostureShoulderRecoilModifer=3.85
   	RecoilViewRotationScale=0.45

	InstantHitDamage(0)=125
	InstantHitDamage(1)=125

	InstantHitDamageTypes(0)=class'DRDmgType_BoysBullet'
	InstantHitDamageTypes(1)=class'DRDmgType_BoysBullet'

	InstantHitMomentum(0)=1000
	InstantHitMomentum(1)=1000

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_DShK' 
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=none//class'ROGame.ROGrenadeExplosionLight'//class'ROGame.RORifleMuzzleFlashLight'

	// Shell eject FX
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'DR_WEP_CW_BOYS.ShellEjects.Boys_ShellEject' //TODO: Make a better one soon.
	bNoShellEjectOnFire=true

	//Equip and putdown
	WeaponPutDownAnim=PutAway_30
	WeaponEquipAnim=Select_65
	WeaponDownAnim=PutAway_30
	WeaponUpAnim=Select_65

	// Fire Anims
	//Hip fire
	//Fire using iron sights
	WeaponFireSightedAnim(0)=fire
	WeaponFireSightedAnim(1)=fire
	WeaponFireLastSightedAnim=fire //TODO: Replace Me Soon with proper script on bone controller!

	WeaponFireDeployedAnim(0)=fire
	WeaponFireDeployedAnim(1)=fire
	WeaponFireLastDeployedAnim=fire
	// Idle Anims
	WeaponIdleDeployedAnims(0)=Idle_bipod
	WeaponIdleDeployedAnims(1)=Idle_bipod
	//Hip Idle
	WeaponIdleAnims(0)=Idle
	WeaponIdleAnims(1)=Idle
	// Shouldered idle
	WeaponIdleShoulderedAnims(0)=Idle
	WeaponIdleShoulderedAnims(1)=Idle
	//Sighted Idle
	WeaponIdleSightedAnims(0)=Idle_bipod //TODO: Replace Me Soon!
	WeaponIdleSightedAnims(1)=Idle_bipod //TODO: Replace Me Soon!

	//Reloading
	WeaponManualBoltAnim=bolting

	// Enemy Spotting
	WeaponSpotEnemyAnim=Idle
	WeaponSpotEnemySightedAnim=Idle
	WeaponSpotEnemyDeployedAnim=bipod_spot

	// Ammo check
	WeaponAmmoCheckAnim=Bipod_Check_187
	WeaponRestAmmoCheckAnim=Bipod_Check_187
	DeployAmmoCheckAnim=Bipod_Check_187

	// Sprinting

	WeaponSprintStartAnim=Select_65 //TODO: Replace Me Soon!
	WeaponSprintLoopAnim=Run
	WeaponSprintEndAnim=Select_65 //TODO: Replace Me Soon!
	Weapon1HSprintStartAnim=Select_65 //TODO: Replace Me Soon!
	Weapon1HSprintLoopAnim=Run
	Weapon1HSprintEndAnim=Select_65 //TODO: Replace Me Soon!

	// Mantling
	WeaponMantleOverAnim=Mantle_60

	// Cover/Blind Fire Anims
	WeaponRestAnim=Idle
	WeaponEquipRestAnim=Idle
	WeaponPutDownRestAnim=Idle

	// Reload
	WeaponReloadEmptyMagAnim=emptyreloadtest
	WeaponReloadNonEmptyMagAnim=reloadtest
	WeaponRestReloadEmptyMagAnim=emptyreloadtest
	WeaponRestReloadNonEmptyMagAnim=reloadtest
	DeployReloadEmptyMagAnim=bipod_reload_empty
	DeployReloadHalfMagAnim=bipod_reload

	ReloadMagazinEmptyCameraAnim=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_reloadempty'

	EquipTime=+1.00
	PutDownTime=+0.75

	bDebugWeapon = false

  	//BoltControllerNames[0]=Bolt

	ISFocusDepth=30
	ISFocusBlendRadius=16

	// Ammo
	AmmoClass=class'DRAmmo_Boys' //TODO:Replace with proper values
	MaxAmmoCount=6 // Each magazine holds 5 rounds. So that means we add an extra round for the chamber!
	bUsesMagazines=true
	InitialNumPrimaryMags=5 // Hoover said that we can carry 5 spare magazines
	bPlusOneLoading=true
	bCanReloadNonEmptyMag=true
	bCanLoadStripperClip=false
	bCanLoadSingleBullet=false
	PenetrationDepth=38.1
	MaxPenetrationTests=3
	MaxNumPenetrations=4


	// Y KEY NEGATIVE = LEFT POSITIVE = RIGHT
	// X FORWARD AND BACK
	// Z UP AND DOWN

	PlayerViewOffset=(X=17,Y=0.0,Z=-5)
	ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
	ShoulderedTime=0.35
	ShoulderedPosition=(X=15,Y=0.0,Z=-2.0)// (X=0,Y=1,Z=-1.4)
	ShoulderRotation=(Pitch=-500,Yaw=0,Roll=2500)
	IronSightPosition=(X=4.0,Y=0,Z=0.0)
	ZoomInTime=0.5//0.65
	ZoomOutTime=0.35//0.6


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
		Samples(0)=(LeftAmplitude=30,RightAmplitude=50,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.150)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	CollisionCheckLength=50.0 //TODO:Put the real value here?

	DeployedSwayScale=0.05

	bHasIronSights=true;
	bHasManualBolting=true;
	bAmmoCheckDoesBolting=true

	// Prone Crawl
	WeaponCrawlingAnims(0)=Select_65 //TODO: Replace Me Soon!
	WeaponCrawlStartAnim=Run //TODO: Replace Me Soon!
	WeaponCrawlEndAnim=Select_65 //TODO: Replace Me Soon!
	// Deployed Prone Crawl
	RedeployCrawlingAnims(0)=idle_2_bipod

	PitchControlName=PitchControl
	BipodZCheckDist=25.0
	bHasBipod=true
	DeployAnimName=idle_2_bipod
	UnDeployAnimName=bipod_2_idle
	RestDeployAnimName=idle_2_bipod
	RestUnDeployAnimName=bipod_2_idle
	DeployToShuffleAnimName=Bipod_Move_45
	ShuffleIdleAnimName=Bipod_Move_45 //TODO: Replace Me Soon!
	ShuffleToDeployAnimName=Bipod_Move_45 //TODO: Replace Me Soon!
	RedeployProneTurnAnimName=Bipod_Move_45 //TODO: Replace Me Soon!
	UnDeployProneTurnAnimName=Bipod_Move_45 //TODO: Replace Me Soon!
	ProneTurningIdleAnimName=Bipod_Move_45 //TODO: Replace Me Soon!
	BipodPivotBoneName=Bipod

	// 19.5 Z offset to ground from 0,0,0

	FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_DP28_Shoot'
	FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_DP28_Shoot'
	ShakeScaleControlled=0.65

	SightSlideControlName=Sight_Slide
	SightRotControlName=Sight_Rotation
}
