class DRVehicle_SdKfz_251_Halftrack_Content extends DRVehicle_SdKfz_251_Halftrack
    placeable;

DefaultProperties
{
    // ------------------------------- Mesh --------------------------------------------------------------

    Begin Object Name=ROSVehicleMesh
        SkeletalMesh=SkeletalMesh'DR_VH_DAK_SdKfz.Mesh.Ger_SdkFz_Rig_Master'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
        AnimTreeTemplate=AnimTree'DR_VH_DAK_SdKfz.Anim.AT_VH_SdkFz'
        PhysicsAsset=PhysicsAsset'DR_VH_DAK_SdKfz.Phys.Ger_SdkFz_Rig_Master_Physics'
        AnimSets.Add(AnimSet'DR_VH_DAK_SdKfz.Anim.SdkFz_Anim_Master')
        AnimSets.Add(AnimSet'DR_VH_DAK_SdKfz.Anim.Ger_SdkFz_Destroyed_Anims')
    End Object

    /*
    // -------------------------------- Sounds -----------------------------------------------------------

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
        SoundCue=SoundCue'AUD_Vehicle_Transport_SdkFz.Movement.SdkFz_Movement_Engine_Start_Exhaust_Cue'
    End Object
    EngineStartExhaustSound=StartEngineExhaustSound

    Begin Object Class=AudioComponent Name=StopEngineSound
        SoundCue=SoundCue'AUD_Vehicle_Transport_SdkFz.Movement.SdkFz_Movement_Engine_Stop_Cue'
    End Object
    EngineStopSound=StopEngineSound

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
        SoundCue=SoundCue'AUD_Vehicle_Transport_SdkFz.Movement.SdkFz_Movement_Engine_Run_Exhaust_Cue'
        bShouldRemainActiveIfDropped=TRUE
    End Object
    EngineSound=IdleEngineExhaustSound

    // Track sounds
    Begin Object Class=AudioComponent Name=TrackLSound
        SoundCue=SoundCue'AUD_Vehicle_Transport_SdkFz.Movement.SdkFz_Movement_Treads_L_Cue'
    End Object
    TrackLeftSound=TrackLSound

    Begin Object Class=AudioComponent Name=TrackRSound
        SoundCue=SoundCue'AUD_Vehicle_Transport_SdkFz.Movement.SdkFz_Movement_Treads_R_Cue'
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
    ShiftUpSound=SoundCue'AUD_Vehicle_Transport_SdkFz.Movement.SdkFz_Movement_Engine_Exhaust_ShiftUp_Cue'
    ShiftDownSound=SoundCue'AUD_Vehicle_Tank_T34.Movement.T34_Movement_Engine_Exhaust_ShiftDown_Cue'
    ShiftLeverSound=SoundCue'AUD_Vehicle_Tank_PanzerIV.Foley.Panzer_Lever_GearShift_Cue'


    ExplosionSound=SoundCue'AUD_EXP_Tanks.A_CUE_Tank_Explode'


    Begin Object Class=AudioComponent name=HullMGSoundComponent
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
        SoundCue=SoundCue'AUD_Firearms_MG_MG34.Fire_3P.MG_MG34_Fire_Loop_M_Cue'
    End Object
    HullMGAmbient=HullMGSoundComponent
    Components.Add(HullMGSoundComponent)

    HullMGStopSound=SoundCue'AUD_Firearms_MG_MG34.Fire_3P.MG_MG34_Fire_LoopEnd_M_Cue'

    */

    // -------------------------------- Dead -----------------------------------------------------------

    DestroyedSkeletalMesh=SkeletalMesh'DR_VH_DAK_SdKfz.Mesh.Ger_SdkFz_Destroyed_Master'
    DestroyedSkeletalMeshWithoutTurret=SkeletalMesh'DR_VH_DAK_SdKfz.Mesh.Ger_SdkFz_Destroyed_Master'
    DestroyedPhysicsAsset=PhysicsAsset'DR_VH_DAK_SdKfz.Phys.Ger_SdkFz_Destroyed_Master_Physics'
    DestroyedMaterial=MaterialInstanceConstant'DR_VH_DAK_SdKfz.MIC.SdKfz_Destr_INST'
    DestroyedMaterial2=Material'VH_VN_Drivable_M113_APC.Materials.M113_APC_LTread'
    DestroyedMaterial3=MaterialInstanceConstant'DR_WP_DAK_MG34_LMG.Materials.3rd_Ger_MG34_LOD_MIC'
    DestroyedFXMaterial=MaterialInstanceConstant'DR_WP_DAK_MG34_LMG.Materials.3rd_Ger_MG34_LOD_MIC'
    DestroyedTurretClass=none

    // HUD
    HUDBodyTexture=Texture2D'DR_VH_DAK_SdKfz.UITextures.ui_hud_sdkfz_VehicleBase'
    HUDTurretTexture=none
    DriverOverlayTexture=none

    HUDMainCannonTexture=none
    HUDGearBoxTexture=Texture2D'DR_VH_DAK_SdKfz.UITextures.ui_hud_sdkfz_Transmission'
    HUDFrontArmorTexture=Texture2D'DR_VH_DAK_SdKfz.UITextures.ui_hud_sdkfz_FrontArmor'
    HUDBackArmorTexture=Texture2D'DR_VH_DAK_SdKfz.UITextures.ui_hud_sdkfz_RearArmor'
    HUDLeftArmorTexture=Texture2D'DR_VH_DAK_SdKfz.UITextures.ui_hud_sdkfz_LeftArmor'
    HUDRightArmorTexture=Texture2D'DR_VH_DAK_SdKfz.UITextures.ui_hud_sdkfz_RightArmor'
    // TODO: Check these wheel textures:
    HUDRightSteerWheelTexture=Texture2D'DR_VH_DAK_SdKfz.UITextures.ui_hud_sdkfz_RightSteerWheel'
    HUDLeftSteerWheelTexture=Texture2D'DR_VH_DAK_SdKfz.UITextures.ui_hud_sdkfz_LeftSteerWheel'

    //? RoleSelectionImage=Texture2D'UI_Textures_VehiclePack.Textures.Sov_tank_UC'

    // Driver
    SeatProxies(0)={(
        TunicMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt',
        HeadGearMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head6_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_06_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
        SeatIndex=0,
        PositionIndex=1)}

    // Hull MG
    SeatProxies(1)={(
        TunicMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt',
        HeadGearMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head6_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_06_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
        SeatIndex=1,
        PositionIndex=1)}

    //PASS1
    SeatProxies(2)={(
        TunicMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt',
        HeadGearMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head6_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_06_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
        SeatIndex=2,
        PositionIndex=0)}

    //PASS2
    SeatProxies(3)={(
        TunicMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt',
        HeadGearMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head6_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_06_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
        SeatIndex=3,
        PositionIndex=0)}
    //PASS3
    SeatProxies(4)={(
        TunicMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt',
        HeadGearMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head6_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_06_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
        SeatIndex=4,
        PositionIndex=0)}
    //PASS4
    SeatProxies(5)={(
        TunicMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt',
        HeadGearMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head6_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_06_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
        SeatIndex=5,
        PositionIndex=0)}
    //PASS5
    SeatProxies(6)={(
        TunicMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt',
        HeadGearMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head6_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_06_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
        SeatIndex=6,
        PositionIndex=0)}
    //PASS6
    SeatProxies(7)={(
        TunicMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt',
        HeadGearMeshType=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head6_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_06_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
        SeatIndex=7,
        PositionIndex=0)}

    // Seat proxy animations
    SeatProxyAnimSet=AnimSet'DR_VH_DAK_SdKfz.Anim.CHR_SdkFz_Anim_Master'


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

    Begin Object class=StaticMeshComponent name=ExtBodyAttachment0
        StaticMesh=StaticMesh'DR_VH_DAK_SdKfz.Mesh.SdKfz_Body_Ext'
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
        StaticMesh=StaticMesh'DR_VH_DAK_SdKfz.Mesh.SdKfz_Body_Int'
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

//  Begin Object class=StaticMeshComponent name=IntBodyAttachment1
//      StaticMesh=StaticMesh'VH_Ger_Halftrack.Mesh.VH_SM_HT_Driver_Side'
//      LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
//      LightEnvironment = MyInteriorLightEnvironment
//      CastShadow=false
//      DepthPriorityGroup=SDPG_Foreground
//      HiddenGame=true
//      CollideActors=false
//      BlockActors=false
//      BlockZeroExtent=false
//      BlockNonZeroExtent=false
//  End Object

    /*Begin Object class=StaticMeshComponent name=IntBodyAttachment2
        StaticMesh=StaticMesh'VH_Ger_Halftrack.Mesh.VH_SM_HT_Pass_Back'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
        LightEnvironment = MyInteriorLightEnvironment
        CastShadow=false
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object*/

//  Begin Object class=StaticMeshComponent name=IntBodyAttachment3
//      StaticMesh=StaticMesh'VH_Ger_Halftrack.Mesh.VH_SM_HT_Pass_Side'
//      LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
//      LightEnvironment = MyInteriorLightEnvironment
//      CastShadow=false
//      DepthPriorityGroup=SDPG_Foreground
//      HiddenGame=true
//      CollideActors=false
//      BlockActors=false
//      BlockZeroExtent=false
//      BlockNonZeroExtent=false
//  End Object

    /*Begin Object class=StaticMeshComponent name=IntBodyAttachment4
        StaticMesh=StaticMesh'VH_ger_SdKfz.Mesh.VH_SM_SdkFz_Int_Body'
        LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
        LightEnvironment = MyInteriorLightEnvironment
        CastShadow=false
        DepthPriorityGroup=SDPG_Foreground
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object*/

    MeshAttachments(0)={(AttachmentName=ExtBodyComponent,Component=ExtBodyAttachment0,AttachmentTargetName=chassis)}
    MeshAttachments(1)={(AttachmentName=IntBodyComponent,Component=IntBodyAttachment0,AttachmentTargetName=chassis)}
    //MeshAttachments(2)={(AttachmentName=IntBodyComponent2,Component=IntBodyAttachment1,AttachmentTargetName=chassis)}
    //MeshAttachments(3)={(AttachmentName=IntBodyComponent3,Component=IntBodyAttachment2,AttachmentTargetName=chassis)}
    //MeshAttachments(4)={(AttachmentName=IntBodyComponent4,Component=IntBodyAttachment3,AttachmentTargetName=chassis)}
    //MeshAttachments(5)={(AttachmentName=IntBodyComponent5,Component=IntBodyAttachment4,AttachmentTargetName=chassis)}
}
