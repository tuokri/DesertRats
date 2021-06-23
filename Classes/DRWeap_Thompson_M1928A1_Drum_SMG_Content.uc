class DRWeap_Thompson_M1928A1_Drum_SMG_Content extends DRWeap_Thompson_M1928A1_SMG;

DefaultProperties
{
    AttachmentClass=class'DRWeapAttach_Thompson_M1928A1_Drum_SMG'

    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_UK_M1928A1.Mesh.M1928A1_Thompson_Grip'
        PhysicsAsset=PhysicsAsset'DR_WP_UK_M1928A1.Phy.M1928A1_Thompson_Grip_Physics'
        AnimSets(0)=AnimSet'DR_WP_UK_M1928A1.Animation.WP_M1928Thompson_UPGD3'
        AnimTreeTemplate=AnimTree'DR_WP_UK_M1928A1.Animation.USA_M1928A1_AnimTree'
        Scale=1.0
        FOV=70
    End Object

    // ArmsAnimSet=AnimSet'DR_WP_UK_M1928A1.Animation.WP_M1928ThompsonHands'
    ArmsAnimSet=AnimSet'DR_WP_UK_M1928A1.Animation.WP_M1928Thompson_UPGD3'

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_UK_M1928A1.Mesh.Thompson_3rd_Master_UPGD3'
        //? PhysicsAsset=PhysicsAsset'DR_WP_UK_M1928A1.Phy.Thompson_3rd_Master_UPGD2_Physics'
        AnimTreeTemplate=AnimTree'DR_WP_UK_M1928A1.Animation.USA_M1928A1_AnimTree'
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=true
        BlockNonZeroExtent=true//false
        BlockRigidBody=true
        bHasPhysicsAssetInstance=false
        bUpdateKinematicBonesFromAnimation=false
        PhysicsWeight=1.0
        RBChannel=RBCC_GameplayPhysics
        RBCollideWithChannels=(Default=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
        bSkipAllUpdateWhenPhysicsAsleep=TRUE
        bSyncActorLocationToRootRigidBody=true
    End Object

    PlayerViewOffset=(X=2.5,Y=4.5,Z=-2.25)//(X=1,Y=4,Z=-2)
    IronSightPosition=(X=-2,Y=0,Z=0)

    //Equip and putdown
    WeaponPutDownAnim=M1928A1_putaway
    WeaponEquipAnim=M1928A1_pullout
    WeaponDownAnim=M1928A1_Down
    WeaponUpAnim=M1928A1_Up

    // Fire Anims
    //Hip fire
    WeaponFireAnim(0)=M1928A1_Hip_Shoot
    WeaponFireAnim(1)=M1928A1_Hip_Shoot
    WeaponFireLastAnim=M1928A1_shootLAST
    //Shouldered fire
    WeaponFireShoulderedAnim(0)=M1928A1_Hip_Shoot
    WeaponFireShoulderedAnim(1)=M1928A1_Hip_Shoot
    WeaponFireLastShoulderedAnim=M1928A1_shootLAST
    //Fire using iron sights
    WeaponFireSightedAnim(0)=M1928A1_iron_shoot
    WeaponFireSightedAnim(1)=M1928A1_iron_shoot
    WeaponFireLastSightedAnim=M1928A1_iron_shootLAST

    // Idle Anims
    //Hip Idle
    WeaponIdleAnims(0)=M1928A1_shoulder_idle
    WeaponIdleAnims(1)=M1928A1_shoulder_idle
    // Shouldered idle
    WeaponIdleShoulderedAnims(0)=M1928A1_shoulder_idle
    WeaponIdleShoulderedAnims(1)=M1928A1_shoulder_idle
    //Sighted Idle
    WeaponIdleSightedAnims(0)=M1928A1_iron_idle
    WeaponIdleSightedAnims(1)=M1928A1_iron_idle

    // Prone Crawl
    WeaponCrawlingAnims(0)=M1928A1_CrawlF
    WeaponCrawlStartAnim=M1928A1_Crawl_into
    WeaponCrawlEndAnim=M1928A1_Crawl_out

    //Reloading
    WeaponReloadEmptyMagAnim=M1928A1_reloadempty
    WeaponReloadNonEmptyMagAnim=M1928A1_reloadhalf
    WeaponRestReloadEmptyMagAnim=M1928A1_reloadempty_rest
    WeaponRestReloadNonEmptyMagAnim=M1928A1_reloadhalf_rest
    // Ammo check
    WeaponAmmoCheckAnim=M1928A1_ammocheck
    WeaponRestAmmoCheckAnim=M1928A1_ammocheck_rest

    // Sprinting
    WeaponSprintStartAnim=M1928A1_sprint_into
    WeaponSprintLoopAnim=M1928A1_Sprint
    WeaponSprintEndAnim=M1928A1_sprint_out
    Weapon1HSprintStartAnim=M1928A1_1H_sprint_into
    Weapon1HSprintLoopAnim=M1928A1_1H_sprint
    Weapon1HSprintEndAnim=M1928A1_1H_sprint_out

    // Mantling
    WeaponMantleOverAnim=M1928A1_Mantle

    // Cover/Blind Fire Anims
    WeaponRestAnim=M1928A1_rest_idle
    WeaponEquipRestAnim=M1928A1_pullout_rest
    WeaponPutDownRestAnim=M1928A1_putaway_rest
    WeaponBlindFireRightAnim=M1928A1_BF_Right_Shoot
    WeaponBlindFireLeftAnim=M1928A1_BF_Left_Shoot
    WeaponBlindFireUpAnim=M1928A1_BF_up_Shoot
    WeaponIdleToRestAnim=M1928A1_idleTOrest
    WeaponRestToIdleAnim=M1928A1_restTOidle
    WeaponRestToBlindFireRightAnim=M1928A1_restTOBF_Right
    WeaponRestToBlindFireLeftAnim=M1928A1_restTOBF_Left
    WeaponRestToBlindFireUpAnim=M1928A1_restTOBF_up
    WeaponBlindFireRightToRestAnim=M1928A1_BF_Right_TOrest
    WeaponBlindFireLeftToRestAnim=M1928A1_BF_Left_TOrest
    WeaponBlindFireUpToRestAnim=M1928A1_BF_up_TOrest
    WeaponBFLeftToUpTransAnim=M1928A1_BFleft_toBFup
    WeaponBFRightToUpTransAnim=M1928A1_BFright_toBFup
    WeaponBFUpToLeftTransAnim=M1928A1_BFup_toBFleft
    WeaponBFUpToRightTransAnim=M1928A1_BFup_toBFright
    // Blind Fire ready
    WeaponBF_Rest2LeftReady=M1928A1_restTO_L_ready
    WeaponBF_LeftReady2LeftFire=M1928A1_L_readyTOBF_L
    WeaponBF_LeftFire2LeftReady=M1928A1_BF_LTO_L_ready
    WeaponBF_LeftReady2Rest=M1928A1_L_readyTOrest
    WeaponBF_Rest2RightReady=M1928A1_restTO_R_ready
    WeaponBF_RightReady2RightFire=M1928A1_R_readyTOBF_R
    WeaponBF_RightFire2RightReady=M1928A1_BF_RTO_R_ready
    WeaponBF_RightReady2Rest=M1928A1_R_readyTOrest
    WeaponBF_Rest2UpReady=M1928A1_restTO_Up_ready
    WeaponBF_UpReady2UpFire=M1928A1_Up_readyTOBF_Up
    WeaponBF_UpFire2UpReady=M1928A1_BF_UpTO_Up_ready
    WeaponBF_UpReady2Rest=M1928A1_Up_readyTOrest
    WeaponBF_LeftReady2Up=M1928A1_L_ready_toUp_ready
    WeaponBF_LeftReady2Right=M1928A1_L_ready_toR_ready
    WeaponBF_UpReady2Left=M1928A1_Up_ready_toL_ready
    WeaponBF_UpReady2Right=M1928A1_Up_ready_toR_ready
    WeaponBF_RightReady2Up=M1928A1_R_ready_toUp_ready
    WeaponBF_RightReady2Left=M1928A1_R_ready_toL_ready
    WeaponBF_LeftReady2Idle=M1928A1_L_readyTOidle
    WeaponBF_RightReady2Idle=M1928A1_R_readyTOidle
    WeaponBF_UpReady2Idle=M1928A1_Up_readyTOidle
    WeaponBF_Idle2UpReady=M1928A1_idleTO_Up_ready
    WeaponBF_Idle2LeftReady=M1928A1_idleTO_L_ready
    WeaponBF_Idle2RightReady=M1928A1_idleTO_R_ready

    // Melee anims
    WeaponMeleeAnims(0)=M1928A1_Bash
    WeaponMeleeHardAnim=M1928A1_BashHard
    MeleePullbackAnim=M1928A1_Pullback
    MeleeHoldAnim=M1928A1_Pullback_Hold
}
