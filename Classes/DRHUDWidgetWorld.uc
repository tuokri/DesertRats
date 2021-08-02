class DRHUDWidgetWorld extends ROHUDWidgetWorld;

DefaultProperties
{
    ObjectiveNeutralIcon                 = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_world_Neutral'
    ObjectiveStatusNorthAttackingNeutral = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_world_Neutral_contested_red'
    ObjectiveStatusSouthAttackingNeutral = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_world_Neutral_contested_blue'

    // DAK.
    NorthIcons(0)={(
        ObjIconRed               = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_DAK_red',
        ObjIconBlue              = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_DAK_blue',
        CappingObjRed            = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_DAK_border_glow_red_GM',
        CappingObjBlue           = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_DAK_border_glow_blue_GM',
        HomeObjIconRed           = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_DAK_HOME_red_red',
        HomeObjIconBlue          = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_DAK_HOME_blue_blue',
        HomeObjNeutralIconRed    = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_DAK_HOME_red_white',
        HomeObjNeutralIconBlue   = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_DAK_HOME_blue_white',
        HomeObjEnemyHeldIconRed  = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_DAK_HOME_blue_red',
        HomeObjEnemyHeldIconBlue = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_DAK_HOME_red_blue',
    )}

    // UK.
    SouthIcons(0)={(
        ObjIconRed               = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_UK_red',
        ObjIconBlue              = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_UK_blue',
        CappingObjRed            = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_UK_border_glow_red_GM',
        CappingObjBlue           = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_UK_border_glow_blue_GM',
        HomeObjIconRed           = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_UK_HOME_red_red',
        HomeObjIconBlue          = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_UK_HOME_blue_blue',
        HomeObjNeutralIconRed    = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_UK_HOME_red_white',
        HomeObjNeutralIconBlue   = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_UK_HOME_blue_white',
        HomeObjEnemyHeldIconRed  = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_UK_HOME_blue_red',
        HomeObjEnemyHeldIconBlue = Texture2D'DR_UI.ObjectiveNew.World.ui_hud_obj_world_UK_HOME_red_blue',
    )}

    NorthSelectedTexture=Texture2D'DR_UI.Misc.SquadSelect_GER'
    SouthSelectedTexture=Texture2D'DR_UI.Misc.SquadSelect_UK'

    //? EnemyTransportSpottedIcon=Texture2D'VN_UI_Textures.OverheadMap.ui_overheadmap_icons_enemy_tank'
}
