class DRGameInfoTerritories extends ROGameInfoTerritories
    config(Game_DesertRats_GameInfo);

var array<string> TempPawnsBrit;
var array<string> TempPawnsGer;

`include(DesertRats\Classes\DRGameInfo_Common.uci)

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

// Ends the current round and starts the next one.
function RoundWon(int WinningTeam, byte WinCondition )
{
    local int i;
    local int NumOfPlayers;
    local string MapName;
    local string WinningTeamName;
    local ObjectiveInfo ObjInfo;
    local BalanceStats BStats;

    ClearTimer('DelayedCheckReinforcementLockdown');

    if (bDebugMorale)
    {
        `log("RoundWon()");
    }

    SetMorale(255, 255);

    MapName = string(WorldInfo.GetPackageName());
    WinningTeamName = (WinningTeam == `AXIS_TEAM_INDEX ? "Axis" : "Allies");
    NumOfPlayers = GetNumPlayers();

    `log("BALANCE STATS:" @ MapName @ "|" @ MaxPlayers @ " max players |" @ NumOfPlayers
        @ "players playing" @ "Teams Swapped=" @ bReverseRolesAndSpawns,,'DevBalanceStats');
    `log("BALANCE STATS: WinningTeam=" $ WinningTeamName @ "Teams Swapped="
        @ bReverseRolesAndSpawns,, 'DevBalanceStats');
    `log("BALANCE STATS: TimeRemaining=" $ GameReplicationInfo.RemainingTime $ " seconds which is "
        $ (GameReplicationInfo.RemainingTime / 60.0) $ " minutes" @ "Teams Swapped=" @ bReverseRolesAndSpawns,, 'DevBalanceStats');
    `log("BALANCE STATS: AxisReinforcements=" $ AxisTeam.ReinforcementsRemaining @ "AlliesReinforcements="
        $ AlliesTeam.ReinforcementsRemaining @ "Teams Swapped=" @ bReverseRolesAndSpawns,, 'DevBalanceStats');

    BStats.MapName = MapName;
    BStats.WinningTeamName = WinningTeamName;
    BStats.MaxPlayers = MaxPlayers;
    BStats.NumPlayers = NumOfPlayers;
    BStats.TimeRemainingSeconds = GameReplicationInfo.RemainingTime;
    BStats.AxisReinforcements = AxisTeam.ReinforcementsRemaining;
    BStats.AlliesReinforcements = AlliesTeam.ReinforcementsRemaining;
    BStats.bReverseRolesAndSpawns = bReverseRolesAndSpawns;

    for (i = 0; i < Objectives.Length; i++)
    {
        ObjInfo.ObjIndex = Objectives[i].ObjIndex;
        ObjInfo.ObjState = Objectives[i].ObjState;
        ObjInfo.ObjName = Objectives[i].ObjName;

        BStats.ObjInfos.AddItem(ObjInfo);

        if (Objectives[i] != none && Objectives[i].bActive)
        {
            `log("BALANCE STATS: ActiveObjectives " $ i $ " = " $ Objectives[i].ObjName
                @ "Status=" $ (Objectives[i].ObjState == `AXIS_TEAM_INDEX ? "Axis" : (
                    Objectives[i].ObjState == `ALLIES_TEAM_INDEX ? "Allies" : "Neutral")),, 'DevBalanceStats');
        }
    }

    /*
    // Of course this class is territories, but this is to prevent subclasses logging stats against this game type
    // This must be called BEFORE the super class, or it will miss the push to the TW servers!
    if( Class.static.GetGameType() == ROGT_Territory )
    {
        AnalyticsLog("round_won_te", MostRecentObjIdxCaptured[`AXIS_TEAM_INDEX], MostRecentObjIdxCaptured[`ALLIES_TEAM_INDEX]);
    }
    */

    super.RoundWon(WinningTeam, WinCondition);

    `log("BALANCE STATS: AxisTeamScore=" $ AxisTeam.Score @ "AlliesTeamScore=" $ AlliesTeam.Score,, 'DevBalanceStats');

    BStats.AxisTeamScore = AxisTeam.Score;
    BStats.AlliesTeamScore = AlliesTeam.Score;

    LastTeamObjectivesCaptured[`AXIS_TEAM_INDEX] = TeamObjectivesCaptured[`AXIS_TEAM_INDEX];
    LastTeamObjectivesCaptured[`ALLIES_TEAM_INDEX] = TeamObjectivesCaptured[`ALLIES_TEAM_INDEX];
    ROGameReplicationInfo(GameReplicationInfo).LastRoundGrandScore[`AXIS_TEAM_INDEX] = ROGameReplicationInfo(GameReplicationInfo).TeamsGrandScore[`AXIS_TEAM_INDEX];
    ROGameReplicationInfo(GameReplicationInfo).LastRoundGrandScore[`ALLIES_TEAM_INDEX] = ROGameReplicationInfo(GameReplicationInfo).TeamsGrandScore[`ALLIES_TEAM_INDEX];

    SendBalanceStatsPackage(BStats);
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
                &&  (EnabledObjectives - TeamObjectiveCount(`ALLIES_TEAM_INDEX) > 1
                    || EnabledObjectives - TeamObjectiveCount(`AXIS_TEAM_INDEX) > 1))
            {
                // TODO: Need something custom here?
                BroadcastLocalizedMessage(class'ROLocalMessageObjective', ROOBJMSG_Captured + Objectives[i].CapTeamIndex, , , Objectives[i]);
            }

            // Let the game object know that an objective was captured
            ObjectiveCaptured(i);
        }

        // Replicate this Objective status to Cappers
        for ( j = 0; j < PlayerCappers.Length; j++ )
        {
            PlayerCappers[j].ObjectiveIndex = i;
            PlayerCappers[j].ObjectiveName  = Objectives[i].ObjName;
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

function RestartPlayer(Controller NewPlayer)
{
    local NavigationPoint StartSpot;
    local int TeamNum, Idx;
    local array<SequenceObject> Events;
    local SeqEvent_PlayerSpawned SpawnedEvent;
    local ROPlayerReplicationInfo ROPRI;
    local ROVehicle ROV;
    local ROPlayerController ROPC, MySL;
    local rotator MySLRot;
    local bool bIgnoreRespawnTickets;

    if ( bRestartLevel && WorldInfo.NetMode != NM_DedicatedServer &&
        WorldInfo.NetMode != NM_ListenServer && WorldInfo.NetMode != NM_StandAlone )
    {
        `warn("bRestartLevel && !server, abort from RestartPlayer" @ WorldInfo.NetMode);
        return;
    }

    if ( AIController(NewPlayer) != none )
    {
        if ( TooManyBots(NewPlayer) )
        {
            NewPlayer.Destroy();
            return;
        }
    }

    // if the Player's on a Team
    if ( NewPlayer.PlayerReplicationInfo != none && NewPlayer.PlayerReplicationInfo.Team != none )
    {
        // Use the Team's Index to find a Start Spot
        TeamNum = NewPlayer.PlayerReplicationInfo.Team.TeamIndex;
    }
    else
    {
        // Use the default Team Number
        TeamNum = 255;
    }

    /*
    * If we're requesting an Ambush Respawn...
    * Validate our team is Axis, our VC commander is alive and they have a pawn. Failing to verify if their pawn existed caused a weird edge case where calling Ambush Respawn when in the Spawn Select menu would cause the
    * reinforcements to spawn in the air and plummet to their death for some reason Possibly because the pawn hadn't been placed yet.
    */
    if(AttemptingAmbushRespawn(NewPlayer))
    {
        StartSpot = Spawn(class'ROSpawnNavigationPoint',,,VCAmbushStartLocation);
    }
    else // else just use standard 'find me a start spot' logic for this player.
    {
        // Find a start spot
        StartSpot = FindPlayerStart(NewPlayer, TeamNum);

        // If a start spot wasn't found...
        if ( StartSpot == none )
        {
            // Check for a previously assigned spot
        /*  if ( NewPlayer.StartSpot != none )
            {
                StartSpot = NewPlayer.StartSpot;
                `logd("Player start not found, using last start spot");
            }
            else if(NewPlayer.StartSpot == none)
            {*/
                // Otherwise abort
                `logd("Player start not found, failed to restart player");
                return;
            //}
        }
    }

    // Try to create a pawn to use of the default class for this player
    if ( NewPlayer.Pawn == none )
    {
        NewPlayer.Pawn = SpawnDefaultPawnFor(NewPlayer, StartSpot);
    }

    // If we couldn't create a new Pawn
    if ( NewPlayer.Pawn == none )
    {
        `log("Failed to spawn player at" @ StartSpot);

        NewPlayer.StartSpot = StartSpot;

        if( !NewPlayer.IsInState('Spectating') )
        {
            NewPlayer.GotoState('Dead');

            if ( PlayerController(NewPlayer) != None )
            {
                PlayerController(NewPlayer).ClientGotoState('Dead', 'Begin');
            }
        }
    }
    else
    {
        if( !bSpawnOnSquadLeader && !bSpawnOnSquadTunnel && ROVehicleBase(NewPlayer.Pawn) == none && SpawnProtectionDelay > 0.05)
        {
            NewPlayer.bGodMode = true;
            NewPlayer.SetTimer(SpawnProtectionDelay, false, 'RestoreGodMode');
        }
        // else
        // {
        //  `Log("Skipping spawn protection");
        // }

        ROPC = ROPlayerController(NewPlayer);
        if ( ROPC != none && ROPC.bIsSwappingRole ) // If the player is swapping roles in spawn, don't use tickets to spawn them
            bIgnoreRespawnTickets = true;

        // RS2PR-5811 - Also, skip ticket consumption if we're in the midst of an Instant Deploy (Force/Ambush respawn) for this player's team. -Nate
        if(ROPC != None
            && TeamNum != 255
            && TeamNum != `NEUTRAL_TEAM_INDEX
            && TeamNum == CurInstantDeployTeam
            && CurReinforcementbForceRespawn)
        {
            bIgnoreRespawnTickets = true;
        }

        if ( !bIgnoreRespawnTickets )
        {
            // Reduce the Player's Team's Reinforcement count if Enhanced Logistics is active and this is NOT an Ambush Respawn.
            if(NewPlayer.PlayerReplicationInfo.GetTeamNum() == `AXIS_TEAM_INDEX
                && bEnableEnhancedLogistics
                && !bEnableAmbushRespawn)
            {
                ELCounter++;
                if(ELCounter % 2 == 0)
                {
                    ConsumeReinforcement(NewPlayer);
                }
            }
            else // Must be a regular spawn OR Enhanced Logistics is still active and we're Ambush Respawning, consume a ticket normally.
            {
                ConsumeReinforcement(NewPlayer);
            }
        }

        // Initialize the Pawn and start it up
        NewPlayer.Pawn.SetAnchor(StartSpot);

        if ( PlayerController(NewPlayer) != None )
        {
            PlayerController(NewPlayer).TimeMargin = -0.1;
        }

        NewPlayer.Pawn.LastStartSpot = PlayerStart(StartSpot);
        NewPlayer.Pawn.LastStartTime = WorldInfo.TimeSeconds;
        NewPlayer.Possess(NewPlayer.Pawn, false);
        NewPlayer.Pawn.PlayTeleportEffect(true, true);
        NewPlayer.ClientSetRotation(NewPlayer.Pawn.Rotation, TRUE);

        if ( !WorldInfo.bNoDefaultInventoryForPlayer )
        {
            AddDefaultInventory(NewPlayer.Pawn);
        }

        SetPlayerDefaults(NewPlayer.Pawn);
        AttachPlayerRadio(NewPlayer.Pawn);

        if ( ROPC != none )
            ROPC.Spawned();

        // activate spawned events
        if ( WorldInfo.GetGameSequence() != none )
        {
            WorldInfo.GetGameSequence().FindSeqObjectsByClass(class'SeqEvent_PlayerSpawned', true, Events);
            for ( Idx = 0; Idx < Events.Length; Idx++ )
            {
                SpawnedEvent = SeqEvent_PlayerSpawned(Events[Idx]);
                if ( SpawnedEvent != none && SpawnedEvent.CheckActivate(NewPlayer,NewPlayer) )
                {
                    SpawnedEvent.SpawnPoint = startSpot;
                    SpawnedEvent.PopulateLinkedVariableValues();
                }
            }
        }
    }

    ROPRI = ROPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo);
    `DRLogSpawning(NewPlayer.PlayerReplicationInfo.PlayerName @ "checking for Tank Spawn" @ ROPRI @ ROPRI.RoleInfo @ ROPRI.RoleInfo.bCanBeTankCrew);
    if ( ROPRI != none && ROPRI.RoleInfo != none && ROPRI.RoleInfo.bCanBeTankCrew && ROVehicleBase(NewPlayer.Pawn) == none )
    {
        NewPlayer.Pawn.SetCollision(false, false);
        AddDefaultInventory(NewPlayer.Pawn);

    /*  ROV = ROMapInfo(WorldInfo.GetMapInfo()).GetFireTeamVehicle(TeamNum, bReverseRolesAndSpawns, ROPRI.SquadIndex, ROPRI.FireTeamIndex);
        `DRLogSpawning(NewPlayer.PlayerReplicationInfo.PlayerName @ "checking Vehicle" @ ROPRI.RoleInfo.bIsTankCommander @ ROV @ (ROV != none ? ROV.Health : -1));
        if ( ROPRI.RoleInfo.bIsTankCommander && (ROV == none || ROV.Health <= 0) )
        {
            SpawnTankAndCrew(NewPlayer);
            // reset camera relative to tank
            NewPlayer.ClientSetRotation(rot(0,0,0));
        }
        else if( ROV != none && ROV.Health > 0 )
        {
            ROPC = ROPlayerController(NewPlayer);

            if ( ROPC != none )
            {
                // Handle the failure of not being able to take over tank AI so you don't just end up floating in space
                if( !ROPC.TryPossessVehicleAI() )
                {
                    `DRLogSpawning("TryPossessVehicleAI Failed to take over vehicle AI!!!!!!!!");

                    // Get rid of the pawn that was created if we can't get in the vehicle
                    NewPlayer.Pawn.Destroy();
                    NewPlayer.UnPossess();

                    NewPlayer.GotoState('Dead');

                    if ( PlayerController(NewPlayer) != None )
                    {
                        PlayerController(NewPlayer).ClientGotoState('Dead', 'Begin');
                    }
                }
                else
                {
                    // reset camera relative to tank
                    NewPlayer.ClientSetRotation(rot(0,0,0));
                }
            }
        }
        else
        {*/
            // Handle the failure of not spawning a tank or taking over vehicle AI so you don't just end up floating in space
            `DRLogSpawning("Failed to spawn a tank or spawn in a tank!!!!!!!!");

             // Get rid of the pawn that was created if we can't get in the vehicle
            NewPlayer.Pawn.Destroy();
            NewPlayer.UnPossess();

            NewPlayer.GotoState('Dead');

            if ( PlayerController(NewPlayer) != None )
            {
                PlayerController(NewPlayer).ClientGotoState('Dead', 'Begin');
            }
    //  }
    }
    else if ( ROPRI != none && ROPRI.RoleInfo != none && ROPRI.RoleInfo.bIsPilot && ROVehicleBase(NewPlayer.Pawn) == none )
    {
        //NewPlayer.Pawn.SetCollision(false, false);
        AddDefaultInventory(NewPlayer.Pawn);

        ROPC = ROPlayerController(NewPlayer);
        if ( ROPC != none )
            ROV = ROPC.LastFlownHelo;

        if( ROV != none && ROV.Health > 0 )
        {
            if( !ROPC.TryPossessHeloCopilot() )
            {
                `DRLogSpawning("TryPossessHeloCopilot Failed to take over copilot seat!!!!!!!!");

                // Get rid of the pawn that was created if we can't get in the vehicle
                NewPlayer.Pawn.Destroy();
                NewPlayer.UnPossess();

                NewPlayer.GotoState('Dead');

                if ( PlayerController(NewPlayer) != None )
                {
                    PlayerController(NewPlayer).ClientGotoState('Dead', 'Begin');
                }
            }
            else
            {
                // reset camera relative to helo
                NewPlayer.ClientSetRotation(rot(0,0,0));
                NewPlayer.bGodMode = false;
                NewPlayer.ClearTimer('RestoreGodMode');
                ROV.HandleBattleChatterEvent(`BATTLECHATTER_HeloPilotDead);
            }
        }
    }

    if ( bRoundActive && bRoundHasBegun && !bInRoundStartScreen )
    {
        if ( ROPlayerController(NewPlayer) != none )
        {
            ROPlayerController(NewPlayer).ClientHideRoundStartScreen();
            ROPlayerController(NewPlayer).SetCinematicMode(false, false, false, true, false, true);
        }
    }
    else if ( bInRoundStartScreen )
    {
        if ( ROPlayerController(NewPlayer) != none )
        {
            ROPlayerController(NewPlayer).ClientCloseLobbyScene();
            ROPlayerController(NewPlayer).ClientCloseTeamWinScreen();
            ROPlayerController(NewPlayer).SetCinematicMode(true, false, false, true, false, true);
            ROPlayerController(NewPlayer).ClientShowRoundStartScreen(GameReplicationInfo.RemainingTime);
        }

        if ( ROAIController(NewPlayer) != none )
        {
            ROAIController(NewPlayer).AISuspended();
        }
    }

    if( ROPRI != none )
    {
        ROPRI.bWeaponNeedsResupply = false;

        if( ROPRI.Squad != none && ROPRI.bIsSquadLeader )
        {
            ROPRI.Squad.SRI.bIsSquadLeaderAlive = true;
            ROPRI.Squad.SRI.SquadLeaderLocation = NewPlayer.Pawn.Location;
            ROPRI.Squad.SRI.SquadLeaderHeadLocation = ROPawn(NewPlayer.Pawn).Mesh.GetBoneLocation(ROPawn(NewPlayer.Pawn).HeadBoneName,0);
            ROPRI.Squad.SRI.bSLJustGotPromoted = false;
        }

        if( bSpawnOnSquadTunnel )
        {
            if( bSpawnOnSquadLeader && ROPawn(NewPlayer.Pawn).bCanCrouch )
            {
                ROPawn(NewPlayer.Pawn).ServerForceCrouch();
            }

            // Give the SL some points
            ScoreSquadSpawn(NewPlayer, ROPRI.Squad.GetSquadLeader());
        }
        // Re-purposed for CHAR-1369: Face the same direction as our SL. Also adapt their stance (crouch, prone) -Nate.
        // Sturt: This check MUST now happen after the tunnel spawn check, as we're borrowing bSpawnOnSquadLeader for use there as well
        else if( bSpawnOnSquadLeader )
        {
            // Grab our Squad Leader.
            MySL = ROPlayerController(ROPRI.Squad.GetSquadLeader());

            if(MySL != None)
            {
                // Grab the SL's rotation (Yaw).
                MySLRot = MySL.Pawn.Rotation;
                MySLRot.Pitch = 0;
                MySLRot.Roll = 0;

                // Set our new player's rotation (Yaw) to that of their SL's roation (Yaw).
                NewPlayer.ClientSetRotation(MySLRot);

                // ---- Attempt to force our new pawn to adapt the stance of our SL (crouched, prone, etc.)

                // Firstly, if our SL is proning, try to force this new pawn to go prone.
                if((ROPawn(MySL.Pawn).bIsProning || ROPawn(MySL.Pawn).IsProneTransitioning())
                    && (ROPawn(NewPlayer.Pawn).CanProneTransition() && ROPawn(NewPlayer.Pawn).bCanProne))
                {
                    ROPawn(NewPlayer.Pawn).ServerForceProne();
                }
                // Else if the SL is crouched or our new pawn cannot prone, attempt to force crouch.
                else if((ROPawn(MySL.Pawn).bIsCrouched && ROPawn(NewPlayer.Pawn).bCanCrouch)
                    || !ROPawn(NewPlayer.Pawn).bCanProne)
                {
                    ROPawn(NewPlayer.Pawn).ServerForceCrouch();
                }
            }

            // Give the SL some points
            ScoreSquadSpawn(NewPlayer, ROPRI.Squad.GetSquadLeader());
        }
    }

    ROPRI.LastPRIToSpotMeIndex = 255; // reset to handle round end, any other circumstance

    if ( ROPlayerController(NewPlayer) != none )
        ROPlayerController(NewPlayer).StartTimeInRole = WorldInfo.TimeSeconds;
}

