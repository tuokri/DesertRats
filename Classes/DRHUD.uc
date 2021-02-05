class DRHUD extends ROHUD;

event PostBeginPlay()
{
    super.PostBeginPlay();

    HUDWidgetList.RemoveItem(CamoIndicatorWidget);
    CamoIndicatorWidget=None
}

DefaultProperties
{
    DefaultHelicopterInfoWidget=class'DRHUDWidgetHelicopterInfo'
    DefaultCommanderWidget=class'DRHUDWidgetCommander'
    // DefaultCommanderAbilitiesWidgetNorth=class'DRHUDWidgetCommanderAbilitiesNorth'
    // DefaultCommanderAbilitiesWidgetSouth=class'DRHUDWidgetCommanderAbilitiesSouth'
}
