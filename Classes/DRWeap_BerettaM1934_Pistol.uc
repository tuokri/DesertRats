class DRWeap_BerettaM1934_Pistol extends ROWeap_PM_Pistol
    abstract;

var name SlideControlNegName;
var SkelControlBase SlideControlNeg;

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super.PostInitAnimTree(SkelComp);

    if(SlideControlNegName != 'none')
    {
        SlideControlNeg = SkelComp.FindSkelControl(SlideControlNegName);
        SlideControlNeg.SetSkelControlStrength(0.0, 0.0);
    }
}

simulated function SlideBack()
{
    if (SlideControlNeg != None)
    {
        SlideControlNeg.SetSkelControlStrength(0.0, BoltSlideTime);
    }
}

simulated function SlideForward()
{
    if (SlideControlNeg != None)
    {
        SlideControlNeg.SetSkelControlStrength(1.0, BoltSlideTime);
    }
}

// TODO: Weight etc?
DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_BerettaM1934_Pistol_Content"

    WeaponClassType=ROWCT_HandGun
    TeamIndex=`AXIS_TEAM_INDEX
    InvIndex=`DRII_BERETTA_M1934_PISTOL

    RoleSelectionImage(0)=Texture2D'DR_UI.WP_Render.WP_Render_Beretta34'

    PlayerViewOffset=(X=6.0,Y=4.5,Z=-2.75)
    ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
    ShoulderedPosition=(X=5.0,Y=2.0,Z=-2.0)
    IronSightPosition=(X=0,Y=0,Z=-0.4)

    WeaponReloadEmptyMagAnim=PM_reloadempty_Slide
    WeaponReloadEmptyMagIronAnim=PM_reloadempty_Ironsight_Slide

    SlideControlNegName=SlideControl_PM_Neg

    // Shell eject FX
    ShellEjectSocket=ShellEjectSocket
    ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_VC_MAT49_9mm'

    WeaponProjectiles(0)=class'DRBullet_BerettaM1934'
    InstantHitDamageTypes(0)=class'DRDmgType_BerettaM1934'
    InstantHitDamageTypes(1)=class'DRDmgType_BerettaM1934'

    // Ammo
    MaxAmmoCount=8
    AmmoClass=class'DRAmmo_BerettaM1934'
    bUsesMagazines=true
    InitialNumPrimaryMags=3
    bPlusOneLoading=true
    bCanReloadNonEmptyMag=true
    bCanLoadStripperClip=false
    bCanLoadSingleBullet=false
    PenetrationDepth=7
    MaxPenetrationTests=3
    MaxNumPenetrations=2
    PerformReloadPct=0.75f
}
