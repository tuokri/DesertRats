class DRWeapon_Bren_LMG_Content extends DRWeapon_Bren_LMG;

DefaultProperties
{
    ArmsAnimSet=AnimSet'DR_WP_UK_BREN.Animation.WP_BrenMk2hands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_UK_BREN.Mesh.GB_BrenMk2_UPGD1'
        PhysicsAsset=None
        AnimSets(0)=AnimSet'DR_WP_UK_BREN.Animation.WP_BrenMk2hands'
        Animations=AnimTree'DR_WP_UK_BREN.Animation.GB_BrenLMGBipod_Tree'
        Scale=1.0
        FOV=70
    End Object

    // Pickup staticmesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_UK_BREN.Mesh.BrenMk2_3rd_Master'
        PhysicsAsset=PhysicsAsset'DR_WP_UK_BREN.Phy.BrenMk2_3rd_Master_Physics'
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

    AttachmentClass=class'DesertRats.DRWeapAttach_Bren_LMG'

    // WeaponFireSnd[0]=SoundCue'WP_WF_GB_BrenMk2.Audio.BrenFire_loop_3p_cue'
    // WeaponFireSnd[1]=none
}
