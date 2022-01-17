class DRWeap_EnfieldNo2_Revolver extends ROWeap_M1917_Pistol
    abstract;

// `include(DesertRats\Classes\DRWeaponPickupMessagesOverride.uci)

var name DummyBoneName;

var name CylinderSkelControlName;
var SkelControlSingleBone CylinderSkelControl;

var name RoundFXSocketNames[6];
var ROParticleSystemComponent RoundShellEjectPSCs[6];

var int NextShellToUnHideIndex;
var name ShellBoneNames[6];

var byte FiredRounds[6];

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super.PostInitAnimTree(SkelComp);

    if (CylinderSkelControlName != '')
    {
        CylinderSkelControl = SkelControlSingleBone(
            SkeletalMeshComponent(Mesh).FindSkelControl(CylinderSkelControlName));
        CylinderSkelControl.SetSkelControlStrength(1.0, 0.0);
    }
}

simulated function TimeReloading()
{
    local float ReloadDuration;

    SkeletalMeshComponent(Mesh).UnHideBoneByName(DummyBoneName);

    if (CurrentReloadType == RORT_None && IsInState('Reloading'))
    {
        CurrentReloadType = RORT_SingleBullet;
    }

    if (CurrentReloadType == RORT_SingleBullet)
    {
        // Check to see if we should use alternate reload animations
        if (!HasAnyAmmo() || (bHasManualBolting && bNeedsBolting))
        {
            // bNonEmptyChamberReload = true;
            // bUseEjectionPort = true;
            bNeedsBolting = false;
        }

        if (CurrentReloadStatus == RORS_None)
        {
            ReloadDuration = SkeletalMeshComponent(Mesh).GetAnimLength(GetOpenBoltAnimName());
            if (MaxAmmoCount <= TotalStoredAmmoCount)
            {
                MaxSingleBulletsToLoad = MaxAmmoCount;
            }
            else
            {
                MaxSingleBulletsToLoad = Min(MaxAmmoCount, AmmoCount + TotalStoredAmmoCount);
            }
            CurrentReloadStatus = RORS_OpeningBolt;
        }
        else if (CurrentReloadStatus == RORS_OpeningBolt || (CurrentReloadStatus == RORS_Reloading && AmmoCount < MaxSingleBulletsToLoad && !bEndReloadEarly))
        {
            ReloadDuration = SkeletalMeshComponent(Mesh).GetAnimLength( GetReloadSingleBulletAnimName() );
            CurrentReloadStatus = RORS_Reloading;
        }
        else if (CurrentReloadStatus == RORS_Reloading)
        {
            ReloadDuration = 0.75 * SkeletalMeshComponent(Mesh).GetAnimLength(ROPawn(Instigator).IsInCover() ? WeaponRestCloseBoltAnim : WeaponCloseBoltAnim);
            CurrentReloadStatus = RORS_ClosingBolt;
        }
        else if (CurrentReloadStatus == RORS_ClosingBolt)
        {
            CurrentReloadStatus = RORS_Complete;
            ReloadComplete();
            // bNonEmptyChamberReload = false;
            return;
        }
    }
    else
        return;

    // This shouldn't happen
    if (ReloadDuration == 0.0)
    {
        ReloadDuration = 0.1;
    }

    if (Instigator.IsFirstPerson())
    {
        PlayReload(ReloadDuration);
    }

    // call TimeReloading() again after the reload animation is finished playing
    SetTimer(ReloadDuration, false, 'NextReloadStatus');

    // give ammo and leave reload state slightly before animation is finished
    SetTimer(ReloadDuration * PerformReloadPct, false, 'PerformReload');
}

function ReloadComplete()
{
    super.ReloadComplete();
    SkeletalMeshComponent(Mesh).HideBoneByName(DummyBoneName, PBO_Disable);
}

simulated function bool UseRestingAnim()
{
    return false;
}

// Adjusted to handle MaxAmmoCount not being remotely similar to the ammo provided by our "mags".
simulated function float GetTotalAmmoPercentage()
{
    return float(GetTotalAmmoCount()) / float(MaxAmmoCount + InitialNumPrimaryMags - 1);
}

/**
 * Performed by anim notify when we are reloading for proper sync. Can't let this happen as soon as we start reloading, because
 * we might pull out a full mag
 * @param bReloadingAnimNotify : context for the call to this function.
 * TODO: How many emitters to fire when reloading after interrupted reload?
 */