function NavigationPoint FindPlayerStartWithOverride(Controller Player, int SpawnIndexOverride, optional byte InTeam, optional string IncomingName)
{
    local byte Team, SelectedSpawnIndex, SpawnOnSLFailCode;
    local NavigationPoint BestStart, N;
    local vector SquadLeaderSpawnPoint;
    local float /*BestRating, */NewRating;
    local Teleporter Tel;
    local ROPlayerStart P;
    local ROMapInfo ROMI;
    local ROPlayerReplicationInfo ROPRI, SLROPRI; // MGPRI;
    // local Pawn MGPawn;
    local ROTeamInfo TeamInfo;
    local ROVolumePlayerStartGroup PlayerStartVolume;
    //local ROVehicle TransportVehicle;
    local ROVehicleHelicopter HelicopterVehicle;
    local ROPlaceableSpawn SpawnTunnel;
    local ROObjective NearestObjective;
    local bool bTankCrew, bWantsVehicleSpawn, bCanSpawnInHelo, bPilot, bCanSpawnAtTunnel, bRadioMan;
    local Controller SquadLeader;
    local int i;

    //BestRating = 0;
    bSpawnOnSquadLeader = false;
    bSpawnOnSquadTunnel = false;

    // int failure code.
    SpawnOnSLFailCode = 255;

    // Reset our cached controller.
    ControllerFailedSpawnOnSL = None;

    // Use InTeam if player doesn't have a team yet
    Team = (Player != none && Player.PlayerReplicationInfo != none && Player.PlayerReplicationInfo.Team != None) ? byte(Player.PlayerReplicationInfo.Team.TeamIndex) : InTeam;

    // if the specified Team is invalid(NOTE: Must allow FindPlayerStart to return a NavPoint when creating a new controller)
    if ( Player != none && Team != `AXIS_TEAM_INDEX && Team != `ALLIES_TEAM_INDEX )
    {
        // Don't let them Spawn until they choose a Team
        return none;
    }

    // allow GameRulesModifiers to override playerstart selection
    if (BaseMutator != None)
    {
        N = BaseMutator.FindPlayerStart(Player, InTeam, IncomingName);
        if (N != None)
        {
            return N;
        }
    }

    // if incoming start is specified, then just use it
    if ( IncomingName != "" )
    {
        foreach WorldInfo.AllNavigationPoints(class 'Teleporter', Tel)
        {
            if ( string(Tel.Tag) ~= IncomingName )
            {
                return Tel;
            }
        }
    }

    if ( Player != none )
    {
        ROPRI = ROPlayerReplicationInfo(Player.PlayerReplicationInfo);
    }

    if ( ROPRI != none )
    {
        if ( ROPRI.RoleInfo != none )
        {
            bTankCrew = ROPRI.RoleInfo.bCanBeTankCrew;
            bPilot = ROPRI.RoleInfo.bIsPilot;
            bRadioMan = ROPRI.RoleInfo.bIsRadioMan;
        }

        SelectedSpawnIndex = ROPRI.SpawnSelection;

        if ( SelectedSpawnIndex >= 128 )
        {
            SelectedSpawnIndex -= 128;
        }
        if( SpawnIndexOverride != -1 )
        {
           SelectedSpawnIndex = SpawnIndexOverride;
        }

        if( !bTankCrew && !bPilot )
        {
            TeamInfo = ROTeamInfo(WorldInfo.GRI.Teams[Team]);
            if( TeamInfo != none)
            {
                if(SelectedSpawnIndex == 123) // U.S. Commander Loach spawn.
                {
                    if(ROPRI.RoleInfo.bIsTeamLeader && TeamInfo.GetTeamNum() == `ALLIES_TEAM_INDEX)
                        bCanSpawnInHelo = true;
                }
                else if(SelectedSpawnIndex == 124)
                {
                    if( TeamInfo.GetSpawnableHelicopter(ROPRI.SquadIndex,HelicopterVehicle) )
                        bCanSpawnInHelo = true;
                }
                else if( SelectedSpawnIndex >= 110 && SelectedSpawnIndex <= 119 )
                {
                    if( TeamInfo.GetSpawnableHelicopterByIndex(HelicopterVehicle, SelectedSpawnIndex - 110) )
                        bCanSpawnInHelo = true;
                }
            }
        }

        if( ROAIController(Player) != none )
        {
            if( bCanSpawnInHelo && FRand() > 0.65 )
                SelectedSpawnIndex = 124; // +1 because of MG deprecation
            else if( !bDisableSpawnOnSquadLeader && ROGameReplicationInfo(WorldInfo.GRI) != none && FRand() > 0.85 )
            {
                if( ROGameReplicationInfo(WorldInfo.GRI).SquadSpawnMethod[Team] == ROSSM_Tunnel )
                    SelectedSpawnIndex = 125;
                else if( ROGameReplicationInfo(WorldInfo.GRI).SquadSpawnMethod[Team] == ROSSM_SquadLeader )
                    SelectedSpawnIndex = 126;
            }
        }
    }

    // if we're trying to Spawn on Squad Leader
    if ( !bTankCrew && !bPilot && Player != none && SelectedSpawnIndex == 126 ) //ROPlayerController(Player) != none changed to Player != none
    {
        ROMI = ROMapInfo(WorldInfo.GetMapInfo());
        SquadLeader = ROPRI.Squad != none ? ROPRI.Squad.GetSquadLeader() : none;
        SLROPRI = SquadLeader != none ? ROPlayerReplicationInfo(SquadLeader.PlayerReplicationInfo) : none;

        `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "attempting spawn on Squad Leader" @ ROMI @ ROPRI @ ROPRI.Squad @ SquadLeader @ ROPLayerController(Player).SRI.SquadLeaderLocation);
        if ( ROMI != none && ROPRI != none && ROPRI.Squad != none && SquadLeader != none && SquadLeader != Player )
        {
            if( SLROPRI.TeamHelicopterArrayIndex != 255 && ROTeamInfo(ROPRI.Team).TeamHelicopterArray[SLROPRI.TeamHelicopterArrayIndex].CanSpawnInto() ) // spawn into helo if SL is in one and there are seats available
            {
                HelicopterVehicle = ROTeamInfo(ROPRI.Team).TeamHelicopterArray[SLROPRI.TeamHelicopterArrayIndex];

                PlayerStartVolume = GetClosestActivePlayerStartVolume(ROPLayerController(Player).SRI.SquadLeaderLocation, Team, false); // in case spawning fails

                if ( ROPlayerController(Player) != none )
                    ROPlayerController(Player).SpawnedInHelicopter();

                return SpawnPlayerInHelicopter(Player, HelicopterVehicle, PlayerStartVolume, Team);
            }
            // Try to find a suitable location near the SL
            else if( FindNearestSpawnablePoint(SquadLeader, SquadLeaderSpawnPoint,, SpawnOnSLFailCode) )
            {
                BestStart = Spawn(class'ROSpawnNavigationPoint',,,SquadLeaderSpawnPoint);
            }

            if ( BestStart != none )
            {
                NearestObjective = GetNearestActiveObjective(BestStart.Location);
                if ( NearestObjective != none )
                {
                    BestStart.SetRotation(rotator(NearestObjective.Location - BestStart.Location));
                }

                bSpawnOnSquadLeader = true;
                return BestStart;
            }
            else
            {
                // SL in protected spawn volume.
                if(SpawnOnSLFailCode == 0)
                {
                    // Message to spawning player.
                    PlayerController(Player).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnSLFailedInSpawnVol,,,Player);
                    // Message to SL.
                    PlayerController(ROPRI.Squad.GetSquadLeader()).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnYouFailedInSpawnVol);
                }
                // SL in Objective volume.
                else if(SpawnOnSLFailCode == 1)
                {
                    PlayerController(Player).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnSLFailedInObjVol,,,Player);
                    PlayerController(ROPRI.Squad.GetSquadLeader()).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnYouFailedInObjVol);
                }
                // SL In Tunnel Spawn
                else if(SpawnOnSLFailCode == 2)
                {
                    PlayerController(Player).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnSLFailedInTunnel,,,Player);
                    PlayerController(ROPRI.Squad.GetSquadLeader()).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnYouFailedInTunnel);
                }
                // Either SL is dead / gone, or for some strange technical reason we failed to spawn on the SL. Keep trying and put them back in the spawn queue.
                else
                {
                    PlayerController(Player).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnSquadLeaderFailed,,,Player);
                    PlayerController(ROPRI.Squad.GetSquadLeader()).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnYouFailed);
                }

                // Cache our controller that failed to spawn on the SL.
                ControllerFailedSpawnOnSL = Player;
                `DRLogSpawning("Failed to spawn on SL- Caching controller "$ControllerFailedSpawnOnSL$" and will return this controller to spawn queue.");

                // Reset fail code.
                SpawnOnSLFailCode = 255;
            }
        }
    }

    // if we're trying to Spawn on our Commander
    if ( bRadioMan && Player != none && SelectedSpawnIndex == 109 )
    {
        ROMI = ROMapInfo(WorldInfo.GetMapInfo());
        SquadLeader = ROPlayerController(Player).GetTeamLeader();
        SLROPRI = SquadLeader != none ? ROPlayerReplicationInfo(SquadLeader.PlayerReplicationInfo) : none;

        `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "attempting spawn on Squad Leader" @ ROMI @ ROPRI @ ROPRI.Squad @ SquadLeader @ ROPLayerController(Player).SRI.SquadLeaderLocation);
        if ( ROMI != none && ROPRI != none && ROPRI.Squad != none && SquadLeader != none && SquadLeader != Player )
        {
            if( SLROPRI.TeamHelicopterArrayIndex != 255 && ROTeamInfo(ROPRI.Team).TeamHelicopterArray[SLROPRI.TeamHelicopterArrayIndex].CanSpawnInto() ) // spawn into helo if SL is in one and there are seats available
            {
                HelicopterVehicle = ROTeamInfo(ROPRI.Team).TeamHelicopterArray[SLROPRI.TeamHelicopterArrayIndex];

                PlayerStartVolume = GetClosestActivePlayerStartVolume(ROPLayerController(Player).SRI.SquadLeaderLocation, Team, false); // in case spawning fails

                if ( ROPlayerController(Player) != none )
                    ROPlayerController(Player).SpawnedInHelicopter();

                return SpawnPlayerInHelicopter(Player, HelicopterVehicle, PlayerStartVolume, Team);
            }
            // Try to find a suitable location near the SL
            else if( FindNearestSpawnablePoint(SquadLeader, SquadLeaderSpawnPoint,, SpawnOnSLFailCode) )
            {
                BestStart = Spawn(class'ROSpawnNavigationPoint',,,SquadLeaderSpawnPoint);
            }

            if ( BestStart != none )
            {
                NearestObjective = GetNearestActiveObjective(BestStart.Location);
                if ( NearestObjective != none )
                {
                    BestStart.SetRotation(rotator(NearestObjective.Location - BestStart.Location));
                }

                bSpawnOnSquadLeader = true;
                return BestStart;
            }
            else
            {
                // SL in protected spawn volume.
                if(SpawnOnSLFailCode == 0)
                {
                    // Message to spawning player.
                    PlayerController(Player).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnSLFailedInSpawnVol,,,Player);
                    // Message to SL.
                    PlayerController(ROPRI.Squad.GetSquadLeader()).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnYouFailedInSpawnVol);
                }
                // SL in Objective volume.
                else if(SpawnOnSLFailCode == 1)
                {
                    PlayerController(Player).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnSLFailedInObjVol,,,Player);
                    PlayerController(ROPRI.Squad.GetSquadLeader()).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnYouFailedInObjVol);
                }
                // SL In Tunnel Spawn
                else if(SpawnOnSLFailCode == 2)
                {
                    PlayerController(Player).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnSLFailedInTunnel,,,Player);
                    PlayerController(ROPRI.Squad.GetSquadLeader()).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnYouFailedInTunnel);
                }
                // Either SL is dead / gone, or for some strange technical reason we failed to spawn on the SL. Keep trying and put them back in the spawn queue.
                else
                {
                    PlayerController(Player).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnSquadLeaderFailed,,,Player);
                    PlayerController(ROPRI.Squad.GetSquadLeader()).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnOnYouFailed);
                }

                // Cache our controller that failed to spawn on the SL.
                ControllerFailedSpawnOnSL = Player;
                `DRLogSpawning("Failed to spawn on SL- Caching controller "$ControllerFailedSpawnOnSL$" and will return this controller to spawn queue.");

                // Reset fail code.
                SpawnOnSLFailCode = 255;
            }
        }
    }

    // Trying to spawn at a Placeable Tunnel
    if ( !bTankCrew && !bPilot && Player != none && SelectedSpawnIndex == 125 )
    {
        // Grab our squad's tunnel if it's available and active
        if( ROPRI.Squad.SRI.bHasSpawnTunnel )
        {
            SpawnTunnel = ROPRI.Squad.PlaceableSpawn;
            if( ROPRI.Squad.SRI.bIsSpawnTunnelActive )
            {
                bCanSpawnAtTunnel = true;
            }
            else if (SpawnTunnel != none && SpawnTunnel.bEnemyClose)
            {
                ControllerFailedSpawnOnSL = Player;
                `DRLogSpawning("Failed to spawn on SL- Caching controller "$ControllerFailedSpawnOnSL$" and will return this controller to spawn queue.");
                PlayerController(Player).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnTunnelEnemyClose,,,Player);
            }
            else
            {
                ControllerFailedSpawnOnSL = Player;
                `DRLogSpawning("Failed to spawn on SL- Caching controller "$ControllerFailedSpawnOnSL$" and will return this controller to spawn queue.");
                PlayerController(Player).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnTunnelInvalid,,,Player);
            }
        }

        `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "attempting spawn at Placeable Tunnel" @ ROPRI @ ROPRI.Squad @ SpawnTunnel @ SpawnTunnel.Location);

        if ( bCanSpawnAtTunnel )
        {
            if( FindSpawnablePointForTunnel( SpawnTunnel, SquadLeaderSpawnPoint) )
            {
                BestStart = Spawn(class'ROSpawnNavigationPoint',,,SquadLeaderSpawnPoint);
            }

            if ( BestStart != none )
            {
                NearestObjective = GetNearestActiveObjective(BestStart.Location);
                if ( NearestObjective != none )
                {
                    BestStart.SetRotation(rotator(NearestObjective.Location - BestStart.Location));
                }

                bSpawnOnSquadTunnel = true;

                return BestStart;
            }
            else
            {
                ControllerFailedSpawnOnSL = Player;
                `DRLogSpawning("Failed to spawn on Tunnel - Caching controller "$ControllerFailedSpawnOnSL$" and will return this controller to spawn queue.");
                PlayerController(Player).ReceiveLocalizedMessage(class'ROLocalMessageGameAlert', ROMSG_SpawnAtTunnelFailed,,,Player);
            }
        }
    }

    // Trying to spawn in Helicopter
    if ( Player != none && bCanSpawnInHelo )
    {
        if( SelectedSpawnIndex >= 110 && SelectedSpawnIndex <= 119 )
        {
            // if our original helicopter choice has died while waiting to spawn, see if another is available
            if( HelicopterVehicle == none )
            {
                // If one isn't available, we can't spawn in a helo, so change the condition
                if( !TeamInfo.GetSpawnableHelicopterByIndex(HelicopterVehicle, SelectedSpawnIndex - 110) )
                    bCanSpawnInHelo = false;
            }
        }
        else if( SelectedSpawnIndex == 124 )
        {
            // if our original helicopter choice has died while waiting to spawn, see if another is available
            if( HelicopterVehicle == none )
            {
                // If one isn't available, we can't spawn in a helo, so change the condition
                if( !TeamInfo.GetSpawnableHelicopter(ROPRI.SquadIndex,HelicopterVehicle) )
                    bCanSpawnInHelo = false;
            }
        }
        else if(SelectedSpawnIndex == 123)
        {
            if(HelicopterVehicle == None)
            {
                if(!TeamInfo.GetSpawnableHelicopterForCommander(HelicopterVehicle))
                    bCanSpawnInHelo = false;
            }
        }

        `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "attempting spawn in Helicopter" @ ROPRI @ ROPRI.Squad @ HelicopterVehicle @ HelicopterVehicle.Location);

        if ( bCanSpawnInHelo )
        {
            if ( ROPlayerController(Player) != none )
                ROPlayerController(Player).SpawnedInHelicopter();

            return SpawnPlayerInHelicopter(Player, HelicopterVehicle, PlayerStartVolume, Team);
        }
    }

    if (ControllerFailedSpawnOnSL == None
        && Player != none
        && BestStart == none
        && SelectedSpawnIndex < `MAX_ACTIVE_SPAWNS
        && (Team == `AXIS_TEAM_INDEX || Team == `ALLIES_TEAM_INDEX) )
    {
        TeamInfo = ROTeamInfo(WorldInfo.GRI.Teams[Team]);

        `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "attempting to use SelectedSpawnIndex" @ Team @ TeamInfo @ bTankCrew @ SelectedSpawnIndex);
        if ( TeamInfo != none )
        {
            if ( bTankCrew )// || TransportVehicle == none )
            {
                // Get selected spawn volume (Bots choose randomly instead)
                if ( SelectedSpawnIndex == 0 && !Player.IsA('PlayerController'))
                {
                    PlayerStartVolume = GetRandomVehicleSpawnVolume(TeamInfo);
                    `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "Vehicle SelectedSpawn status" @ PlayerStartVolume @ PlayerStartVolume.PlayerStartList[0].bEnabled);
                }
                else
                {
                    PlayerStartVolume = TeamInfo.AvailableVehicleSpawnLocations[SelectedSpawnIndex];
                    `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "Vehicle SelectedSpawn status" @ PlayerStartVolume @ PlayerStartVolume.PlayerStartList[0].bEnabled);
                }

                // If the selected volume is valid then continue
                if ( PlayerStartVolume != none && PlayerStartVolume.PlayerStartList.Length > 0 && PlayerStartVolume.PlayerStartList[0].bEnabled )
                {
                    for ( i = 0; i < PlayerStartVolume.PlayerStartList.Length; i++ )
                    {
                        // Select a Random Spawn Point from the list and Rate it
                        P = PlayerStartVolume.PlayerStartList[rand(PlayerStartVolume.PlayerStartList.Length)];

                        if ( !P.bOutsidePlayableArea )
                        {
                            NewRating = RatePlayerStart(P, Team, Player);

                            // If the random Player Start can be spawned at, use it
                            if ( NewRating > 0.0 )
                            {
                                `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "found TankCrew spawn" @ P @ NewRating @ PlayerStartVolume);

                                return P;
                            }
                        }
                    }
                }
            }
            else if( bPilot )
            {
                // If player wants to spawn with helicopters
                PlayerStartVolume = TeamInfo.AvailablePilotSpawnLocations[SelectedSpawnIndex];
                `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "Pilot as Infantry SelectedSpawn status" @ PlayerStartVolume @ PlayerStartVolume.PlayerStartList[0].bEnabled @ PlayerStartVolume.PlayerStartList.Length);

                // If the selected volume is valid then continue
                if ( PlayerStartVolume != none && PlayerStartVolume.PlayerStartList.Length > 0 && PlayerStartVolume.PlayerStartList[0].bEnabled )
                {
                    for ( i = 0; i < PlayerStartVolume.PlayerStartList.Length; i++ )
                    {
                        // Select a Random Spawn Point from the list and Rate it
                        P = PlayerStartVolume.PlayerStartList[rand(PlayerStartVolume.PlayerStartList.Length)];

                        if ( P != none && !P.bOutsidePlayableArea )
                        {
                            NewRating = RatePlayerStart(P, Team, Player);

                            // If the random Player Start can be spawned at, use it
                            if ( NewRating > 0.0 )
                            {
                                `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "found Pilot spawn" @ P @ NewRating @ PlayerStartVolume);

                                return P;
                            }
                        }
                    }
                }
            }
            else
            {
                // Get selected spawn volume (Bots choose randomly instead)
                if ( SelectedSpawnIndex == 0 && !Player.IsA('PlayerController'))
                {
                    PlayerStartVolume = GetRandomSpawnVolume(TeamInfo);
                    `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "Infantry SelectedSpawn status" @ PlayerStartVolume @ PlayerStartVolume.PlayerStartList[0].bEnabled @ PlayerStartVolume.PlayerStartList.Length);
                }
                else
                {
                    PlayerStartVolume = TeamInfo.AvailableSpawnLocations[SelectedSpawnIndex];
                    `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "Infantry SelectedSpawn status" @ PlayerStartVolume @ PlayerStartVolume.PlayerStartList[0].bEnabled @ PlayerStartVolume.PlayerStartList.Length);
                }

                // If the selected volume is valid then continue
                if ( PlayerStartVolume != none && PlayerStartVolume.PlayerStartList.Length > 0 && PlayerStartVolume.PlayerStartList[0].bEnabled )
                {
                    for ( i = 0; i < PlayerStartVolume.PlayerStartList.Length; i++ )
                    {
                        // Select a Random Spawn Point from the list and Rate it
                        P = PlayerStartVolume.PlayerStartList[rand(PlayerStartVolume.PlayerStartList.Length)];

                        if ( P != none && !P.bOutsidePlayableArea )
                        {
                            NewRating = RatePlayerStart(P, Team, Player);

                            `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "Infantry SelectedSpawn status - Checking" @ P @ P.bOutsidePlayableArea @ NewRating);
                            // If the random Player Start can be spawned at, use it
                            if ( NewRating > 0.0 )
                            {
                                `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "found infantry spawn" @ P @ NewRating @ PlayerStartVolume);
                                return P;
                            }
                        }
                    }
                }
            }
        }
    }

    // if we're not trying to Spawn on Squad Leader or MGer or there wasn't a good place to Spawn near one of them
    if ( ControllerFailedSpawnOnSL == None
        && Player != none
        && BestStart == none )
    {
        bWantsVehicleSpawn = (bTankCrew || (/*TransportVehicle == none &&*/ SelectedSpawnIndex == 125));        // bumped to 125 from 124

        foreach AllActors(class'ROVolumePlayerStartGroup', PlayerStartVolume)
        {
            if ( PlayerStartVolume.PlayerStartList.Length > 0 )
            `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "Checking PlayerStartVolume" @ PlayerStartVolume.PlayerStartList.Length @ PlayerStartVolume.PlayerStartList[0].bEnabled @ PlayerStartVolume.PlayerStartList[0].TeamIndex @ bTankCrew @ ROVolumePlayerStartGroupTankCrew(PlayerStartVolume) @ SelectedSpawnIndex);
            if ( PlayerStartVolume.PlayerStartList.Length <= 0 || !PlayerStartVolume.PlayerStartList[0].bEnabled || PlayerStartVolume.PlayerStartList[0].TeamIndex != Team ||
                 (bWantsVehicleSpawn && ROVolumePlayerStartGroupTankCrew(PlayerStartVolume) == none) ||
                 (!bWantsVehicleSpawn && ROVolumePlayerStartGroupTankCrew(PlayerStartVolume) != none) ||
                  (bPilot && ROVolumePlayerStartGroupPilot(PlayerStartVolume) == none) ||
                 (!bPilot && ROVolumePlayerStartGroupPilot(PlayerStartVolume) != none))
            {
                continue;
            }

            `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "Looping through all PlayerStarts" @ PlayerStartVolume);
            for ( i = 0; i < PlayerStartVolume.PlayerStartList.Length; i++ )
            {
                // Select a Random Spawn Point from the list and Rate it
                P = PlayerStartVolume.PlayerStartList[rand(PlayerStartVolume.PlayerStartList.Length)];

                if ( !P.bOutsidePlayableArea )
                {
                    NewRating = RatePlayerStart(P, Team, Player);

                    // If the random Player Start can be spawned at, use it
                    if ( NewRating > 0.0 )
                    {
                        `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "Found Player Start" @ P @ NewRating @ PlayerStartVolume);

                        if ( SelectedSpawnIndex == 125 )    // bumped to 125 from 124
                        {
                            SpawnPlayerInTransport(Player, ROPRI.SquadIndex, none, false, P.Location, P.Rotation);
                        }

                        return P;
                    }
                }
            }
        }
    }

    if (ControllerFailedSpawnOnSL == None
        && BestStart == none
        && Player == none )
    {
        // No playerstart found, so pick any NavigationPoint to keep player from failing to enter game
        foreach WorldInfo.AllNavigationPoints(class 'NavigationPoint', N)
        {
            `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "Defaulted to NavigationPoint");
            return N;
        }
    }

    `DRLogSpawning(Player.PlayerReplicationInfo.PlayerName @ "Every other test failed - returning" @ BestStart);

    if(ControllerFailedSpawnOnSL == None)
    {
        return BestStart;
    }
    else
    {
        return None;
    }
}

DefaultProperties
{
    `DRGICommonDP

    bDisableCharCustMenu=False

    SquadSpawnMethod[0]=ROSSM_SquadLeader
    SquadSpawnMethod[1]=ROSSM_SquadLeader
}
