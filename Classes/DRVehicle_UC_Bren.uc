// Bren carrier.
class DRVehicle_UC_Bren extends DRVehicle_UC
    abstract;

DefaultProperties
{
    Seats(0)={( CameraTag=none,
            CameraOffset=-420,
            SeatAnimBlendName=DriverPositionNode,
            SeatPositions=( (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=70.0,PositionUpAnim=Driver_leanIN,PositionIdleAnim=Driver_leanIN_idle,DriverIdleAnim=Driver_leanIN_idle,AlternateIdleAnim=Driver_leanIN_idle_AI,SeatProxyIndex=0,
                                    bIsExterior=true,
                                    LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverLeftSteer,DefaultEffectorRotationTargetName=IK_DriverLeftSteer,
                                        AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchLever,EffectorRotationTargetName=IK_DriverClutchLever))),
                                    RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverRightSteer,DefaultEffectorRotationTargetName=IK_DriverRightSteer),
                                    LeftFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverClutchPedal,DefaultEffectorRotationTargetName=IK_DriverClutchPedal,
                                        AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchPedal,EffectorRotationTargetName=IK_DriverClutchPedal))),
                                    RightFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverGasPedal,DefaultEffectorRotationTargetName=IK_DriverGasPedal),
                                    HipsIKInfo=(PinEnabled=true),
                                    PositionFlinchAnims=(Driver_open_Flinch),
                                    PositionDeathAnims=(Driver_Death)),
                            (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=70.0,PositionDownAnim=Driver_leanBACK,PositionIdleAnim=Driver_idle,DriverIdleAnim=Driver_idle,AlternateIdleAnim=Driver_idle_AI,SeatProxyIndex=0,
                                    bIsExterior=true,
                                    LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverLeftSteer,DefaultEffectorRotationTargetName=IK_DriverLeftSteer,
                                        AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchLever,EffectorRotationTargetName=IK_DriverClutchLever))),
                                    RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverRightSteer,DefaultEffectorRotationTargetName=IK_DriverRightSteer),
                                    LeftFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverClutchPedal,DefaultEffectorRotationTargetName=IK_DriverClutchPedal,
                                        AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchPedal,EffectorRotationTargetName=IK_DriverClutchPedal))),
                                    RightFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverGasPedal,DefaultEffectorRotationTargetName=IK_DriverGasPedal),
                                    HipsIKInfo=(PinEnabled=true),
                                    PositionFlinchAnims=(Driver_open_Flinch),
                                    PositionDeathAnims=(Driver_Death))),
            bSeatVisible=true,
            SeatBone=driver_player,
            DriverDamageMult=1.0,
            InitialPositionIndex=0,
            SeatRotation=(Pitch=0,Yaw=0,Roll=0),
            VehicleBloodMICParameterName=Gore03,
            )}

    Seats(1)={( GunClass=class'DRVWeap_UC_Bren_HullMG',
                //SightOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_mg',
                //VignetteOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_vignette',
                GunSocket=(MG_Barrel),
                SeatOffset=(X=0,y=1.5,Z=0),
                GunPivotPoints=(MG_Pitch),
                TurretVarPrefix="HullMG",
                TurretControls=(Hull_MG_Yaw,Hull_MG_Pitch),
                CameraTag=None,
                CameraOffset=-420,
                bSeatVisible=true,
                SeatBone=Hullgunner_bone,
                SeatAnimBlendName=HullMGPositionNode,
                SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=70.0,bRotateGunOnCommand=true,PositionUpAnim=MG_idleTOlean,PositionIdleAnim=MG_LeanIdle,DriverIdleAnim=MG_LeanIdle,AlternateIdleAnim=MG_LeanIdle_AI,SeatProxyIndex=1,bIgnoreWeapon=true,
                                    bIsExterior=true,
                                    LeftHandIKInfo=(PinEnabled=true),
                                    RightHandIKInfo=(PinEnabled=true),//(IKEnabled=true,DefaultEffectorLocationTargetName=IK_HullMGRightHand,DefaultEffectorRotationTargetName=IK_HullMGRightHand),
                                    HipsIKInfo=(PinEnabled=true),
                                    LeftFootIKInfo=(PinEnabled=true),
                                    RightFootIKInfo=(PinEnabled=true),
                                    PositionFlinchAnims=(MG_close_Flinch),
                                    PositionDeathAnims=(MG_Death)),
                                (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=70.0,bRotateGunOnCommand=true,PositionUpAnim=MG_ironTOidle,PositionDownAnim=MG_LeanTOidle,PositionIdleAnim=MG_Idle,DriverIdleAnim=MG_Idle,AlternateIdleAnim=MG_Idle_AI,SeatProxyIndex=1,bIgnoreWeapon=true,
                                    bIsExterior=true,
                                    LeftHandIKInfo=(PinEnabled=true),
                                    RightHandIKInfo=(PinEnabled=true),//(IKEnabled=true,DefaultEffectorLocationTargetName=IK_HullMGRightHand,DefaultEffectorRotationTargetName=IK_HullMGRightHand),
                                    HipsIKInfo=(PinEnabled=true),
                                    LeftFootIKInfo=(PinEnabled=true),
                                    RightFootIKInfo=(PinEnabled=true),
                                    PositionFlinchAnims=(MG_close_Flinch),
                                    PositionDeathAnims=(MG_Death)),
                                (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=MG_Camera,ViewFOV=55.0,bCamRotationFollowSocket=true,bViewFromCameraTag=true,bDrawOverlays=false,bUseDOF=true,
                                    bIsExterior=true,
                                    PositionDownAnim=MG_idleTOiron,PositionIdleAnim=MG_ironIdle,bConstrainRotation=false,YawContraintIndex=0,PitchContraintIndex=1,DriverIdleAnim=MG_ironIdle,AlternateIdleAnim=MG_ironIdle_AI,SeatProxyIndex=1,
                                    LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_HullMGLeftHand,DefaultEffectorRotationTargetName=IK_HullMGLeftHand),
                                    RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_HullMGRightHand,DefaultEffectorRotationTargetName=IK_HullMGRightHand),
                                    HipsIKInfo=(PinEnabled=true),
                                    LeftFootIKInfo=(PinEnabled=true),
                                    RightFootIKInfo=(PinEnabled=true),
                                    PositionFlinchAnims=(MG_close_Flinch),
                                    PositionDeathAnims=(MG_Death),
                                    ChestIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_HullMGChest,DefaultEffectorRotationTargetName=IK_HullMGChest))),
                DriverDamageMult=1.0,
                InitialPositionIndex=2,
                FiringPositionIndex=2,
                SeatRotation=(Pitch=0,Yaw=0,Roll=0),
                VehicleBloodMICParameterName=Gore03,
                TracerFrequency=5,
                //? WeaponTracerClass=(class'DT_UCBulletTracer',class'DT_UCBulletTracer'),
                MuzzleFlashLightClass=(class'ROVehicleMGMuzzleFlashLight',class'ROVehicleMGMuzzleFlashLight'),
                VehicleBloodMICParameterName=Gore01,
                )}

    Seats(2)={( CameraTag=None,
        CameraOffset=-420,
        SeatAnimBlendName=Pass1PositionNode,
        SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionUpAnim=Passenger1_SitUp,PositionIdleAnim=Passenger1_idle,DriverIdleAnim=Passenger1_idle,AlternateIdleAnim=Passenger1_idle_AI,SeatProxyIndex=2,
                        bIsExterior=true,
                        PositionDeathAnims=(Passenger1_Death)),
                      (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger1_Duck,PositionIdleAnim=Passenger1_DuckIdle,DriverIdleAnim=Passenger1_DuckIdle,AlternateIdleAnim=Passenger1_DuckIdle_AI,SeatProxyIndex=2,
                        bIsExterior=true,
                        bLimitViewRotation=true,
                        PositionDeathAnims=(Passenger1_Death))),
        TurretVarPrefix="PassengerOne",
        bSeatVisible=true,
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        SeatBone=passenger_l_1,
        DriverDamageMult=1.0,
        VehicleBloodMICParameterName=Gore04,
        )}

    Seats(3)={( CameraTag=None,
        CameraOffset=-420,
        SeatAnimBlendName=Pass2PositionNode,
        SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionUpAnim=Passenger3_SitUp,PositionIdleAnim=Passenger3_idle,DriverIdleAnim=Passenger3_idle,AlternateIdleAnim=Passenger3_idle_AI,SeatProxyIndex=3,
                        bIsExterior=true,
                        PositionDeathAnims=(Passenger3_Death)),
                      (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger3_Duck,PositionIdleAnim=Passenger3_DuckIdle,DriverIdleAnim=Passenger3_DuckIdle,AlternateIdleAnim=Passenger3_DuckIdle_AI,SeatProxyIndex=3,
                        bIsExterior=true,
                        bLimitViewRotation=true,
                        PositionDeathAnims=(Passenger3_Death))),
        TurretVarPrefix="PassengerTwo",
        bSeatVisible=true,
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        SeatBone=passenger_r_1,
        DriverDamageMult=1.0,
        VehicleBloodMICParameterName=Gore02,
        )}

    Seats(4)={( CameraTag=None,
        CameraOffset=-420,
        SeatAnimBlendName=Pass3PositionNode,
        SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionUpAnim=Passenger2_SitUp,PositionIdleAnim=Passenger2_idle,DriverIdleAnim=Passenger2_idle,AlternateIdleAnim=Passenger2_idle_AI,SeatProxyIndex=4,
                        bIsExterior=true,
                        PositionDeathAnims=(Passenger2_Death)),
                      (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger2_Duck,PositionIdleAnim=Passenger2_DuckIdle,DriverIdleAnim=Passenger2_DuckIdle,AlternateIdleAnim=Passenger2_DuckIdle_AI,SeatProxyIndex=4,
                        bIsExterior=true,
                        bLimitViewRotation=true,
                        PositionDeathAnims=(Passenger2_Death))),
        TurretVarPrefix="PassengerThree",
        bSeatVisible=true,
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        SeatBone=passenger_l_2,
        DriverDamageMult=1.0,
        VehicleBloodMICParameterName=Gore04,
        )}
    Seats(5)={( CameraTag=None,
        CameraOffset=-420,
        SeatAnimBlendName=Pass4PositionNode,
        SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionUpAnim=Passenger4_SitUp,PositionIdleAnim=Passenger4_idle,DriverIdleAnim=Passenger4_idle,AlternateIdleAnim=Passenger4_idle_AI,SeatProxyIndex=5,
                        bIsExterior=true,
                        PositionDeathAnims=(Passenger4_Death)),
                      (bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=70.0,PositionDownAnim=Passenger4_Duck,PositionIdleAnim=Passenger4_DuckIdle,DriverIdleAnim=Passenger4_DuckIdle,AlternateIdleAnim=Passenger4_DuckIdle_AI,SeatProxyIndex=5,
                        bIsExterior=true,
                        bLimitViewRotation=true,
                        PositionDeathAnims=(Passenger4_Death))),
        TurretVarPrefix="PassengerFour",
        bSeatVisible=true,
        SeatRotation=(Pitch=0,Yaw=0,Roll=0),
        SeatBone=passenger_r_2,
        DriverDamageMult=1.0,
        VehicleBloodMICParameterName=Gore02,
        )}

    CrewAnimSet=AnimSet'DR_VH_UK_UC.Anim.UC_Char_Anims'
}
