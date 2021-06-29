class DRVWeap_HT_HullMG_Content extends DRVWeap_HT_HullMG;

DefaultProperties
{
    WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'DR_AUD_MG34.Play_WEP_MG34_Loop_3P',FirstPersonCue=AkEvent'DR_AUD_MG34.Play_WEP_MG34_Auto_LP')
    bLoopingFireSnd(DEFAULT_FIREMODE)=true
    WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Tail_3P',FirstPersonCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Tail')
    bLoopHighROFSounds(DEFAULT_FIREMODE)=true

    BarTexture=Texture2D'ui_textures.Textures.button_128grey'
}
