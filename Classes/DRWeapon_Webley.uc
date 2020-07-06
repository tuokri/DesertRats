
class DRWeapon_Webley extends ROProjectileWeapon
	abstract;

`include(DesertRats\Classes\DRWeaponPickupMessagesOverride.uci)

simulated function CauseShellEject(bool bPlayingFireEffects)
{
	if ( bPlayingFireEffects )
	{
		return;
	}
	
	Super.CauseShellEject(bPlayingFireEffects);
}

simulated function float GetSpreadMod()
{
	return 3 * super.GetSpreadMod();
}

defaultproperties
{
	WeaponContentClass(0)="DesertRats.DRWeapon_Webley_ActualContent"
	
	RoleSelectionImage(0)=Texture2D'WinterWar_UI.WP_Render.WP_Render_NagantRevolver'
	
	WeaponClassType=ROWCT_HandGun
	
	TeamIndex=`ALLIES_TEAM_INDEX
	
	InvIndex=`WI_WEBLEY
	
	Category=ROIC_Secondary
	Weight=0.79
	InventoryWeight=0
	WeaponDryFireSnd=AkEvent'WW_WEP_Shared.Play_WEP_Generic_Dry_Fire'
	RoleEncumbranceModifier=0.0

	PlayerIronSightFOV=65.0
	
	FiringStatesArray(0)=WeaponSingleFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'M1917Bullet'
	FireInterval(0)=+0.175
	Spread(0)=0.0048
	
	FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	WeaponProjectiles(ALTERNATE_FIREMODE)=class'M1917Bullet'
	FireInterval(ALTERNATE_FIREMODE)=+0.175
	Spread(ALTERNATE_FIREMODE)=0.0035
	
	PreFireTraceLength=1250 //25 Meters
	
	MinBurstAmount=1
	MaxBurstAmount=3
	BurstWaitTime=1.5
	AISpreadScale=20.0
	
	maxRecoilPitch=220//950
	minRecoilPitch=220//900
	maxRecoilYaw=70//100
	minRecoilYaw=-70//-100
	RecoilRate=0.1
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=750
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=500
	RecoilISMinYawLimit=65035
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65035
   	RecoilBlendOutRatio=0.65
	
	InstantHitDamage(0)=85
	InstantHitDamage(1)=85
	
	InstantHitDamageTypes(0)=class'RODmgType_M1917Bullet'
	InstantHitDamageTypes(1)=class'RODmgType_M1917Bullet'
	
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_Pistol'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'
	
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_USA_M1917_Revolver_Full'
	bNoShellEjectOnFire=true

	bHasIronSights=true;

	 //Equip and putdown
	WeaponPutDownAnim=1st_revolver_putaway
	WeaponEquipAnim=1st_revolver_pullout
	WeaponDownAnim=1st_revolver_Down
	WeaponUpAnim=1st_revolver_Up

	// Fire Anims
	//Hip fire
   	WeaponFireAnim(0)=1st_revolver_iron_shootdecocked
	WeaponFireAnim(1)=1st_revolver_iron_shootdecocked
	WeaponFireLastAnim=1st_revolver_iron_shootdecocked
	//Shouldered fire
	WeaponFireShoulderedAnim(0)=1st_revolver_iron_shootdecocked
	WeaponFireShoulderedAnim(1)=1st_revolver_iron_shootdecocked
	WeaponFireLastShoulderedAnim=1st_revolver_iron_shootdecocked
	//Fire using iron sights
   	WeaponFireSightedAnim(0)=1st_revolver_iron_shootdecocked
	WeaponFireSightedAnim(1)=1st_revolver_iron_shootdecocked
	WeaponFireLastSightedAnim=1st_revolver_iron_shootdecocked

	// Idle Anims
	//Hip Idle
   	WeaponIdleAnims(0)=1st_revolver_shoulder_idle_decocked
	WeaponIdleAnims(1)=1st_revolver_shoulder_idle_decocked
	// Shouldered idle
	WeaponIdleShoulderedAnims(0)=1st_revolver_shoulder_idle_decocked
	WeaponIdleShoulderedAnims(1)=1st_revolver_shoulder_idle_decocked
	//Sighted Idle
	WeaponIdleSightedAnims(0)=1st_revolver_iron_idle_decocked
	WeaponIdleSightedAnims(1)=1st_revolver_iron_idle_decocked

	// Prone Crawl
	WeaponCrawlingAnims(0)=1st_revolver_CrawlF
	WeaponCrawlStartAnim=1st_revolver_Crawl_into
	WeaponCrawlEndAnim=1st_revolver_Crawl_out

	//Reloading
	WeaponReloadSingleBulletAnim=1st_revolver_reloadInsert_NewReload
	WeaponOpenBoltAnim=1st_revolver_reloadOpen_NewReload
	WeaponCloseBoltAnim=1st_revolver_reloadClose_NewReload

	// Ammo check
	WeaponAmmoCheckAnim=1st_revolver_ammocheck

	// Sprinting
	WeaponSprintStartAnim=1st_revolver_sprint_into
	WeaponSprintLoopAnim=1st_revolver_Sprint
	WeaponSprintEndAnim=1st_revolver_sprint_out

	// Mantling
	WeaponMantleOverAnim=1st_revolver_Mantle

	// Melee anims
	WeaponMeleeAnims(0)=1st_revolver_Bash
	WeaponMeleeHardAnim=1st_revolver_BashHard
	MeleePullbackAnim=1st_revolver_Pullback
	MeleeHoldAnim=1st_revolver_Pullback_Hold

	EquipTime=+0.50
	PutDownTime=+0.33

	bDebugWeapon = true

  	//BoltControllerName=BoltSlide_MP40

	ISFocusDepth=20
	ISFocusBlendRadius=8

	// Ammo
	MaxAmmoCount=6
	AmmoClass=class'ROAmmo_1143x23_M1917Clip'
	bUsesMagazines=false
	InitialNumPrimaryMags=8
	bPlusOneLoading=false
	bCanReloadNonEmptyMag=false
	bCanLoadStripperClip=false
	bCanLoadSingleBullet=true
	PenetrationDepth=8.89
	MaxPenetrationTests=3
	MaxNumPenetrations=2

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
