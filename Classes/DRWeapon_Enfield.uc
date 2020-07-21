
class DRWeapon_Enfield extends ROProjectileWeapon
	abstract;

var(Animations) name ReloadStripperDoubleAnim;
var(Animations) name RestReloadStripperDoubleAnim;

simulated function bool ShouldLoadStripperClip()
{
	if((AmmoCount == 0) && NumFullStripperClips == 1)
	{
		return false;
	}
	
	return super(ROWeapon).ShouldLoadStripperClip();
}

simulated function bool ShouldLoadTwoStripperClips()
{
	if(NumFullStripperClips >= 2)
	{
		if(ShouldLoseRoundOnReload())
		{
			if(((MaxAmmoCount - AmmoCount) + 1) >= (2 * StripperClipBulletCount))
			{
				return true;
			}
		}
		else
		{
			if((MaxAmmoCount - AmmoCount) >= (2 * StripperClipBulletCount))
			{
				return true;
			}
		}
	}
	return false;
}

simulated function name GetReloadStripperX2AnimName()
{
	if(ROPawn(Instigator).IsInCover())
	{
		return RestReloadStripperDoubleAnim;
	}
	else
	{
		return ReloadStripperDoubleAnim;
	}
}

simulated function SightIndexUpdated()
{
	if(SightRotController != none)
	{
		SightRotController.BoneRotation.Pitch = SightRanges[SightRangeIndex].SightPitch;
	}
	
	if(SightSlideController != none)
	{
		SightSlideController.BoneTranslation.X = SightRanges[SightRangeIndex].SightSlideOffset;
	}
	
	IronSightPosition.Z = SightRanges[SightRangeIndex].SightPositionOffset;
	PlayerViewOffset.Z = SightRanges[SightRangeIndex].SightPositionOffset;
}

function bool GiveInitialAmmo(optional bool bResupplyOnly)
{
	local int InitialAmount;
	local bool bGivenAmmo;
	
	bGivenAmmo = super(ROWeapon).GiveInitialAmmo(bResupplyOnly);
	
	if((AmmoClass != none) && !bResupplyOnly)
	{
		InitialAmount = AmmoClass.default.InitialAmount;
		
		if((AddAmmo(InitialAmount)) > 0)
		{
			bGivenAmmo = true;
		}
	}
	return bGivenAmmo;
}

