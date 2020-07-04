
class DRGameInfoTerritories extends ROGameInfoTerritories
	config(Game_DesertRats_GameInfo);

var	array<string> TempPawnsBrit;
var	array<string> TempPawnsGer;

simulated function SetMorale(byte AxisMorale, byte AlliesMorale)
{
	if (AxisMorale != AxisTeam.Morale)
	{
		if (AxisMorale != 255)
		{
			LastMoraleChangeTime[`AXIS_TEAM_INDEX] = WorldInfo.TimeSeconds;
		}
		else
		{
			LastMoraleChangeTime[`AXIS_TEAM_INDEX] = 0;
		}
		
		AxisTeam.Morale = AxisMorale;
		
		if (WorldInfo.NetMode == NM_StandAlone)
		{
			AxisTeam.ReplicatedEvent('Morale');
		}
	}
	
	if (AlliesMorale != AlliesTeam.Morale)
	{
		if (AlliesMorale != 255)
		{
			LastMoraleChangeTime[`ALLIES_TEAM_INDEX] = WorldInfo.TimeSeconds;
		}
		else
		{
			LastMoraleChangeTime[`ALLIES_TEAM_INDEX] = 0;
		}
		
		AlliesTeam.Morale = AlliesMorale;
		
		if (WorldInfo.NetMode == NM_StandAlone)
		{
			AlliesTeam.ReplicatedEvent('Morale');
		}
	}
}

function string GetDefaultBotName(Controller C, byte TeamIndex, byte NameIndex)
{
	if( TeamIndex == `AXIS_TEAM_INDEX )
	{
		if( ROAIController( C ) != none )
		{
			ROAIController( C ).bNameInitialized = true;
		}
		
		return class'DRGameInfo'.default.AxisBotNames[NameIndex - 1];
	}
	else if ( TeamIndex == `ALLIES_TEAM_INDEX )
	{
		if( ROAIController( C ) != none )
		{
			ROAIController( C ).bNameInitialized = true;
		}
		
		return class'DRGameInfo'.default.AlliesBotNames[NameIndex - 1];
	}
	
	return string(C.Name);
}

function Actor SpawnAerialReconPlane(Actor BaseActor, float Duration, ROPlayerController CallingController)
{
	local ROTeamInfo Team;
	local class<ROAerialReconPlane> ReconPlaneClass;
	
	Team = ROTeamInfo(CallingController.PlayerReplicationInfo.Team);
	ReconPlaneClass = Team.GetAerialReconPlaneClass();
	
	if ( Team.AerialReconPlane != none )
	{
		DestroyAerialReconPlane(CallingController.GetTeamNum());
	}
	
	`dr(""$ ReconPlaneClass, 'CMDA');
	
	Team.AerialReconPlane = Spawn(ReconPlaneClass, self, , BaseActor.Location, BaseActor.Rotation);
	Team.AerialReconPlane.SetBase(BaseActor);
	Team.AerialReconPlane.BaseActor = BaseActor;
	Team.AerialReconPlane.CallingController = CallingController;
	Team.AerialReconPlane.AerialReconDuration = Duration;
	Team.AerialReconPlane.TeamIndex = Team.TeamIndex;
	
	CallingController.NextAerialReconController = WorldInfo.ControllerList;
	CallingController.PrevAerialReconController = none;
	
	return Team.AerialReconPlane;
}

function ScoreMGResupply(Controller Dropper, Controller Gunner)
{
	if( Dropper == Gunner )
	{
		return;
	}
	else if (ROPlayerReplicationInfo(Dropper.PlayerReplicationInfo) != none &&
			ROPlayerReplicationInfo(Dropper.PlayerReplicationInfo).RoleInfo != none &&
			ROPlayerReplicationInfo(Dropper.PlayerReplicationInfo).RoleInfo.ClassIndex != `RI_MACHINE_GUNNER)
	{
		AddDelayedKillMessage(ROKMT_Resupplied, GameReplicationInfo.ElapsedTime, Dropper.PlayerReplicationInfo);
	}
}

