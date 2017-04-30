//=============================================================================
// WFAPawn.uc
//=============================================================================
// Global attributes shared by all Pawns.
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAPawn extends WFPawn
	notplaceable;

DefaultProperties
{
	// InventoryManagerClass=class'WFAInventoryManager'
	HeadgearAttachSocket=helmet
	
	Begin Object Name=ROPawnSkeletalMeshComponent
		AnimSets(0)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Stand_anim'
		AnimSets(1)=AnimSet'CHR_Playeranim_Master.Anim.CHR_ChestCover_anim'
		AnimSets(2)=AnimSet'CHR_Playeranim_Master.Anim.CHR_WaistCover_anim'
		AnimSets(3)=AnimSet'CHR_Playeranim_Master.Anim.CHR_StandCover_anim'
		AnimSets(4)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Crouch_anim'
		AnimSets(5)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Prone_anim'
		AnimSets(6)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Hand_Poses_Master'
		AnimSets(7)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Death_anim'
		AnimSets(8)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Tripod_anim'
		AnimSets(9)=AnimSet'CHR_Playeranim_Master.Anim.Special_Actions'
		AnimSets(10)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Melee'
		AnimSets(11)=none // Faction specific animations
		AnimSets(12)=none // Weapon animations
		AnimSets(13)=AnimSet'CHR_RS_Playeranim_Master.Anim.CHR_RS_Hand_Poses_Master'
		AnimSets(14)=AnimSet'CHR_RS_Playeranim_Master.Anim.CHR_RS_Tripod_Anim'
	End Object
	
	ArmsOnlyMesh=SkeletalMesh'CHR_HandsOnly.HandsOnly_Hands'
}
