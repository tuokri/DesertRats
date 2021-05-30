class DRWeapAttach_Thompson_M1928A1_SMG extends DRWeapAttach_Thompson_SMG;

DefaultProperties
{
    WeaponClass=class'DRWeap_Thompson_M1928A1_SMG'

    // Weapon SkeletalMesh
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_UK_M1928A1.Mesh.Thompson_3rd_Master_UPGD2'
        AnimSets(0)=AnimSet'WP_VN_ARVN_3rd_Master.Anim.ThompsonM1A1_3rd_Anims'
        AnimTreeTemplate=AnimTree'WP_VN_ARVN_3rd_Master.AnimTree.M1Thompson_SMG_3rd_Tree'
        Animations=NONE
        PhysicsAsset=PhysicsAsset'DR_WP_UK_M1928A1.Phy.Thompson_3rd_Master_UPGD2_Physics'
        CullDistance=5000
    End Object
}
