class DRVWeap_ShermanIII_HullMG extends ROVWeap_HullMG
    abstract
    HideDropDown;

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRVWeap_M4A3_HullMG_Content"
    SeatIndex=3
    PlayerIronSightFOV=13.5 //2.4x zoom
    bUseOverlayWhenAiming=true

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponFiring
    WeaponFireTypes(0)=EWFT_Projectile
    //? WeaponProjectiles(0)=class'MG34_VehicleBullet'
    FireInterval(0)=+0.15
    FireCameraAnim(0)=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    Spread(0)=0.0007
    //ShotCost(0)=0

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=none
    WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_None
    WeaponProjectiles(ALTERNATE_FIREMODE)=none
    FireInterval(ALTERNATE_FIREMODE)=+0.15
    FireCameraAnim(ALTERNATE_FIREMODE)=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    Spread(ALTERNATE_FIREMODE)=0.0007
    //ShotCost(ALTERNATE_FIREMODE)=0
    //bZoomedFireMode(ALTERNATE_FIREMODE)=1

    // AI
    AILongDistanceScale=1.15
    AIMediumDistanceScale=1.1
    AISpreadScale=200.0
    AISpreadNoSeeScale=2.0
    AISpreadNMEStillScale=0.5
    AISpreadNMESprintScale=1.5

    FireTriggerTags=(PanzerIVGHullMG)
    AltFireTriggerTags=(PanzerIVGHullMG)

    // ZoomedTargetFOV=40.0
    // ZoomedRate=60.0

    VehicleClass=class'DRVehicle_ShermanIII'

    // Ammo
    //? AmmoClass=class'WFAmmo_30calBelt_250Rd'
    MaxAmmoCount=250
    bUsesMagazines=true
    InitialNumPrimaryMags=6

    PenetrationDepth=23.5
    MaxPenetrationTests=3
    MaxNumPenetrations=2
}
