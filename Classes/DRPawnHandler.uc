class DRPawnHandler extends ROPawnHandler
    config(Game_DesertRats_Char);

var config array<CharacterConfig> DAKConfig;
var config array<CharacterConfig> UKConfig;

var array<TunicInfo>        DAK_Tunics, DAK_TankCrew_Tunics, DAK_Commander_Tunics;
var array<HeadgearInfo>     DAK_Headgear, DAK_TankCrew_Headgear, DAK_Commander_Headgear;
var array<HeadgearMICInfo>  DAK_HeadgearMICs;
var array<FieldgearMeshes>  DAK_FieldgearByRole;
var TunicSVInfo         DAK_TunicSV, DAK_TankCrewSV;
var array<PlayerHeadInfo>   DAK_Heads;
var array<FaceItemInfo>     DAK_FaceItems;
var array<FacialHairInfo>   DAK_FacialHair;

var array<TunicInfo>        UK_Tunics, UK_TankCrew_Tunics, UK_Commander_Tunics;
var array<HeadgearInfo>     UK_Headgear, UK_TankCrew_Headgear, UK_Commander_Headgear;
var array<HeadgearMICInfo>  UK_HeadgearMICs;
var array<FieldgearMeshes>  UK_FieldgearByRole;
var TunicSVInfo         UK_TunicSV, UK_TankCrewSV;
var array<PlayerHeadInfo>   UK_Heads;
var array<FaceItemInfo>     UK_FaceItems;
var array<FacialHairInfo>   UK_FacialHair;


