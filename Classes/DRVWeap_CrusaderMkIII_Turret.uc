class DRVWeap_CrusaderMkIII_Turret extends DRVWeap_TankTurret
    abstract
    HideDropDown;

var Texture2D OpticsExtraTex;

simulated function DrawRangeOverlay(Hud HUD)
{
    // No range overlay for Crusader.
}

simulated function DrawCenterSights(Hud InHUD)
{
    local float TexScale;
    local float SightTexSizeX;
    local float SightTexSizeY;
    local float ExtraTexSizeX;
    local float ExtraTexSizeY;
    local float DrawPosX;
    local float DrawPosY;

    // Maintain aspect ratio of original.
    TexScale = InHUD.Canvas.SizeY / 1024.0;
    SightTexSizeX = MyVehicle.Seats[SeatIndex].SightOverlayTexture.SizeX * TexScale;
    SightTexSizeY = MyVehicle.Seats[SeatIndex].SightOverlayTexture.SizeY * TexScale;
    ExtraTexSizeX = OpticsExtraTex.SizeX * TexScale;
    ExtraTexSizeY = OpticsExtraTex.SizeY * TexScale;

    DrawPosX = InHUD.CenterX - (SightTexSizeX / 2.0f);
    DrawPosY = InHUD.CenterY - (SightTexSizeY / 2.0f);

    // `log("DrawPosX=" $ DrawPosX,, 'DRDEV');
    // `log("DrawPosY=" $ DrawPosY,, 'DRDEV');

    InHUD.Canvas.SetPos(DrawPosX, DrawPosY);
    InHUD.Canvas.DrawTile(MyVehicle.Seats[SeatIndex].SightOverlayTexture,
        SightTexSizeX, SightTexSizeY, 0, 0, MyVehicle.Seats[SeatIndex].SightOverlayTexture.SizeX,
        MyVehicle.Seats[SeatIndex].SightOverlayTexture.SizeY);

    InHUD.Canvas.SetPos(DrawPosX - ExtraTexSizeX, DrawPosY);
    InHUD.Canvas.DrawTile(OpticsExtraTex, ExtraTexSizeX, ExtraTexSizeY, 0, 0,
        OpticsExtraTex.SizeX, OpticsExtraTex.SizeY);

    // `log("extra draw pos 1 X= " $ DrawPosX - ExtraTexSizeX,, 'DRDEV');
    // `log("extra draw pos 1 Y= " $ DrawPosY - (ExtraTexSizeY / 2.0f),, 'DRDEV');

    InHUD.Canvas.SetPos(DrawPosX + SightTexSizeX, DrawPosY);
    InHUD.Canvas.DrawTile(OpticsExtraTex, ExtraTexSizeX, ExtraTexSizeY, 0, 0,
        OpticsExtraTex.SizeX, OpticsExtraTex.SizeY);

    // `log("extra draw pos 2 X= " $ DrawPosX + SightTexSizeX,, 'DRDEV');
    // `log("extra draw pos 2 Y= " $ InHUD.Canvas.SizeY - (ExtraTexSizeY / 2.0f),, 'DRDEV');
}

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRVWeap_CrusaderMkIII_Turret_Content"
    SeatIndex=2

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponSingleFiring
    WeaponFireTypes(0)=EWFT_Projectile
    WeaponProjectiles(0)=class'DRVProjectile_CrusaderIII_AP'
    FireInterval(0)=+3.5
    Spread(0)=0.0001

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=WeaponFiring
    WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Projectile
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRBullet_MG34_Turret' // TODO: Correct bullet.
    FireInterval(ALTERNATE_FIREMODE)=+0.15
    Spread(ALTERNATE_FIREMODE)=0.0007

    // AI
    AILongDistanceScale=1.15
    AIMediumDistanceScale=1.1
    AISpreadScale=200.0
    AISpreadNoSeeScale=2.0
    AISpreadNMEStillScale=0.5
    AISpreadNMESprintScale=1.5

    FireTriggerTags=(PanzerIIIMCannon)
    AltFireTriggerTags=(PanzerIIIMCoaxMG)

    VehicleClass=class'DRVehicle_CrusaderMkIII'

    // Main Gun Ammo
    MainGunProjectiles(MAINGUN_AP_INDEX)=class'DRVProjectile_CrusaderIII_AP'
    MainGunProjectiles(MAINGUN_HE_INDEX)=class'DRVProjectile_CrusaderIII_HE'
    HEAmmoCount=42
    APAmmoCount=42
    SmokeAmmoCount=3

    // MG Ammo
    AmmoClass=class'DRAmmo_792x57_MG34Belt_150' // TODO: Correct ammo.
    MaxAmmoCount=250
    bUsesMagazines=true
    InitialNumPrimaryMags=9

    /// AIMING
    BaseAddedPitch=10
    APSightSettings.Empty
    HESightSettings.Empty
    // Range (AP), optical sights via HUDPosOffset
    APSightSettings(0)=(Range=100,HUDPosOffset=0,HUDRotOffset=0)
    // Range (HE), optical sights via HUDPosOffset
    HESightSettings(0)=(Range=100,HUDPosOffset=0,HUDRotOffset=0)

    PenetrationDepth=21.5
    MaxPenetrationTests=3
    MaxNumPenetrations=2

    OpticsExtraTex=Texture2D'DR_VH_UK_CrusaderIII.UITextures.ui_hud_vehicle_optics_Crusader_extra_line'
}
