class DRVWeap_ShermanIII_Turret extends DRVWeap_TankTurret
    abstract
    HideDropDown;

simulated function DrawRangeOverlay( Hud HUD )
{
    // No range overlay for Sherman III.
}

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRVWeap_ShermanIII_Turret_Content"
    SeatIndex=2

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponSingleFiring
    WeaponFireTypes(0)=EWFT_Projectile
    WeaponProjectiles(0)=class'DRVProjectile_ShermanIII_AP'
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

    VehicleClass=class'DRVehicle_ShermanIII'

    // Main Gun Ammo
    MainGunProjectiles(MAINGUN_AP_INDEX)=class'DRVProjectile_ShermanIII_AP'
    MainGunProjectiles(MAINGUN_HE_INDEX)=class'DRVProjectile_ShermanIII_HE'
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
}
