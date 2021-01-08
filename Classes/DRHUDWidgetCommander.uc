class DRHUDWidgetCommander extends ROHUDWidgetCommander;

enum EDRCommanderTextures
{
    DRCT_Dummy1,  //ROCT_ForceRespawnButton,
    DRCT_Dummy2,  //ROCT_ForceRespawnTime,
    DRCT_Dummy3,  //ROCT_AerialReconButton,
    DRCT_Dummy4,  //ROCT_AerialReconTime,
    DRCT_Dummy5,  //ROCT_AerialReconProgress,
    DRCT_Dummy6,  //ROCT_CancelButton,
    DRCT_Dummy7,  //ROCT_MortarsButton,
    DRCT_Dummy8,  //ROCT_MortarsTime,
    DRCT_Dummy9,  //ROCT_MortarsProgress,
    DRCT_Dummy10, //ROCT_ArtilleryButton,
    DRCT_Dummy11, //ROCT_ArtilleryTime,
    DRCT_Dummy12, //ROCT_ArtilleryProgress,
    DRCT_Dummy13, //ROCT_RocketsButton,
    DRCT_Dummy14, //ROCT_RocketsTime,
    DRCT_Dummy15, //ROCT_RocketsProgress,
    DRCT_Dummy16, //ROCT_ReqUpdatedCoordsButton,
    DRCT_Dummy17, //ROCT_ReqUpdatedCoordsButtonTexture,
    DRCT_Dummy18, //ROCT_ReqUpdatedCoordsButtonText,
    DRCT_Dummy19, //ROCT_ClearCoordsButton,
    DRCT_Dummy20, //ROCT_ClearCoordsButtonTexture,
    DRCT_Dummy21, //ROCT_ClearCoordsButtonText,
    DRCT_Dummy22, //ROCT_ArtySummaryTexture,
    DRCT_Dummy23, //ROCT_ArtySummaryText,
    DRCT_Dummy24, //ROCT_SquadText,
    DRCT_Dummy25, //ROCT_ScrollSquadInstructionText,
    DRCT_Dummy26, //ROCT_TipBackground,
    DRCT_Dummy27, //ROCT_TipCoolDown,
    DRCT_Dummy28, //ROCT_TipTitle,
    DRCT_Dummy29, //ROCT_TipDescription1

    DRCT_StrafingRunButton,
    DRCT_StrafingRunTime,
    DRCT_StrafingRunProgress,
    DRCT_BombingRunButton,
    DRCT_BombingRunTime,
    DRCT_BombingRunProgress,
    DRCT_AntiAirButton,
    DRCT_AntiAirTime,
    DRCT_AntiAirProgress
};

var bool bStrafingRunAvailable;
var bool bBombingRunAvailable;
var bool bAntiAirAvailable;

var EROHUDButtonState StrafingRunButtonState;

var localized string StrafingRunString;
// var localized string DRBombingRunString; // "BombingRunString" already used.

var MaterialInstanceConstant DAKMortarsButtonTexTemplate;
var MaterialInstanceConstant DAKStrafingRunButtonTexTemplate;
var MaterialInstanceConstant DAKBombingRunButtonTexTemplate;
var MaterialInstanceConstant DAKAntiAirButtonTexTemplate;

var MaterialInstanceConstant NorthAbility4ButtonTex;
var MaterialInstanceConstant SouthAbility4ButtonTex;
var MaterialInstanceConstant Ability4ProgressMat;
var MaterialInstanceConstant NorthAbility5ButtonTex;
var MaterialInstanceConstant SouthAbility5ButtonTex;
var MaterialInstanceConstant Ability5ProgressMat;
var MaterialInstanceConstant NorthAbility6ButtonTex;
var MaterialInstanceConstant SouthAbility6ButtonTex;
var MaterialInstanceConstant Ability6ProgressMat;

/*
function Initialize(PlayerController HUDPlayerOwner)
{
    Ability4ProgressMat = new class'MaterialInstanceConstant';
    Ability4ProgressMat.SetParent(ProgressMaterialTemplate);
    Ability4ProgressMat.SetTextureParameterValue(ProgressBarTypeTexParamName, ProgressTexture);

    HUDComponents[DRCT_StrafingRunButton].Mat = Ability4ProgressMat;

    NorthAbility4ButtonTex = new class'MaterialInstanceConstant';
    NorthAbility4ButtonTex.SetParent(DAKStrafingRunButtonTexTemplate);

    `dr("CMDR HUD components length: " $ HUDComponents.Length);

    super.Initialize(HUDPlayerOwner);
}
*/