simulated function UpdateRounds(bool bAnimNotify)
{
    local SkeletalMeshComponent SkelMesh;
    local int i, RoundsInGun;

    RoundsInGun = Role == ROLE_Authority ? AmmoCount : ClientAmmoCount;

    SkelMesh = SkeletalMeshComponent(Mesh);

    if (SkelMesh != none)
    {
        for (i = ArrayCount(RoundBoneNames) - 1; i >= 0; --i)
        {
            if (!bAnimNotify && i >= RoundsInGun)
            {
                SkelMesh.HideBoneByName(RoundBoneNames[i], PBO_Disable);
                FiredRounds[i] = 1;
            }
            else
            {
                SkelMesh.UnHideBoneByName(RoundBoneNames[i]);
                FiredRounds[i] = 0;
            }
        }
    }
}

simulated function AttachShellEject()
{
    local SkeletalMeshComponent SKMesh;
    local int i;

    bShellEjectAttached = true;
    SKMesh = SkeletalMeshComponent(Mesh);
    if (SKMesh != none)
    {
        if (ShellEjectPSCTemplate != None)
        {
            for (i = 0; i < ArrayCount(RoundFXSocketNames); ++i)
            {
                if (SKMesh.GetSocketByName(RoundFXSocketNames[i]) != None)
                {
                    RoundShellEjectPSCs[i] = new(self) class'ROParticleSystemComponent';
                    RoundShellEjectPSCs[i].bAutoActivate = false;
                    RoundShellEjectPSCs[i].SetFOV(ROSkeletalMeshComponent(SKMesh).FOV);
                    RoundShellEjectPSCs[i].SetFloatParameter('LifetimeParam', WorldInfo.GetShellCasingExtendedLife());

                    SKMesh.AttachComponentToSocket(RoundShellEjectPSCs[i], RoundFXSocketNames[i]);
                    RoundShellEjectPSCs[i].SetTemplate(ShellEjectPSCTemplate);
                }
            }
        }
    }
}

simulated function DetachShellEject()
{
    local SkeletalMeshComponent SKMesh;
    local int i;

    bShellEjectAttached = false;
    SKMesh = SkeletalMeshComponent(Mesh);
    if (SKMesh != none)
    {
        for (i = 0; i < ArrayCount(RoundFXSocketNames); ++i)
        {
            if (RoundShellEjectPSCs[i] != None)
            {
                SKMesh.DetachComponent(RoundShellEjectPSCs[i]);
                RoundShellEjectPSCs[i] = None;
            }
        }
    }
}

simulated function SetFOV(float NewFOV)
{
    local int i;

    super.SetFOV(NewFOV);

    for (i = 0; i < ArrayCount(RoundFXSocketNames); ++i)
    {
        if (RoundShellEjectPSCs[i] != None)
        {
            RoundShellEjectPSCs[i].SetFOV(NewFOV);
        }
    }
}

simulated function NotifyEjectShells()
{
    local int i;

    if (WorldInfo.NetMode == NM_DedicatedServer)
    {
        return;
    }

    if (bHidden && !bShowFireFXWhenHidden)
    {
        return;
    }

    if (!bShellEjectAttached)
    {
        AttachShellEject();
    }

    for (i = 0; i < ArrayCount(RoundFXSocketNames); ++i)
    {
        if (True/*FiredRounds[i] == 1*/)
        {
            if (RoundShellEjectPSCs[i] != None && !RoundShellEjectPSCs[i].bIsActive)
            {
                RoundShellEjectPSCs[i].ActivateSystem();
                SkeletalMeshComponent(Mesh).HideBoneByName(ShellBoneNames[i], PBO_Disable);
            }
        }
    }
}

simulated function NotifyUnHideShell()
{
    SkeletalMeshComponent(Mesh).UnHideBoneByName(ShellBoneNames[NextShellToUnHideIndex]);
    NextShellToUnHideIndex = (NextShellToUnHideIndex + 1) % MaxAmmoCount;
}

simulated function NotifyRotateCylinderFire()
{
    if (CylinderSkelControl != None)
    {
        CylinderSkelControl.BoneRotation.Roll -= 65535 / MaxAmmoCount;
    }
}

simulated function NotifyRotateCylinderReload()
{
    if (CylinderSkelControl != None)
    {
        CylinderSkelControl.BoneRotation.Roll -= 65535 / MaxAmmoCount;
    }
}

