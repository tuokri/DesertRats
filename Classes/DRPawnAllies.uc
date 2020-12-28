
class DRPawnAllies extends ROSouthPawn;

`include(DesertRats\Classes\DRPawn_Common.uci)

DefaultProperties
{
    `DRPCommonDP

    TunicMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.UK_Tunic'
    
    FieldgearMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.UK_Gear_Generic'
    
    ArmsOnlyMeshFP=SkeletalMesh'DR_CHR.Mesh.UK_Hands_Rolled'
    
    HeadAndArmsMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.UK_Kead'
    HeadAndArmsMICTemplate=MaterialInstanceConstant'DR__PLACEHOLDER_CHR.MIC.UK_Head'
    
    HeadgearMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.UK_Headgear_Helmet'
    
    Begin Object Name=ROPawnSkeletalMeshComponent
        AnimSets(11)=AnimSet'DR_CHR.Anim.CHR_Allies_Unique'
    End Object
    
    bSingleHandedSprinting=false
}
