class DRWeapAttach_Kar98AZ_Rifle extends ROWeapAttach_MN9130_Rifle;

DefaultProperties
{
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_KAR98AZ.Mesh.KAR98AZ_3rd'
        AnimSets(0)=AnimSet'WP_VN_3rd_Master.Anim.MN9130_3rd_anim'
        AnimTreeTemplate=AnimTree'WP_VN_3rd_Master.AnimTree.MN9130_3rd_Tree'
        Animations=NONE
        PhysicsAsset=PhysicsAsset'DR_WP_DAK_KAR98AZ.Phy.KAR98AZ_3rd_BOUNDS_Physics'
        CullDistance=5000
    End Object

   WeaponClass=class'DRWeap_Kar98AZ_Rifle'
}
