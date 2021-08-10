// Some weird fucking shit going on here. Devs not sharing correct version
// of source code to not reveal "secrets" to hackers. Either that or they do some even
// weirder fucking shit in native for whatever reason.
// Anyhow, stupid workarounds can be found in this file.
class DRPlayerReplicationInfo extends ROPlayerReplicationInfo
    HideCategories(Navigation,Movement,Collision);

struct native DRCharacterConfig extends CharacterConfig
{
    var byte ClassIndex;
};

reliable server function ServerSetCustomCharConfigDR(DRCharacterConfig MyCharConfig)
{
    local ROMapInfo ROMI;
    local byte TeamIndex, ArmyIndex, bPilot;
    local ROPlayerController ROPC;

    TeamIndex = GetTeamNum();

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    if (ROMI != none)
    {
        if( TeamIndex == `AXIS_TEAM_INDEX )
            ArmyIndex = ROMI.NorthernForce;
        else
            ArmyIndex = ROMI.SouthernForce;
    }

    if (PawnHandlerClass == none)
    {
        PawnHandlerClass = class<ROGameInfo>(WorldInfo.GetGameClass()).default.PawnHandlerClass;
    }

    if (RoleInfo.bCanBeTankCrew)
    {
        bPilot = `BPILOT_TANKCREW;
    }
    else if (RoleInfo.bIsTeamLeader)
    {
        bPilot = `BPILOT_COMMANDER;
    }

    // Don't take the client's word for it that everything is legitimate. Check it here first before replicating to everyone else
    PawnHandlerClass.static.ValidateCharConfig(TeamIndex, ArmyIndex, bPilot, int(HonorLevel),
        MyCharConfig.TunicMesh, MyCharConfig.TunicMaterial, MyCharConfig.ShirtTexture, MyCharConfig.HeadMesh,
        MyCharConfig.HairMaterial, MyCharConfig.HeadgearMesh, MyCharConfig.HeadgearMaterial, MyCharConfig.FaceItemMesh,
        MyCharConfig.FacialHairMesh, MyCharConfig.TattooTex, self);
    SetCustomCharConfigDR(MyCharConfig);

    ROPC = ROPlayerController(Owner);

    // Set an appropriate voice pack for the player
    if( ROPC != none )
    {
        /*
        // Hardcoded for ARVN, until such time as we ever have any other factions that require alternate nationality pilots
        if( ArmyIndex == SFOR_ARVN && bPilot == 2 )
            bUsesAltVoicePacks = true;
        else
        */
            bUsesAltVoicePacks = false;

        if( TeamIndex == `AXIS_TEAM_INDEX )
        {
            ROPC.SetSuitableVoicePack(TeamIndex, ArmyIndex, 0);
        }
        else
        {
            ROPC.SetSuitableVoicePack(TeamIndex, ArmyIndex,
                PawnHandlerClass.static.GetSkinTone(TeamIndex, ArmyIndex, CurrentCharConfig.HeadMesh, bPilot));
        }
    }
}

function SetCustomCharConfigDR(DRCharacterConfig MyCharConfig)
{
    CurrentCharConfig.TunicMesh = MyCharConfig.TunicMesh;
    CurrentCharConfig.TunicMaterial = MyCharConfig.TunicMaterial;
    CurrentCharConfig.ShirtTexture = MyCharConfig.ShirtTexture;
    CurrentCharConfig.HeadMesh = MyCharConfig.HeadMesh;
    CurrentCharConfig.HairMaterial = MyCharConfig.HairMaterial;
    CurrentCharConfig.HeadgearMesh = MyCharConfig.HeadgearMesh;
    CurrentCharConfig.FaceItemMesh = MyCharConfig.FaceItemMesh;
    CurrentCharConfig.TattooTex = MyCharConfig.TattooTex;
    CurrentCharConfig.ClassIndex = MyCharConfig.ClassIndex;

    if (Role == ROLE_Authority && WorldInfo.NetMode != NM_Standalone)
    {
        PackCharacterConfig();
    }
}

simulated function ClientSetCustomCharConfig()
{
    local DRCharacterConfig TempCharConfig;
    local ROMapInfo ROMI;
    local byte TeamIndex, ArmyIndex, bPilot;

    TeamIndex = GetTeamNum();

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    if( ROMI != none )
    {
        if( TeamIndex == `AXIS_TEAM_INDEX )
            ArmyIndex = ROMI.NorthernForce;
        else
            ArmyIndex = ROMI.SouthernForce;
    }

    TempCharConfig.ClassIndex = ClassIndex;

    // Pull the appropriate pawn config for our team and nation.
    if ( RoleInfo != none)
    {
        if (RoleInfo.bCanBeTankCrew)
        {
            bPilot = `BPILOT_TANKCREW;
        }
        else if (RoleInfo.bIsTeamLeader)
        {
            bPilot = `BPILOT_COMMANDER;
        }

        PawnHandlerClass.static.GetCharConfig(TeamIndex, ArmyIndex, bPilot, ClassIndex, int(HonorLevel),
            TempCharConfig.TunicMesh, TempCharConfig.TunicMaterial, TempCharConfig.ShirtTexture,
            TempCharConfig.HeadMesh, TempCharConfig.HairMaterial, TempCharConfig.HeadgearMesh,
            TempCharConfig.HeadgearMaterial, TempCharConfig.FaceItemMesh, TempCharConfig.FacialHairMesh,
            TempCharConfig.TattooTex, self, bBot);
    }

    if( Role < ROLE_Authority )
        ServerSetCustomCharConfigDR(TempCharConfig);
    else
        SetCustomCharConfigDR(TempCharConfig);

    // If this is the owning client, force this to true, since we don't need to wait for replication to ourself.
    if (bNetOwner)
    {
        bReplicatedInitialCharConfig = true;
    }
}

DefaultProperties
{
    PawnHandlerClass=class'DRPawnHandler'
}