defaultproperties
{
	WeaponContentClass(0)="DesertRats.DRWeapon_Enfield_ActualContent"
	
	RoleSelectionImage(0)=Texture2D'VN_UI_Textures.WeaponTex.VN_Weap_MN1891-30_Rifle'
	
	WeaponClassType=ROWCT_Rifle
	
	TeamIndex=`ALLIES_TEAM_INDEX
	
	InvIndex=`WI_ENFIELD
	
	bDebugWeapon=false
	
	Category=ROIC_Primary
	Weight=4.0 // kg
	InventoryWeight=0
	PlayerIronSightFOV=40.0
	PreFireTraceLength=2500
	FiringStatesArray(0)=WeaponSingleFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'MN9130Bullet'
	FireInterval(0)=1.1//+1.5
	DelayedRecoilTime(0)=0.01
	Spread(0)=0.00012
	
	FiringStatesArray(ALTERNATE_FIREMODE)=WeaponManualSingleFiring
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	WeaponProjectiles(ALTERNATE_FIREMODE)=class'MN9130Bullet'
	FireInterval(ALTERNATE_FIREMODE)=1.1//+1.5
	DelayedRecoilTime(ALTERNATE_FIREMODE)=0.01
	Spread(ALTERNATE_FIREMODE)=0.00012
	
	MinBurstAmount=1
	MaxBurstAmount=1
	BurstWaitTime=0.5
	AILongDistanceScale=1.25f
	AIMediumDistanceScale=0.5f
	AISpreadScale=200.0
	AISpreadNoSeeScale=2.0
	AISpreadNMEStillScale=0.5
	AISpreadNMESprintScale=1.5
	
	maxRecoilPitch=850
	minRecoilPitch=725
	maxRecoilYaw=300
	minRecoilYaw=215
	RecoilRate=0.1
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=2000
	RecoilMinPitchLimit=63535
	RecoilISMaxYawLimit=500
	RecoilISMinYawLimit=65035
	RecoilISMaxPitchLimit=1500
	RecoilISMinPitchLimit=64035
	InstantHitDamage(0)=115
	InstantHitDamage(1)=115
	
	InstantHitDamageTypes(0)=class'RODmgType_MN9130Bullet'
	InstantHitDamageTypes(1)=class'RODmgType_MN9130Bullet'
	
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_Rifles_round'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'
	
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_VC_MN9130'
	
	bHasIronSights=true
	bHasManualBolting=true
	
	//Equip and putdown
	WeaponPutDownAnim=SMLE_Putaway
	WeaponEquipAnim=SMLE_Pullout
	WeaponDownAnim=SMLE_Down
	WeaponUpAnim=SMLE_Up

	// Fire Anims
	//Hip fire
	WeaponFireAnim(0)=SMLE_Hip_Bolt
	WeaponFireAnim(1)=SMLE_Hip_Bolt
	WeaponFireLastAnim=SMLE_Hip_ShootLAST
	
	//Shouldered fire
	WeaponFireShoulderedAnim(0)=SMLE_Hip_Bolt
	WeaponFireShoulderedAnim(1)=SMLE_Hip_Bolt
	WeaponFireLastShoulderedAnim=SMLE_Hip_ShootLAST
	
	//Fire using iron sights
	WeaponFireSightedAnim(0)=SMLE_Iron_Manual_Bolt
	WeaponFireSightedAnim(1)=SMLE_Iron_Manual_Bolt
	WeaponFireLastSightedAnim=SMLE_Iron_ShootLAST
	
	//Manual bolting
	WeaponManualBoltAnim=SMLE_Iron_Manual_Bolt
	WeaponManualBoltRestAnim=SMLE_Iron_Manual_Bolt_rest

	// Idle Anims
	//Hip Idle
	WeaponIdleAnims(0)=SMLE_Hip_Idle
	WeaponIdleAnims(1)=SMLE_Hip_Idle
	// Shouldered idle
	WeaponIdleShoulderedAnims(0)=SMLE_Hip_Idle
	WeaponIdleShoulderedAnims(1)=SMLE_Hip_Idle
	//Sighted Idle
	WeaponIdleSightedAnims(0)=SMLE_Iron_Idle
	WeaponIdleSightedAnims(1)=SMLE_Iron_Idle

	// Prone Crawl
	WeaponCrawlingAnims(0)=SMLE_CrawlF
	WeaponCrawlStartAnim=SMLE_Crawl_into
	WeaponCrawlEndAnim=SMLE_Crawl_out

	//Reloading
	WeaponReloadStripperAnim=				SMLE_Reload_Half
	ReloadStripperDoubleAnim=				SMLE_Reload_Empty
	WeaponReloadSingleBulletAnim=			SMLE_Rsingle_Insert
	WeaponReloadEmptySingleBulletAnim=		SMLE_Rsingle_Insert_empty
	WeaponOpenBoltAnim=						SMLE_Rsingle_Boltopen
	WeaponOpenBoltEmptyAnim=				SMLE_Rsingle_Boltopen_empty
	WeaponCloseBoltAnim=					SMLE_Rsingle_Boltclose
	
	WeaponRestReloadStripperAnim=			SMLE_Reload_Half_rest
	RestReloadStripperDoubleAnim=			SMLE_Reload_Empty_rest
	WeaponRestReloadSingleBulletAnim=		SMLE_Rsingle_Insert_rest
	WeaponRestReloadEmptySingleBulletAnim=	SMLE_Rsingle_Insert_empty_rest
	WeaponRestOpenBoltAnim=					SMLE_Rsingle_Boltopen_rest
	WeaponRestOpenBoltEmptyAnim=			SMLE_Rsingle_Boltopen_empty_rest
	WeaponRestCloseBoltAnim=				SMLE_Rsingle_Boltclose_rest
	
	// Ammo check
	WeaponAmmoCheckAnim=SMLE_ammocheck
	WeaponRestAmmoCheckAnim=SMLE_Ammocheck_rest

	// Sprinting
	WeaponSprintStartAnim=SMLE_sprint_into
	WeaponSprintLoopAnim=SMLE_Sprint
	WeaponSprintEndAnim=SMLE_sprint_out
	Weapon1HSprintStartAnim=SMLE_sprint_into
	Weapon1HSprintLoopAnim=SMLE_Sprint
	Weapon1HSprintEndAnim=SMLE_sprint_out

	// Mantling
	WeaponMantleOverAnim=SMLE_Mantle

	// Cover/Blind Fire Anims
	WeaponRestAnim=SMLE_rest_idle
	WeaponEquipRestAnim=SMLE_pullout_rest
	WeaponPutDownRestAnim=SMLE_putaway_rest
	WeaponBlindFireRightAnim=SMLE_BF_Right_Shoot
	WeaponBlindFireLeftAnim=SMLE_BF_Left_Shoot
	WeaponBlindFireUpAnim=SMLE_BF_up_Shoot
	WeaponIdleToRestAnim=SMLE_idleTOrest
	WeaponRestToIdleAnim=SMLE_restTOidle
	WeaponRestToBlindFireRightAnim=SMLE_restTOBF_Right
	WeaponRestToBlindFireLeftAnim=SMLE_restTOBF_Left
	WeaponRestToBlindFireUpAnim=SMLE_restTOBF_up
	WeaponBlindFireRightToRestAnim=SMLE_BF_Right_TOrest
	WeaponBlindFireLeftToRestAnim=SMLE_BF_Left_TOrest
	WeaponBlindFireUpToRestAnim=SMLE_BF_up_TOrest
	WeaponBFLeftToUpTransAnim=SMLE_BFleft_toBFup
	WeaponBFRightToUpTransAnim=SMLE_BFright_toBFup
	WeaponBFUpToLeftTransAnim=SMLE_BFup_toBFleft
	WeaponBFUpToRightTransAnim=SMLE_BFup_toBFright
	
	// Blind Fire ready
	WeaponBF_Rest2LeftReady=SMLE_restTO_L_ready
	WeaponBF_LeftReady2LeftFire=SMLE_L_readyTOBF_L
	WeaponBF_LeftFire2LeftReady=SMLE_BF_LTO_L_ready
	WeaponBF_LeftReady2Rest=SMLE_L_readyTOrest
	WeaponBF_Rest2RightReady=SMLE_restTO_R_ready
	WeaponBF_RightReady2RightFire=SMLE_R_readyTOBF_R
	WeaponBF_RightFire2RightReady=SMLE_BF_RTO_R_ready
	WeaponBF_RightReady2Rest=SMLE_R_readyTOrest
	WeaponBF_Rest2UpReady=SMLE_restTO_Up_ready
	WeaponBF_UpReady2UpFire=SMLE_Up_readyTOBF_Up
	WeaponBF_UpFire2UpReady=SMLE_BF_UpTO_Up_ready
	WeaponBF_UpReady2Rest=SMLE_Up_readyTOrest
	WeaponBF_LeftReady2Up=SMLE_L_ready_toUp_ready
	WeaponBF_LeftReady2Right=SMLE_L_ready_toR_ready
	WeaponBF_UpReady2Left=SMLE_Up_ready_toL_ready
	WeaponBF_UpReady2Right=SMLE_Up_ready_toR_ready
	WeaponBF_RightReady2Up=SMLE_R_ready_toUp_ready
	WeaponBF_RightReady2Left=SMLE_R_ready_toL_ready
	WeaponBF_LeftReady2Idle=SMLE_L_readyTOidle
	WeaponBF_RightReady2Idle=SMLE_R_readyTOidle
	WeaponBF_UpReady2Idle=SMLE_Up_readyTOidle
	WeaponBF_Idle2UpReady=SMLE_idleTO_Up_ready
	WeaponBF_Idle2LeftReady=SMLE_idleTO_L_ready
	WeaponBF_Idle2RightReady=SMLE_idleTO_R_ready

	// Melee anims
	WeaponMeleeAnims(0)=SMLE_Bash
	WeaponMeleeHardAnim=SMLE_BashHard
	MeleePullbackAnim=SMLE_Pullback
	MeleeHoldAnim=SMLE_Pullback_Hold
	
	EquipTime=+0.75
	PutDownTime=+0.50
	BoltControllerNames[0]=Hammer_9130
	ISFocusDepth=30
	ISFocusBlendRadius=12
	
	AmmoClass=class'ROAmmo_762x54R_MNStripper'
	MaxAmmoCount=10
	bUsesMagazines=false
	InitialNumPrimaryMags=12
	bLosesRoundOnReload=true
	bPlusOneLoading=false
	bCanReloadNonEmptyMag=true
	bCanLoadStripperClip=true
	bCanLoadSingleBullet=true
	StripperClipBulletCount=5
	
	PenetrationDepth=23.4
	MaxPenetrationTests=3
	MaxNumPenetrations=2
	PerformReloadPct=0.60f
	
	PlayerViewOffset=(X=2.0,Y=8.0,Z=-5)
	ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
	ShoulderedTime=0.35
	ShoulderedPosition=(X=2.50,Y=4.0,Z=-2.0)
	ShoulderRotation=(Pitch=-500,Yaw=0,Roll=2500)
	IronSightPosition=(X=2.0,Y=0,Z=-0.03)
	
	bUsesFreeAim=true
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
	FreeAimHipfireOffsetX=45
	
	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=50,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.200)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	
	CollisionCheckLength=45.5
	
	FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MN9130_Shoot'
	FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MN9130_Shoot'
	
	SightSlideControlName=Sight_Rotation
	SightRotControlName=Sight_Rotation
	
	// SightRanges[0]=(SightRange=100,SightPitch=60,SightSlideOffset=0.05,SightPositionOffset=-0.03)
	
	SuppressionPower=20
	
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M40.Play_WEP_M40_Fire_Single_3P',FirstPersonCue=AkEvent'WW_WEP_M40.Play_WEP_M40_Fire_Single')
	WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M40.Play_WEP_M40_Fire_Single_3P',FirstPersonCue=AkEvent'WW_WEP_M40.Play_WEP_M40_Fire_Single')
}
