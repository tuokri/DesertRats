//=============================================================================
// DRVoicePackUKTeam01.uc
//=============================================================================
// UK Voice Pack 1.
//=============================================================================
// Desert Rats for Rising Storm 2: Vietnam
// Copyright (C) 2022
// Authored by Adrian "adrian$t3@m" Bari
//=============================================================================

class DRVoicePackUKTeam01 extends DRVoicePack;

defaultproperties
{
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////// INFANTRY /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // INF_CommanderAbilities
    CustomVoiceComs[`VOICECOM_RequestAbility1]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_CancelArtillery'")
    CustomVoiceComs[`VOICECOM_RequestAbility2]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_CancelArtillery'")
    CustomVoiceComs[`VOICECOM_RequestAbility3]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_CancelArtillery'")
    CustomVoiceComs[`VOICECOM_CallForReconPlane]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_CancelArtillery'")
    CustomVoiceComs[`VOICECOM_CancelArtillery]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_CancelArtillery'")

    // INF_Attack
    CustomVoiceComs[`VOICECOM_Attack]=                  (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_AttackGeneric'")
    CustomVoiceComs[`VOICECOM_SLSupressiveFire]=        (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SupressingFire'")
    CustomVoiceComs[`VOICECOM_SLAttackTank]=            (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_AttackGeneric'")
    CustomVoiceComs[`VOICECOM_SLAttackHelo]=            (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_AttackGeneric'")
    CustomVoiceComs[`VOICECOM_TLSupressiveFire]=        (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SupressingFire'")
    CustomVoiceComs[`VOICECOM_TLAttackTank]=            (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_AttackGeneric'")
    CustomVoiceComs[`VOICECOM_TLAttackHelo]=            (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_AttackGeneric'")

    // INF_AttackObjective
    CustomVoiceComs[`VOICECOM_SLAttack]=                (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_AttackObj'")
    CustomVoiceComs[`VOICECOM_TLAttack]=                (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_AttackObj'")

    // INF_Charging
    //CustomVoiceComs[`VOICECOM_Charging]=              (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.AttackGeneric'")

    // INF_Confirm
    CustomVoiceComs[`VOICECOM_Confirm]=                 (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Confirm'")
    CustomVoiceComs[`VOICECOM_SLConfirm]=               (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Confirm'")
    CustomVoiceComs[`VOICECOM_TLConfirm]=               (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Confirm'")
    CustomVoiceComs[`VOICECOM_AIConfirm]=               (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Confirm'")

    // INF_DefendObjective
    CustomVoiceComs[`VOICECOM_SLDefend]=                (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_DefendObjective'")
    CustomVoiceComs[`VOICECOM_TLDefend]=                (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_DefendObjective'")

    // INF_EnemyDeath
    CustomVoiceComs[`VOICECOM_EnemyDeath]=              (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_EnemyDeath'")
    CustomVoiceComs[`VOICECOM_EnemyDeath_Hero]=         (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_EnemyDeath'")
    CustomVoiceComs[`VOICECOM_EnemyDeath_LowMorale]=    (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_EnemyDeath'")
    CustomVoiceComs[`VOICECOM_EnemyDeath_Suppressed]=   (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_EnemyDeathSuppressed'")
    CustomVoiceComs[`VOICECOM_EnemyHeloDeath]=          (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_EnemyDeath'")


    // INF_EnemyDeathUnknown
    CustomVoiceComs[`VOICECOM_EnemyDeathUnknown]=       (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_EnemyDeath'")

    // INF_EnemySpotted_Engineer
    CustomVoiceComs[`VOICECOM_EnemySpottedEngineer]=            (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_EngineerSpotted'")
    CustomVoiceComs[`VOICECOM_EnemySpottedEngineer_Special]=    (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_EngineerSpotted'")

    // INF_EnemySpotted_Generic
    CustomVoiceComs[`VOICECOM_InfantrySpotted]=         (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_InfantrySpotted'")
    CustomVoiceComs[`VOICECOM_EnemySpottedInfantry]=    (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_InfantrySpotted'")

    // INF_EnemySpotted_MG
    CustomVoiceComs[`VOICECOM_TakingFireMachineGunner]=     (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_TakingFireMG'")
    CustomVoiceComs[`VOICECOM_EnemySpottedMGer]=            (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.MGerSpotted'")

    // INF_EnemySpotted_RPG
    CustomVoiceComs[`VOICECOM_EnemySpottedAntiTank]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_AntiTankSpotted'")

    // INF_EnemySpotted_Sniper
    CustomVoiceComs[`VOICECOM_TakingFireSniper]=    (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_TakingFireSniper'")
    CustomVoiceComs[`VOICECOM_EnemySpottedSniper]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SniperSpotted'")

    // INF_EnemySpotted_Tank
    CustomVoiceComs[`VOICECOM_TakingFireTank]=(Type=ROVCT_TeamRadius,  CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_RequestSupport'")
    CustomVoiceComs[`VOICECOM_EnemySpottedTank]=   (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_TankSpotted'")

    // INF_EnemySpotted_Transport
    CustomVoiceComs[`VOICECOM_EnemySpottedTransport]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_InfantrySpotted'")

    // INF_EnemySpotted_Trap
    CustomVoiceComs[`VOICECOM_SpottedExplosive]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_LiveGrenade'")

    // INF_EnemySpotted_Tunnel
    CustomVoiceComs[`VOICECOM_EnemySpottedTunnel]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_TankSpotted'")

    // INF_Follow
    CustomVoiceComs[`VOICECOM_SLFollow]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_FollowMe'")
    CustomVoiceComs[`VOICECOM_TLFollow]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_FollowMe'")

    // INF_FriendlyDeath
    CustomVoiceComs[`VOICECOM_FriendlyDeath]=               (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_FriendlyDeath'")
    CustomVoiceComs[`VOICECOM_FriendlyDeath_LowMorale]= (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_FriendlyDeath'")
    CustomVoiceComs[`VOICECOM_FriendlyDeath_Hero]=      (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_FriendlyDeath'")
    CustomVoiceComs[`VOICECOM_FriendlyHeloDeathInf]=        (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_FriendlyDeathOfficer'")

    // INF_FriendlyFire
    CustomVoiceComs[`VOICECOM_FriendlyFire]=        (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_FriendlyFire'")
    CustomVoiceComs[`VOICECOM_SawFriendlyFire]=     (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SeeingFriendlyFire'")

    // INF_IdleChatter
    CustomVoiceComs[`VOICECOM_Bandaging]=                           (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Bandaging'")
    CustomVoiceComs[`VOICECOM_IdleSituation1]=                      (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SoldierSituation'")
    CustomVoiceComs[`VOICECOM_IdleSituation1_LowMorale]=            (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SoldierSituation'")
    CustomVoiceComs[`VOICECOM_IdleSituation2]=                      (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SoldierSituation'")
    CustomVoiceComs[`VOICECOM_IdleSituation2_LowMorale]=            (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SoldierSituation'")
    CustomVoiceComs[`VOICECOM_IdleSituation3]=                      (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SoldierSituation'")
    CustomVoiceComs[`VOICECOM_IdleSituation3_LowMorale]=            (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SoldierSituation'")
    CustomVoiceComs[`VOICECOM_IdleSituation3_HighMorale]=           (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SoldierSituation'")
    CustomVoiceComs[`VOICECOM_IdleSituationOfficer]=                (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_OfficerSituation'")
    CustomVoiceComs[`VOICECOM_IdleSituationOfficer_LowMorale]=      (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_OfficerSituation'")
    CustomVoiceComs[`VOICECOM_IdleSituationOfficer_HighMorale]=     (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_OfficerSituation'")
    CustomVoiceComs[`VOICECOM_IdleEnemyLocation]=                   (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SoldierSituation'")
    CustomVoiceComs[`VOICECOM_IdleEnemyLocation_LowMorale]=         (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SoldierSituation'")
    CustomVoiceComs[`VOICECOM_IdleEnemyLocationOfficer]=            (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_OfficerSituation'")
    CustomVoiceComs[`VOICECOM_IdleEnemyLocationOfficer_LowMorale]=  (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_OfficerSituation'")
    CustomVoiceComs[`VOICECOM_SoldierHurt]=                         (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.SoldierHurt'")

    // INF_LosingObjective
    CustomVoiceComs[`VOICECOM_LosingObjective]=             (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_LosingObj'")
    CustomVoiceComs[`VOICECOM_LosingObjectiveOfficer]=      (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_LosingObj'")
    CustomVoiceComs[`VOICECOM_LosingObjective_LowMorale]=   (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_LosingObj'")

    // INF_MoveOut
    CustomVoiceComs[`VOICECOM_SLMove]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_AttackGeneric'")
    CustomVoiceComs[`VOICECOM_TLMove]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_AttackGeneric'")

    // INF_Negative
    CustomVoiceComs[`VOICECOM_Negative]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Deny'")
    CustomVoiceComs[`VOICECOM_SLReject]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Deny'")

    // INF_NoAmmo
    CustomVoiceComs[`VOICECOM_NeedAmmo]=                (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_LowOnAmmo'")
    CustomVoiceComs[`VOICECOM_LowOnAmmo]=               (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_LowOnAmmo'")
    CustomVoiceComs[`VOICECOM_LowOnAmmo_LowMorale]=     (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_LowOnAmmo'")
    CustomVoiceComs[`VOICECOM_OutOfAmmo]=               (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_OutOfAmmoSoldier'")
    CustomVoiceComs[`VOICECOM_OutOfAmmoMGer]=           (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_OutOfAmmoMG'")

    // INF_Reloading
    CustomVoiceComs[`VOICECOM_Reloading]=               (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Reloading'")
    CustomVoiceComs[`VOICECOM_Reloading_Suppressed]=    (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_ReloadingSuppressed'")

    // INF_RequestArtyCoordinates
    CustomVoiceComs[`VOICECOM_TLRequestArtyCoords]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_RequestOrders'")

    // INF_RequestOrders
    CustomVoiceComs[`VOICECOM_RequestOrders]=       (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_RequestOrders'")
    CustomVoiceComs[`VOICECOM_SLRequestOrders]= (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_RequestOrderstoCom'")

    // INF_RequestSupport_Air
    //CustomVoiceComs[`VOICECOM_NeedHelo]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.NeedHelicopterSupport'")

    // INF_RequestSupport_Artillery
    CustomVoiceComs[`VOICECOM_SLRequestArty]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_RequestSupportArty'")
    CustomVoiceComs[`VOICECOM_NeedArtillery]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_RequestSupportArty'")

    // INF_RequestSupport_Engineer
    CustomVoiceComs[`VOICECOM_NeedExplosives]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_ManExplosivesRequest'")

    // INF_RequestSupport_Generic
    CustomVoiceComs[`VOICECOM_RequestSupport]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_RequestSupport'")

    // INF_RequestSupport_MG
    CustomVoiceComs[`VOICECOM_NeedMGSupport]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_RequestSupportMG'")

    // INF_RequestSupport_Recon
    CustomVoiceComs[`VOICECOM_NeedRecon]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_RequestSupport'")

    // INF_RequestSupport_Smoke
    CustomVoiceComs[`VOICECOM_NeedSmoke]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_RequestSupportSmoke'")

    // INF_Resume
    CustomVoiceComs[`VOICECOM_SLResume]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Resume'")
    CustomVoiceComs[`VOICECOM_TLResume]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Resume'")

    // INF_Retreat
    CustomVoiceComs[`VOICECOM_Retreat]=         (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Retreat'")
    CustomVoiceComs[`VOICECOM_Retreat_LowMorale]=   (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Retreat'")

    // INF_Sorry
    CustomVoiceComs[`VOICECOM_Sorry]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Sorry'")

    // INF_SpawnSpeech
    CustomVoiceComs[`VOICECOM_SpawnAttacking]=          (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SpawnAttacking'")
    CustomVoiceComs[`VOICECOM_SpawnAttacking_HighMorale]=   (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SpawnAttacking'")
    CustomVoiceComs[`VOICECOM_SpawnAttacking_LowMorale]=    (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SpawnAttacking'")
    CustomVoiceComs[`VOICECOM_SpawnDefending]=          (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SpawnDefenders'")
    CustomVoiceComs[`VOICECOM_SpawnDefending_HighMorale]=   (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SpawnDefenders'")
    CustomVoiceComs[`VOICECOM_SpawnDefending_LowMorale]=    (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SpawnDefenders'")
    CustomVoiceComs[`VOICECOM_SpawnNeutral]=                (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SpawnAttacking'")

    // INF_Suppressed
    CustomVoiceComs[`VOICECOM_Suppressed]=          (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Supressed'")
    CustomVoiceComs[`VOICECOM_Suppressed_LowMorale]=    (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Supressed'")
    CustomVoiceComs[`VOICECOM_Suppressed_Hero]=     (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SupressedOfficer'")

    // INF_Suppressing
    CustomVoiceComs[`VOICECOM_Suppressing]=     (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Suppressing'")
    CustomVoiceComs[`VOICECOM_Suppressing_Hero]=    (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_SuppressingOfficer'")

    // INF_TakingFire
    CustomVoiceComs[`VOICECOM_TakeCover]=                       (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_TakingFireGeneric'")
    CustomVoiceComs[`VOICECOM_IncomingArtillery]=               (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_IncomingArty'")
    CustomVoiceComs[`VOICECOM_IncomingArtillery_Suppressed]=    (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_IncomingArtySupport'")
    CustomVoiceComs[`VOICECOM_IncomingGunship]=             (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_IncomingArtySupport'")
    CustomVoiceComs[`VOICECOM_IncomingAirstrike]=               (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_IncomingArtySupport'")
    CustomVoiceComs[`VOICECOM_Grenade]=                     (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_LiveGrenade'")
    CustomVoiceComs[`VOICECOM_Satchel]=                     (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_LiveGrenade'")
    CustomVoiceComs[`VOICECOM_TakingFireUnknown]=               (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_TakingFireUnknown'")
    CustomVoiceComs[`VOICECOM_TakingFireUnknown_Hero]=      (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_TakingFireUnknownOfficer'")
    CustomVoiceComs[`VOICECOM_TakingFireInfantry]=          (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_TakingFireGeneric'")

    // INF_TakingObjective
    CustomVoiceComs[`VOICECOM_TakingObjective]=         (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_TakingObj'")
    CustomVoiceComs[`VOICECOM_TakingObjectiveOfficer]=  (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_TakingObjOfficer'")
    CustomVoiceComs[`VOICECOM_TakingObjective_LowMorale]=   (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_TakingObj'")

    // INF_Taunts
    CustomVoiceComs[`VOICECOM_Taunt]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Thanks'")

    // INF_Thanks
    CustomVoiceComs[`VOICECOM_Thanks]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Thanks'")

    // INF_ThrowingGrenade
    CustomVoiceComs[`VOICECOM_ThrowingGrenade]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_ThrowingGrenade'")

    // INF_ThrowingSatchel
    CustomVoiceComs[`VOICECOM_ThrowingSatchel]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_ThrowingGrenade'")

    // INF_ThrowingSmoke
    CustomVoiceComs[`VOICECOM_ThrowingSmoke]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_ThrowingSmoke'")

    // INF_TunnelDestroyed
    CustomVoiceComs[`VOICECOM_EnemyTunnelDestroyed]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_1_Thanks'")

    // INF_Wounded NOTE: THIS IS NOT COMPLETE
    CustomVoiceComs[`VOICECOM_DeathHeart]=  (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_2_DyingFast'")
    CustomVoiceComs[`VOICECOM_DeathStomach]=    (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_2_DyingSlow'")
    CustomVoiceComs[`VOICECOM_DeathNeck]=       (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice1.Play_UK_Soldier_2_DyingFast'")
    CustomVoiceComs[`VOICECOM_DyingFast]=       (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice2.Play_UK_Soldier_2_DyingFast'")
    CustomVoiceComs[`VOICECOM_DyingSlow]=       (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice2.Play_UK_Soldier_2_DyingSlow'")
    CustomVoiceComs[`VOICECOM_Wounded]=     (CustomSound="SoundCue'DR_AUD_VOX_UK_Voice2.Play_UK_Soldier_2_Wounded'")

    CustomVoiceComs[`VOICECOM_Burning]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice2.Play_UK_Soldier_2_DeathByFire'")

    CustomVoiceComs[`VOICECOM_SlowlyDying]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice2.Play_UK_Soldier_2_DyingSlow'") // Bleeding Out
    CustomVoiceComs[`VOICECOM_SlowlyDying_Hero]=(CustomSound="SoundCue'DR_AUD_VOX_UK_Voice2.Play_UK_Soldier_2_DyingSlow'") // Bleeding Out


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////// TANK ///////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /*
    // TNK_IdleChatter
    CustomVoiceComs[`VOICECOM_TankIdleSituation]=                       (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCIdle'")
    CustomVoiceComs[`VOICECOM_TankIdleSituation_LowMorale]=         (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCIdle'")
    CustomVoiceComs[`VOICECOM_TankIdleCommanderSituation]=          (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCIdle'")
    CustomVoiceComs[`VOICECOM_TankIdleCommanderSituation_LowMorale]=    (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCIdle'")
    CustomVoiceComs[`VOICECOM_TankIdleCommanderSituation_HighMorale]=   (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCIdle'")
    CustomVoiceComs[`VOICECOM_TankIdleVehicleGood]=                 (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCIdle'")

    // TNK_IdleChatter_Damaged
    CustomVoiceComs[`VOICECOM_TankIdleVehicleBad]=(CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCDamaged'")

    // TNK_IdleChatter_Destroyed
    CustomVoiceComs[`VOICECOM_TankIdleVehicleHorrible]=(CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCDestroyed'")

    // TNK_LoadedCannon
    CustomVoiceComs[`VOICECOM_TankCannonReloaded]=(CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.AttackGeneric'")

    // TNK_UnderTankFire
    CustomVoiceComs[`VOICECOM_TankDriverDead]=              (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCDriverKilled'")
    CustomVoiceComs[`VOICECOM_TankGunnerDead]=              (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.FriendlyDeath'")
    CustomVoiceComs[`VOICECOM_TankLoaderDead]=              (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.FriendlyDeath'")
    CustomVoiceComs[`VOICECOM_TankHullGunnerDead]=          (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.FriendlyDeath'")
    CustomVoiceComs[`VOICECOM_TankEngineDamaged]=           (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCDamaged'")
    CustomVoiceComs[`VOICECOM_TankEngineDestroyed]=         (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCDestroyed'")
    CustomVoiceComs[`VOICECOM_TankMainGunDestroyed]=        (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCGenHit'")
    CustomVoiceComs[`VOICECOM_TankHullMGDestroyed]=         (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCGenHit'")
    CustomVoiceComs[`VOICECOM_TankLeftTrackDestroyed]=      (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCGenHit'")
    CustomVoiceComs[`VOICECOM_TankRightTrackDestroyed]=     (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCGenHit'")
    CustomVoiceComs[`VOICECOM_TankBrakesDestroyed]=         (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCGenHit'")
    CustomVoiceComs[`VOICECOM_TankGearBoxDestroyed]=        (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCGenHit'")
    CustomVoiceComs[`VOICECOM_TankTurretTraverseDestroyed]= (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCGenHit'")
    CustomVoiceComs[`VOICECOM_TankHitFront]=                (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCGenHit'")
    CustomVoiceComs[`VOICECOM_TankHitBack]=                 (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCGenHit'")
    CustomVoiceComs[`VOICECOM_TankHitLeft]=                 (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCGenHit'")
    CustomVoiceComs[`VOICECOM_TankHitRight]=                (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCGenHit'")
    CustomVoiceComs[`VOICECOM_TankUnderFire]=               (CustomSound="SoundCue'GOM4_VOX.ROK.Voice1.APC.APCUnderSmallArmsFire'")
    */
    // TODO: MAKE A TANKINCOMINGRPG VOICE COM
}
