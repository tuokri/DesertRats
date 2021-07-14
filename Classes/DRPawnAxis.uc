class DRPawnAxis extends RONorthPawn;

`include(DesertRats\Classes\DRPawn_Common.uci)

DefaultProperties
{
    `DRPCommonDP

    TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt'

    FieldgearMesh=SkeletalMesh'DR_CHR_DAK.Gear.DAK_Gear_Rifleman'

    ArmsOnlyMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic'

    // TODO:
    HeadAndArmsMesh=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head6_Mesh'
    HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_06_Long_INST'

    HeadgearMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40'

    bSingleHandedSprinting=true

    Begin Object Name=ROPawnSkeletalMeshComponent
        AnimSets(11)=AnimSet'DR_CHR.Anim.CHR_Axis_Unique'
    End Object

    Begin Object Class=DRAudioComponent Name=DialogAudioComp0
        bStopWhenOwnerDestroyed=true
        AudioClass=EAC_SFX
    End Object
    DialogAudioComp=DialogAudioComp0
    // TODO: Refactor DRPAWN!
}