simulated function NotifyResetCylinderRotation()
{
    if (CylinderSkelControl != None)
    {
        CylinderSkelControl.BoneRotation.Roll = 0;
    }
}

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_EnfieldNo2_Revolver_Content"

    RoleSelectionImage(0)=Texture2D'DR_UI.WP_Render.WP_Render_EnfieldNo2'

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

    /*
    WeaponReloadStripperAnim=Reload
    ReloadStripperDoubleAnim=Reload
    WeaponAltReloadStripperAnim=Reload
    WeaponAltReloadStripperIronAnim=Reload
    WeaponReloadEmptyMagIronAnim=Reload
    WeaponReloadNonEmptyMagIronAnim=Reload
    */

    WeaponReloadEmptyMagAnim=ReloadLoop
    WeaponReloadSingleBulletAnim=ReloadLoop
    WeaponReloadEmptySingleBulletAnim=ReloadLoop
    WeaponOpenBoltAnim=ReloadStart
    WeaponOpenBoltEmptyAnim=ReloadStart
    WeaponCloseBoltAnim=ReloadEnd
    // WeaponRestReloadEmptyMagAnim=Reload
    // WeaponRestReloadSingleBulletAnim=Reload
    // WeaponRestReloadEmptySingleBulletAnim=Reload
    // WeaponRestOpenBoltAnim=Reload
    // WeaponRestOpenBoltEmptyAnim=Reload
    // WeaponRestCloseBoltAnim=Reload

    WeaponAmmoCheckAnim=AmmoCheck
    WeaponAmmoCheckIronAnim=AmmoCheck
    WeaponAltAmmoCheckAnim=AmmoCheck
    WeaponAltAmmoCheckIronAnim=AmmoCheck

    WeaponSprintStartAnim=RunInitial
    WeaponSprintLoopAnim=RunLoop
    WeaponSprintEndAnim=RunEnd

    WeaponMantleOverAnim=Vault

    // WeaponSwitchToAltFireModeAnim=''
    // WeaponSightedSwitchToAltFireModeAnim=''

    WeaponSpotEnemyAnim=Spot
    WeaponSpotEnemySightedAnim=SpotAim

    WeaponMeleeAnims(0)=Melee

    MeleePullbackAnim=ChargeBegin
    MeleeHoldAnim=ChargeLoop
    WeaponMeleeHardAnim=ChargeEnd

    WeaponDryFireAnim=FireDry
    WeaponDryFireSightedAnim=FireDry

    bUsesIronSightAnims=false
    bUsesIronsightMeleeAnim=false

    DoubleActionFireDelay=0.15 //0.17

    ZoomInTime=0.25
    ZoomOutTime=0.25

    bDebugWeapon=false

    ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
    PlayerViewOffset=(X=0,Y=0,Z=0)
    ShoulderedPosition=(X=4.0,Y=4.0,Z=-2.0)
    IronSightPosition=(X=0,Y=0,Z=0)

    MaxAmmoCount=6
    NumMagsToResupply=6
    InitialNumPrimaryMags=24
    AmmoClass=class'DRAmmo_9x20_EnfieldNo2_Cartridge' // TODO: Ammo.
    bUsesMagazines=true
    bPlusOneLoading=false
    bCanReloadNonEmptyMag=false
    bCanLoadStripperClip=false
    bCanLoadSingleBullet=true
    StripperClipBulletCount=6
    PenetrationDepth=10
    MaxPenetrationTests=3
    MaxNumPenetrations=2
    PerformReloadPct=0.73f

    BoltControllerNames.Empty
    BoltControllerNames[0]=EnfieldNo2_Hammer
    // BoltControllerNames[1]=EnfieldNo2_Cylinder

    NextShellToUnHideIndex=5

    CylinderSkelControlName=EnfieldNo2_Cylinder

    RoundBoneNames(0)=Enfield_Bullet1
    RoundBoneNames(1)=Enfield_Bullet2
    RoundBoneNames(2)=Enfield_Bullet3
    RoundBoneNames(3)=Enfield_Bullet4
    RoundBoneNames(4)=Enfield_Bullet5
    RoundBoneNames(5)=Enfield_Bullet7

    ShellBoneNames(0)=Enfield_Shell1
    ShellBoneNames(1)=Enfield_Shell2
    ShellBoneNames(2)=Enfield_Shell3
    ShellBoneNames(3)=Enfield_Shell4
    ShellBoneNames(4)=Enfield_Shell5
    ShellBoneNames(5)=Enfield_Shell7

    DummyBoneName=Enfield_Bullet6

    RoundFXSocketNames(0)=Shell1FX
    RoundFXSocketNames(1)=Shell2FX
    RoundFXSocketNames(2)=Shell3FX
    RoundFXSocketNames(3)=Shell4FX
    RoundFXSocketNames(4)=Shell5FX
    RoundFXSocketNames(5)=Shell7FX

    SightRanges.Empty
    SightRanges[0]=(SightRange=0,SightPitch=0,SightPositionOffset=0.6,AddedPitch=250)

    bHasManualBolting=False

    ShellEjectPSCTemplate=ParticleSystem'DR_WP_UK_EnfieldNo2.FX.FX_Wep_ShellEject_UK_EnfieldNo2Revolver'
}
