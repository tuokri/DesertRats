class DRUISceneUnitSelect extends ROUISceneUnitSelect;

function bool ShouldPlayTutorialVideo()
{
    return false;
}

DefaultProperties
{
    NorthBackgroundImages.Empty
    SouthBackgroundImages.Empty

    NorthBackgroundImages[0]=Texture2D'DR_UI.TeamLogo.Team_Logo_DAK_Large'
    SouthBackgroundImages[0]=Texture2D'DR_UI.TeamLogo.Team_Logo_UK_Large'
}
