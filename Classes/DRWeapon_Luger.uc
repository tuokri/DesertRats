
class DRWeapon_Luger extends ROProjectileWeapon
	abstract;

var name RoundBoneNames[8];

var name MagFollowerSkelControlName;

var SkelControlBase MagFollowerSkelControl;

var int UpcomingMagAmmoCount;

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	
	if(MagFollowerSkelControlName != 'none')
	{
		MagFollowerSkelControl = SkelComp.FindSkelControl(MagFollowerSkelControlName);
	}
}

simulated function FireAmmunition()
{
	super.FireAmmunition();
	UpdateRounds(false);
}

simulated function TimeAmmoCheck()
{
	super.TimeAmmoCheck();
	UpdateRounds(false);
}

private reliable client function SendNextMagAmmoCount(int NewMagCount)
{
	UpcomingMagAmmoCount = NewMagCount;
}

simulated function TimeReloading()
{
	if( Role == ROLE_Authority )
	{
		UpcomingMagAmmoCount = AmmoArray.Length > 0 ? AmmoArray[GetNextMagIndex(AmmoCount <= 0)] : 0;
		SendNextMagAmmoCount(UpcomingMagAmmoCount);
	}
	
	UpdateRounds(false);
	
	super.TimeReloading();
}

simulated function UpdateRoundsTimeReloading()
{
	UpdateRounds(true);
}

simulated function UpdateRounds(bool bReloadingAnimNotify)
{
	local SkeletalMeshComponent SkelMesh;
	local int i, NumRoundsInMag;
	
	SkelMesh = SkeletalMeshComponent(Mesh);
	
	NumRoundsInMag = bReloadingAnimNotify ? UpcomingMagAmmoCount : AmmoCount - 1;
	
	if(SkelMesh != none)
	{
		for(i = 0; i < MaxAmmoCount /*- 1*/; ++i)
		{
			if(i >= NumRoundsInMag)
			{
				SkelMesh.HideBoneByName(RoundBoneNames[i], PBO_Disable);
			}
			else
			{
				SkelMesh.UnHideBoneByName(RoundBoneNames[i]);
			}
		}
	}
	
	if(MagFollowerSkelControl != none)
	{
		MagFollowerSkelControl.SetSkelControlStrength( 1 - FPctByRange(NumRoundsInMag, 0, MaxAmmoCount /*- 1*/), 0.f );
	}
}