static function ValidateCharConfig(int Team, int ArmyIndex, byte bPilot, int HonorLevel,
    out byte TunicID, out byte TunicMaterialID, out byte ShirtID, out byte HeadID,
    out byte HairID, out byte HeadgearID, out byte HeadgearMatID, out byte FaceItemID,
    out byte FacialHairID, out byte TattooID, ROPlayerReplicationInfo ROPRI, optional bool bPreviewOnly)
{
    local array<TunicInfo>      TempTunics;
    local array<HeadgearInfo>   TempHeadgear;
    local array<FaceItemInfo>   TempFaceItems;
    local array<FacialHairInfo> TempFacialHair;
    local array<ShirtInfo>      TempShirts;
    local array<TattooInfo>     TempTattoos;
    local array<PlayerHeadInfo> TempHeads;
    local array<HairMICInfo>    TempHair;
    local int i, NationIndex, NationDLCOffset;
    local bool bHasNationUnlock;
    local array<int> AvailableItemIDs;

    TempHair = default.HairMICs;

    TempTunics = GetTunicArray(Team, ArmyIndex, bPilot);
    TempHeadgear = GetHeadgearArray(Team, ArmyIndex, bPilot);
    TempFaceItems = GetFaceItemArray(Team, ArmyIndex, bPilot);
    TempFacialHair = GetFacialHairArray(Team, ArmyIndex);
    TempShirts = GetShirtArray(Team, ArmyIndex, bPilot);
    TempTattoos = GetTattooArray(Team, ArmyIndex, bPilot);
    TempHeads = GetHeadArray(Team, ArmyIndex, bPilot);

    if( ROPRI == none )
    {
        `warn("Attempted to validate a character config without a valid ROPRI!");
        ScriptTrace();
        return;
    }

    if( ROPRI.bIsDev )
        HonorLevel = 255;
    else if( ROPRI.bBot )
        HonorLevel = 99; // Stops bots from getting dev only or paid DLC items

    NationIndex = class'DRMapInfo'.static.GetNationForArmy(ArmyIndex);
    NationDLCOffset = DLC_NVietComplete - 1;
    bHasNationUnlock = (1 << (NationDLCOffset + NationIndex) & ROPRI.OwnedDLCPacks) != 0;

    if( TunicID < 0 || TunicID > TempTunics.length - 1 || (!bPreviewOnly && TempTunics[TunicID].RequiredLevel > HonorLevel &&
        ((1 << (TempTunics[TunicID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempTunics[TunicID].RequiredLevel == 255))) )
    {
        AvailableItemIDs.length = 0;

        for( i=0; i<TempTunics.length; i++ )
        {
            if( TempTunics[i].RequiredLevel <= HonorLevel || (TempTunics[i].DLCPackID != DLC_None && ((1 << (TempTunics[i].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) != 0) )
                AvailableItemIDs[AvailableItemIDs.Length] = i;
        }

        if( AvailableItemIDs.Length <= 0 )
            TunicID = 0;
        else
            TunicID = AvailableItemIDs[Rand(AvailableItemIDs.length)];
    }

    if( TunicMaterialID < 0 || TunicMaterialID > TempTunics[TunicID].BodyMICs.length - 1 ||
        (!bPreviewOnly && TempTunics[TunicID].BodyMICs[TunicMaterialID].RequiredLevel > HonorLevel &&
        ((1 << (TempTunics[TunicID].BodyMICs[TunicMaterialID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempTunics[TunicID].BodyMICs[TunicMaterialID].RequiredLevel == 255))) )
    {
        AvailableItemIDs.length = 0;

        for( i=0; i<TempTunics[TunicID].BodyMICs.length; i++ )
        {
            if( TempTunics[TunicID].BodyMICs[i].RequiredLevel <= HonorLevel || (TempTunics[TunicID].BodyMICs[i].DLCPackID != DLC_None && ((1 << (TempTunics[TunicID].BodyMICs[i].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) != 0) )
                AvailableItemIDs[AvailableItemIDs.Length] = i;
        }

        if( AvailableItemIDs.Length <= 0 )
            TunicMaterialID = 0;
        else
            TunicMaterialID = AvailableItemIDs[Rand(AvailableItemIDs.length)];
    }

    if( ShirtID < 0 || ShirtID > TempShirts.length - 1 || (!bPreviewOnly && TempShirts[ShirtID].RequiredLevel > HonorLevel &&
        ((1 << (TempShirts[ShirtID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempShirts[ShirtID].RequiredLevel == 255))) )
    {
        AvailableItemIDs.length = 0;

        for( i=0; i<TempShirts.length; i++ )
        {
            if( TempShirts[i].RequiredLevel <= HonorLevel || (TempShirts[i].DLCPackID != DLC_None && ((1 << (TempShirts[i].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) != 0) )
                AvailableItemIDs[AvailableItemIDs.Length] = i;
        }

        if( AvailableItemIDs.Length <= 0 )
            ShirtID = 0;
        else
            ShirtID = AvailableItemIDs[Rand(AvailableItemIDs.length)];
    }

    if( HeadID < 0 || HeadID > TempHeads.length - 1 )
    {
        HeadID = Rand(TempHeads.length);
    }

    if( HairID < 0 || HairID > TempHair.length - 1 )
    {
        AvailableItemIDs.length = 0;

        for( i=0; i<TempHair.length; i++ )
        {
            if( ((2 ** i) & TempHeads[HeadID].HairColours) > 0 )
                AvailableItemIDs[AvailableItemIDs.Length] = i;
        }

        if( AvailableItemIDs.Length <= 0 )
            HairID = 0;
        else
            HairID = AvailableItemIDs[Rand(AvailableItemIDs.length)];
    }
    else if( HairID > 0 && (((2 ** HairID) & TempHeads[HeadID].HairColours) == 0) )
    {
        HairID = 0;
    }

    if( HeadgearID < 0 || HeadgearID > TempHeadgear.length - 1 || (!bPreviewOnly && TempHeadgear[HeadgearID].RequiredLevel > HonorLevel &&
        ((1 << (TempHeadgear[HeadgearID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempHeadgear[HeadgearID].RequiredLevel == 255))) )
    {
        AvailableItemIDs.length = 0;

        for( i=0; i<TempHeadgear.length; i++ )
        {
            if( TempHeadgear[i].RequiredLevel <= HonorLevel || (TempHeadgear[i].DLCPackID != DLC_None && ((1 << (TempHeadgear[i].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) != 0) )
                AvailableItemIDs[AvailableItemIDs.Length] = i;
        }

        if( AvailableItemIDs.Length <= 0 )
            HeadgearID = 0;
        else
            HeadgearID = AvailableItemIDs[Rand(AvailableItemIDs.length)];
    }

    if( HeadgearMatID < 0 || HeadgearMatID > TempHeadgear[HeadgearID].HeadgearMICs.length - 1 )
    {
        if( TempHeadgear[HeadgearID].HeadgearMICs.length <= 0 )
            HeadgearMatID = 0;
        else
            HeadgearMatID = Rand(TempHeadgear[HeadgearID].HeadgearMICs.length);
    }

    if( FaceItemID < 0 || FaceItemID > TempFaceItems.length - 1 || (!bPreviewOnly && TempFaceItems[FaceItemID].RequiredLevel > HonorLevel &&
        ((1 << (TempFaceItems[FaceItemID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempFaceItems[FaceItemID].RequiredLevel == 255))) )
    {
        AvailableItemIDs.length = 0;

        for( i=0; i<TempFaceItems.length; i++ )
        {
            if( TempFaceItems[i].RequiredLevel <= HonorLevel || (TempFaceItems[i].DLCPackID != DLC_None && ((1 << (TempFaceItems[i].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) != 0) )
                AvailableItemIDs[AvailableItemIDs.Length] = i;
        }

        if( AvailableItemIDs.Length <= 0 )
            FaceItemID = 0;
        else
            FaceItemID = AvailableItemIDs[Rand(AvailableItemIDs.length)];
    }

    if( FacialHairID < 0 || FacialHairID > TempFacialHair.length - 1 || (!bPreviewOnly && TempFacialHair[FacialHairID].RequiredLevel > HonorLevel &&
        ((1 << (TempFacialHair[FacialHairID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempFacialHair[FacialHairID].RequiredLevel == 255))) )
    {
        AvailableItemIDs.length = 0;

        for( i=0; i<TempFacialHair.length; i++ )
        {
            if( TempFacialHair[i].RequiredLevel <= HonorLevel || (TempFacialHair[i].DLCPackID != DLC_None && ((1 << (TempFacialHair[i].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) != 0) )
                AvailableItemIDs[AvailableItemIDs.Length] = i;
        }

        if( AvailableItemIDs.Length <= 0 )
            FacialHairID = 0;
        else
            FacialHairID = AvailableItemIDs[Rand(AvailableItemIDs.length)];
    }

    if( TattooID < 0 || TattooID > TempTattoos.length - 1 || (!bPreviewOnly && TempTattoos[TattooID].RequiredLevel > HonorLevel &&
        ((1 << (TempTattoos[TattooID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempTattoos[TattooID].RequiredLevel == 255))) )
    {
        AvailableItemIDs.length = 0;

        for( i=0; i<TempTattoos.length; i++ )
        {
            if( TempTattoos[i].RequiredLevel <= HonorLevel || (TempTattoos[i].DLCPackID != DLC_None && ((1 << (TempTattoos[i].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) != 0) )
                AvailableItemIDs[AvailableItemIDs.Length] = i;
        }

        if( AvailableItemIDs.Length <= 0 )
            TattooID = 0;
        else
            TattooID = AvailableItemIDs[Rand(AvailableItemIDs.length)];
    }
}

static function bool IsCharConfigValid(int Team, int ArmyIndex, byte bPilot, int HonorLevel,
    byte TunicID, byte TunicMaterialID, byte ShirtID, byte HeadID, byte HairID,
    byte HeadgearID, byte HeadgearMatID, byte FaceItemID, byte FacialHairID, byte TattooID,
    ROPlayerReplicationInfo ROPRI)
{
    local array<TunicInfo>      TempTunics;
    local array<HeadgearInfo>   TempHeadgear;
    local array<FaceItemInfo>   TempFaceItems;
    local array<FacialHairInfo> TempFacialHair;
    local array<ShirtInfo>      TempShirts;
    local array<TattooInfo>     TempTattoos;
    local array<PlayerHeadInfo> TempHeads;
    //local array<HairMICInfo>  TempHair;
    local int NationIndex, NationDLCOffset;
    local bool bHasNationUnlock;

    //TempHair = default.HairMICs;

    TempTunics = GetTunicArray(Team, ArmyIndex, bPilot);
    TempHeadgear = GetHeadgearArray(Team, ArmyIndex, bPilot);
    TempFaceItems = GetFaceItemArray(Team, ArmyIndex, bPilot);
    TempFacialHair = GetFacialHairArray(Team, ArmyIndex);
    TempShirts = GetShirtArray(Team, ArmyIndex, bPilot);
    TempTattoos = GetTattooArray(Team, ArmyIndex, bPilot);
    TempHeads = GetHeadArray(Team, ArmyIndex);

    if( ROPRI != none )
    {
        if( ROPRI.bIsDev )
            HonorLevel = 255;
        else if( ROPRI.bBot )
            HonorLevel = 99; // Stops bots from getting dev only or paid DLC items
    }

    NationIndex = class'DRMapInfo'.static.GetNationForArmy(ArmyIndex);
    NationDLCOffset = DLC_NVietComplete - 1;
    bHasNationUnlock = (1 << (NationDLCOffset + NationIndex) & ROPRI.OwnedDLCPacks) != 0;

    if( TunicID != 255 && (TunicID < 0 || TunicID > TempTunics.length - 1 || (TempTunics[TunicID].RequiredLevel > HonorLevel &&
        ((1 << (TempTunics[TunicID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempTunics[TunicID].RequiredLevel == 255)))) )
    {
        return false;
    }

    // Hack to prevent the next check returning false if "random" tunic is selected
    if( TunicID == 255 )
        TunicID = 0;

    if( TunicMaterialID != 255 && (TunicMaterialID < 0 || TunicMaterialID > TempTunics[TunicID].BodyMICs.length - 1 ||
        (TempTunics[TunicID].BodyMICs[TunicMaterialID].RequiredLevel > HonorLevel &&
        ((1 << (TempTunics[TunicID].BodyMICs[TunicMaterialID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempTunics[TunicID].BodyMICs[TunicMaterialID].RequiredLevel == 255)))) )
    {
        return false;
    }

    if( ShirtID != 255 && (ShirtID < 0 || ShirtID > TempShirts.length - 1 || (TempShirts[ShirtID].RequiredLevel > HonorLevel &&
        ((1 << (TempShirts[ShirtID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempShirts[ShirtID].RequiredLevel == 255)))) )
    {
        return false;
    }

    if( HeadID != 255 && (HeadID < 0 || HeadID > TempHeads.length - 1) )
    {
        return false;
    }

    /*if( HairID != 255 && (HairID < 0 || HairID > TempHair.length - 1 || (HairID > 0 && (((2D) & TempHeads[HeadID].HairColours) == 0))) )
    {
        return false;
    }*/

    if( HeadgearID != 255 && (HeadgearID < 0 || HeadgearID > TempHeadgear.length - 1 ||
        (TempHeadgear[HeadgearID].RequiredLevel > HonorLevel && ((1 << (TempHeadgear[HeadgearID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempHeadgear[HeadgearID].RequiredLevel == 255)))) )
    {
        return false;
    }

    if( FaceItemID != 255 && (FaceItemID < 0 || FaceItemID > TempFaceItems.length - 1 ||
        (TempFaceItems[FaceItemID].RequiredLevel > HonorLevel && ((1 << (TempFaceItems[FaceItemID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempFaceItems[FaceItemID].RequiredLevel == 255)))) )
    {
        return false;
    }

    if( FacialHairID != 255 && (FacialHairID < 0 || FacialHairID > TempFacialHair.length - 1 ||
        (TempFacialHair[FacialHairID].RequiredLevel > HonorLevel && ((1 << (TempFacialHair[FacialHairID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempFacialHair[FacialHairID].RequiredLevel == 255)))) )
    {
        return false;
    }

    if( TattooID != 255 && (TattooID < 0 || TattooID > TempTattoos.length - 1 ||
        (TempTattoos[TattooID].RequiredLevel > HonorLevel && ((1 << (TempTattoos[TattooID].DLCPackID - 1)) & ROPRI.OwnedDLCPacks) == 0 &&
        (!bHasNationUnlock || (bHasNationUnlock && TempTattoos[TattooID].RequiredLevel == 255)))) )
    {
        return false;
    }

    return true;
}

static function SkeletalMesh GetTunicMeshSV(int Team, int ArmyIndex, int ClassIndex, byte bPilot,
    bool bFlamer, out MaterialInstanceConstant TunicMatSV)
{
    if (Team == `AXIS_TEAM_INDEX)
    {
        if (bPilot > 0)
        {
            TunicMatSV = default.DAK_TankCrewSV.BodyMICTemplate;
            return default.DAK_TankCrewSV.TunicMesh_SV;
        }

        TunicMatSV = default.DAK_TunicSV.BodyMICTemplate;
        return default.DAK_TunicSV.TunicMesh_SV;
    }
    else
    {
        if (bPilot > 0)
        {
            TunicMatSV = default.UK_TankCrewSV.BodyMICTemplate;
            return default.UK_TankCrewSV.TunicMesh_SV;
        }

        TunicMatSV = default.UK_TunicSV.BodyMICTemplate;
        return default.UK_TunicSV.TunicMesh_SV;
    }
}

