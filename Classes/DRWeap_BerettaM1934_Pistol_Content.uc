class DRWeap_BerettaM1934_Pistol_Content extends DRWeap_BerettaM1934_Pistol;

DefaultProperties
{
    ArmsAnimSet=AnimSet'DR_WP_DAK_Beretta34.Anim.WP_BerettaM1934_PistolHands'

    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_Beretta34.Mesh.Beretta34_1st'
        PhysicsAsset=PhysicsAsset'WP_VN_VC_Makarov_Pistol.Phys.VC_Makarov_Pistol_Physics'
        AnimSets(0)=AnimSet'DR_WP_DAK_Beretta34.Anim.WP_BerettaM1934_PistolHands'
        AnimTreeTemplate=AnimTree'DR_WP_DAK_Beretta34.Anim.BerettaM1934_AnimTree'
        Scale=1.0
        FOV=70
    End Object

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'WP_VN_3rd_Master_02.Mesh.Makarov_Pistol_3rd_Master'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master_02.Phy.Makarov_3rd_Physics'
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=true
        BlockNonZeroExtent=true
        BlockRigidBody=true
        bHasPhysicsAssetInstance=false
        bUpdateKinematicBonesFromAnimation=false
        PhysicsWeight=1.0
        RBChannel=RBCC_GameplayPhysics
        RBCollideWithChannels=(Default=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
        bSkipAllUpdateWhenPhysicsAsleep=TRUE
        bSyncActorLocationToRootRigidBody=true
    End Object

    AttachmentClass=class'DesertRats.DRWeapAttach_BerettaM1943_Pistol'
}
