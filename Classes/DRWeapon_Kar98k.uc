
class DRWeapon_Kar98k extends ROWeap_MN9130_Rifle
	abstract;

defaultproperties
{
	WeaponContentClass(0)="DesertRats.DRWeapon_Kar98k_ActualContent"
	
	// RoleSelectionImage(0)=Texture2D'GOM3_UI.WP_Render.ger_wp_kar98_rifle'
	
	InvIndex=`WI_KAR98
	
	bDebugWeapon=false
	
	BoltControllerNames[0]=BoltSlide_Kar98
	
	PlayerViewOffset=(X=0.0,Y=8.0,Z=-5)
	ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
	ShoulderedTime=0.35
	ShoulderedPosition=(X=0.5,Y=4.0,Z=-2.0)
	ShoulderRotation=(Pitch=-500,Yaw=0,Roll=2500)
	IronSightPosition=(X=0,Y=0,Z=-0.05)
	
	InstantHitDamageTypes(0)=class'RODmgType_MN9130Bullet'
	InstantHitDamageTypes(1)=class'RODmgType_MN9130Bullet'
	
	WeaponSpotEnemyAnim=K98_Hip_Idle
	WeaponSpotEnemySightedAnim=K98_Iron_Idle
	
	WeaponPutDownAnim=K98_Putaway
	WeaponEquipAnim=K98_Pullout
	WeaponDownAnim=K98_Down
	WeaponUpAnim=K98_Up
	
	WeaponFireAnim(0)=K98_Hip_Bolt
	WeaponFireAnim(1)=K98_Hip_Bolt
	WeaponFireLastAnim=K98_Hip_ShootLAST
	
	WeaponFireShoulderedAnim(0)=K98_Hip_Bolt
	WeaponFireShoulderedAnim(1)=K98_Hip_Bolt
	WeaponFireLastShoulderedAnim=K98_Hip_ShootLAST
	
	WeaponFireSightedAnim(0)=K98_Iron_Bolt
	WeaponFireSightedAnim(1)=K98_Iron_Bolt
	WeaponFireLastSightedAnim=K98_Iron_ShootLAST
	
	WeaponManualBoltAnim=K98_Iron_Manual_Bolt
	
	WeaponIdleAnims(0)=K98_Hip_Idle
	WeaponIdleAnims(1)=K98_Hip_Idle
	WeaponIdleShoulderedAnims(0)=K98_Hip_Idle
	WeaponIdleShoulderedAnims(1)=K98_Hip_Idle
	
	WeaponIdleSightedAnims(0)=K98_Iron_Idle
	WeaponIdleSightedAnims(1)=K98_Iron_Idle
	
	WeaponCrawlingAnims(0)=K98_CrawlF
	WeaponCrawlStartAnim=K98_Crawl_into
	WeaponCrawlEndAnim=K98_Crawl_out
	
	WeaponReloadStripperAnim=K98_Reload
	WeaponReloadSingleBulletAnim=K98_Rsingle_Insert
	WeaponReloadEmptySingleBulletAnim=K98_Rsingle_Insert_empty
	WeaponOpenBoltAnim=K98_Rsingle_Boltopen
	WeaponOpenBoltEmptyAnim=K98_Rsingle_Boltopen_empty
	WeaponCloseBoltAnim=K98_Rsingle_Boltclose
	
	WeaponAmmoCheckAnim=K98_ammocheck
	
	WeaponSprintStartAnim=K98_sprint_into
	WeaponSprintLoopAnim=K98_Sprint
	WeaponSprintEndAnim=K98_sprint_out
	Weapon1HSprintStartAnim=K98_ger_sprint_into
	Weapon1HSprintLoopAnim=K98_ger_sprint
	Weapon1HSprintEndAnim=K98_ger_sprint_out
	
	WeaponMantleOverAnim=K98_Mantle
	
	WeaponMeleeAnims(0)=K98_Bash
	WeaponBayonetMeleeAnims(0)=K98_Stab
	WeaponMeleeHardAnim=K98_BashHard
	WeaponBayonetMeleeHardAnim=K98_StabHard
	MeleePullbackAnim=K98_Pullback
	MeleeHoldAnim=K98_Pullback_Hold
	
	WeaponAttachBayonetAnim=K98_Bayonet_Attach
	WeaponDetachBayonetAnim=K98_Bayonet_Detach
	
	BayonetSkelControlName=Bayonet_Position
	
	SightSlideControlName=Sight_Slide
	SightRotControlName=Sight_Rotation
	
	SightRanges.Empty()
	SightRanges[0]=(SightRange=100,SightPitch=60,SightSlideOffset=0.0,SightPositionOffset=-0.05)
	SightRanges[1]=(SightRange=200,SightPitch=165,SightSlideOffset=0.2,SightPositionOffset=-0.1)
	SightRanges[2]=(SightRange=300,SightPitch=280,SightSlideOffset=0.36,SightPositionOffset=-0.17)
	SightRanges[3]=(SightRange=400,SightPitch=400,SightSlideOffset=0.48,SightPositionOffset=-0.24)
}