function Initialize(PlayerController HUDPlayerOwner)
{
    local Sequence GameSeq;
    local array<SequenceObject> AerialReconSeqEvents;
    local ROMapInfo ROMI;
    local ROGameReplicationInfo ROGRI;
    local int i, HUDComponentIndex;
    local ROHUDWidgetComponent TempComponent;
    local int TeamIndex;

    //HUDComponents[ROCT_ForceRespawnButtonText].Text = AmbushString;
    //HUDComponents[ROCT_ForceRespawnButtonText2].Text = RespawnString;
    HUDComponents[ROCT_ForceRespawnTime].Text = ZeroTimeString;
    //HUDComponents[ROCT_AerialReconButtonText].Text = ScoutString;
    //HUDComponents[ROCT_AerialReconButtonText2].Text = ReconString;
    HUDComponents[ROCT_AerialReconTime].Text = ZeroTimeString;
    //HUDComponents[ROCT_CancelButtonText].Text = CancelString;
    //HUDComponents[ROCT_CancelButtonText2].Text = ArtilleryString;
    //HUDComponents[ROCT_MortarsButtonText].Text = EnhancedString;
    //HUDComponents[ROCT_MortarsButtonText2].Text = LogisticsString;
    HUDComponents[ROCT_MortarsTime].Text = ZeroTimeString;
    //HUDComponents[ROCT_ArtilleryButtonText].Text = RequestString;
    //HUDComponents[ROCT_ArtilleryButtonText2].Text = ArtilleryString;
    HUDComponents[ROCT_ArtilleryTime].Text = ZeroTimeString;
    //HUDComponents[ROCT_RocketsButtonText].Text = RequestString;
    //HUDComponents[ROCT_RocketsButtonText2].Text = AirDefenceString;
    HUDComponents[ROCT_RocketsTime].Text = ZeroTimeString;
    HUDComponents[ROCT_ReqUpdatedCoordsButtonText].Text = RequestCoordsString;
    HUDComponents[ROCT_ClearCoordsButtonText].Text = ClearCoordsString;
    HUDComponents[ROCT_ArtySummaryText].Text = CoordsLogString;

    HUDComponents[ROCT_SquadText].Text = GetCurrentSquadText();
    HUDComponents[ROCT_ScrollSquadInstructionText].Text = ScrollThroughSquadString;//Repl(ScrollThroughSquadString, "%x", ROPlayerInput(PlayerOwner.PlayerInput).GetKeyForCommand("ShowOverheadMap"));

    AerialReconProgressMat = new class'MaterialInstanceConstant';
    AerialReconProgressMat.SetParent(ProgressMaterialTemplate);
    AerialReconProgressMat.SetTextureParameterValue(ProgressBarTypeTexParamName, ProgressTexture);
    Ability1ProgressMat = new class'MaterialInstanceConstant';
    Ability1ProgressMat.SetParent(ProgressMaterialTemplate);
    Ability1ProgressMat.SetTextureParameterValue(ProgressBarTypeTexParamName, ProgressTexture);
    Ability2ProgressMat = new class'MaterialInstanceConstant';
    Ability2ProgressMat.SetParent(ProgressMaterialTemplate);
    Ability2ProgressMat.SetTextureParameterValue(ProgressBarTypeTexParamName, ProgressTexture);
    Ability3ProgressMat = new class'MaterialInstanceConstant';
    Ability3ProgressMat.SetParent(ProgressMaterialTemplate);
    Ability3ProgressMat.SetTextureParameterValue(ProgressBarTypeTexParamName, ProgressTexture);

    HUDComponents[ROCT_AerialReconProgress].Mat = AerialReconProgressMat;
    HUDComponents[ROCT_MortarsProgress].Mat = Ability1ProgressMat;
    HUDComponents[ROCT_ArtilleryProgress].Mat = Ability2ProgressMat;
    HUDComponents[ROCT_RocketsProgress].Mat = Ability3ProgressMat;

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    ForceRespawnButtonTex = new class'MaterialInstanceConstant';
    ForceRespawnButtonTex.SetParent(ForceRespawnButtonTexTemplate);

    AmbushRespawnButtonTex = new class'MaterialInstanceConstant';
    AmbushRespawnButtonTex.SetParent(AmbushRespawnButtonTexTemplate);

    AerialReconButtonTex = new class'MaterialInstanceConstant';
    AerialReconButtonTex.SetParent(AerialReconButtonTexTemplate);

    ScoutReconButtonTex = new class'MaterialInstanceConstant';
    ScoutReconButtonTex.SetParent(ScoutReconButtonTexTemplate);

    NorthAbility1ButtonTex = new class'MaterialInstanceConstant';
    NorthAbility1ButtonTex.SetParent(DAKMortarsButtonTexTemplate);

    SouthAbility1ButtonTex = new class'MaterialInstanceConstant';

    if( ROMI != none && ROMI.SouthernForce == SFOR_AusArmy )
        SouthAbility1ButtonTex.SetParent(CanberraButtonTexTemplate);
    else
        SouthAbility1ButtonTex.SetParent(GunshipButtonTexTemplate);

    NorthAbility2ButtonTex = new class'MaterialInstanceConstant';

    // TODO:
    if( ROMI != none && ROMI.NorthernForce == NFOR_NLF )
    {
        NorthAbility2ButtonTex.SetParent(BarrageButtonTexTemplate);
    }
    else
    {
        NorthAbility2ButtonTex.SetParent(NorthArtilleryButtonTexTemplate);
    }

    NorthAbility3ButtonTex = new class'MaterialInstanceConstant';
    NorthAbility3ButtonTex.SetParent(AirDefenceButtonTexTemplate);

    SouthAbility2ButtonTex = new class'MaterialInstanceConstant';
    SouthAbility3ButtonTex = new class'MaterialInstanceConstant';

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);

    if( ROMI != none && ROMI.SouthernForce == SFOR_ARVN )
    {
        SouthAbility3ButtonTex.SetParent(ARVNNapalmButtonTexTemplate);
        SouthAbility2ButtonTex.SetParent(MortarsButtonTexTemplate);
    }
    // Special handling for the early war USMC to have a skyraider
    else if( ROMI != none && ROMI.SouthernForce == SFOR_USMC &&
            ROGRI != none && ROGRI.bIsCampaignGame && ROGRI.CampaignWarPhase == ROCWP_Early )
    {
        SouthAbility3ButtonTex.SetParent(ARVNNapalmButtonTexTemplate);
        SouthAbility2ButtonTex.SetParent(SouthArtilleryButtonTexTemplate);
    }
    else
    {
        SouthAbility3ButtonTex.SetParent(NapalmButtonTexTemplate);
        SouthAbility2ButtonTex.SetParent(SouthArtilleryButtonTexTemplate);
    }

    Ability4ProgressMat = new class'MaterialInstanceConstant';
    Ability4ProgressMat.SetParent(ProgressMaterialTemplate);
    Ability4ProgressMat.SetTextureParameterValue(ProgressBarTypeTexParamName, ProgressTexture);

    HUDComponents[DRCT_StrafingRunButton].Mat = Ability4ProgressMat;

    NorthAbility4ButtonTex = new class'MaterialInstanceConstant';
    NorthAbility4ButtonTex.SetParent(DAKStrafingRunButtonTexTemplate);

    `dr("CMDR HUD components length: " $ HUDComponents.Length);

    super(ROHUDWidget).Initialize(HUDPlayerOwner);

    // Use Game Sequence to find the AerialRecon Seq event
    GameSeq = WorldInfo.GetGameSequence();
    if ( GameSeq != none )
    {
        // find any Level Loaded events that exist
        GameSeq.FindSeqObjectsByClass(class'ROSeqEvent_AerialRecon', true, AerialReconSeqEvents);

        if ( AerialReconSeqEvents.Length > 0 )
        {
            bAerialReconAvailable = true;
        }
    }

    if ( ROMI != none && ROGRI != none )
    {
        TeamIndex = PlayerOwner.GetTeamNum();
        bArtilleryAvailable = ROGRI.ArtilleryStrikeLimit[TeamIndex] > 0;
        bMortarArtyAvailable = ROMI.CampaignAbilityAllowedInPhase(TeamIndex, ROGRI.CampaignWarPhase, 0) && ROMI.GetFirstAbilityLimit( ROGRI.MaxPlayers, TeamIndex ) > 0;
        bMediumArtyAvailable = ROMI.CampaignAbilityAllowedInPhase(TeamIndex, ROGRI.CampaignWarPhase, 1) && ROMI.GetSecondAbilityLimit( ROGRI.MaxPlayers, TeamIndex ) > 0;
        bRocketArtyAvailable = ROMI.CampaignAbilityAllowedInPhase(TeamIndex, ROGRI.CampaignWarPhase, 2) && ROMI.GetThirdAbilityLimit( ROGRI.MaxPlayers, TeamIndex ) > 0;
        MaxArtyAvailable = ROMI.GetMaxArtyType(TeamIndex, ROGameReplicationInfo(WorldInfo.GRI).bReverseRolesAndSpawns);
        bAllowStrikeDir = (ROMI.SouthernForce == SFOR_AusArmy && bMortarArtyAvailable);// || bRocketArtyAvailable;
    }

    if( OverheadMap != none )
    {
        LocalPlayer(HUDPlayerOwner.Player).ViewportClient.GetViewportSize(OverheadMap.ScreenCenter);
    }

    // Create a new component for each possible body text line
    for ( i = 1; i < RowCount; i++ )
    {
        // TODO: Update this as components are added.
        HUDComponentIndex = DRCT_StrafingRunButton + i;

        // Create a new Widget Component to hold the Row's text
        HUDComponents[HUDComponentIndex] = new class'ROHUDWidgetComponent';
        HUDComponents[HUDComponentIndex].X = 0;
        HUDComponents[HUDComponentIndex].Y = 0;
        HUDComponents[HUDComponentIndex].TextFont = HUDComponents[ROCT_TipDescription1].TextFont;
        HUDComponents[HUDComponentIndex].TextAlignment = HUDComponents[ROCT_TipDescription1].TextAlignment;
        HUDComponents[HUDComponentIndex].TextScale = HUDComponents[ROCT_TipDescription1].TextScale;
        HUDComponents[HUDComponentIndex].DrawColor = HUDComponents[ROCT_TipDescription1].DrawColor;
        HUDComponents[HUDComponentIndex].FullAlpha = HUDComponents[ROCT_TipDescription1].FullAlpha;
        HUDComponents[HUDComponentIndex].bVisible = HUDComponents[ROCT_TipDescription1].bVisible;
        HUDComponents[HUDComponentIndex].FadeOutTime = HUDComponents[ROCT_TipDescription1].FadeOutTime;
        HUDComponents[HUDComponentIndex].FadeInTime = HUDComponents[ROCT_TipDescription1].FadeInTime;
        HUDComponents[HUDComponentIndex].bDropShadow = HUDComponents[ROCT_TipDescription1].bDropShadow;
        HUDComponents[HUDComponentIndex].DropShadowOffset = HUDComponents[ROCT_TipDescription1].DropShadowOffset;
        HUDComponents[HUDComponentIndex].DropShadowColor = HUDComponents[ROCT_TipDescription1].DropShadowColor;
        HUDComponents[HUDComponentIndex].bWrapText = HUDComponents[ROCT_TipDescription1].bWrapText;
        HUDComponents[HUDComponentIndex].SortPriority = HUDComponents[ROCT_TipDescription1].SortPriority;
        HUDComponents[HUDComponentIndex].Initialize();
    }

    ROCT_CoordsStartIndex = HUDComponents.length;

    // Create a new component for each possible body text line
    for ( i = 0; i < `MAX_SQUADS; i++ )
    {
        //HUDComponentIndex = ROCT_CoordsStartIndex + i; // How to reference these components

        // Create a new Widget Component for time
        TempComponent = new class'ROHUDWidgetComponent';
        TempComponent.X = HUDComponents[ROCT_ArtySummaryText].X - CoordLogColumnOffset ;
        TempComponent.Y = HUDComponents[ROCT_ArtySummaryText].Y + CoordLogTitleOffset  + (i*CoordLogTextSize);
        TempComponent.TextFont = Font'VN_UI_Fonts.Font_VN_Condensed';
        TempComponent.TextAlignment = ROHTA_Center;
        TempComponent.TextScale = 0.35;
        TempComponent.DrawColor = class'HUD'.default.WhiteColor;
        TempComponent.bVisible = true;
        TempComponent.FadeOutTime = 0.5;
        TempComponent.bDropShadow = true;
        TempComponent.DropShadowOffset = vect2d(2,2);
        TempComponent.SortPriority = DSP_High;
        TempComponent.Initialize();

        HUDComponents.AddItem(TempComponent);

        // Create a new Widget Component for time
        TempComponent = new class'ROHUDWidgetComponent';
        TempComponent.X = HUDComponents[ROCT_ArtySummaryText].X;
        TempComponent.Y = HUDComponents[ROCT_ArtySummaryText].Y + CoordLogTitleOffset  + (i*CoordLogTextSize);
        TempComponent.TextFont = Font'VN_UI_Fonts.Font_VN_Condensed';
        TempComponent.TextAlignment = ROHTA_Center;
        TempComponent.TextScale = 0.35;
        TempComponent.DrawColor = class'HUD'.default.WhiteColor;
        TempComponent.bVisible = true;
        TempComponent.FadeOutTime = 0.5;
        TempComponent.bDropShadow = true;
        TempComponent.DropShadowOffset = vect2d(2,2);
        TempComponent.SortPriority = DSP_High;
        TempComponent.Initialize();

        HUDComponents.AddItem(TempComponent);

        // Create a new Widget Component for time
        TempComponent = new class'ROHUDWidgetComponent';
        TempComponent.X = HUDComponents[ROCT_ArtySummaryText].X + CoordLogColumnOffset ;
        TempComponent.Y = HUDComponents[ROCT_ArtySummaryText].Y + CoordLogTitleOffset  + (i*CoordLogTextSize);
        TempComponent.TextFont = Font'VN_UI_Fonts.Font_VN_Condensed';
        TempComponent.TextAlignment = ROHTA_Center;
        TempComponent.TextScale = 0.35;
        TempComponent.DrawColor = class'HUD'.default.WhiteColor;
        TempComponent.bVisible = true;
        TempComponent.FadeOutTime = 0.5;
        TempComponent.bDropShadow = true;
        TempComponent.DropShadowOffset = vect2d(2,2);
        TempComponent.SortPriority = DSP_High;
        TempComponent.Initialize();

        HUDComponents.AddItem(TempComponent);
    }

        // Create a new component for each possible body text line
    for ( i = 0; i < `MAX_SQUADS; i++ )
    {
        // Create a new Widget Component for time
        TempComponent = new class'ROHUDWidgetComponent';
        TempComponent.X = HUDComponents[ROCT_ArtySummaryText].X - 70; // Middle - (Width/2), to get centered
        TempComponent.Y = HUDComponents[ROCT_ArtySummaryText].Y + CoordLogTitleOffset  + (i*CoordLogTextSize) + 3; // plus 3 for a small gap inbetween them
        TempComponent.Width = 140;
        TempComponent.Height = 18;
        TempComponent.TexWidth = 32;
        TempComponent.TexHeight = 32;
        TempComponent.Tex=Texture2D'EngineResources.WhiteSquareTexture';
        TempComponent.DrawColor = MakeColor(255,255,0,100);
        TempComponent.FullAlpha = 100;
        TempComponent.bVisible = false;
        TempComponent.FadeInTime = 0.25;
        TempComponent.FadeOutTime = 0.25;
        TempComponent.SortPriority = DSP_High;
        TempComponent.Initialize();

        HUDComponents.AddItem(TempComponent);
        ROCT_YellowFlashes[i] = TempComponent;
    }
}

function UpdateForTeam(byte MyTeam)
{
    local ROMapInfo ROMI;
    local ROGameReplicationInfo ROGRI;

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());
    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);

    if(ROMI == none)
        return;

    // Set appropriate images and text for each team's differing abilities
    if( MyTeam == `AXIS_TEAM_INDEX )
    {
        HUDComponents[ROCT_ForceRespawnButton].Mat = AmbushRespawnButtonTex;
        //HUDComponents[ROCT_ForceRespawnButtonText].Text = AmbushString;
        //HUDComponents[ROCT_ForceRespawnButtonText2].Text = RespawnString;
        HUDComponents[ROCT_ForceRespawnTime].Text = ZeroTimeString;

        HUDComponents[ROCT_AerialReconButton].Mat = ScoutReconButtonTex;
        //HUDComponents[ROCT_AerialReconButtonText].Text = ScoutString;
        //HUDComponents[ROCT_AerialReconButtonText2].Text = ReconString;
        HUDComponents[ROCT_AerialReconTime].Text = ZeroTimeString;

        // Ability 1
        HUDComponents[ROCT_MortarsButton].Mat = NorthAbility1ButtonTex;
        //HUDComponents[ROCT_MortarsButtonText].Text = EnhancedString;
        //HUDComponents[ROCT_MortarsButtonText2].Text = LogisticsString;
        HUDComponents[ROCT_MortarsTime].Text = ZeroTimeString;

        // Ability 2
        HUDComponents[ROCT_ArtilleryButton].Mat = NorthAbility2ButtonTex;
        //HUDComponents[ROCT_ArtilleryButtonText].Text = RequestString;
        /*if( ROMI.NorthernForce == NFOR_NVA )
            HUDComponents[ROCT_ArtilleryButtonText2].Text = ArtilleryString;
        else
            HUDComponents[ROCT_ArtilleryButtonText2].Text = BarrageString;*/

        HUDComponents[ROCT_ArtilleryTime].Text = ZeroTimeString;

        // Ability 3
        HUDComponents[ROCT_RocketsButton].Mat = NorthAbility3ButtonTex;
        //HUDComponents[ROCT_RocketsButtonText].Text = RequestString;
        //HUDComponents[ROCT_RocketsButtonText2].Text = AirDefenceString;
        HUDComponents[ROCT_RocketsTime].Text = ZeroTimeString;

        // Ability 4
        HUDComponents[DRCT_StrafingRunButton].Mat = NorthAbility4ButtonTex;

        HUDComponents[ROCT_CancelButton].Tex = NorthCancelTex;

        // #1
        ButtonOneTipTitleString  = AmbushRespawnTipTitleString;
        ButtonOneTipDescriptionString = AmbushRespawnTipString;

        // #2
        ButtonTwoTipTitleString = ScoutReconTipTitleString;
        ButtonTwoTipDescriptionString = ScoutReconTipString;

        // #3
        ButtonThreeTipTitleString = LogisticsTipTitleString;
        ButtonThreeTipDescriptionString = Repl(LogisticsTipString, "%DUR%", string(ROMI.EnhancedLogisticsDuration));;

        // #4
        if( ROMI.NorthernForce == NFOR_NVA )
        {
            ButtonFourTipTitleString = SouthArtilleryTipTitleString;
            ButtonFourTipDescriptionString = SouthArtilleryTipString;
        }
        else
        {
            ButtonFourTipTitleString = NorthArtilleryTipTitleString;
            ButtonFourTipDescriptionString = NorthArtilleryTipString;
        }

        // #5
        ButtonFiveTipTitleString = AirDefenceTipTitleString;
        ButtonFiveTipDescriptionString = AirDefenceTipString;
    }
    else
    {
        HUDComponents[ROCT_ForceRespawnButton].Mat = ForceRespawnButtonTex;
        //HUDComponents[ROCT_ForceRespawnButtonText].Text = ForceString;
        //HUDComponents[ROCT_ForceRespawnButtonText2].Text = RespawnString;
        HUDComponents[ROCT_ForceRespawnTime].Text = ZeroTimeString;

        HUDComponents[ROCT_AerialReconButton].Mat = AerialReconButtonTex;
        //HUDComponents[ROCT_AerialReconButtonText].Text = AerialString;
        //HUDComponents[ROCT_AerialReconButtonText2].Text = ReconString;
        HUDComponents[ROCT_AerialReconTime].Text = ZeroTimeString;

        // Ability 1
        HUDComponents[ROCT_MortarsButton].Mat = SouthAbility1ButtonTex;
        //HUDComponents[ROCT_MortarsButtonText].Text = RequestString;
        /*if( ROMI.SouthernForce == SFOR_AusArmy )
            HUDComponents[ROCT_MortarsButtonText2].Text = BombingRunString;
        else
            HUDComponents[ROCT_MortarsButtonText2].Text = GunshipString;*/

        HUDComponents[ROCT_MortarsTime].Text = ZeroTimeString;

        // Ability 2
        HUDComponents[ROCT_ArtilleryButton].Mat = SouthAbility2ButtonTex;
        //HUDComponents[ROCT_ArtilleryButtonText].Text = RequestString;
        /*if( ROMI.SouthernForce == SFOR_ARVN )
            HUDComponents[ROCT_ArtilleryButtonText2].Text = MortarsString;
        else
            HUDComponents[ROCT_ArtilleryButtonText2].Text = ArtilleryString;*/

        HUDComponents[ROCT_ArtilleryTime].Text = ZeroTimeString;

        // Ability 3
        HUDComponents[ROCT_RocketsButton].Mat = SouthAbility3ButtonTex;
        //HUDComponents[ROCT_RocketsButtonText].Text = RequestString;
        //HUDComponents[ROCT_RocketsButtonText2].Text = NapalmString;
        HUDComponents[ROCT_RocketsTime].Text = ZeroTimeString;

        HUDComponents[ROCT_CancelButton].Tex = SouthCancelTex;

        // #1
        ButtonOneTipTitleString = ForceRespawnTipTitleString;
        ButtonOneTipDescriptionString = ForceRespawnTipString;

        // #2
        ButtonTwoTipTitleString = AerialReconTipTitleString;
        ButtonTwoTipDescriptionString = AerialReconTipString;

        // #3
        if( ROMI.SouthernForce == SFOR_AusArmy )
        {
            ButtonThreeTipTitleString = BombingRunTipTitleString;
            ButtonThreeTipDescriptionString = BombingRunTipString;
        }
        else
        {
            ButtonThreeTipTitleString = GunshipTipTitleString;
            ButtonThreeTipDescriptionString = Repl(GunshipTipString, "%DUR%", string(ROMI.GetGunshipDuration()));
        }

        // #4
        if( ROMI.SouthernForce == SFOR_ARVN )
        {
            ButtonFourTipTitleString = MortarsTipTitleString;
            ButtonFourTipDescriptionString = MortarsTipString;
        }
        else
        {
            ButtonFourTipTitleString = SouthArtilleryTipTitleString;
            ButtonFourTipDescriptionString = SouthArtilleryTipString;
        }

        // #5
        ButtonFiveTipTitleString = NapalmTipTitleString;
        ButtonFiveTipDescriptionString = NapalmTipString;

    }

    ButtonOneTipCooldownString = CooldownString @ ROMI.InstantRespawnInterval;
    ButtonTwoTipCooldownString = CooldownString @ ROMI.GetReconInterval(MyTeam);
    ButtonThreeTipCooldownString = CooldownString @ ROGRI.AbilityOneDelay[MyTeam];
    ButtonFourTipCooldownString = CooldownString @ ROGRI.AbilityTwoDelay[MyTeam];
    ButtonFiveTipCooldownString = CooldownString @ ROGRI.AbilityThreeDelay[MyTeam];

    HUDComponents[ROCT_AerialReconProgress].bVisible = false;
    MaterialInstanceConstant(HUDComponents[ROCT_AerialReconProgress].Mat).SetScalarParameterValue(ProgressParamName, 0);
    HUDComponents[ROCT_MortarsProgress].bVisible = false;
    MaterialInstanceConstant(HUDComponents[ROCT_MortarsProgress].Mat).SetScalarParameterValue(ProgressParamName, 0);
    HUDComponents[ROCT_ArtilleryProgress].bVisible = false;
    MaterialInstanceConstant(HUDComponents[ROCT_ArtilleryProgress].Mat).SetScalarParameterValue(ProgressParamName, 0);
    HUDComponents[ROCT_RocketsProgress].bVisible = false;
    MaterialInstanceConstant(HUDComponents[ROCT_RocketsProgress].Mat).SetScalarParameterValue(ProgressParamName, 0);
}

