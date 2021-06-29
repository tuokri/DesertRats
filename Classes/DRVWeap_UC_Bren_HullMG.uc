class DRVWeap_UC_Bren_HullMG extends DRVWeap_Transport_HullMG
    abstract
    HideDropDown;

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRVWeap_UC_Bren_HullMG_Content"
    SeatIndex=1
    PlayerIronSightFOV=55 // No real zoom

    // MAIN FIREMODE
    FiringStatesArray(0)=WeaponFiring
    WeaponFireTypes(0)=EWFT_Projectile
    WeaponProjectiles(0)=class'DRBullet_Bren'
    FireInterval(0)=+0.12
    FireCameraAnim(0)=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    Spread(0)=0.000175

    // AI
    AILongDistanceScale=1.25
    AIMediumDistanceScale=1.1
    AISpreadScale=200.0
    AISpreadNoSeeScale=2.0
    AISpreadNMEStillScale=0.5
    AISpreadNMESprintScale=1.5

    // ALT FIREMODE
    FiringStatesArray(ALTERNATE_FIREMODE)=none
    //WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Projectile
    WeaponProjectiles(ALTERNATE_FIREMODE)=none
    FireInterval(ALTERNATE_FIREMODE)=+0.092
    FireCameraAnim(ALTERNATE_FIREMODE)=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
    Spread(ALTERNATE_FIREMODE)=0.000175

    FireTriggerTags=(UCHullMG)
    AltFireTriggerTags=(UCHullMG)

    VehicleClass=class'DRVehicle_UC'

//  bRecommendSplashDamage=true
//  bInstantHit=false
//
//  Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
//      Samples(0)=(LeftAmplitude=50,RightAmplitude=80,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.200)
//  End Object
//  WeaponFireWaveForm=ForceFeedbackWaveformShooting1

    // Ammo
    AmmoClass=class'DRAmmo_77x56_BrenBox'
    MaxAmmoCount=30
    bUsesMagazines=true
    InitialNumPrimaryMags=19

    PenetrationDepth=22.23
    MaxPenetrationTests=3
    MaxNumPenetrations=2
}
