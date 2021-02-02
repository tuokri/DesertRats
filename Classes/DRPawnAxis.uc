class DRPawnAxis extends RONorthPawn;

`include(DesertRats\Classes\DRPawn_Common.uci)

DefaultProperties
{
    `DRPCommonDP

    // TODO: Why doesn't this work in the macro?
    bCanCamouflage=False

    TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long'

    FieldgearMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.ger_rr_gear_rifleman'

    ArmsOnlyMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic'

    // TODO:
    HeadAndArmsMesh=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head6_Mesh'
    HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_06_Long_INST'

    HeadgearMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M35'

    Begin Object Name=ROPawnSkeletalMeshComponent
        AnimSets(11)=AnimSet'DR_CHR.Anim.CHR_Axis_Unique'
    End Object

    bSingleHandedSprinting=true
}
