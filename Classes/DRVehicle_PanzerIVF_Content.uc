class DRVehicle_PanzerIVF_Content extends DRVehicle_PanzerIVF
    placeable;

DefaultProperties
{
    // ------------------------------- Mesh --------------------------------------------------------------

    Begin Object Name=ROSVehicleMesh
        SkeletalMesh=SkeletalMesh'DR_VH_DAK_PanzerIV_F.Mesh.Ger_PZIV_Rig_Master'
        //MorphSets[0]=MorphTargetSet'VH_Goliath.Mesh.SK_VH_Goliath_Morph'
        AnimTreeTemplate=AnimTree'DR_VH_DAK_PanzerIV_F.Anim.AT_VH_PanzerIVG_New'
        PhysicsAsset=PhysicsAsset'DR_VH_DAK_PanzerIV_F.Phys.Ger_PZIV_Rig_new_Physics'
        AnimSets.Add(AnimSet'DR_VH_DAK_PanzerIV_F.Anim.PZIV_anim_Master')
        AnimSets.Add(AnimSet'DR_VH_DAK_PanzerIV_F.Anim.PZIV_Destroyed_anim_Master')
    End Object

    // -------------------------------- Sounds -----------------------------------------------------------

    /*
    // Engine start sounds
    Begin Object Class=AudioComponent Name=StartEngineLSound
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Start_Cabin_L_Cue'
    End Object
    EngineStartLeftSound=StartEngineLSound

    Begin Object Class=AudioComponent Name=StartEngineRSound
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Start_Cabin_R_Cue'
    End Object
    EngineStartRightSound=StartEngineRSound

    Begin Object Class=AudioComponent Name=StartEngineExhaustSound
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Start_Exhaust_Cue'
    End Object
    EngineStartExhaustSound=StartEngineExhaustSound

    // Engine idle sounds
    Begin Object Class=AudioComponent Name=IdleEngineLeftSound
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Run_Cabin_L_Cue'
        bShouldRemainActiveIfDropped=TRUE
    End Object
    EngineIntLeftSound=IdleEngineLeftSound

    Begin Object Class=AudioComponent Name=IdleEngineRighSound
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Run_Cabin_R_Cue'
        bShouldRemainActiveIfDropped=TRUE
    End Object
    EngineIntRightSound=IdleEngineRighSound

    Begin Object Class=AudioComponent Name=IdleEngineExhaustSound
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Run_Exhaust_Cue'
        bShouldRemainActiveIfDropped=TRUE
    End Object
    EngineSound=IdleEngineExhaustSound

    // Track sounds
    Begin Object Class=AudioComponent Name=TrackLSound
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_L_Cue'
    End Object
    TrackLeftSound=TrackLSound

    Begin Object Class=AudioComponent Name=TrackRSound
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_R_Cue'
    End Object
    TrackRightSound=TrackRSound

    // Brake sounds
    Begin Object Class=AudioComponent Name=BrakeLeftSnd
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_Brake_Cue'
    End Object
    BrakeLeftSound=BrakeLeftSnd

    Begin Object Class=AudioComponent Name=BrakeRightSnd
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_Brake_Cue'
    End Object
    BrakeRightSound=BrakeRightSnd

    // Damage sounds
    EngineIdleDamagedSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Broken_Cue'
    TrackTakeDamageSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_Brake_Cue'
    TrackDamagedSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_Broken_Cue'
    TrackDestroyedSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Treads_Skid_Cue'

    // Destroyed tranmission
    Begin Object Class=AudioComponent Name=BrokenTransmissionSnd
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Transmission_Broken_Cue'
        bStopWhenOwnerDestroyed=TRUE
    End Object
    BrokenTransmissionSound=BrokenTransmissionSnd

    // Gear shift sounds
    ShiftUpSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Exhaust_ShiftUp_Cue'
    ShiftDownSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Movement.Panzer_Movement_Engine_Exhaust_ShiftDown_Cue'
    ShiftLeverSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Foley.Panzer_Lever_GearShift_Cue'

    // Turret sounds
    Begin Object Class=AudioComponent Name=TurretTraverseComponent
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Turret.Turret_Traverse_Manual_Cue'
    End Object
    TurretTraverseSound=TurretTraverseComponent
    Components.Add(TurretTraverseComponent);

    Begin Object Class=AudioComponent Name=TurretMotorTraverseComponent
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Turret.Turret_Traverse_Electric_Cue'
    End Object
    TurretMotorTraverseSound=TurretMotorTraverseComponent
    Components.Add(TurretMotorTraverseComponent);

    Begin Object Class=AudioComponent Name=TurretElevationComponent
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Turret.Turret_Elevate_Cue'
    End Object
    TurretElevationSound=TurretElevationComponent
    Components.Add(TurretElevationComponent);

    ExplosionSound=SoundCue'AUD_EXP_Tanks.A_CUE_Tank_Explode'

    Begin Object Class=AudioComponent name=HullMGSoundComponent
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Weapon.MG_MG34_Fire_Loop_M_Cue'
    End Object
    HullMGAmbient=HullMGSoundComponent
    Components.Add(HullMGSoundComponent)

    Begin Object Class=AudioComponent name=CoaxMGSoundComponent
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
        SoundCue=SoundCue'AUD_Vehicle_Tank_PanzerIV.Weapon.MG_MG34_Fire_Loop_M_Cue'
    End Object
    CoaxMGAmbient=CoaxMGSoundComponent
    Components.Add(CoaxMGSoundComponent)

    HullMGStopSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Weapon.MG_MG34_Fire_LoopEnd_M_Cue'
    CoaxMGStopSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Weapon.MG_MG34_Fire_LoopEnd_M_Cue'

    */
    // -------------------------------- Dead -----------------------------------------------------------

    DestroyedSkeletalMesh=SkeletalMesh'DR_VH_DAK_PanzerIV_F.Mesh.Ger_PZIV_Destroyed_Master'
    DestroyedSkeletalMeshWithoutTurret=SkeletalMesh'DR_VH_DAK_PanzerIV_F.Mesh.PZIV_Body_Destroyed'
    DestroyedPhysicsAsset=PhysicsAsset'DR_VH_DAK_PanzerIV_F.Phys.Ger_PZIV_Destroyed_Physics'
    DestroyedMaterial=MaterialInstanceConstant'DR_VH_DAK_PanzerIV_F.MIC.VH_DAK_PZIV_Destroyed_INST'
    //? DestroyedFXMaterial=Material'Vehicle_Mats.M_Common_Vehicles.Tank_Fireplanes'
    DestroyedTurretClass=class'DRVehicleDeathTurret_PanzerIVF'

    // HUD
    HUDBodyTexture=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_pz4_body'
    HUDTurretTexture=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_pz4_turret'
    //? DriverOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_PZIV_driver'
    HUDMainCannonTexture=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_GunPZ'
    HUDGearBoxTexture=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_transmition_PZ'
    HUDFrontArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_PZ4armor_front'
    HUDBackArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_PZ4armor_back'
    HUDLeftArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_PZ4armor_left'
    HUDRightArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_PZ4armor_right'
    HUDTurretFrontArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_PZ4armor_turretfront'
    HUDTurretBackArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_PZ4armor_turretback'
    HUDTurretLeftArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_PZ4armor_turretleft'
    HUDTurretRightArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_PZ4armor_turretright'

    RoleSelectionImage=Texture2D'ui_textures.Textures.ger_tank_pzIVg'

    // Driver
    SeatProxies(0)={(
        TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
        HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head1_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Long_INST',
        SeatIndex=0,
        PositionIndex=1)}

    // Commander
    SeatProxies(1)={(
        TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
        HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head1_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Long_INST',
        SeatIndex=1,
        PositionIndex=1)}

    // Hull MG
    SeatProxies(2)={(
        TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
        HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head1_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Long_INST',
        SeatIndex=3,
        PositionIndex=2)}

    // Loader
    SeatProxies(3)={(
        TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
        HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head1_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Long_INST',
        SeatIndex=4,
        PositionIndex=0)}

    // Gunner
    SeatProxies(4)={(
        TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
        HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head1_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Long_INST',
        SeatIndex=2,
        PositionIndex=0)}

    // Seat proxy animations
    // SeatProxyAnimSet=AnimSet'CHR_Playeranim_Master.Anim.CHR_Panzer4G_Anim_Master'

    //----------------------------------------------------------------
    //                 Tank Attachments
    //
    // Exterior attachments use the exterior light environment,
    // accept light from the dominant directional light only and
    // cast shadows
    //
    // Interior attachments use the interior light environment,
    // accept light from both the dominant directional light and
    // the vehicle interior lights. They do not usually cast shadows.
    // Exceptions are attachments which share a part of the mesh with
    // the exterior.
    //----------------------------------------------------------------

    // -------------- Exterior attachments ------------------//
    /*

    Begin Object class=StaticMeshComponent name=ExtBodyAttachment0
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Ext_Body'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
        LightEnvironment = MyLightEnvironment
        CastShadow=true
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=ExtBodyAttachment1
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Ext_Turret'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
        LightEnvironment = MyLightEnvironment
        CastShadow=true
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=ExtBodyAttachment2
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Ext_GunBase'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
        LightEnvironment = MyLightEnvironment
        CastShadow=true
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=ExtBodyAttachment3
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Ext_Barrel'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
        LightEnvironment = MyLightEnvironment
        CastShadow=true
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=ExtBodyAttachment4
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Ext_MG'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
        LightEnvironment = MyLightEnvironment
        CastShadow=true
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    // -------------- Interior attachments ------------------//

    Begin Object class=StaticMeshComponent name=IntBodyAttachment0
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Int_Body'
        LightingChannels=(Dynamic=FALSE,Unnamed_1=TRUE,bInitialized=TRUE)
        LightEnvironment = MyInteriorLightEnvironment
        CastShadow=false
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=IntBodyAttachment6
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Int_Main_Ammo'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
        LightEnvironment = MyInteriorLightEnvironment
        CastShadow=false
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=IntBodyAttachment8
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Hull_Side_1'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
        LightEnvironment = MyInteriorLightEnvironment
        CastShadow=false
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=IntBodyAttachment10
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Driver_Side_1'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
        LightEnvironment = MyInteriorLightEnvironment
        CastShadow=false
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=IntBodyAttachment13
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Int_HullMG'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
        LightEnvironment = MyInteriorLightEnvironment
        CastShadow=false
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=TurretAttachment0
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Int_Turret'
        LightingChannels=(Dynamic=FALSE,Unnamed_1=TRUE,bInitialized=TRUE)
        LightEnvironment = MyInteriorLightEnvironment
        CastShadow=false
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=TurretAttachment1
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Int_GunBase'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
        LightEnvironment = MyInteriorLightEnvironment
        CastShadow=false
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=TurretAttachment2
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Int_Coppola'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
        LightEnvironment = MyInteriorLightEnvironment
        CastShadow=true
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=TurretAttachment5
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Int_Turret_Details_1'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
        LightEnvironment = MyInteriorLightEnvironment
        CastShadow=false
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    Begin Object class=StaticMeshComponent name=TurretAttachment7
        StaticMesh=StaticMesh'VH_Ger_Panzer_IVG_Interior.Mesh.VH_SM_PzIVG_Int_Turret_Basket'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
        LightEnvironment = MyInteriorLightEnvironment
        CastShadow=false
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object

    MeshAttachments(0)={(AttachmentName=ExtBodyComponent,Component=ExtBodyAttachment0,bAttachToSocket=true,AttachmentTargetName=attachments_body)}
    MeshAttachments(1)={(AttachmentName=ExtTurretComponent,Component=ExtBodyAttachment1,bAttachToSocket=true,AttachmentTargetName=attachments_turret)}
    MeshAttachments(2)={(AttachmentName=ExtGunBaseComponent,Component=ExtBodyAttachment2,bAttachToSocket=true,AttachmentTargetName=attachments_gun)}
    MeshAttachments(3)={(AttachmentName=ExtBarrelComponent,Component=ExtBodyAttachment3,bAttachToSocket=true,AttachmentTargetName=attachments_turretBarrel)}
    MeshAttachments(4)={(AttachmentName=ExtMGComponent,Component=ExtBodyAttachment4,bAttachToSocket=true,AttachmentTargetName=attachments_MGPitch)}
    MeshAttachments(5)={(AttachmentName=IntBodyComponent,Component=IntBodyAttachment0,bAttachToSocket=true,AttachmentTargetName=attachments_body)}
    MeshAttachments(6)={(AttachmentName=IntMainAmmoComponent,Component=IntBodyAttachment6,bAttachToSocket=true,AttachmentTargetName=attachments_body)}
    MeshAttachments(7)={(AttachmentName=IntHullSide1Component,Component=IntBodyAttachment8,bAttachToSocket=true,AttachmentTargetName=attachments_body)}
    MeshAttachments(8)={(AttachmentName=IntDriverSide1Component,Component=IntBodyAttachment10,bAttachToSocket=true,AttachmentTargetName=attachments_body)}
    MeshAttachments(9)={(AttachmentName=IntHullMGComponent,Component=IntBodyAttachment13,bAttachToSocket=false,AttachmentTargetName=Hull_MG_interior)}
    MeshAttachments(10)={(AttachmentName=TurretComponent,Component=TurretAttachment0,bAttachToSocket=true,AttachmentTargetName=attachments_turret)}
    MeshAttachments(11)={(AttachmentName=TurretGunGaseComponent,Component=TurretAttachment1,bAttachToSocket=true,AttachmentTargetName=attachments_gun)}
    MeshAttachments(12)={(AttachmentName=TurretCuppolaComponent,Component=TurretAttachment2,bAttachToSocket=true,AttachmentTargetName=attachments_turret)}
    MeshAttachments(13)={(AttachmentName=TurretDetails1Component,Component=TurretAttachment5,bAttachToSocket=true,AttachmentTargetName=attachments_turret)}
    MeshAttachments(14)={(AttachmentName=TurretBasketComponent,Component=TurretAttachment7,bAttachToSocket=true,AttachmentTargetName=attachments_turret)}

    */
}
