class DRHUDWidgetWeapon extends ROHUDWidgetWeapon;

function UpdateWidget()
{
    super.UpdateWidget();

    HUDComponents[ROWC_TunnelSpawnIcon].bVisible = False;
    HUDComponents[ROWC_TunnelSpawnCount].bVisible = False;
    HUDComponents[ROWC_DigTunnelIcon].bVisible = False;
    HUDComponents[ROWC_DigTunnelTextP1].bVisible = False;
    HUDComponents[ROWC_DigTunnelTextP2].bVisible = False;
    HUDComponents[ROWC_DigTunnelTextP3].bVisible = False;

    if (ROVehicle(PlayerOwner.Pawn) != None || ROWeaponPawn(PlayerOwner.Pawn) != None)
    {
        HUDComponents[ROWC_GrenadeIcon].bVisible = False;
        HUDComponents[ROWC_GrenadeCount].bVisible = False;
        HUDComponents[ROWC_FireModeIcon].bVisible = False;
    }
}
