class DRVWeap_HT_HullMG extends ROVWeap_Transport_HullMG
    abstract
    HideDropDown;

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRVWeap_HT_HullMG_Content"
    SeatIndex=1
    PlayerIronSightFOV=55 // No real zoom

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponFiring
    WeaponFireTypes(0)=EWFT_Projectile
    WeaponProjectiles(0)=class'DRBullet_MG34_Turret' // TODO: own bullet class.
    FireInterval(0)=+0.075
    FireCameraAnim(0)=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    Spread(0)=0.0007

    // AI
    AILongDistanceScale=1.25
    AIMediumDistanceScale=1.1
    AISpreadScale=200.0
    AISpreadNoSeeScale=2.0
    AISpreadNMEStillScale=0.5
    AISpreadNMESprintScale=1.5

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
    WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Projectile
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRBullet_MG34_Turret' // TODO: own bullet class.
    FireInterval(ALTERNATE_FIREMODE)=+0.075
    FireCameraAnim(ALTERNATE_FIREMODE)=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    Spread(ALTERNATE_FIREMODE)=0.0007

    FireTriggerTags=(HTHullMG)
    AltFireTriggerTags=(HTHullMG)

    VehicleClass=class'DRVehicle_SdKfz_251_Halftrack'

//  bRecommendSplashDamage=true
//  bInstantHit=false
//
//  Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
//      Samples(0)=(LeftAmplitude=50,RightAmplitude=80,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.200)
//  End Object
//  WeaponFireWaveForm=ForceFeedbackWaveformShooting1

    // Ammo
    AmmoClass=class'DRAmmo_792x57_MG34Belt_250'
    MaxAmmoCount=50
    bUsesMagazines=true
    InitialNumPrimaryMags=24

    PenetrationDepth=23.5
    MaxPenetrationTests=3
    MaxNumPenetrations=2
}