static function SkeletalMesh GetTunicMeshes(int Team, int ArmyIndex, byte bPilot, byte TunicMeshID, optional out byte bNoHeadgear)
{
    local array<TunicInfo> Tunics;

    Tunics = GetTunicArray(Team, ArmyIndex, bPilot);
    bNoHeadgear = byte(Tunics[TunicMeshID].bCoversHead);

    `log("GetTunicMeshes(): Team=" $ Team $ ", ArmyIndex="
        $ ArmyIndex $ ", bPilot=" $ bPilot $ ", TunicMeshID="
        $ TunicMeshID $ ", bNoHeadgear=" $ bNoHeadgear $ ", Tunics.Length=" $ Tunics.Length,, 'DRDEV');

    return Tunics[TunicMeshID].TunicMesh;
}

static function array<TunicInfo> GetTunicArray(byte TeamIndex, byte ArmyIndex, optional byte bPilot)
{
    if (TeamIndex == `AXIS_TEAM_INDEX)
    {
        if (bPilot == `BPILOT_TANKCREW)
        {
            return default.DAK_TankCrew_Tunics;
        }
        else if (bPilot == `BPILOT_COMMANDER)
        {
            return default.DAK_Commander_Tunics;
        }

        return default.DAK_Tunics;
    }
    else
    {
        if (bPilot == `BPILOT_TANKCREW)
        {
            return default.UK_TankCrew_Tunics;
        }
        else if (bPilot == `BPILOT_COMMANDER)
        {
            return default.UK_Commander_Tunics;
        }

        return default.UK_Tunics;
    }
}

