class DRHUDWidgetObjectiveOverview extends ROHUDWidgetObjectiveOverview;

DefaultProperties
{
    ObjectiveNeutralIcon                       = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral'
    ObjectiveNeutralUncontestedBorder          = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral'
    ObjectiveStatusNorthAttackingNeutral       = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral_GER_Taking_Progress'
    ObjectiveStatusSouthAttackingNeutral       = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral_UK_Taking_Progress'
    ObjectiveStatusNorthAttackingNeutralBorder = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral_Taking'
    ObjectiveStatusSouthAttackingNeutralBorder = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral_Taking'

    NeutralUpperEdgeMargin=0.22, // 28px
    NeutralLowerEdgeMargin=0.22, // 28px

    // Deutsches Afrikakorps.
    NorthIcons(0)={(
        UpperEdgeMargin=0.22, // 28px
        LowerEdgeMargin=0.22, // 28px
        ObjIconRed                  = Texture2D'DR_UI.Objective.64x64.Objective_64_GER',
        ObjIconBlue                 = Texture2D'DR_UI.Objective.64x64.Objective_64_GER_Losing_Progress',
        ObjBorder                   = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral',
        CappingObjBorderRed         = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral_Taking',
        CappingObjBorderBlue        = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral_Taking',

        // HomeObjIconRed           = Texture2D'DR_UI.Objective.64x64.Objective_64_GERHQ',
        // HomeObjIconBlue          = Texture2D'DR_UI.Objective.64x64.Objective_64_GERHQ_Losing_Progress',
        // HomeObjEnemyHeldIconRed  = Texture2D'DR_UI.Objective.64x64.Objective_64_UKHQ_Losing_Progress',
        // HomeObjEnemyHeldIconBlue = Texture2D'DR_UI.Objective.64x64.Objective_64_UKHQ',
        // HomeObjNeutralRed        = Texture2D'DR_UI.Objective.64x64.Objective_64_GERHQ_Neutral',
        // HomeObjNeutralBlue       = Texture2D'DR_UI.Objective.64x64.Objective_64_GERHQ_Neutral'
    )}

    // 8th Army.
    SouthIcons(0)={(
        UpperEdgeMargin=0.22, // 28px
        LowerEdgeMargin=0.22, // 28px
        ObjIconRed                  = Texture2D'DR_UI.Objective.64x64.Objective_64_UK_Losing_Progress',
        ObjIconBlue                 = Texture2D'DR_UI.Objective.64x64.Objective_64_UK',
        ObjBorder                   = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral',
        CappingObjBorderRed         = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral_Taking',
        CappingObjBorderBlue        = Texture2D'DR_UI.Objective.64x64.Objective_64_Neutral_Taking',

        // HomeObjIconRed           = Texture2D'DR_UI.Objective.64x64.Objective_64_UKHQ_Losing',
        // HomeObjIconBlue          = Texture2D'DR_UI.Objective.64x64.Objective_64_UKHQ',
        // HomeObjEnemyHeldIconRed  = Texture2D'DR_UI.Objective.64x64.Objective_64_GERHQ',
        // HomeObjEnemyHeldIconBlue = Texture2D'DR_UI.Objective.64x64.Objective_64_GERHQ_Losing_Progress',
        // HomeObjNeutralRed        = Texture2D'DR_UI.Objective.64x64.Objective_64_UKHQ_Neutral',
        // HomeObjNeutralBlue       = Texture2D'DR_UI.Objective.64x64.Objective_64_UKHQ_Neutral'
    )}
}
