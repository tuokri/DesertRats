class DRWeap_Kar98Scoped_Rifle_Content extends DRWeap_Kar98Scoped_Rifle;

DefaultProperties
{
    // Arms
    ArmsAnimSet=AnimSet'DR_WP_DAK_KAR98.Anim.WP_Kar98Hands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_KAR98.Mesh.Kar98_Sniper'
        Materials(2)=MaterialInstanceConstant'DR_WP_DAK_KAR98.MIC.Kar98_Scope_M'
        PhysicsAsset=PhysicsAsset'WP_VN_VC_MN9130_rifle.Phys.Sov_MN9130_Physics'
        AnimSets(0)=AnimSet'DR_WP_DAK_KAR98.Anim.WP_Kar98Hands'
        AnimTreeTemplate=AnimTree'DR_WP_DAK_KAR98.Anim.Ger_Kar98_Tree_Bayonet'
        Scale=1.0
        FOV=70
    End Object

    // Pickup staticmesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_KAR98.Mesh.Kar98_Sniper_3rd'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy.MN9130_3rd_Master_Physics'
        //? AnimTreeTemplate=AnimTree'DR_WP_DAK_KAR98.Anim.Ger_Kar98_Tree_Bayonet' // TODO: need separate one for 3rd person?
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=true
        BlockNonZeroExtent=true//false
        BlockRigidBody=true
        bHasPhysicsAssetInstance=false
        bUpdateKinematicBonesFromAnimation=false
        PhysicsWeight=1.0
        RBChannel=RBCC_GameplayPhysics
        RBCollideWithChannels=(Default=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
        bSkipAllUpdateWhenPhysicsAsleep=TRUE
        bSyncActorLocationToRootRigidBody=true
    End Object

    AttachmentClass=class'DRWeapAttach_Kar98Scoped_Rifle'

    //? WeaponFireSnd[0]=SoundCue'AUD_Firearms_Rifle_Kar98_Sn.Fire_3P.Rifle_Kar98_Sniper_Fire_Single_M_Cue'
    //? WeaponFireSnd[1]=SoundCue'AUD_Firearms_Rifle_Kar98_Sn.Fire_3P.Rifle_Kar98_Sniper_Fire_Single_M_Cue'

    // TODO: GET KAR98 SNIPER RETICLE FROM RO2!!
    ScopeLenseMICTemplate=MaterialInstanceConstant'WP_VN_VC_MAS49.Materials.VC_MAS49_LenseMat_PU'
}