static function SkeletalMesh GetFieldgearMesh(int Team, int ArmyIndex, int TunicMeshID, int ClassIndex, byte BodyMIC)
{
    if( Team == `AXIS_TEAM_INDEX )
    {
			if (TunicMeshID == 12)
		{
			return default.DAK_FieldgearByRole[ClassIndex].FieldgearByTunicType[1];
		}
        return default.DAK_FieldgearByRole[ClassIndex].FieldgearByTunicType[0];
    }
    else
    {

        return default.UK_FieldgearByRole[ClassIndex].FieldgearByTunicType[0];
    }
}



static function array<ShirtInfo> GetShirtArray(byte TeamIndex, byte ArmyIndex, optional byte bPilot)
{
    return default.USPilotShirts;
}

static function array<PlayerHeadInfo> GetHeadArray(byte TeamIndex, byte ArmyIndex, optional byte bPilot)
{
    if (TeamIndex == `AXIS_TEAM_INDEX)
    {
        return default.DAK_Heads;
    }
    else
    {
        return default.UK_Heads;
    }
}

static function array<HeadgearInfo> GetHeadgearArray(byte TeamIndex, byte ArmyIndex, optional byte bPilot)
{
    if (TeamIndex == `AXIS_TEAM_INDEX)
    {
        if (bPilot == `BPILOT_TANKCREW)
        {
            return default.DAK_TankCrew_Headgear;
        }
        else if (bPilot == `BPILOT_COMMANDER)
        {
            return default.DAK_Commander_Headgear;
        }

        return default.DAK_Headgear;
    }
    else
    {
        if (bPilot == `BPILOT_TANKCREW)
        {
            return default.UK_TankCrew_Headgear;
        }
        else if (bPilot == `BPILOT_COMMANDER)
        {
            return default.UK_Commander_Headgear;
        }

        return default.UK_Headgear;
    }
}

static function array<HeadgearMICInfo> GetHeadgearMICArray(byte TeamIndex, byte ArmyIndex, optional byte bPilot)
{
    if (TeamIndex == `AXIS_TEAM_INDEX)
    {
        return default.DAK_HeadgearMICs;
    }
    else
    {
        return default.UK_HeadgearMICs;
    }
}

static function array<FaceItemInfo> GetFaceItemArray(byte TeamIndex, byte ArmyIndex, optional byte bPilot)
{
    local array<FaceItemInfo> TankerItems;

    if (TeamIndex == `AXIS_TEAM_INDEX)
    {
        return default.DAK_FaceItems;
    }
    else
    {
        return default.UK_FaceItems;
    }
}

static function array<FacialHairInfo> GetFacialHairArray(byte TeamIndex, byte ArmyIndex)
{
    if (TeamIndex == `AXIS_TEAM_INDEX)
    {
        return default.DAK_FacialHair;
    }
    else
    {
        return default.UK_FacialHair;
    }
}

static function array<TattooInfo> GetTattooArray(byte TeamIndex, byte ArmyIndex, optional byte bPilot)
{
    return default.USPilotTattoos;
}

static function SkeletalMesh GetFaceItemMesh(int Team, int ArmyIndex, byte bPilot, byte HeadgearID,
    out byte FaceItemID, out name SocketName, out byte bHideFacialHair)
{
    local array<FaceItemInfo> FaceItems;

    FaceItems = GetFaceItemArray(Team, ArmyIndex, bPilot);
    SocketName = FaceItems[FaceItemID].FaceItemSocket;
    bHideFacialHair = 0;

    return FaceItems[FaceItemID].FaceItemMesh;
}

static function SkeletalMesh GetGoreMeshes(int TeamNum, int ArmyIndex, byte TunicID, byte SkinToneID,
    out MaterialInstanceConstant GoreMIC, out class<ROGib> LeftHandGibClass, out class<ROGib> RightHandGibClass,
    out class<ROGib> LeftLegGibClass, out class<ROGib> RightLegGibClass)
{
    LeftHandGibClass=class'ROGib_HumanArm_Gore_BareArm';
    RightHandGibClass=class'ROGib_HumanArm_Gore_BareArm';
    LeftLegGibClass=class'ROGib_HumanLeg_Gore_BareLeg';
    RightLegGibClass=class'ROGib_HumanLeg_Gore_BareLeg';
    GoreMIC = default.GoreSkinToneMICs[SkinToneID];

    return SkeletalMesh'CHR_VN_Gore.Mesh.Gore_Main_Mesh';
}


