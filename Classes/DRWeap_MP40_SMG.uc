class DRWeap_MP40_SMG extends ROWeap_MP40_SMG
	abstract;

`include(DesertRats\Classes\DRWeaponPickupMessagesOverride.uci)

simulated function SetupArmsAnim()
{
	super.SetupArmsAnim();

	// ArmsMesh.AnimSets has slots 0-2-3 filled, so we need to back fill slot 1 and then move to slot 4
	ROPawn(Instigator).ArmsMesh.AnimSets[1] = SkeletalMeshComponent(Mesh).AnimSets[0];
	ROPawn(Instigator).ArmsMesh.AnimSets[4] = SkeletalMeshComponent(Mesh).AnimSets[1];
}

DefaultProperties
{
	WeaponContentClass(0)="DesertRats.DRWeap_MP40_SMG_Content"

    RoleSelectionImage(0)=Texture2D'DR_UI.WP_Render.WP_Render_MP40'

	InvIndex=`DRII_MP40_SMG
}
