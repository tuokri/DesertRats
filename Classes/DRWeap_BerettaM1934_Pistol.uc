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
    InvIdex=`DRII_BERETTA_M1934_PISTOL

    RoleSelectionImage(0)=Texture2D'VN_UI_Textures.WeaponTex.VN_Weap_MakarovPM_Pistol'

    WeaponReloadEmptyMagAnim=PM_reloadempty_slide

    SlideControlNegName=SlideControl_PM_Neg
}
