class DRVWeapon_PanzerIVF_HullMG extends ROVWeap_HullMG
    abstract
    HideDropDown;

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRVWeapon_PanzerIVF_HullMG_Content"
    SeatIndex=3
    PlayerIronSightFOV=13.5 //2.4x zoom
    bUseOverlayWhenAiming=true

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponFiring
    WeaponFireTypes(0)=EWFT_Projectile
    WeaponProjectiles(0)=class'DRVBullet_MG34'
    FireInterval(0)=+0.075
    FireCameraAnim(0)=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    Spread(0)=0.0007
    //ShotCost(0)=0

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
    WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Projectile
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRVBullet_MG34'
    FireInterval(ALTERNATE_FIREMODE)=+0.075
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

//  ZoomedTargetFOV=40.0
//  ZoomedRate=60.0
//
    VehicleClass=class'DRVehicle_PanzerIVF'
//
//  bRecommendSplashDamage=true
//  bInstantHit=false
//
//  Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
//      Samples(0)=(LeftAmplitude=50,RightAmplitude=80,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.200)
//  End Object
//  WeaponFireWaveForm=ForceFeedbackWaveformShooting1

    // Ammo
    AmmoClass=class'DRAmmo_792x57_MG34Belt_150'
    MaxAmmoCount=150
    bUsesMagazines=true
    InitialNumPrimaryMags=6

    PenetrationDepth=23.5
    MaxPenetrationTests=3
    MaxNumPenetrations=2
}
