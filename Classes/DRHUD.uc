class DRHUD extends ROHUD;

event PostBeginPlay()
{
    super.PostBeginPlay();

    VehicleListWidget = Spawn(DefaultVehicleListWidget, PlayerOwner);
    VehicleListWidget.Initialize(PlayerOwner);
    HUDWidgetList.AddItem(VehicleListWidget);

    HUDWidgetList.RemoveItem(CamoIndicatorWidget);
    CamoIndicatorWidget.Destroy();
    CamoIndicatorWidget=None;

    /*
    HUDWidgetList.RemoveItem(HelicopterInfoWidget);
    HelicopterInfoWidget.Destroy();
    HelicopterInfoWidget=None;
    */
}

DefaultProperties
{
    DefaultHelicopterInfoWidget=class'DRHUDWidgetHelicopterInfo'
    DefaultCommanderWidget=class'DRHUDWidgetCommander'
    // DefaultCommanderAbilitiesWidgetNorth=class'DRHUDWidgetCommanderAbilitiesNorth'
    // DefaultCommanderAbilitiesWidgetSouth=class'DRHUDWidgetCommanderAbilitiesSouth'
    DefaultObjectiveOverviewWidget=class'DRHUDWidgetObjectiveOverview'
    DefaultObjectiveWidget=class'DRHUDWidgetObjective'
    DefaultOverheadMapWidget=class'DRHUDWidgetOverheadMap'
    DefaultWorldWidget=class'DRHUDWidgetWorld'
    DefaultCompassWidget=class'DRHUDWidgetSimpleCompass'
    DefaultWeaponWidget=class'DRHUDWidgetWeapon'
}
