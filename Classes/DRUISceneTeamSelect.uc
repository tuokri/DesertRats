class DRUISceneTeamSelect extends ROUISceneTeamSelect;

var localized array<string> TeamDescriptions;

function InitializeButtonStyle(ROPlayerController ROPC)
{
    NorthButtonImageEnabled = NorthEnabledLogos[0];
    NorthButtonImageDisabled = NorthDisabledLogos[0];
    NorthButtonImageHighlighted = NorthHighlightedLogos[0];

    SouthButtonImageEnabled = SouthEnabledLogos[0];
    SouthButtonImageDisabled = SouthDisabledLogos[0];
    SouthButtonImageHighlighted = SouthHighlightedLogos[0];

    TeamLabelButtons[0].SetCaption(class'DRMapInfo'.default.NorthernArmyNames[0]);
    TeamLabelButtons[1].SetCaption(class'DRMapInfo'.default.SouthernArmyNames[0]);

    TeamImages[0].SetValue(NorthButtonImageEnabled);
    TeamImages[1].SetValue(SouthButtonImageEnabled);
}

function ShowTeamInfo()
{
    local UIPanel Container;
    Container = UIPanel(FindChild(TeamInfoContainerName, true));

    if (TeamInfoTeamIndex == `AXIS_TEAM_INDEX)
    {
        UILabel(Container.FindChild(TeamInfoLabelName, true)).SetValue(TeamDescriptions[0]);
    }
    else
    {
        UILabel(Container.FindChild(TeamInfoLabelName, true)).SetValue(TeamDescriptions[1]);
    }

    Container.SetDockParameters(UIFACE_Top, TeamImages[TeamInfoTeamIndex], UIFACE_Top, 0.5, UIPADDINGEVAL_PercentTarget);
    Container.SetDockParameters(UIFACE_Left, TeamImages[TeamInfoTeamIndex], UIFACE_Left, 0.0);
    Container.SetDockParameters(UIFACE_Right, TeamImages[TeamInfoTeamIndex], UIFACE_Right, 0.0);
    Container.SetVisibility(TeamInfoTeamIndex < 2);
}

/*
function bool AllowTeamSwitch()
{
`ifndef(RELEASE)
    return True;
`endif
    return super.AllowTeamSwitch();
}
*/

DefaultProperties
{
    NorthEnabledLogos(0)     = MaterialInstanceConstant'DR_UI.TeamSelect.Team_Cutout_GER_desat'
    NorthDisabledLogos(0)    = MaterialInstanceConstant'DR_UI.TeamSelect.Team_Cutout_GER_disabled'
    NorthHighlightedLogos(0) = MaterialInstanceConstant'DR_UI.TeamSelect.Team_Cutout_GER_highlighted'

    SouthEnabledLogos(0)     = MaterialInstanceConstant'DR_UI.TeamSelect.Team_Cutout_UK_desat'
    SouthDisabledLogos(0)    = MaterialInstanceConstant'DR_UI.TeamSelect.Team_Cutout_UK_disabled'
    SouthHighlightedLogos(0) = MaterialInstanceConstant'DR_UI.TeamSelect.Team_Cutout_UK_highlighted'
}
