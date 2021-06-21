class DRWeap_MG34_LMG extends ROWeap_MG34_LMG
    abstract;

`include(DesertRats\Classes\DRWeaponPickupMessagesOverride.uci)

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_MG34_LMG_Content"

    RoleSelectionImage(0)=Texture2D'DR_UI.WP_Render.WP_Render_MG34Belt'

    bDebugWeapon=False

    InvIndex=`DRII_MG34_LMG

    AmmoClass=class'DRAmmo_792x57_MG34Belt_250'
    MaxAmmoCount=250
    bUsesMagazines=true
    InitialNumPrimaryMags=1
    NumMagsToResupply=1
    MaxNumPrimaryMags=2

    SightRanges.Empty

    // Dialed in.
    SightRanges[0]=(SightRange=200,SightPitch=16384,SightSlideOffset=0.0,SightPositionOffset=0.0,AddedPitch=-125)

    // Estimated.
    SightRanges[1]=(SightRange=400,SightPitch=16384,SightSlideOffset=0.05,SightPositionOffset=-0.075,AddedPitch=-107)
    SightRanges[2]=(SightRange=500,SightPitch=16384,SightSlideOffset=0.075,SightPositionOffset=-0.12,AddedPitch=-97)
    SightRanges[3]=(SightRange=600,SightPitch=16384,SightSlideOffset=0.11,SightPositionOffset=-0.18,AddedPitch=-85)
    SightRanges[4]=(SightRange=700,SightPitch=16384,SightSlideOffset=0.14,SightPositionOffset=-0.225,AddedPitch=-85)

    // Wrong.
    SightRanges[5]=(SightRange=800,SightPitch=16384,SightSlideOffset=0.16,SightPositionOffset=-0.285,AddedPitch=86)
    SightRanges[6]=(SightRange=900,SightPitch=16384,SightSlideOffset=0.24,SightPositionOffset=-0.4,AddedPitch=96)
    SightRanges[7]=(SightRange=1000,SightPitch=16384,SightSlideOffset=0.3,SightPositionOffset=-0.52,AddedPitch=106)
    SightRanges[8]=(SightRange=1100,SightPitch=16384,SightSlideOffset=0.37,SightPositionOffset=-0.63,AddedPitch=116)
    SightRanges[9]=(SightRange=1200,SightPitch=16384,SightSlideOffset=0.44,SightPositionOffset=-0.75,AddedPitch=127)
    SightRanges[10]=(SightRange=1300,SightPitch=16384,SightSlideOffset=0.51,SightPositionOffset=-0.88,AddedPitch=137)
    SightRanges[11]=(SightRange=1400,SightPitch=16384,SightSlideOffset=0.59,SightPositionOffset=-1.0,AddedPitch=147)
    SightRanges[12]=(SightRange=1500,SightPitch=16384,SightSlideOffset=0.69,SightPositionOffset=-1.19,AddedPitch=157)
    SightRanges[13]=(SightRange=1600,SightPitch=16384,SightSlideOffset=0.79,SightPositionOffset=-1.36,AddedPitch=167)
    SightRanges[14]=(SightRange=1700,SightPitch=16384,SightSlideOffset=0.9,SightPositionOffset=-1.55,AddedPitch=178)
    SightRanges[15]=(SightRange=1800,SightPitch=16384,SightSlideOffset=1.02,SightPositionOffset=-1.75,AddedPitch=188)
    SightRanges[16]=(SightRange=1900,SightPitch=16384,SightSlideOffset=1.15,SightPositionOffset=-1.99,AddedPitch=198)
    SightRanges[17]=(SightRange=2000,SightPitch=16384,SightSlideOffset=1.28,SightPositionOffset=-2.25,AddedPitch=208)

    WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'DR_AUD_MG34.Play_WEP_MG34_Loop_3P',FirstPersonCue=AkEvent'DR_AUD_MG34.Play_WEP_MG34_Auto_LP')
    WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1918.Play_WEP_M1918_Single_3P',FirstPersonCue=AkEvent'WW_WEP_M1918.Play_WEP_M1918_Fire_Single')

    // Advanced (High RPM) Fire Effects
    bLoopingFireSnd(DEFAULT_FIREMODE)=true
    WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Tail_3P',FirstPersonCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Tail')
    bLoopHighROFSounds(DEFAULT_FIREMODE)=true
}