DefaultProperties
{
    //DAK uniforms
    //Tunics

    //Long tunic
    DAK_Tunics(0)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
                //RequiredLevel=5
            )
        ),
        SkinToShow=STS_HeadHands,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Long'
    )}

    //Long Tunic with Shirt
    DAK_Tunics(1)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
                //RequiredLevel=15
            )
        ),
        SkinToShow=STS_HeadHands,
        //RequiredLevel=10,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Long_Shirt'
    )}

    //Shorts with long boots
    DAK_Tunics(2)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Boots',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
                //RequiredLevel=25
            )
        ),
        SkinToShow=STS_HeadForearms,
       // RequiredLevel=20,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Boots'
    )}

    //Shorts with long boots and shirt
    DAK_Tunics(3)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Boots_Shirt',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
                //RequiredLevel=35
            )
        ),
        SkinToShow=STS_HeadForearms,
        //RequiredLevel=30,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Boots_Shirt'
    )}

    //Shorts
    DAK_Tunics(4)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Shorts',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
                //RequiredLevel=45
            )
        ),
        SkinToShow=STS_HeadForearms,
      //  RequiredLevel=40,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Shorts'
    )}

    //Shorts and shirt
    DAK_Tunics(5)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Shorts_Shirt',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
               // RequiredLevel=50
            )
        ),
        SkinToShow=STS_HeadForearms,
       // RequiredLevel=45,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Shorts_Shirt'
    )}

    //Long tunic with iron cross
    DAK_Tunics(6)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Cross',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
                RequiredLevel=65
            )
        ),
        SkinToShow=STS_HeadHands,
        RequiredLevel=60,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Long_Cross'
    )}

    //Long tunic with iron cross and shirt
    DAK_Tunics(7)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt_Cross',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
                //RequiredLevel=70
            )
        ),
        SkinToShow=STS_HeadHands,
        //RequiredLevel=65,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Long_Shirt_Cross'
    )}

    //Shorts with long boots and iron cross
    DAK_Tunics(8)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Boots_Cross',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
               // RequiredLevel=75
            )
        ),
        SkinToShow=STS_HeadForearms,
       // RequiredLevel=70,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Boots_Cross'
    )}

    //Shorts with long boots, iron cross and shirt
    DAK_Tunics(9)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Boots_Shirt_Cross',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
               // RequiredLevel=80
            )
        ),
        SkinToShow=STS_HeadForearms,
       // RequiredLevel=75,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Boots_Shirt_Cross'
    )}

    //Shorts with iron cross
    DAK_Tunics(10)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Shorts_Cross',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
              //  RequiredLevel=85
            )
        ),
        SkinToShow=STS_HeadForearms,
      //  RequiredLevel=80,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Shorts_Cross'
    )}

    //Shorts with iron cross and shirt
    DAK_Tunics(11)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Shorts_Shirt_Cross',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
               // RequiredLevel=90
            )
        ),
        SkinToShow=STS_HeadForearms,
      //  RequiredLevel=85,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Shorts_Shirt_Cross'
    )}


    //DAK COMMANDER TUNICS

    //Long tunic
    DAK_Commander_Tunics(0)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
               // RequiredLevel=5
            )
        ),
        SkinToShow=STS_HeadHands,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Long'
    )}

    //Long Tunic with Shirt
    DAK_Commander_Tunics(1)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
            //   RequiredLevel=15
            )
        ),
        SkinToShow=STS_HeadHands,
      //  RequiredLevel=10,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Long_Shirt'
    )}

    //Shorts with long boots
    DAK_Commander_Tunics(2)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Boots',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
             //   RequiredLevel=25
            )
        ),
        SkinToShow=STS_HeadForearms,
      //  RequiredLevel=20,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Boots'
    )}

    //Shorts with long boots and shirt
    DAK_Commander_Tunics(3)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Boots_Shirt',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
               // RequiredLevel=35
            )
        ),
        SkinToShow=STS_HeadForearms,
       // RequiredLevel=30,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Boots_Shirt'
    )}

    //Shorts
    DAK_Commander_Tunics(4)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Shorts',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
               // RequiredLevel=45
            )
        ),
        SkinToShow=STS_HeadForearms,
       // RequiredLevel=40,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Shorts'
    )}

    //Shorts and shirt
    DAK_Commander_Tunics(5)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Shorts_Shirt',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
               // RequiredLevel=50
            )
        ),
        SkinToShow=STS_HeadForearms,
       // RequiredLevel=45,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Shorts_Shirt'
    )}

    //Long tunic with iron cross
    DAK_Commander_Tunics(6)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Cross',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
               // RequiredLevel=65
            )
        ),
        SkinToShow=STS_HeadHands,
       // RequiredLevel=60,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Long_Cross'
    )}

    //Long tunic with iron cross and shirt
    DAK_Commander_Tunics(7)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Long_Shirt_Cross',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
               // RequiredLevel=70
            )
        ),
        SkinToShow=STS_HeadHands,
      //  RequiredLevel=65,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Long_Shirt_Cross'
    )}

    //Shorts with long boots and iron cross
    DAK_Commander_Tunics(8)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Boots_Cross',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
                //RequiredLevel=75
            )
        ),
        SkinToShow=STS_HeadForearms,
        //RequiredLevel=70,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Boots_Cross'
    )}

    //Shorts with long boots, iron cross and shirt
    DAK_Commander_Tunics(9)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Boots_Shirt_Cross',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
                //RequiredLevel=80
            )
        ),
        SkinToShow=STS_HeadForearms,
        //RequiredLevel=75,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Boots_Shirt_Cross'
    )}

    //Shorts with iron cross
    DAK_Commander_Tunics(10)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Shorts_Cross',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
                //RequiredLevel=85
            )
        ),
        SkinToShow=STS_HeadForearms,
        //RequiredLevel=80,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Shorts_Cross'
    )}

    //Shorts with iron cross and shirt
    DAK_Commander_Tunics(11)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_Shorts_Shirt_Cross',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Olive_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Olive_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Olive'
            ),
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tan_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_Tan_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_DAK_Tunic_Tan',
                //RequiredLevel=90
            )
        ),
        SkinToShow=STS_HeadForearms,
        //RequiredLevel=85,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Shorts_Shirt_Cross'
    )}

    //Leather overcoat
    DAK_Commander_Tunics(12)={(
        TunicMesh=SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Tunic_TL',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.DAK_Hands_GreatCoat',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Tunic_TL',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.DAK_Tunic_GreatCoat_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_TL'
            )
        ),
        SkinToShow=STS_HeadHands,
        //RequiredLevel=85,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_TL'
    )}


    DAK_TunicSV=(TunicMesh_SV=SkeletalMesh'CHR_VN_US_Army.Mesh_Low.US_Tunic_Low_Mesh',BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_USMC_Tunic_Long_INST')

    // Fieldgear by role first and tunic mesh type second (for tunic types, 0 = Pants and Top, 1 = Pants Only)
    DAK_FieldgearByRole(`DRCI_RIFLEMAN)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_DAK.Gear.DAK_Gear_Rifleman'))
    DAK_FieldgearByRole(`DRCI_ASSAULT)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_DAK.Gear.DAK_Gear_Assault'))
    DAK_FieldgearByRole(`DRCI_MACHINEGUNNER)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_DAK.Gear.DAK_Gear_MG'))
    DAK_FieldgearByRole(`DRCI_SNIPER)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_DAK.Gear.DAK_Gear_Sniper'))
    DAK_FieldgearByRole(`DRCI_SAPPER)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_DAK.Gear.DAK_Gear_Pioneer'))
    DAK_FieldgearByRole(`DRCI_ANTITANK)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_DAK.Gear.DAK_Gear_Sniper'))
    DAK_FieldgearByRole(`DRCI_RADIOMAN)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_DAK.Gear.DAK_Gear_Radioman'))
    DAK_FieldgearByRole(`DRCI_COMMANDER)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_DAK.Gear.DAK_Gear_Commander',SkeletalMesh'DR_CHR_DAK.Gear.DAK_Gear_Commander_Coat'))
    DAK_FieldgearByRole(`DRCI_TANK_CREW)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Gear_Crew'))
    DAK_FieldgearByRole(`DRCI_TANK_COMMANDER)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Gear_Crew'))


    DAK_Headgear(0)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40'),HeadgearMICs=(0,1,2,3,4,5,6,7),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40')
    DAK_Headgear(1)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_Cap_Overseas'),HeadgearMICs=(8,9),HeadgearSocket=helmet,bIsHelmet=0,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_Cap_Overseas',RequiredLevel=0)
    DAK_Headgear(2)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_Cap'),HeadgearMICs=(8,9),HeadgearSocket=helmet,bIsHelmet=0,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_Cap',RequiredLevel=0)
    DAK_Headgear(3)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Paper'),HeadgearMICs=(11),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Paper',RequiredLevel=0)
    DAK_Headgear(4)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Camo_2'),HeadgearMICs=(12),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_2',RequiredLevel=0)
    DAK_Headgear(5)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_G_Up'),HeadgearMICs=(0,1,2,3,4,5,6,7),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_G_Up',RequiredLevel=0)
    DAK_Headgear(6)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Paper_G_UP'),HeadgearMICs=(11),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Paper_G_UP',RequiredLevel=0)
    DAK_Headgear(7)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Camo_2_G_UP'),HeadgearMICs=(12),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_2_G_UP',RequiredLevel=0)
    DAK_Headgear(8)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Camo_1'),HeadgearMICs=(13,14),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_1',RequiredLevel=0)
    DAK_Headgear(9)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_G_Face'),HeadgearMICs=(0,1,2,3,4,5,6,7),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_G_Face',RequiredLevel=0)
    DAK_Headgear(10)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Paper_G_Face'),HeadgearMICs=(11),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Paper_G_Face',RequiredLevel=0)
    DAK_Headgear(11)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Camo_2_G_Face'),HeadgearMICs=(12),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_2_G_Face',RequiredLevel=0)
    DAK_Headgear(12)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Camo_1_G_UP'),HeadgearMICs=(13,14),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_1_G_face',RequiredLevel=0)
    DAK_Headgear(13)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Camo_1_G_face'),HeadgearMICs=(13,14),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_1_G_face',RequiredLevel=0)

    DAK_Commander_Headgear(0)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40'),HeadgearMICs=(0,1,2,3,4,5,6,7),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40')
    DAK_Commander_Headgear(1)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_Cap_Overseas'),HeadgearMICs=(8,9),HeadgearSocket=helmet,bIsHelmet=0,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_Cap_Overseas',RequiredLevel=0)
    DAK_Commander_Headgear(2)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_Cap'),HeadgearMICs=(8,9),HeadgearSocket=helmet,bIsHelmet=0,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_Cap',RequiredLevel=0)
    DAK_Commander_Headgear(3)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Paper'),HeadgearMICs=(11),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Paper',RequiredLevel=0)
    DAK_Commander_Headgear(4)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Camo_2'),HeadgearMICs=(12),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_2',RequiredLevel=0)
    DAK_Commander_Headgear(5)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_G_Up'),HeadgearMICs=(0,1,2,3,4,5,6,7),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_G_Up',RequiredLevel=0)
    DAK_Commander_Headgear(6)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Paper_G_UP'),HeadgearMICs=(11),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Paper_G_UP',RequiredLevel=0)
    DAK_Commander_Headgear(7)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Camo_2_G_UP'),HeadgearMICs=(12),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_2_G_UP',RequiredLevel=0)
    DAK_Commander_Headgear(8)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Camo_1'),HeadgearMICs=(13,14),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_1',RequiredLevel=0)
    DAK_Commander_Headgear(9)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_G_Face'),HeadgearMICs=(0,1,2,3,4,5,6,7),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_G_Face',RequiredLevel=0)
    DAK_Commander_Headgear(10)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Paper_G_Face'),HeadgearMICs=(11),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Paper_G_Face',RequiredLevel=0)
    DAK_Commander_Headgear(11)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Camo_2_G_Face'),HeadgearMICs=(12),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_2_G_Face',RequiredLevel=0)
    DAK_Commander_Headgear(12)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Camo_1_G_UP'),HeadgearMICs=(13,14),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_1_G_face',RequiredLevel=0)
    DAK_Commander_Headgear(13)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_M40_Camo_1_G_face'),HeadgearMICs=(13,14),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_1_G_face',RequiredLevel=0)
    DAK_Commander_Headgear(14)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_DAK.Mesh.DAK_Headgear_Officer'),HeadgearMICs=(10),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_Officer',RequiredLevel=0)



    DAK_HeadgearMICS(0)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_Heer_Headgear_Helmet',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet')
    DAK_HeadgearMICS(1)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_Heer_Headgear_Helmet_Tan',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet_Tan')
    DAK_HeadgearMICs(2)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_Heer_Headgear_Helmet_Insignia',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet_Insignia')
    DAK_HeadgearMICs(3)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_Heer_Headgear_Helmet_Insignia_Tan',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet_Insignia_Tan')
    DAK_HeadgearMICs(4)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_Heer_Headgear_Helmet_Dirt_Light',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet_Dirt_Light')
    DAK_HeadgearMICs(5)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_Heer_Headgear_Helmet_Mud_Light',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet_Mud_Light')
    DAK_HeadgearMICs(6)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_Heer_Headgear_Helmet_Dirt_Heavy',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet_Dirt_Heavy')
    DAK_HeadgearMICs(7)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_Heer_Headgear_Helmet_Mud_Heavy',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet_Mud_Heavy')
    DAK_HeadgearMICs(8)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Cap_Olive_INST',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Headgear_Cap_Olive')
    DAK_HeadgearMICs(9)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Cap_Tan_INST',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Headgear_Cap_Tan')
    DAK_HeadgearMICs(10)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_DAK_Headgear_Officer_INST')
    DAK_HeadgearMICs(11)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_Heer_Headgear_Helmet_Cover_Paper')
    DAK_HeadgearMICs(12)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_Heer_Headgear_Helmet_Winter_Cloth')
    DAK_HeadgearMICs(13)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_Heer_Headgear_Helmet_Winter_Camo',ThumbnailImage=Texture2D'VN_UI_Textures_Character.TunicMats.TunicMat_NVA_Camo')
    DAK_HeadgearMICs(14)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_DAK.MIC.M_Heer_Headgear_Helmet_Camo',ThumbnailImage=Texture2D'VN_UI_Textures_Character.TunicMats.TunicMat_NVA_Camo')



    DAK_Heads(0)=(HeadMesh=SkeletalMesh'DR_CHR_Heads.Mesh.DAK_Head_01_Mesh',HeadMICTemplates=(MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_02_Long_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.DAK.M_DAK_Head_01_Long_INST'),SkinToneID=0,HairColours=15,HeadgearSubIndex=1,ThumbnailImage=Texture2D'VN_UI_Textures_Character.Heads.Head_US_01')
    DAK_Heads(1)=(HeadMesh=SkeletalMesh'DR_CHR_Heads.Mesh.DAK_Head_02_Mesh',HeadMICTemplates=(MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_03_Long_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.DAK.M_DAK_Head_02_Long_INST'),SkinToneID=0,HairColours=15,ThumbnailImage=Texture2D'VN_UI_Textures_Character.Heads.Head_US_02')
    DAK_Heads(2)=(HeadMesh=SkeletalMesh'DR_CHR_Heads.Mesh.DAK_Head_01_Mesh',HeadMICTemplates=(MaterialInstanceConstant'CHR_VN_DLC_US_Heads.Materials_AUS.M_AUS_Head_11_Long_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.DAK.M_DAK_Head_01_Alt_01_Long_INST'),SkinToneID=0,HairColours=15,ThumbnailImage=Texture2D'VN_UI_Textures_Character.Heads.Head_US_03')
    DAK_Heads(3)=(HeadMesh=SkeletalMesh'DR_CHR_Heads.Mesh.DAK_Head_02_Mesh',HeadMICTemplates=(MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_05_Long_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.DAK.M_DAK_Head_02_Alt_01_Long_INST'),SkinToneID=0,HairColours=15,HeadgearSubIndex=1,ThumbnailImage=Texture2D'VN_UI_Textures_Character.Heads.Head_US_04')
    DAK_Heads(4)=(HeadMesh=SkeletalMesh'DR_CHR_Heads.Mesh.DAK_Head_01_Mesh',HeadMICTemplates=(MaterialInstanceConstant'CHR_VN_AUS_Heads.Materials.M_AUS_Head_07_Long_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.DAK.M_DAK_Head_01_Alt_02_Long_INST'),SkinToneID=0,HairColours=15,ThumbnailImage=Texture2D'VN_UI_Textures_Character.Heads.Head_US_05')


    //UK uniforms
    //Tunics

    //Long tunic with socks
    UK_Tunics(0)={(
        TunicMesh=SkeletalMesh'DR_CHR_UK.Mesh.UK_Tunic_LongSocks',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.UK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_UK.MIC.M_UK_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.UK_Tunic_Long_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_UK_Tunic_Tan'
            )
        ),
        SkinToShow=STS_HeadHands,
        ThumbnailImage=Texture2D'DR_UI.Character_One.UK_Tunic_LongSocks'
    )}

    //Long tunic
    UK_Tunics(1)={(
        TunicMesh=SkeletalMesh'DR_CHR_UK.Mesh.UK_Tunic_Long',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.UK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_UK.MIC.M_UK_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.UK_Tunic_Long_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_UK_Tunic_Tan'
            )
        ),
        SkinToShow=STS_HeadHands,
        ThumbnailImage=Texture2D'DR_UI.Character_One.UK_Tunic_Long'
    )}

    //Rolled tunic with socks
    UK_Tunics(2)={(
        TunicMesh=SkeletalMesh'DR_CHR_UK.Mesh.UK_Tunic_RolledSocks',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.UK_Hands_Rolled',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_UK.MIC.M_UK_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.UK_Tunic_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_UK_Tunic_Tan'
            )
        ),
        SkinToShow=STS_HeadForearms,
        ThumbnailImage=Texture2D'DR_UI.Character_One.UK_Tunic_RolledSocks'
    )}

    //Rolled tunic
    UK_Tunics(3)={(
        TunicMesh=SkeletalMesh'DR_CHR_UK.Mesh.UK_Tunic_Rolled',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.UK_Hands_Rolled',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_UK.MIC.M_UK_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.UK_Tunic_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_UK_Tunic_Tan'
            )
        ),
        SkinToShow=STS_HeadForearms,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Long'
    )}

    //Shorts with socks
    UK_Tunics(4)={(
        TunicMesh=SkeletalMesh'DR_CHR_UK.Mesh.UK_Tunic_ShortsSocks',
        ArmsMeshFP=SkeletalMesh'CHR_VN_1stP_Hands_Master.Mesh.VN_1stP_ALL_Bare_Mesh',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_UK.MIC.M_UK_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.UK_Tunic_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_UK_Tunic_Tan'
            )
        ),
        SkinToShow=STS_HeadAndArms,
        ThumbnailImage=Texture2D'DR_UI.Character_One.UK_Tunic_ShortsSocks'
    )}

    //Shorts
    UK_Tunics(5)={(
        TunicMesh=SkeletalMesh'DR_CHR_UK.Mesh.UK_Tunic_Shorts',
        ArmsMeshFP=SkeletalMesh'CHR_VN_1stP_Hands_Master.Mesh.VN_1stP_ALL_Bare_Mesh',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_UK.MIC.M_UK_Tunic_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.UK_Tunic_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_UK_Tunic_Tan'
            )
        ),
        SkinToShow=STS_HeadAndArms,
        ThumbnailImage=Texture2D'DR_UI.Character_One.UK_Tunic_Shorts'
    )}

    //Battledress
    UK_Tunics(6)={(
        TunicMesh=SkeletalMesh'DR_CHR_UK.Mesh.UK_BattleDress_Long',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.UK_Hands_Tunic',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_UK.MIC.M_UK_Battledress_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.UK_Tunic_Long_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_UK_Tunic_Tan'
            )
        ),
        SkinToShow=STS_HeadHands,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Long'
    )}

    //Service dress
    UK_Tunics(7)={(
        TunicMesh=SkeletalMesh'DR_CHR_UK.Mesh.UK_ServiceDress_Long',
        ArmsMeshFP=SkeletalMesh'DR_CHR.Mesh.UK_Hands_ServiceDress',
        BodyMICs=(
            (
                BodyMICTemplate=MaterialInstanceConstant'DR_CHR_UK.MIC.M_UK_ServiceDress_INST',
                SleeveMICFP=MaterialInstanceConstant'DR_CHR.MIC.UK_Tunic_ServiceDress_INST',
                ThumbnailImage=Texture2D'DR_UI.Character_Three.T_UK_Tunic_Tan'
            )
        ),
        SkinToShow=STS_HeadHands,
        ThumbnailImage=Texture2D'DR_UI.Character_One.DAK_Tunic_Long'
    )}

    // Fieldgear by role first and tunic mesh type second (for tunic types, 0 = Pants and Top, 1 = Pants Only)
    UK_FieldgearByRole(`DRCI_RIFLEMAN)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_UK.Gear.UK_Gear_Rifleman'))
    UK_FieldgearByRole(`DRCI_ASSAULT)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_UK.Gear.UK_Gear_Assault'))
    UK_FieldgearByRole(`DRCI_MACHINEGUNNER)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_UK.Gear.UK_Gear_MachineGunner'))
    UK_FieldgearByRole(`DRCI_SNIPER)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_UK.Gear.UK_Gear_Sniper'))
    UK_FieldgearByRole(`DRCI_SAPPER)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_UK.Gear.UK_GEAR_Sapper'))
    UK_FieldgearByRole(`DRCI_ANTITANK)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_UK.Gear.UK_Gear_Sniper'))
    UK_FieldgearByRole(`DRCI_RADIOMAN)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_UK.Gear.UK_GEAR_Radioman'))
    UK_FieldgearByRole(`DRCI_COMMANDER)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_UK.Gear.UK_Gear_Commander'))
    UK_FieldgearByRole(`DRCI_TANK_CREW)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_UK.Gear.UK_Gear_Crewman'))
    UK_FieldgearByRole(`DRCI_TANK_COMMANDER)=(FieldgearByTunicType=(SkeletalMesh'DR_CHR_UK.Gear.UK_Gear_Crewman'))


    UK_Headgear(0)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_UK.Headgear.UKr_Brodie_Straight'),HeadgearMICs=(0,1),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40')
    UK_Headgear(1)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_UK.Headgear.UK_Brodie_TiltL'),HeadgearMICs=(0,1),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_Cap_Overseas',RequiredLevel=0)
    UK_Headgear(2)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_UK.Headgear.UK_Brodie_TiltR'),HeadgearMICs=(0,1),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_Cap',RequiredLevel=0)
    UK_Headgear(3)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_UK.Headgear.UK_Brodie_Straight_Net'),HeadgearMICs=(0,1),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Paper',RequiredLevel=0)
    UK_Headgear(4)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_UK.Headgear.UK_Brodie_Straight_Cover'),HeadgearMICs=(0,1),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_2',RequiredLevel=0)
    UK_Headgear(5)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_UK.Headgear.UK_Brodie_Straight_G_UP'),HeadgearMICs=(0,1),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_G_Up',RequiredLevel=0)
    UK_Headgear(6)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_UK.Headgear.UK_Brodie_TiltL_G_UP'),HeadgearMICs=(0,1),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Paper_G_UP',RequiredLevel=0)
    UK_Headgear(7)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_UK.Headgear.UK_Brodie_TiltR_G_UP'),HeadgearMICs=(0,1),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_2_G_UP',RequiredLevel=0)
    UK_Headgear(8)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_UK.Headgear.UK_Brodie_Straight_G_Face'),HeadgearMICs=(0,1),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_1',RequiredLevel=0)
    UK_Headgear(9)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_UK.Headgear.UK_Brodie_TiltL_G_Face'),HeadgearMICs=(0,1),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_G_Face',RequiredLevel=0)
    UK_Headgear(10)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_UK.Headgear.UK_Brodie_TiltR_G_Face'),HeadgearMICs=(0,1),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Paper_G_Face',RequiredLevel=0)
    UK_Headgear(11)=(HeadgearMeshes=(SkeletalMesh'DR_CHR_UK.Headgear.UK_CapComforter'),HeadgearMICs=(4),HeadgearSocket=helmet,bIsHelmet=0,ThumbnailImage=Texture2D'DR_UI.Character_Two.DAK_Headgear_M40_Camo_2_G_Face',RequiredLevel=0)

    UK_HeadgearMICS(0)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_UK.MIC.M_UK_Brodie_Olive_INST',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet')
    UK_HeadgearMICS(1)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_UK.MIC.M_UK_Brodie_Tan_INST',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet_Tan')
    UK_HeadgearMICs(2)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_UK.MIC.M_UK_Beret_INST',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet_Insignia')
    UK_HeadgearMICs(3)=(HeadgearMICTemplate=MaterialInstanceConstant'DR_CHR_UK.MIC.M_UK_OfficerCap_INST',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet_Insignia_Tan')
    UK_HeadgearMICs(4)=(HeadgearMICTemplate=MaterialInstanceConstant'CHR_VN_DLC_Modders.Materials.M_US_headgear_sandbag_INST',ThumbnailImage=Texture2D'DR_UI.Character_Three.T_Heer_Headgear_Helmet_Dirt_Light')


    UK_Heads(0)=(HeadMesh=SkeletalMesh'DR_CHR_Heads.Mesh.UK_Head_01_Mesh',HeadMICTemplates=(MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_01_Long_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_01_Rolled_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_01_ShortShoes_INST'),SkinToneID=0,HairColours=15,ThumbnailImage=Texture2D'VN_UI_Textures_Character.Heads.Head_US_06')
    UK_Heads(1)=(HeadMesh=SkeletalMesh'DR_CHR_Heads.Mesh.UK_Head_02_Mesh',HeadMICTemplates=(MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_02_Long_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_02_Rolled_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_02_ShortShoes_INST'),SkinToneID=0,HairColours=15,ThumbnailImage=Texture2D'VN_UI_Textures_Character_Two.Heads.Head_AUS_01')
    UK_Heads(2)=(HeadMesh=SkeletalMesh'DR_CHR_Heads.Mesh.UK_Head_03_Mesh',HeadMICTemplates=(MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_03_Long_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_03_Rolled_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_03_ShortShoes_INST'),SkinToneID=0,HairColours=15,ThumbnailImage=Texture2D'VN_UI_Textures_Character_Two.Heads.Head_AUS_03')
    UK_Heads(3)=(HeadMesh=SkeletalMesh'DR_CHR_Heads.Mesh.UK_Head_04_Mesh',HeadMICTemplates=(MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_04_Long_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_04_Rolled_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_04_ShortShoes_INST'),SkinToneID=0,HairColours=15,ThumbnailImage=Texture2D'VN_UI_Textures_Character_Two.Heads.Head_US_11')
    UK_Heads(4)=(HeadMesh=SkeletalMesh'DR_CHR_Heads.Mesh.UK_Head_05_Mesh',HeadMICTemplates=(MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_05_Long_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_05_Rolled_INST',MaterialInstanceConstant'DR_CHR_Heads.MIC.UK.M_UK_Head_05_ShortShoes_INST'),SkinToneID=0,HairColours=15,ThumbnailImage=Texture2D'VN_UI_Textures_Character_Two.Heads.Head_AUS_04')
}
