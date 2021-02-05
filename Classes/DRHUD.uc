class DRHUD extends ROHUD;

event PostBeginPlay()
{
    super.PostBeginPlay();

    HUDWidgetList.RemoveItem(CamoIndicatorWidget);
    CamoIndicatorWidget=None;

    HUDWidgetList.RemoveItem(HelicopterInfoWidget);
    HelicopterInfoWidget=None;
}

DefaultProperties
{
    DefaultHelicopterInfoWidget=class'DRHUDWidgetHelicopterInfo'
    DefaultCommanderWidget=class'DRHUDWidgetCommander'
    // DefaultCommanderAbilitiesWidgetNorth=class'DRHUDWidgetCommanderAbilitiesNorth'
    // DefaultCommanderAbilitiesWidgetSouth=class'DRHUDWidgetCommanderAbilitiesSouth'
}
