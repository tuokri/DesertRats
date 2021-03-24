class DRWeap_MG34_Tripod_Content extends DRWeap_MG34_Tripod;

DefaultProperties
{
    ArmsAnimSet=AnimSet'DR_WP_DAK_MG34_Tripod.Animation.WP_MG34Tripod_Hands'

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_MG34_Tripod.Mesh.Ger_MG34_Tripod'
        AnimSets(0)=AnimSet'DR_WP_DAK_MG34_Tripod.Animation.WP_MG34Tripod_Hands'
        Animations=AnimTree'DR_WP_DAK_MG34_Tripod.Animation.MG34TurretAnimtree'
    End Object

    // Arms SkeletalMesh
    Begin Object Name=FirstPersonArmsMesh
        AnimSets(1)=AnimSet'DR_WP_DAK_MG34_Tripod.Animation.WP_MG34Tripod_Hands'
    End Object

    // Ammo belt SkeletalMesh
    Begin Object Name=AmmoBelt0
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_MG34_Tripod.Mesh.Ger_MG34_Tripod_Belt'
        PhysicsAsset=PhysicsAsset'DR_WP_DAK_MG34_Tripod.Phy.Ger_MG34_Tripod_Belt_Physics'
        AnimSets(0)=AnimSet'DR_WP_DAK_MG34_Tripod.Animation.WP_MG34Tripod_Hands'
        DepthPriorityGroup=SDPG_Foreground
        bOnlyOwnerSee=true
        MaxAmmoShown=22
    End Object
    AmmoBeltMesh=AmmoBelt0

    AttachmentClass=class'DesertRats.DRWeapAttach_MG34_LMG_Turret'
}
