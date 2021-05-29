class DRWeap_MP40_SMG extends ROWeap_MP40_SMG
	abstract;

`include(DesertRats\Classes\DRWeaponPickupMessagesOverride.uci)

DefaultProperties
{
	WeaponContentClass(0)="DesertRats.DRWeap_MP40_SMG_Content"

    RoleSelectionImage(0)=Texture2D'DR_UI.WP_Render.WP_Render_MP40'

	InvIndex=`DRII_MP40_SMG
}
