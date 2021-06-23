class DRWeap_Thompson_SMG extends ROWeap_M1A1_SMG
	abstract;

`include(DesertRats\Classes\DRWeaponPickupMessagesOverride.uci)

function AddKill(Pawn KilledPawn, optional class<DamageType> dmgType)
{
	super(ROProjectileWeapon).AddKill(KilledPawn, dmgType);
}

DefaultProperties
{
	WeaponContentClass(0)="DesertRats.DRWeap_Thompson_SMG_Content"

	InvIndex=`DRII_THOMPSON_SMG

	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Loop_3P', FirstPersonCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Auto_LP')
	WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue= AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Single_3P', FirstPersonCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Fire_Single')

	bLoopingFireSnd(DEFAULT_FIREMODE)=true
	WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Tail_3P', FirstPersonCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Auto_Tail')
	bLoopHighROFSounds(DEFAULT_FIREMODE)=true
}