`include(DesertRats\Classes\DRWeaponPickupMessagesOverride.uci)

defaultproperties
{
	WeaponContentClass(0)="DesertRats.DRWeapon_Luger_ActualContent"
	
	// RoleSelectionImage(0)=
	
	WeaponClassType=ROWCT_HandGun
	
	TeamIndex=`AXIS_TEAM_INDEX
	
	InvIndex=`WI_LUGER
	
	Category=ROIC_Secondary
	Weight=0.90
	InventoryWeight=0
	RoleEncumbranceModifier=0.0
	
	PlayerIronSightFOV=60.0
	
	// MAIN FIREMODE
	FiringStatesArray(0)=WeaponSingleFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'DRProjectile_Luger'
	FireInterval(0)=+0.15
	Spread(0)=0.013 //0.011
	
	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=none
	//WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	WeaponProjectiles(ALTERNATE_FIREMODE)=none
	FireInterval(ALTERNATE_FIREMODE)=+0.15
	Spread(ALTERNATE_FIREMODE)=0
	
	PreFireTraceLength=1250 //25 Meters
	
	ShoulderedSpreadMod=6.0
	HippedSpreadMod=10.0
	
	MinBurstAmount=1
	MaxBurstAmount=3
	BurstWaitTime=1.5
	AISpreadScale=20.0
	
	maxRecoilPitch=500
	minRecoilPitch=350
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
	
	InstantHitDamage(0)=69
	InstantHitDamage(1)=69
	
	InstantHitDamageTypes(0)=class'DRDmgType_Luger'
	InstantHitDamageTypes(1)=class'DRDmgType_Luger'
	
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_Pistol'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'
	
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_USA_M1911A1Pistol'
	
	bHasIronSights=true
	
	PlayerViewOffset=(X=7.0,Y=8.0,Z=-5)
	ShoulderedPosition=(X=8.5,Y=4.0,Z=-2.0)
	IronSightPosition=(X=5.0,Y=0,Z=0.0)
	
	WeaponEquipAnim=Lahti_pullout
	WeaponPutDownAnim=Lahti_putaway
	
	WeaponUpAnim=Lahti_pullout//Lahti_Up
	WeaponDownAnim=Lahti_putaway//Lahti_Down
	
	WeaponFireAnim(0)=Lahti_shoot
	WeaponFireAnim(1)=Lahti_shoot
	WeaponFireLastAnim=Lahti_shoot_last
	
	WeaponFireShoulderedAnim(0)=Lahti_shoot
	WeaponFireShoulderedAnim(1)=Lahti_shoot
	WeaponFireLastShoulderedAnim=Lahti_shoot_last
	
	WeaponFireSightedAnim(0)=Lahti_shoot
	WeaponFireSightedAnim(1)=Lahti_shoot
	WeaponFireLastSightedAnim=Lahti_shoot_last
	
	WeaponIdleAnims(0)=Lahti_idle
	WeaponIdleAnims(1)=Lahti_idle
	WeaponIdleShoulderedAnims(0)=Lahti_idle
	WeaponIdleShoulderedAnims(1)=Lahti_idle
	
	WeaponIdleSightedAnims(0)=Lahti_iron_idle
	WeaponIdleSightedAnims(1)=Lahti_iron_idle
	
	WeaponCrawlingAnims(0)=Lahti_Crawl
	WeaponCrawlStartAnim=Lahti_Crawl_into
	WeaponCrawlEndAnim=Lahti_Crawl_out
	
	WeaponReloadNonEmptyMagAnim=Luger_reloadhalf
	WeaponReloadEmptyMagAnim=Luger_reloadempty
	
	WeaponAmmoCheckAnim=Luger_ammocheck
	
	WeaponSprintStartAnim=Lahti_sprint_into
	WeaponSprintLoopAnim=Lahti_sprint
	WeaponSprintEndAnim=Lahti_sprint_out
	
	Weapon1HSprintStartAnim=Lahti_sprint_into
	Weapon1HSprintLoopAnim=Lahti_sprint
	Weapon1HSprintEndAnim=Lahti_sprint_out
	
	WeaponMantleOverAnim=Lahti_Mantle
	
	WeaponSpotEnemyAnim=Lahti_SpotEnemy
	WeaponSpotEnemySightedAnim=Lahti_SpotEnemy_ironsight
	
	WeaponMeleeAnims(0)=Lahti_Bash
	WeaponMeleeHardAnim=Lahti_BashHard
	MeleePullbackAnim=Lahti_Pullback
	MeleeHoldAnim=Lahti_Pullback_Hold
	
	BoltControllerNames[0]=SlideControl_Barrel
	BoltControllerNames[1]=SlideControl_MainSlide
	BoltControllerNames[2]=SlideControl_Toggle
	BoltControllerNames[3]=SlideControl_Link
	
	MagFollowerSkelControlName=FeedControl
	
	RoundBoneNames(0)=B1
	RoundBoneNames(1)=B2
	RoundBoneNames(2)=B3
	RoundBoneNames(3)=B4
	RoundBoneNames(4)=B5
	RoundBoneNames(5)=B6
	RoundBoneNames(6)=B7
	RoundBoneNames(7)=B8
	
	EquipTime=+0.50
	PutDownTime=+0.33
	
	bDebugWeapon=false
	
	ISFocusDepth=20
	ISFocusBlendRadius=8

	// Ammo
	MaxAmmoCount=8
	AmmoClass=class'ROAmmo_9x19_BHPMag'
	bUsesMagazines=true
	InitialNumPrimaryMags=4
	bPlusOneLoading=true
	bCanReloadNonEmptyMag=true
	bCanLoadStripperClip=false
	bCanLoadSingleBullet=false
	//StripperClipBulletCount=10
	PenetrationDepth=10
	MaxPenetrationTests=3
	MaxNumPenetrations=2
	PerformReloadPct=0.81f
	
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
	
	SuppressionPower=5
}
