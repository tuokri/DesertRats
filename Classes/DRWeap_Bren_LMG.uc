class DRWeap_Bren_LMG extends ROMGWeapon
    abstract;

var Name RecoilSkelControlName;
var(Recoil) GameSkelCtrl_Recoil RecoilSkelControl;

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super.PostInitAnimTree(SkelComp);

    if (RecoilSkelControlName != '')
    {
        RecoilSkelControl = GameSkelCtrl_Recoil(
            SkeletalMeshComponent(Mesh).FindSkelControl(RecoilSkelControlName));
    }
}

/*
simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration,
    optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
    if (bUsingSights && (Sequence == 'Bren_shoulder_shoot' || Sequence == 'Bren_shoulder_shootLAST'))
    {
        PlayRecoil();
    }
    else
    {
        super.PlayWeaponAnimation(Sequence, fDesiredDuration, bLoop, SkelMesh);
    }
}
*/

simulated function PlayRecoil()
{
    if (RecoilSkelControl != None)
    {
        `dr("recoiling");
        RecoilSkelControl.bPlayRecoil = True;
    }
}

/*
simulated function PlayAnimation(name Sequence, optional float fDesiredDuration,
    optional bool bLoop, optional float TweenTime = 0.1)
{
    // Hack to stop Bren ADS idle anim from swaying too much.
    if (bUsingSights && Sequence == 'Bren_shoulder_idle')
    {
        bLoop = False;
        fDesiredDuration = MaxInt;
    }

    // `dr("anim seq: " $ Sequence $ " t: " $ fDesiredDuration);

    super.PlayAnimation(Sequence, fDesiredDuration, bLoop, TweenTime);
}
*/

// Temp fix for left hand yaw.
// TODO: remove when (if) we have proper anims.
simulated state Reloading
{
    simulated function BeginState(name PreviousStateName)
    {
        local int NextMagIndex;
        local ROPawn ROP;

        ROP = ROPawn(Instigator);

        if ( Role == ROLE_Authority )
        {
            ROGameInfo(WorldInfo.Game).HandleBattleChatterEvent(Instigator, `BATTLECHATTER_Reloading);
        }

        if ( ROP != None )
        {
            if( bStationaryReload || ROP.bIsProning || ROP.bBipodDeployed || ROP.bBipodDeployedNoCover )
            {
                if( !bNoViewRotIgnoreOnReload )
                    BeginIgnoreViewRotation();
                ROP.HeavyWeaponAction();
            }

            if( ROP.bBipodDeployed || ROP.bBipodDeployedNoCover )
                ROP.SetBipodCamera(false, (ROP.IsInCover()) ? 0.25f : 0.15f);

            // 3rd person reload anims here
            ROP.PlayThirdPersonWeaponAction((HasAnyAmmo()) ? ROWAE_Reload : ROWAE_ReloadEmpty);
        }

        TimeReloading();

        // Cancel pending redeploy
        if ( bProneRedeployOnStop )
        {
            CancelProneRedeploy();
        }

        // How much ammo does our next mag have left in it?
        if ( Role == ROLE_Authority )
        {
            // Taken from PerformMagazineReload()
            if ( bPlusOneLoading )
            {
                //`warn("Plus one loading is set on a bipod, next magazine prediction won't work");
                NextMagAmmoCount = -1;
            }
            // We should have at least two mags left including the current
            else if ( AmmoArray.Length <= 1 )
            {
                `warn("Reloading without any spare magazines - How did we get here?");
                NextMagAmmoCount = -1;
            }
            else
            {
                // find mag index
                NextMagIndex = CurrentMagIndex + 1;
                if ( NextMagIndex > AmmoArray.Length - 1)
                {
                    NextMagIndex = 0;
                }

                NextMagAmmoCount = AmmoArray[NextMagIndex];
            }
        }
    }
}

simulated function SightIndexUpdated()
{
    if( SightRotController != none )
    {
        SightRotController.BoneRotation.Pitch = SightRanges[SightRangeIndex].SightPitch * -1;
    }
    if( SightSlideController != none )
    {
        SightSlideController.BoneTranslation.Z = SightRanges[SightRangeIndex].SightSlideOffset;
    }
    IronSightPosition.Z=SightRanges[SightRangeIndex].SightPositionOffset;
    PlayerViewOffset.Z=SightRanges[SightRangeIndex].SightPositionOffset;
}

simulated exec function SwitchFireMode()
{
    ROMGOperation();
}

simulated function bool OverrideAllowFocusZoom()
{
    return bUsingSights;
}

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_Bren_LMG_Content"

    RoleSelectionImage(0)=Texture2D'DR_UI.WP_Render.WP_Render_Bren'

    WeaponClassType=ROWCT_LMG
    TeamIndex=`ALLIES_TEAM_INDEX

    Category=ROIC_Primary
    Weight=12.1 //KG
    RoleEncumbranceModifier=0.35
    InvIndex=37
    InventoryWeight=3

    PlayerIronSightFOV=65.0

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponFiring
    WeaponFireTypes(0)=EWFT_Custom
    WeaponProjectiles(0)=class'DRBullet_Bren'
    bLoopHighROFSounds(0)=true
    FireInterval(0)=+0.12
    DelayedRecoilTime(0)=0.0
    Spread(0)=0.000175//0.0003

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=none
    WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
    WeaponProjectiles(ALTERNATE_FIREMODE)=none
    bLoopHighROFSounds(ALTERNATE_FIREMODE)=false
    FireInterval(ALTERNATE_FIREMODE)=+0.12
    DelayedRecoilTime(ALTERNATE_FIREMODE)=0.01
    Spread(ALTERNATE_FIREMODE)=0.000175//0.0003

    PreFireTraceLength=2500 //50 Meters
    FireTweenTime=0.025

    ShoulderedSpreadMod=6.0
    HippedSpreadMod=10.0

    // AI
    MinBurstAmount=3
    MaxBurstAmount=9
    BurstWaitTime=0.9

    // Recoil
    maxRecoilPitch=160//130//65//130
    minRecoilPitch=140//110//55//110
    maxRecoilYaw=100//70//35//50
    minRecoilYaw=-75//-50//-25//-40
    maxDeployedRecoilPitch=65//130
    minDeployedRecoilPitch=55//110
    maxDeployedRecoilYaw=35//50
    minDeployedRecoilYaw=-25//-40
    minDeployedRecoilYawAbsolute=25
    RecoilRate=0.07
    RecoilMaxYawLimit=1500
    RecoilMinYawLimit=64035
    RecoilMaxPitchLimit=1500
    RecoilMinPitchLimit=64785
    RecoilISMaxYawLimit=500
    RecoilISMinYawLimit=65035
    RecoilISMaxPitchLimit=450//350
    RecoilISMinPitchLimit=65035
    RecoilBlendOutRatio=0.75
    PostureHippedRecoilModifer=11.0//5.5
    PostureShoulderRecoilModifer=4.0//2.0
    RecoilViewRotationScale=0.45

    RecoilSkelControlName=RecoilControl

    InstantHitDamage(0)=115
    InstantHitDamage(1)=115

    InstantHitDamageTypes(0)=class'DRDmgType_BrenBullet'
    InstantHitDamageTypes(1)=class'DRDmgType_BrenBullet'

    MuzzleFlashSocket=MuzzleFlashSocket
    //? MuzzleFlashPSCTemplate=ParticleSystem'FX_WEP_Gun_Two.MuzzleFlashes.FX_WEP_Gun_A_MuzzleFlash_1stP_MG'
    MuzzleFlashDuration=0.33
    MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    //? ShellEjectPSCTemplate=ParticleSystem'FX_WEP_Gun_Two.ShellEjects.FX_Wep_A_ShellEject_PhysX_Ger_MG34'

    // ? CRef_WeaponFireSndFirstPerson[0]="WP_WF_GB_BrenMk2.Audio.BrenFire_loop_sur_cue"
    // ? CRef_WeaponFireSndFirstPerson[1]=none
    // ? CRef_WeaponFireEndSndFirstPerson[0]="WP_WF_GB_BrenMk2.Audio.BrenFire_loop_end_sur_cue"

    WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Loop_3P', FirstPersonCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Loop')

    bLoopingFireSnd(DEFAULT_FIREMODE)=true
    WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Tail_3P', FirstPersonCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Tail')
    // bLoopHighROFSounds(DEFAULT_FIREMODE)=true

    bHasIronSights=true;

    //Equip and putdown
    WeaponPutDownAnim=Bren_putaway
    WeaponEquipAnim=Bren_pullout
    WeaponDownAnim=Bren_Down
    WeaponUpAnim=Bren_Up

    // Fire Anims
    //Hip fire
    WeaponFireAnim(0)=Bren_shoulder_shoot
    WeaponFireAnim(1)=Bren_shoulder_shoot
    WeaponFireLastAnim=Bren_shoulder_shootLAST
    //Shouldered fire
    WeaponFireShoulderedAnim(0)=Bren_shoulder_shoot
    WeaponFireShoulderedAnim(1)=Bren_shoulder_shoot
    WeaponFireLastShoulderedAnim=Bren_shoulder_shootLAST
    // Fire using iron sights
    // NOTE: actually done with recoil skel control.
    WeaponFireSightedAnim(0)=Bren_shoulder_shoot
    WeaponFireSightedAnim(1)=Bren_shoulder_shoot
    WeaponFireLastSightedAnim=Bren_shoulder_shootLAST
    // WeaponFireLastSightedAnim=Bren_deploy_shootLAST
    // Bipod deployed fire
    WeaponFireDeployedAnim(0)=Bren_deploy_shoot
    WeaponFireDeployedAnim(1)=Bren_deploy_shoot
    WeaponFireLastDeployedAnim=Bren_deploy_shootLAST

    // Idle Anims
    //Hip Idle
    WeaponIdleAnims(0)=Bren_shoulder_idle
    WeaponIdleAnims(1)=Bren_shoulder_idle
    // Shouldered idle
    WeaponIdleShoulderedAnims(0)=Bren_shoulder_idle
    WeaponIdleShoulderedAnims(1)=Bren_shoulder_idle
    // Sighted Idle
    WeaponIdleSightedAnims(0)=Bren_shoulder_idle
    WeaponIdleSightedAnims(1)=Bren_shoulder_idle
    // Bipod deployed idle
    WeaponIdleDeployedAnims(0)=Bren_deploy_idle
    WeaponIdleDeployedAnims(1)=Bren_deploy_idle

    // Prone Crawl
    WeaponCrawlingAnims(0)=Bren_CrawlF
    WeaponCrawlStartAnim=Bren_Crawl_into
    WeaponCrawlEndAnim=Bren_Crawl_out
    // Deployed Prone Crawl
    RedeployCrawlingAnims(0)=Bren_Deployed_CrawlF

    //Reloading
    WeaponReloadEmptyMagAnim=Bren_reloadempty_crouch
    WeaponReloadNonEmptyMagAnim=Bren_reloadhalf_crouch
    WeaponRestReloadEmptyMagAnim=Bren_reloadempty_rest
    WeaponRestReloadNonEmptyMagAnim=Bren_reloadhalf_rest
    DeployReloadEmptyMagAnim=Bren_deploy_reloadempty
    DeployReloadHalfMagAnim=Bren_deploy_reloadhalf
    // Ammo check
    WeaponAmmoCheckAnim=Bren_ammocheck_crouch
    WeaponRestAmmoCheckAnim=Bren_ammocheck_rest
    DeployAmmoCheckAnim=Bren_deploy_ammocheck

    // Sprinting
    WeaponSprintStartAnim=Bren_sprint_into
    WeaponSprintLoopAnim=Bren_Sprint
    WeaponSprintEndAnim=Bren_sprint_out
    Weapon1HSprintStartAnim=Bren_1H_sprint_into
    Weapon1HSprintLoopAnim=Bren_1H_sprint
    Weapon1HSprintEndAnim=Bren_1H_sprint_out

    // Mantling
    WeaponMantleOverAnim=Bren_Mantle

    // Cover/Blind Fire Anims
    WeaponRestAnim=Bren_shoulder_idle
    WeaponEquipRestAnim=Bren_pullout_rest
    WeaponPutDownRestAnim=Bren_putaway_rest
    WeaponIdleToRestAnim=Bren_shoulderTOrest
    WeaponRestToIdleAnim=Bren_restTOshoulder

    ReloadMagazinEmptyCameraAnim=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_reloadempty'

    EquipTime=+1.00
    PutDownTime=+0.75

    bDebugWeapon = false

    ISFocusDepth=30
    ISFocusBlendRadius=16

    // Ammo
    AmmoClass=class'DRAmmo_77x56_BrenBox'
    MaxAmmoCount=30
    bUsesMagazines=true
    InitialNumPrimaryMags=6
    bPlusOneLoading=false
    bCanReloadNonEmptyMag=true
    PenetrationDepth=23.5
    MaxPenetrationTests=3
    MaxNumPenetrations=2
    // Tracers
    // ? TracerClass=class'BrenBulletTracer'
    TracerFrequency=10

    PlayerViewOffset=(X=0.0,Y=8.0,Z=-5)
    ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
    ShoulderedTime=0.35
    ShoulderedPosition=(X=0.5,Y=4.0,Z=-2.0)// (X=0,Y=1,Z=-1.4)
    ShoulderRotation=(Pitch=-500,Yaw=0,Roll=2500)
    IronSightPosition=(X=0.7,Y=0,Z=0.0)

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
        Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
    End Object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1

    CollisionCheckLength=50.0 //TODO:Put the real value here?

    DeployedSwayScale=0.05

    // Bipod anims.
    WeaponExtendBipodAnim=MG34_Bipod_Open
    WeaponFoldBipodAnim=MG34_Bipod_Close

    YawControlName=YawControl
    PitchControlName=PitchControl
    BipodZCheckDist=25.0
    bHasBipod=true
    bCanBlindFire=false
    DeployAnimName=Bren_shoulderTOdeploy
    UnDeployAnimName=Bren_deployTOshoulder
    RestDeployAnimName=Bren_restTOdeploy
    RestUnDeployAnimName=Bren_deployTOrest
    DeployToShuffleAnimName=Bren_Deploy_TO_Shuffle
    ShuffleIdleAnimName=Bren_Shuffle_idle
    ShuffleToDeployAnimName=Bren_Shuffle_TO_Deploy
    RedeployProneTurnAnimName=Bren_prone_turn_TO_Deploy
    UnDeployProneTurnAnimName=Bren_prone_Deploy_TO_turn
    ProneTurningIdleAnimName=Bren_prone_Deploy_turn_idle
    BipodPivotBoneName=Bipod_hinge_Yaw
    BipodOffset=(X=35.80)   // Fake the bipod location so that the gun aims like the DP28

    // 19.5 Z offset to ground from 0,0,0

    FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    ShakeScaleControlled=0.65

    SightSlideControlName=Sight_Slide

    // TODO: These are incorrect.
    SightRanges[0]=(SightRange=200,SightSlideOffset=0.0,SightPositionOffset=0.0,AddedPitch=30)
    SightRanges[1]=(SightRange=300,SightSlideOffset=0.05,SightPositionOffset=-0.05,AddedPitch=58)
    SightRanges[2]=(SightRange=400,SightSlideOffset=0.1,SightPositionOffset=-0.1,AddedPitch=70)
    SightRanges[3]=(SightRange=500,SightSlideOffset=0.15,SightPositionOffset=-0.16,AddedPitch=70)

    SightRanges[4]=(SightRange=600,SightSlideOffset=0.2,SightPositionOffset=-0.21,AddedPitch=86)
    SightRanges[5]=(SightRange=700,SightSlideOffset=0.26,SightPositionOffset=-0.27,AddedPitch=96)
    SightRanges[6]=(SightRange=800,SightSlideOffset=0.33,SightPositionOffset=-0.35,AddedPitch=106)
    SightRanges[7]=(SightRange=900,SightSlideOffset=0.41,SightPositionOffset=-0.44,AddedPitch=116)
    SightRanges[8]=(SightRange=1000,SightSlideOffset=0.50,SightPositionOffset=-0.55,AddedPitch=127)

    ROBarrelClass=class'ROMGBarrelM1919'
    bTrackBarrelHeat=true
    BarrelHeatBone=Barrel
    BarrelChangeAnim=Bren_deploy_changebarrel
    InitialBarrels=2

    /*
    ROBarrelClass=class'WFMGBarrelBren'
    bTrackBarrelHeat=true
    BarrelHeatBone=barrel
    BarrelChangeAnim=Bren_deploy_changebarrel
    InitialBarrels=2
    */

    MaxNumPrimaryMags=6

    SuppressionPower=10
}