`ifndef(RELEASE)
function ShowRoundStartScreen(optional bool AdminStart)
{
	local ROPlayerController ROPC;
	
	super.ShowRoundStartScreen(AdminStart);
	
	foreach WorldInfo.AllControllers(class'ROPlayerController', ROPC)
	{
		ROPC.SetCinematicMode(false, false, false, true, false, true);
		ROPC.ClientHideRoundStartScreen();
		
		ROPC.bIgnoreMoveInput = 0;
		ROPC.bIgnoreChangingSeatsInput = 0;
		ROPC.bIgnoreChangingPositionsInput = 0;
	}
}
`endif

// All this shit, just to change a few calls to BroadcastLocalizedMessage. Ech.
function CaptureTimer()
{
	local ROGameReplicationInfo ROGRI;
	local Pawn P;
	local int NumCappers[`MAX_TEAMS];
	local int TotalCappers[`MAX_TEAMS];
	local float CapRatio;
	local float LeaderMultiplier[`MAX_TEAMS];
	local float TeamCapValue[`MAX_TEAMS];
	local SquadListCounter SquadBonusMultipliers[`MAX_TEAMS];
	local array<ROPlayerController> PlayerCappers;
	local array<Pawn> AllCappers;
	local ROVehicle ROV;
	local int i, j;
	local byte OldObjStatus, OldCapProgress, OldForceRatio;
	local bool bAllObjectivesCapped;

	if ( !bRoundActive )
	{
		return;
	}

	ROGRI = ROGameReplicationInfo(WorldInfo.GRI);

	TotalCappers[`AXIS_TEAM_INDEX] = TeamCount(AxisTeam);
	TotalCappers[`ALLIES_TEAM_INDEX] = TeamCount(AlliesTeam);

	for ( i = 0; i < Objectives.Length; i++ )
	{
		if ( Objectives[i] == none )
			continue;

		NumCappers[`AXIS_TEAM_INDEX] = 0;
		NumCappers[`ALLIES_TEAM_INDEX] = 0;
		LeaderMultiplier[`AXIS_TEAM_INDEX] = 1.0;
		LeaderMultiplier[`ALLIES_TEAM_INDEX] = 1.0;
		TeamCapValue[`AXIS_TEAM_INDEX] = 0.0;
		TeamCapValue[`ALLIES_TEAM_INDEX] = 0.0;
		PlayerCappers.Remove(0, PlayerCappers.Length);
		AllCappers.Remove(0, AllCappers.Length);

		for( j=0; j<`MAX_SQUADS; j++ )
		{
			SquadBonusMultipliers[`AXIS_TEAM_INDEX].SquadCounter[j] = 0;
			SquadBonusMultipliers[`ALLIES_TEAM_INDEX].SquadCounter[j] = 0;
		}

		// Count the number of human cappers on each team
		foreach WorldInfo.AllPawns(class'Pawn', P)
		{
			if ( ROPawn(P) != none )
			{
				if ( P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.Team != none )
				{
					// If this controller is attached to a pawn that's within the objective's radius
					if ( Objectives[i].bActive && Objectives[i].ObjVolume.ContainsPoint(P.Location) )
					{
						NumCappers[P.PlayerReplicationInfo.Team.TeamIndex]++;

						if ( ROPlayerController(P.Controller) != none )
						{
							PlayerCappers.AddItem(ROPlayerController(P.Controller));
						}

						if ( ROPlayerReplicationInfo(P.PlayerReplicationInfo).RoleInfo != none &&
							(ROPlayerReplicationInfo(P.PlayerReplicationInfo).bIsSquadLeader ||
							 ROPlayerReplicationInfo(P.PlayerReplicationInfo).RoleInfo.bIsTeamLeader) )
						{
							LeaderMultiplier[P.PlayerReplicationInfo.Team.TeamIndex] = LEADER_CAPTURE_BONUS_MULTIPLIER;
						}

						// If the player is in a squad then find the team and squad and increment the squad counter by 1
						if ( ROPlayerReplicationInfo(P.PlayerReplicationInfo).SquadIndex < `MAX_SQUADS )
						{
							SquadBonusMultipliers[P.PlayerReplicationInfo.Team.TeamIndex].SquadCounter[ROPlayerReplicationInfo(P.PlayerReplicationInfo).SquadIndex]++;
						}

						AllCappers.AddItem(P);

						// Let the infantry AI know they are in this objective
						if( ROAIController(P.Controller) != none )
						{
							ROAIController(P.Controller).NotifyActiveObjectiveIndex( Objectives[i].ObjIndex );
						}
					}
					else if ( ROPlayerController(P.Controller) != none && ROPlayerController(P.Controller).ObjectiveName == Objectives[i].ObjName )
					{
						ROPlayerController(P.Controller).ObjectiveName = "";
					}
				}
			}
			else if ( ROVehicle(P) != none)
			{
				ROV = ROVehicle(P);
				if ( ROVehicleHelicopter(P) == none && Objectives[i].bActive && Objectives[i].ObjVolume.ContainsPoint(ROV.Location) )
				{
					for ( j = 0; j < ROV.Seats.Length; j++ )
					{
						if ( !ROV.Seats[j].bNonEnterable && ROV.Seats[j].SeatPawn != none && ROV.GetSeatPRI(j) != none && ROV.GetSeatPRI(j).Team != none )
						{
							NumCappers[ROV.GetSeatPRI(j).Team.TeamIndex]++;

							if ( ROPlayerController(ROV.Seats[j].SeatPawn.Controller) != none )
							{
								PlayerCappers.AddItem(ROPlayerController(ROV.Seats[j].SeatPawn.Controller));
							}

							if ( ROPlayerReplicationInfo(ROV.Seats[j].SeatPawn.PlayerReplicationInfo).RoleInfo != none &&
								(ROPlayerReplicationInfo(ROV.Seats[j].SeatPawn.PlayerReplicationInfo).bIsSquadLeader ||
									ROPlayerReplicationInfo(ROV.Seats[j].SeatPawn.PlayerReplicationInfo).RoleInfo.bIsTeamLeader) )
							{
								LeaderMultiplier[ROV.GetSeatPRI(j).Team.TeamIndex] = LEADER_CAPTURE_BONUS_MULTIPLIER;
							}

							// If the player is in a squad then find the team and squad and increment the squad counter by 1
							if ( ROPlayerReplicationInfo(P.PlayerReplicationInfo).SquadIndex < `MAX_SQUADS )
							{
								SquadBonusMultipliers[P.PlayerReplicationInfo.Team.TeamIndex].SquadCounter[ROPlayerReplicationInfo(P.PlayerReplicationInfo).SquadIndex]++;
							}

							AllCappers.AddItem(ROV.Seats[j].SeatPawn);
						}
					}
				}
				else
				{
					for ( j = 0; j < ROV.Seats.Length; j++ )
					{
						if ( ROV.Seats[j].SeatPawn != none && ROPlayerController(ROV.Seats[j].SeatPawn.Controller) != none && ROPlayerController(ROV.Seats[j].SeatPawn.Controller).ObjectiveName == Objectives[i].ObjName )
						{
							ROPlayerController(ROV.Seats[j].SeatPawn.Controller).ObjectiveName = "";
						}
					}
				}
			}
			else if ( ROTurret(P) != none )
			{
				if ( ROTurret(P).Driver != none && P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.Team != none )
				{
					// If this controller is attached to a pawn that's within the objective's radius
					if ( Objectives[i].bActive && Objectives[i].ObjVolume.ContainsPoint(P.Location) )
					{
						NumCappers[P.PlayerReplicationInfo.Team.TeamIndex]++;

						if ( ROPlayerController(P.Controller) != none )
						{
							PlayerCappers.AddItem(ROPlayerController(P.Controller));
						}

						if ( ROPlayerReplicationInfo(P.PlayerReplicationInfo).RoleInfo != none &&
							(ROPlayerReplicationInfo(P.PlayerReplicationInfo).bIsSquadLeader ||
							 ROPlayerReplicationInfo(P.PlayerReplicationInfo).RoleInfo.bIsTeamLeader) )
						{
							LeaderMultiplier[P.PlayerReplicationInfo.Team.TeamIndex] = LEADER_CAPTURE_BONUS_MULTIPLIER;
						}

						// If the player is in a squad then find the team and squad and increment the squad counter by 1
						if ( ROPlayerReplicationInfo(P.PlayerReplicationInfo).SquadIndex < `MAX_SQUADS )
						{
							SquadBonusMultipliers[P.PlayerReplicationInfo.Team.TeamIndex].SquadCounter[ROPlayerReplicationInfo(P.PlayerReplicationInfo).SquadIndex]++;
						}

						AllCappers.AddItem(ROTurret(P).Driver);
					}
					else if ( ROPlayerController(P.Controller) != none && ROPlayerController(P.Controller).ObjectiveName == Objectives[i].ObjName )
					{
						ROPlayerController(P.Controller).ObjectiveName = "";
					}
				}
			}
		}

		// Go through all squads and calcuate the bonus
		for ( j = 0; j < `MAX_SQUADS; j++ )
		{
			// SquadBonusMultipliers[A_TEAM_INDEX].SquadCounter[A_SQUAD_INDEX] == Amount of squad memebers in the cap

			if ( SquadBonusMultipliers[`AXIS_TEAM_INDEX].SquadCounter[j] > 1 ) // If there is more than 1 person in the squad and is in the cap
			{
				TeamCapValue[`AXIS_TEAM_INDEX] += (SquadBonusMultipliers[`AXIS_TEAM_INDEX].SquadCounter[j]-1) * SQUAD_CAPTURE_BONUS_MULTIPLIER;
			}

			if ( SquadBonusMultipliers[`ALLIES_TEAM_INDEX].SquadCounter[j] > 1 ) // If there is more than 1 person in the squad and is in the cap
			{
				TeamCapValue[`ALLIES_TEAM_INDEX] += (SquadBonusMultipliers[`ALLIES_TEAM_INDEX].SquadCounter[j]-1) * SQUAD_CAPTURE_BONUS_MULTIPLIER;
			}
		}

		 // Add Number Of Cappers to the TeamCapValue
		TeamCapValue[`AXIS_TEAM_INDEX] += NumCappers[`AXIS_TEAM_INDEX];
		TeamCapValue[`ALLIES_TEAM_INDEX] += NumCappers[`ALLIES_TEAM_INDEX];

		if ( !Objectives[i].bActive )
		{
			Objectives[i].bCapping = false;
			Objectives[i].CapProgress = 0.0;
			Objectives[i].CapTeamIndex = `NEUTRAL_TEAM_INDEX;

			if ( ROGRI != none )
			{
				ROGRI.UpdateObjectiveStatus(Objectives[i]);
				ROGRI.ObjectiveCapProgress[i] = 0;
				ROGRI.ObjectiveForceRatio[i] = 0;
				ROGRI.ObjCappers[i].NumOfCappers[`AXIS_TEAM_INDEX] = 0;
				ROGRI.ObjCappers[i].NumOfCappers[`ALLIES_TEAM_INDEX] = 0;
			}

			continue;
		}

		if ( bDebugTerritories )
			`log("ROGameInfoTerritories.CaptureTimer Objective"$i @ "- TeamCapValue:"$TeamCapValue[`AXIS_TEAM_INDEX]$","$TeamCapValue[`ALLIES_TEAM_INDEX] @ "ObjectiveCounts:"$TeamObjectiveCount(OBJ_Axis)$","$TeamObjectiveCount(OBJ_Allies));

		// If there are more Axis than Allies
		if ( TeamCapValue[`AXIS_TEAM_INDEX] > TeamCapValue[`ALLIES_TEAM_INDEX] )
		{
			// Calculate the Axis' capture rate
			CapRatio = FMin(NumCappers[`AXIS_TEAM_INDEX] * Objectives[i].CapRate * LeaderMultiplier[`AXIS_TEAM_INDEX] * float(NumCappers[`AXIS_TEAM_INDEX]) / TotalCappers[`AXIS_TEAM_INDEX], Objectives[i].MaxCapRate);

			// if the Allies were capturing
			if ( Objectives[i].CapTeamIndex == `ALLIES_TEAM_INDEX )
			{
				Objectives[i].CapProgress -= CAPTURE_UPDATE_RATE * FMin(Objectives[i].UnCapRate + CapRatio, Objectives[i].MaxUnCapRate);
			}
			// If this objective doesn't belong to the Axis already, let them cap it
			else if ( Objectives[i].ObjState != OBJ_Axis )
			{
				if ( !Objectives[i].bCapping || Objectives[i].CapTeamIndex != `AXIS_TEAM_INDEX )
				{
					if( !bSuppressCappingNotice
						&& (bLastObjective && DefendingTeam == `ALLIES_TEAM_INDEX)
						)
					{
						BroadcastLocalizedMessage(class'ROLocalMessageGameRedAlert', RORAMSG_DefendingFinalObjSouth);
					}
					else
					{
						`drtrace;
						// BroadcastLocalizedMessage(class'DRLocalMessageObjective', ROOBJMSG_NorthCapturing, , , Objectives[i]);
					}

					// Show tac view
					BroadcastShowObjectiveCapturedWorldWidget(true, `ALLIES_TEAM_INDEX);

					Objectives[i].bCapping = true;

					Objectives[i].CapTeamIndex = `AXIS_TEAM_INDEX;

					if ( DefendingTeam != DT_None && `AXIS_TEAM_INDEX != DefendingTeam )
					{
						UpdateLastAttemptTime();
					}
				}

				// @TODO: Still need this? -Nate
				HandleObjectiveBattleChatter(AllCappers, `AXIS_TEAM_INDEX);

				Objectives[i].CapProgress += CAPTURE_UPDATE_RATE * CapRatio;
			}

			if ( DefendingTeam != DT_None  )
			{
				if ( !bLockdownEnabled && bLastObjective )
				{
					if ( Objectives[i].ObjState != OBJ_Axis )
					{
						bAttackersCapping = true;
					}
				}
				else
				{
					if ( `AXIS_TEAM_INDEX != DefendingTeam && Objectives[i].ObjState == DefendingTeam )
					{
						bAttackersCapping = true;
					}
				}
			}
		}

		// If there are more Allies than Axis
		else if ( TeamCapValue[`AXIS_TEAM_INDEX] < TeamCapValue[`ALLIES_TEAM_INDEX] )
		{
			// Calculate the Allies' capture rate
			CapRatio = FMin(NumCappers[`ALLIES_TEAM_INDEX] * Objectives[i].CapRate * LeaderMultiplier[`ALLIES_TEAM_INDEX] * float(NumCappers[`ALLIES_TEAM_INDEX]) / TotalCappers[`ALLIES_TEAM_INDEX], Objectives[i].MaxCapRate);

			// If the Axis were capturing
			if ( Objectives[i].CapTeamIndex == `AXIS_TEAM_INDEX )
			{
				Objectives[i].CapProgress -= CAPTURE_UPDATE_RATE * FMin(Objectives[i].UnCapRate + CapRatio, Objectives[i].MaxUnCapRate);
			}
			// If this objective doesn't belong to the Allies already, let them cap it
			else if ( Objectives[i].ObjState != OBJ_Allies )
			{
				if ( !Objectives[i].bCapping || Objectives[i].CapTeamIndex != `ALLIES_TEAM_INDEX )
				{
					if( !bSuppressCappingNotice
						&& (bLastObjective && DefendingTeam == `AXIS_TEAM_INDEX)
					  )
					{
						BroadcastLocalizedMessage(class'ROLocalMessageGameRedAlert', RORAMSG_DefendingFinalObj);
					}
					else
					{
						BroadcastLocalizedMessage(class'ROLocalMessageObjective', ROOBJMSG_SouthCapturing, , , Objectives[i]);
					}

					// Show tac view
					BroadcastShowObjectiveCapturedWorldWidget(true, `AXIS_TEAM_INDEX);

					Objectives[i].bCapping = true;

					Objectives[i].CapTeamIndex = `ALLIES_TEAM_INDEX;
				}

				if ( DefendingTeam != DT_None && `ALLIES_TEAM_INDEX != DefendingTeam )
				{
					UpdateLastAttemptTime();
				}

				// @TODO: Still need this? -Nate
				HandleObjectiveBattleChatter(AllCappers, `ALLIES_TEAM_INDEX);

				Objectives[i].CapProgress += CAPTURE_UPDATE_RATE * CapRatio;
			}

			if ( DefendingTeam != DT_None  )
			{
				if ( !bLockdownEnabled && bLastObjective )
				{
					if ( Objectives[i].ObjState != OBJ_Allies )
					{
						bAttackersCapping = true;
					}
				}
				else
				{
					if ( `ALLIES_TEAM_INDEX != DefendingTeam && Objectives[i].ObjState == DefendingTeam )
					{
						bAttackersCapping = true;
					}
				}
			}
		}
		// Otherwise, if there are no Cappers in the Objective and the Objective has been partially Capped
		else if ( NumCappers[`AXIS_TEAM_INDEX] == 0 && Objectives[i].CapProgress > 0.0 )
		{
			// If no one is in the cap zone, reverse the progress
			Objectives[i].CapProgress -= CAPTURE_UPDATE_RATE * Objectives[i].UnCapRate;

			if ( Objectives[i].CapProgress <= 0.0 )
			{
				Objectives[i].CapProgress = 0.0;
				bAttackersCapping = false;
				Objectives[i].bCapping = false;
			}
		}

		// If the cap progress has fallen below zero
		if ( Objectives[i].CapProgress < 0.0 )
		{
			// if the objective is still neutral
		    if ( Objectives[i].ObjState == OBJ_Neutral )
		    {
		    	// Flip the extra uncapturing progress into capturing progress
				Objectives[i].CapProgress *= -1.0;
				Objectives[i].CapTeamIndex = 1 - Objectives[i].CapTeamIndex; // This flips the capping team(1 becomes 0, 0 becomes 1)
			}
			else
			{
				// No one is capturing anymore
				Objectives[i].bCapping = false;
				Objectives[i].CapTeamIndex = `NEUTRAL_TEAM_INDEX;
				Objectives[i].CapProgress = 0.0;
				bAttackersCapping = false;
			}
		}
		// If someone has completed a capture
		else if ( Objectives[i].CapProgress >= 1.0 )
		{
			// Give them the objective and reset the Cap Progress
			Objectives[i].bCapping = false;
			Objectives[i].ObjState = EObjectiveState(Objectives[i].CapTeamIndex);
			Objectives[i].CapProgress = 0.0;

			// See if all Objectives have been captured
			bAllObjectivesCapped = true;
			for ( j = 0; j < Objectives.Length; j++ )
			{
				// Make sure this is a valid objective
				if ( Objectives[j] != none )
				{
					// If this objective has not been captured, then not all objectives are captured
					if ( Objectives[j].ObjState != Objectives[i].ObjState )
					{
						bAllObjectivesCapped = false;
					}
				}
			}
			
			// If this isn't our last objective, broadcast the cap message
			if ( !bAllObjectivesCapped
				// What was even the point of this check?
				// && (EnabledObjectives - TeamObjectiveCount(`ALLIES_TEAM_INDEX) > 1 || EnabledObjectives - TeamObjectiveCount(`AXIS_TEAM_INDEX) > 1)
				)
			{
				`drtrace;
				// BroadcastLocalizedMessage(class'WWLocalMessageObjective', ROOBJMSG_Captured + Objectives[i].CapTeamIndex, , , Objectives[i]);
			}

			// Let the game object know that an objective was captured
			ObjectiveCaptured(i);
		}

		// Replicate this Objective status to Cappers
		for ( j = 0; j < PlayerCappers.Length; j++ )
		{
			PlayerCappers[j].ObjectiveIndex	= i;
			PlayerCappers[j].ObjectiveName	= Objectives[i].ObjName;
			PlayerCappers[j].ReplicatedEvent('ObjectiveName');
		}

		if ( bDebugTerritories )
			`log("ROGameInfoTerritories.CaptureTimer Objective"$i @ "- Name:"$Objectives[i].ObjName @ "State:"$Objectives[i].ObjState);

		// Update GRI for everyone
		if ( ROGRI != none )
		{
			OldObjStatus = ROGRI.ObjectiveStatus[i];
			OldCapProgress = ROGRI.ObjectiveCapProgress[i];
			OldForceRatio = ROGRI.ObjectiveForceRatio[i];

			ROGRI.UpdateObjectiveStatus(Objectives[i]);
			ROGRI.ObjectiveCapProgress[i] = byte(Objectives[i].CapProgress * 255.0);
			ROGRI.ObjCappers[i].NumOfCappers[`AXIS_TEAM_INDEX] = NumCappers[`AXIS_TEAM_INDEX];
			ROGRI.ObjCappers[i].NumOfCappers[`ALLIES_TEAM_INDEX] = NumCappers[`ALLIES_TEAM_INDEX];

			if ( NumCappers[`AXIS_TEAM_INDEX] > 0 || NumCappers[`ALLIES_TEAM_INDEX] > 0 )
			{
				ROGRI.ObjectiveForceRatio[i] = byte((float(NumCappers[`AXIS_TEAM_INDEX]) / (NumCappers[`AXIS_TEAM_INDEX] + NumCappers[`ALLIES_TEAM_INDEX])) * 254.0);
			}

			// @TODO: Stop telling the Engine when to replicate...figure out why it doesn't consider the Array to be Dirty
			if ( ROGRI.ObjectiveStatus[i] != OldObjStatus || ROGRI.ObjectiveCapProgress[i] != OldCapProgress || ROGRI.ObjectiveForceRatio[i] != OldForceRatio )
			{
				WorldInfo.GRI.bNetDirty = true;
			}
		}
	}
}

function class<Pawn> GetPlayerClass(Controller C)
{
	local ROPlayerReplicationInfo ROPRI;
	local class<Pawn> PawnClass;
	
	ROPRI = ROPlayerReplicationInfo(C.PlayerReplicationInfo);
	
	if ( ROPRI != none )
	{
		if ( ROPRI.RoleInfo != none )
		{
			if ( ROPRI.Team.TeamIndex == `AXIS_TEAM_INDEX )
			{
				PawnClass = class<Pawn>(DynamicLoadObject("DesertRats.DRPawnAxis", class'Class'));
				return PawnClass;
			}
			else if ( ROPRI.Team.TeamIndex == `ALLIES_TEAM_INDEX )
			{
				PawnClass = class<Pawn>(DynamicLoadObject("DesertRats.DRPawnAllies", class'Class'));
				return PawnClass;
			}
			else
			{
				`warn("Invalid team index:" @ ROPRI.Team.TeamIndex);
			}
		}
		else
		{
			`warn("Player's Role Info is none");
		}
	}
	
	return DefaultPawnClass;
}

defaultproperties
{
	PlayerControllerClass=		class'DRPlayerController'
	AIControllerClass=			class'DRAIController'
	AIPawnClass=				class'DRPawn'
	DefaultPawnClass=			class'DRPawn'
	// HUDType=					class'DRHUD'
	TeamInfoClass=				class'DRTeamInfo'
	// PawnHandlerClass=			class'DRPawnHandler'
	// PlayerReplicationInfoClass=	class'DRPlayerReplicationInfo';
	
	bDisableCharCustMenu=true
	
	SquadSpawnMethod[0]=ROSSM_SquadLeader
	SquadSpawnMethod[1]=ROSSM_SquadLeader
}
