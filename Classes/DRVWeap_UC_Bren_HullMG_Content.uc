class DRVWeap_UC_Bren_HullMG_Content extends DRVWeap_UC_Bren_HullMG;

DefaultProperties
{
    WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Loop_3P', FirstPersonCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Loop')
    bLoopingFireSnd(DEFAULT_FIREMODE)=true
    WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Tail_3P', FirstPersonCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Tail')
    bLoopHighROFSounds(DEFAULT_FIREMODE)=true

    BarTexture=Texture2D'ui_textures.Textures.button_128grey'
}
