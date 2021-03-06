class DRPawnAllies extends ROSouthPawn;

`include(DesertRats\Classes\DRPawn_Common.uci)

DefaultProperties
{
    `DRPCommonDP

    TunicMesh=SkeletalMesh'DR_CHR_UK.Mesh.UK_Tunic_RolledSocks'

    FieldgearMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.UK_Gear_Generic'

    ArmsOnlyMeshFP=SkeletalMesh'DR_CHR.Mesh.UK_Hands_Rolled'

    HeadAndArmsMesh=SkeletalMesh'DR__PLACEHOLDER_CHR.Mesh.UK_Kead'
    HeadAndArmsMICTemplate=MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_05_Rolled_INST' // TODO: CORRECT HEAD??

    HeadgearMesh=SkeletalMesh'DR_CHR_UK.Mesh.UK_Headgear_Brodie_Straight'

    Begin Object Name=ROPawnSkeletalMeshComponent
        AnimSets(11)=AnimSet'DR_CHR.Anim.CHR_Allies_Unique'
    End Object

    bSingleHandedSprinting=False
}