function ShowToolTip(byte ButtonIdx)
{
    local string Description, Title, Cooldown;
    local array<string> WrappedString;
    local int i, CompIndex;
    local bool bTipVisible;
    local float BodyTextHeight, TitleTextHeight, CooldownTextHeight;
    local float BackgroundWidth;

    bTipVisible = !class'ROUIScene'.default.bDisableToolTips;

    BodyTextHeight = (HUDComponents[ROCT_TipDescription1].TextFont.GetMaxCharHeight() + 1) * HUDComponents[ROCT_TipDescription1].TextScale * HUDComponents[ROCT_TipDescription1].ScaleY;
    TitleTextHeight = (HUDComponents[ROCT_TipTitle].TextFont.GetMaxCharHeight() + 1) * HUDComponents[ROCT_TipTitle].TextScale * HUDComponents[ROCT_TipTitle].ScaleY;
    CooldownTextHeight = (HUDComponents[ROCT_TipCooldown].TextFont.GetMaxCharHeight() + 1) * HUDComponents[ROCT_TipCooldown].TextScale * HUDComponents[ROCT_TipCooldown].ScaleY;

    BackgroundWidth = 3 * HUDComponents[ButtonIdx].CurWidth;

    Switch(ButtonIdx)
    {
        case ROCT_ForceRespawnButton:
            Title = ButtonOneTipTitleString;
            Description = ButtonOneTipDescriptionString;
            Cooldown = ButtonOneTipCooldownString;
            break;
        case ROCT_AerialReconButton:
            Title = ButtonTwoTipTitleString;
            Description = ButtonTwoTipDescriptionString;
            Cooldown = ButtonTwoTipCooldownString;
            break;
        case ROCT_MortarsButton:
            Title = ButtonThreeTipTitleString;
            Description = ButtonThreeTipDescriptionString;
            Cooldown = ButtonThreeTipCooldownString;
            break;
        case ROCT_ArtilleryButton:
            Title = ButtonFourTipTitleString;
            Description = ButtonFourTipDescriptionString;
            Cooldown = ButtonFourTipCooldownString;
            break;
        case ROCT_RocketsButton:
            Title = ButtonFiveTipTitleString;
            Description = ButtonFiveTipDescriptionString;
            Cooldown = ButtonFiveTipCooldownString;
            break;
        case ROCT_CancelButton:
            Title = CancelButtonTipTitleString;
            Cooldown = ButtonOneTipCooldownString;
            break;
    }

    SplitStringForWrapping(HUDComponents[ROCT_TipDescription1].TextFont,
                           Description,
                           HUDComponents[ROCT_TipDescription1].ScaleX * HUDComponents[ROCT_TipDescription1].TextScale,
                           BackgroundWidth - 30,
                           WrappedString);

    //`log("WrappedString.Length=" $ WrappedString.Length);
    // Background
    HUDComponents[ROCT_TipBackground].bVisible = bTipVisible;
    HUDComponents[ROCT_TipBackground].CurX = HUDComponents[ROCT_ForceRespawnButton].CurX;
    HUDComponents[ROCT_TipBackground].CurY = HUDComponents[ButtonIdx].CurY + HUDComponents[ButtonIdx].CurHeight;
    HUDComponents[ROCT_TipBackground].CurWidth  = 3 * HUDComponents[ButtonIdx].CurWidth;
    HUDComponents[ROCT_TipBackground].CurHeight = TitleTextHeight + FMax(3.f, WrappedString.Length) * BodyTextHeight + (CooldownTextHeight * 1.5f);

    // Title
    HUDComponents[ROCT_TipTitle].bVisible = bTipVisible;
    HUDComponents[ROCT_TipTitle].CurX = HUDComponents[ROCT_TipBackground].CurX + 4;
    HUDComponents[ROCT_TipTitle].CurY = HUDComponents[ROCT_TipBackground].CurY;
    HUDComponents[ROCT_TipTitle].Text = Title;
    //Set each row of the body message
    for (i = 0; i < RowCount; i++)
    {
        CompIndex = DRCT_AntiAirProgress + i;

        HUDComponents[CompIndex].bVisible = bTipVisible;
        HUDComponents[CompIndex].CurX = HUDComponents[ROCT_TipBackground].CurX + 4;
        HUDComponents[CompIndex].CurY = HUDComponents[ROCT_TipBackground].CurY + TitleTextHeight + i * BodyTextHeight;

        if (i < WrappedString.Length)
        {
            HUDComponents[CompIndex].Text = WrappedString[i];
        }
        else
        {
            HUDComponents[CompIndex].Text = "";
        }
    }

    HUDComponents[ROCT_TipCooldown].bVisible = bTipVisible;
    HUDComponents[ROCT_TipCooldown].CurX = HUDComponents[ROCT_TipBackground].CurX + 4;
    //HUDComponents[ROCT_TipCooldown].CurY = HUDComponents[ROCT_TipBackground + RowCount - 1].CurY + 2 * BodyTextHeight;
    HUDComponents[ROCT_TipCooldown].CurY = HUDComponents[ROCT_TipBackground].CurY + HUDComponents[ROCT_TipBackground].CurHeight - CooldownTextHeight;
    HUDComponents[ROCT_TipCooldown].Text = Cooldown;
}

