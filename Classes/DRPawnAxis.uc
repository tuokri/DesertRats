
class DRPawnAxis extends RONorthPawn;

`include(DesertRats\Classes\DRPawn_Common.uci)

DefaultProperties
{
    `DRPCommonDP

    TunicMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.ger_rr_tunic'
    
    FieldgearMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.ger_rr_gear_rifleman'
    
    ArmsOnlyMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic'
    
    HeadAndArmsMesh=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head6_Mesh'
    HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_06_Long_INST'
    
    HeadgearMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.ger_rr_helmet'
    
    Begin Object Name=ROPawnSkeletalMeshComponent
        AnimSets(11)=AnimSet'DR_CHR.Anim.CHR_Axis_Unique'
    End Object
    
    bSingleHandedSprinting=true
}
