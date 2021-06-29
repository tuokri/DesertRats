class DRVehicle_Valentine_Content extends DRVehicle_Valentine
    placeable;

DefaultProperties
{
    Begin Object Name=ROSVehicleMesh
        SkeletalMesh=SkeletalMesh'DR_VH_UK_Valentine.Mesh.Valentine_RIG'
        AnimTreeTemplate=AnimTree'DR_VH_UK_Valentine.Anim.Valentine_AnimTree'
        PhysicsAsset=PhysicsAsset'DR_VH_UK_Valentine.Phy.Valentine_Physics'
    End Object

    DestroyedSkeletalMesh=SkeletalMesh'DR_VH_UK_Valentine.Mesh.Valentine_WRECK'
    DestroyedPhysicsAsset=PhysicsAsset'DR_VH_UK_Valentine.Phy.Valentine_WRECK_Physics'
    DestroyedMaterial=MaterialInstanceConstant'DR_VH_UK_CrusaderIII.Materials.M_MKIII_Hull_Destroyed'

    DestroyedSkeletalMeshWithoutTurret=SkeletalMesh'DR_VH_UK_Valentine.Mesh.Valentine_WRECK_Body'
    DestroyedTurretClass=class'DRVehicleDeathTurret_CrusaderMkIII'

    HUDBodyTexture=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_pz4_body'
    HUDTurretTexture=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_pz4_turret'
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

    SeatProxies(0)={(
        TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
        HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head1_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Long_INST',
        SeatIndex=0,
        PositionIndex=0
    )}

    SeatProxies(1)={(
        TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
        HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
        HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head1_Mesh',
        HeadphonesMeshType=none,
        HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
        BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Long_INST',
        SeatIndex=1,
        PositionIndex=0
    )}

    SeatProxyAnimSet=AnimSet'VH_VN_ARVN_M113_APC.Anim.CHR_M113_Anim_Master'
}