function HideToolTip()
{
    local int i;

    HUDComponents[ROCT_TipBackground].bVisible = false;
    HUDComponents[ROCT_TipCooldown].bVisible = false;
    HUDComponents[ROCT_TipTitle].bVisible = false;

    for(i = 0; i < RowCount; i++)
    {
        HUDComponents[DRCT_AntiAirProgress + i].bVisible = false;
    }
}

// Commander ability setup:
// DAK (North)
// Deploy   - Recon   - Cancel
// Mortar   - Arty    - Rocket
// Strafing - Bombing - Anti-Air

DefaultProperties
{
    // TODO: need assets.
    // NorthCancelTex=Texture2D'VN_UI_Textures.OverheadMap.ui_cmd_icon_VN_cancel'
    // SouthCancelTex=Texture2D'VN_UI_Textures.OverheadMap.ui_cmd_icon_USA_cancel'

    // --- DAK (North) ---
    AmbushRespawnButtonTexTemplate=MaterialInstanceConstant'DR_UI.CommanderAbility.CommanderAbility_DAK_RapidDeploy_MIC'
    ScoutReconButtonTexTemplate=MaterialInstanceConstant'DR_UI.CommanderAbility.CommanderAbility_DAK_Recon_MIC'
    // Cancel button.
    DAKMortarsButtonTexTemplate=MaterialInstanceConstant'DR_UI.CommanderAbility.CommanderAbility_DAK_Mortars_MIC'
    NorthArtilleryButtonTexTemplate=MaterialInstanceConstant'DR_UI.CommanderAbility.CommanderAbility_DAK_Artillery_MIC'
    AirDefenceButtonTexTemplate=MaterialInstanceConstant'DR_UI.CommanderAbility.CommanderAbility_DAK_Barrage_MIC'
    DAKStrafingRunButtonTexTemplate=MaterialInstanceConstant'DR_UI.CommanderAbility.CommanderAbility_DAK_StrafingRun_MIC'
    DAKBombingRunButtonTexTemplate=MaterialInstanceConstant'DR_UI.CommanderAbility.CommanderAbility_DAK_BombingRun_MIC'
    DAKAntiAirButtonTexTemplate=MaterialInstanceConstant'DR_UI.CommanderAbility.CommanderAbility_DAK_AntiAir_MIC'
    // -------------------

    ForceRespawnButtonTexTemplate=MaterialInstanceConstant'DR_UI.CommanderAbility.CommanderAbility_UK_RapidDeploy_MIC'
    AerialReconButtonTexTemplate=MaterialInstanceConstant'DR_UI.CommanderAbility.CommanderAbility_UK_Recon_MIC'
    GunshipButtonTexTemplate=MaterialInstanceConstant'VN_UI_Textures.OverheadMap.ui_cmd_icon_USA_gunship_MIC'
    //? BarrageButtonTexTemplate=MaterialInstanceConstant'DR_UI.CommanderAbility.CommanderAbility_DAK_Artillery_MIC'
    SouthArtilleryButtonTexTemplate=MaterialInstanceConstant'VN_UI_Textures.OverheadMap.ui_cmd_icon_USA_artillery_MIC'
    NapalmButtonTexTemplate=MaterialInstanceConstant'VN_UI_Textures.OverheadMap.ui_cmd_icon_USA_napalm_MIC'
    ARVNNapalmButtonTexTemplate=MaterialInstanceConstant'VN_UI_Textures.OverheadMap.ui_cmd_icon_SVN_napalm_MIC'
    CanberraButtonTexTemplate=MaterialInstanceConstant'VN_UI_Textures_Three.OverheadMap.ui_cmd_icon_AUS_canberra_MIC'
    MortarsButtonTexTemplate=MaterialInstanceConstant'VN_UI_Textures_Three.OverheadMap.ui_cmd_icon_ARVN_mortars_MIC'

    Begin Object Class=ROHUDWidgetComponent Name=ReqUpdatedCoordsButton
        X=0
        Y=280 // 186
        Width=270
        Height=33
        TexWidth=32
        TexHeight=32
        Tex=Texture2D'EngineResources.Black'
        DrawColor=(R=255,G=255,B=255,A=255)
        FullAlpha=255
        FadeOutTime=0.25
        bVisible=true
        bFadedOut=false
        SortPriority=DSP_AboveNormal
    End Object
    HUDComponents(ROCT_ReqUpdatedCoordsButton)=ReqUpdatedCoordsButton

    Begin Object Class=ROHUDWidgetComponent Name=ReqUpdatedCoordsButtonTexture
        X=15
        Y=287 // 193
        Width=21
        Height=21
        TexWidth=128//64
        TexHeight=128//64
        Tex=Texture2D'VN_UI_Textures_Three.OverheadMap.ui_overheadmap_icons_RotationalCursorGradient'
        DrawColor=(R=255,G=255,B=255,A=255)
        FullAlpha=255
        FadeOutTime=0.25
        bVisible=true
        bFadedOut=false
        SortPriority=DSP_AboveNormal
    End Object
    HUDComponents(ROCT_ReqUpdatedCoordsButtonTexture)=ReqUpdatedCoordsButtonTexture

    Begin Object Class=ROHUDWidgetComponent Name=ReqUpdatedCoordsButtonText
        X=45
        Y=285 // 192
        TextFont=Font'VN_UI_Fonts.Font_VN_Condensed'
        TextAlignment=ROHTA_Left
        TextScale=0.35
        DrawColor=(R=255,G=255,B=255,A=255)
        bDropShadow=true
        DropShadowOffset=(X=1,Y=1)
        FadeOutTime=0.25
        bVisible=true
        bFadedOut=false
        SortPriority=DSP_High
    End Object
    HUDComponents(ROCT_ReqUpdatedCoordsButtonText)=ReqUpdatedCoordsButtonText

    Begin Object Class=ROHUDWidgetComponent Name=ClearCoordsButton
        X=0
        Y=320 // 226 //186
        Width=270
        Height=33
        TexWidth=32
        TexHeight=32
        Tex=Texture2D'EngineResources.Black'
        DrawColor=(R=255,G=255,B=255,A=255)
        FullAlpha=255
        FadeOutTime=0.25
        bVisible=true
        bFadedOut=false
        SortPriority=DSP_AboveNormal
    End Object
    HUDComponents(ROCT_ClearCoordsButton)=ClearCoordsButton

    Begin Object Class=ROHUDWidgetComponent Name=ClearCoordsButtonTexture
        X=15
        Y=327 // 233
        Width=21
        Height=21
        TexWidth=64
        TexHeight=64
        Tex=Texture2D'VN_UI_Textures.menu.kick_icon'
        DrawColor=(R=255,G=255,B=255,A=255)
        FullAlpha=255
        FadeOutTime=0.25
        bVisible=true
        bFadedOut=false
        SortPriority=DSP_AboveNormal
    End Object
    HUDComponents(ROCT_ClearCoordsButtonTexture)=ClearCoordsButtonTexture

    Begin Object Class=ROHUDWidgetComponent Name=ClearCoordsButtonText
        X=45
        Y=326 // 232
        TextFont=Font'VN_UI_Fonts.Font_VN_Condensed'
        TextAlignment=ROHTA_Left
        TextScale=0.35
        DrawColor=(R=255,G=255,B=255,A=255)
        bDropShadow=true
        DropShadowOffset=(X=1,Y=1)
        FadeOutTime=0.25
        bVisible=true
        bFadedOut=false
        SortPriority=DSP_High
    End Object
    HUDComponents(ROCT_ClearCoordsButtonText)=ClearCoordsButtonText

        Begin Object Class=ROHUDWidgetComponent Name=StrafingRunButton
        X=0
        Y=180
        Width=90
        Height=90
        TexWidth=1
        TexHeight=1
        //Tex=Texture2D'ui_textures.OverheadMap.ui_overheadmap_artillery'
        DrawColor=(R=255,G=255,B=255,A=255)
        FullAlpha=255
        FadeOutTime=0.25
        bVisible=true
        bFadedOut=false
        SortPriority=DSP_AboveNormal
    End Object
    HUDComponents(DRCT_StrafingRunButton)=StrafingRunButton

    Begin Object Class=ROHUDWidgetComponent Name=StrafingRunTimeText
        X=45
        Y=185
        TextFont=Font'VN_UI_Fonts.Font_VN_Condensed'
        TextAlignment=ROHTA_Center
        TextScale=0.35
        DrawColor=(R=255,G=255,B=255,A=255)
        bDropShadow=true
        DropShadowOffset=(X=1,Y=1)
        FadeOutTime=0.25
        bVisible=true
        bFadedOut=false
        SortPriority=DSP_High
    End Object
    HUDComponents(DRCT_StrafingRunTime)=StrafingRunTimeText

    Begin Object Class=ROHUDWidgetComponent Name=StrafingRunProgress
        X=0
        Y=180
        Width=90
        Height=90
        TexWidth=1
        TexHeight=1
        Tex=none
        Mat=none
        DrawColor=(R=255,G=255,B=255,A=255)
        FullAlpha=255
        FadeOutTime=0.25
        FadeInTime=0.1
        bVisible=true
        bFadedOut=false
        SortPriority=DSP_AboveNormal
    End Object
    HUDComponents(DRCT_StrafingRunProgress)=StrafingRunProgress
}
