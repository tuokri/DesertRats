class DRHUDWidgetWorld extends ROHUDWidgetWorld;

DefaultProperties
{
    ObjectiveNeutralIcon                 = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral'
    ObjectiveStatusNorthAttackingNeutral = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral_GER_Taking'
    ObjectiveStatusSouthAttackingNeutral = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral_UK_Taking'

    // DAK.
    NorthIcons(0)={(
        ObjIconRed               = Texture2D'DR_UI.Objective.64x64.Objective_64_GER',
        ObjIconBlue              = Texture2D'DR_UI.Objective.64x64.Objective_64_GER',
        CappingObjRed            = Texture2D'DR_UI.Objective.64x64.Objective_64_GER_Losing',
        CappingObjBlue           = Texture2D'DR_UI.Objective.64x64.Objective_64_GER_Losing',
        // HomeObjIconRed           = Texture2D'DR_UI.Objective.64x64.Objective_64_GERHQ',
        // HomeObjIconBlue          = Texture2D'DR_UI.Objective.64x64.Objective_64_GERHQ',
        // HomeObjNeutralIconRed    = Texture2D'DR_UI.Objective.64x64.Objective_64_GERHQ_Neutral',
        // HomeObjNeutralIconBlue   = Texture2D'DR_UI.Objective.64x64.Objective_64_GERHQ_Neutral',
        // EnemyCappingHomeIconRed  = Texture2D'DR_UI.Objective.64x64.Objective_64_GERHQ_Losing',
        // EnemyCappingHomeIconBlue = Texture2D'DR_UI.Objective.64x64.Objective_64_GERHQ_Losing'
    )}

    // UK.
    SouthIcons(0)={(
        ObjIconRed               = Texture2D'DR_UI.Objective.64x64.Objective_64_UK',
        ObjIconBlue              = Texture2D'DR_UI.Objective.64x64.Objective_64_UK',
        CappingObjRed            = Texture2D'DR_UI.Objective.64x64.Objective_64_UK_Losing',
        CappingObjBlue           = Texture2D'DR_UI.Objective.64x64.Objective_64_UK_Losing',
        // HomeObjIconRed           = Texture2D'DR_UI.Objective.64x64.Objective_64_UKHQ',
        // HomeObjIconBlue          = Texture2D'DR_UI.Objective.64x64.Objective_64_UKHQ',
        // HomeObjNeutralIconRed    = Texture2D'DR_UI.Objective.64x64.Objective_64_UKHQ_Neutral',
        // HomeObjNeutralIconBlue   = Texture2D'DR_UI.Objective.64x64.Objective_64_UKHQ_Neutral',
        // EnemyCappingHomeIconRed  = Texture2D'DR_UI.Objective.64x64.Objective_64_UKHQ_Losing',
        // EnemyCappingHomeIconBlue = Texture2D'DR_UI.Objective.64x64.Objective_64_UKHQ_Losing'
    )}

    //? NorthSelectedTexture=Texture2D'DR_UI.Misc.SquadSelection_GER'
    //? SouthSelectedTexture=Texture2D'DR_UI.Misc.SquadSelection_UK'

    //? EnemyTransportSpottedIcon=Texture2D'VN_UI_Textures.OverheadMap.ui_overheadmap_icons_enemy_tank'
}
