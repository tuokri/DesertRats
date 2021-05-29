class DRWeap_Vickers_HMG_Content extends DRWeap_Vickers_HMG;

DefaultProperties
{
    ArmsAnimSet=AnimSet'DR_WP_UK_Vickers_HMG.Anim.WP_VickersHands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'DR_WP_UK_Vickers_HMG.Mesh.Vickers'
        AnimSets(0)=AnimSet'DR_WP_UK_Vickers_HMG.Anim.WP_VickersHands'
        AnimTreeTemplate=AnimTree'DR_WP_UK_Vickers_HMG.Anim.VickersTurretAnimtree_1st'
    End Object

    // Arms SkeletalMesh
    Begin Object Name=FirstPersonArmsMesh
        AnimSets(1)=AnimSet'DR_WP_UK_Vickers_HMG.Anim.WP_VickersHands'
    End Object

    // Ammo belt SkeletalMesh
    Begin Object Name=AmmoBelt0
        SkeletalMesh=SkeletalMesh'DR_WP_UK_Vickers_HMG.Mesh.Vickers_Belt'
        PhysicsAsset=PhysicsAsset'DR_WP_UK_Vickers_HMG.Phy.Vickers_Belt_Physics'
        AnimSets.Add(AnimSet'DR_WP_UK_Vickers_HMG.Anim.WP_VickersHands')
        DepthPriorityGroup=SDPG_Foreground
        bOnlyOwnerSee=true
        MaxAmmoShown=18
    End Object
    AmmoBeltMesh=AmmoBelt0

    AttachmentClass=class'DesertRats.DRWeapAttach_Vickers_HMG'
}
