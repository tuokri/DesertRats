class DRHUDWidgetObjectiveOverview extends ROHUDWidgetObjectiveOverview;

DefaultProperties
{
    ObjectiveNeutralIcon                        = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_Neutral'
    ObjectiveNeutralUncontestedBorder           = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_Neutral'
    ObjectiveStatusNorthAttackingNeutral        = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_Neutral_red'
    ObjectiveStatusSouthAttackingNeutral        = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_Neutral_border_glow_red_GM'
    ObjectiveStatusNorthAttackingNeutralBorder  = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_Neutral_blue'
    ObjectiveStatusSouthAttackingNeutralBorder  = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_Neutral_border_glow_blue_GM'
    ObjectiveStatusNorthSatchelAttackingNeutral = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_Neutral_border_glow_red_GM'
    ObjectiveStatusSouthSatchelAttackingNeutral = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_Neutral_border_glow_blue_GM'
    ObjectiveNeutralUncontestedBorder           = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_Neutral_border_GM'

    NeutralUpperEdgeMargin=0.05
    NeutralLowerEdgeMargin=0.05

    // Deutsches Afrikakorps.
    NorthIcons(0)={(
        UpperEdgeMargin=0.05,
        LowerEdgeMargin=0.05,
        ObjIconRed               = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_DAK_red',
        ObjIconBlue              = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_DAK_blue',
        ObjBorder                = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_DAK_border_GM',
        CappingObjBorderRed      = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_DAK_border_glow_red_GM',
        CappingObjBorderBlue     = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_DAK_border_glow_blue_GM',

        HomeObjIconRed           = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_DAK_home_red_red',
        HomeObjIconBlue          = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_DAK_home_blue_blue',
        HomeObjEnemyHeldIconRed  = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_DAK_home_blue_red',
        HomeObjEnemyHeldIconBlue = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_DAK_home_red_blue',
        HomeObjNeutralRed        = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_DAK_home_red_white',
        HomeObjNeutralBlue       = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_DAK_home_blue_white',
    )}

    // 8th Army.
    SouthIcons(0)={(
        UpperEdgeMargin=0.05,
        LowerEdgeMargin=0.05,
        ObjIconRed               = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_UK_red',
        ObjIconBlue              = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_UK_blue',
        ObjBorder                = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_UK_border_GM',
        CappingObjBorderRed      = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_UK_border_glow_red_GM',
        CappingObjBorderBlue     = Texture2D'DR_UI.ObjectiveNew.GameMode.ui_hud_obj_UK_border_glow_blue_GM',

        HomeObjIconRed           = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_UK_home_red_red',
        HomeObjIconBlue          = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_UK_home_blue_blue',
        HomeObjEnemyHeldIconRed  = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_UK_home_blue_red',
        HomeObjEnemyHeldIconBlue = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_UK_home_red_blue',
        HomeObjNeutralRed        = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_UK_home_red_white',
        HomeObjNeutralBlue       = Texture2D'DR_UI.ObjectiveNew.OverheadMap.ui_overheadmap_icons_UK_home_blue_white',
    )}
}
