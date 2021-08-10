class DRUISceneCharacter extends ROUISceneCharacter;

event PostInitialize()
{
    super.PostInitialize();

    `log("PostInitialize(): TunicSelectionWidget    = " $ TunicSelectionWidget,, 'DRDEV');
    `log("PostInitialize(): TunicMatSelectionWidget = " $ TunicMatSelectionWidget,, 'DRDEV');
}

function InitPlayerConfig()
{
    local LocalPlayer Player;
    local DRMapInfo DRMI;
    local bool bMainMenu;

    Player = GetPlayerOwner();
    if ( Player != none && Player.Actor != none )
    {
        ROPC = ROPlayerController(Player.Actor);
        if(ROPC != none)
        {
            // Get our map info for determining which team geartypes are allowed and populate the combo boxes based on these.
            DRMI = DRMapInfo(ROPC.WorldInfo.GetMapInfo());

            bMainMenu = ROPC.WorldInfo.GRI.GameClass.static.GetGameType() == ROGT_Default;

            if( bMainMenu )
            {
                TeamIndexActual = ROPC.LastDisplayedTeam;
                ArmyIndexActual = ROPC.LastDisplayedArmy;
            }
            else
            {
                // Get Team FIRST before determining army type.
                TeamIndexActual = ROPC.GetTeamNum();

                // Attempt to populate our ArmyIndex variable
                if( DRMI != none && TeamIndexActual == `ALLIES_TEAM_INDEX )
                {
                    ArmyIndexActual = DRMI.SouthernForce;
                }
                else if( DRMI != none && TeamIndexActual == `AXIS_TEAM_INDEX )
                {
                    // Else, load my preconfigured values (if they exist) for me since I'm an Axis player.
                    ArmyIndexActual = DRMI.NorthernForce;
                }
                else
                {
                    ArmyIndexActual = 0;
                }
            }

            ROPRI = ROPlayerReplicationInfo(ROPC.PlayerReplicationInfo);
        }

        if(ROPRI != none && ROPRI.RoleInfo != none)
        {
            ClassIndexActual = ROPRI.RoleInfo.ClassIndex;
            bPilotActual = ROPRI.RoleInfo.bIsPilot;
            bCombatPilotActual = bPilotActual && !ROPRI.RoleInfo.bIsTransportPilot;
        }
        else
        {
            if( bMainMenu )
            {
                bPilotActual = ROPC.bLastDisplayedPilot;
                ClassIndexActual = ROPC.LastDisplayedClass;
            }
            else
            {
                bPilotActual = false;
                ClassIndexActual = -1; // Baseline
            }
        }

        ROPC.StatsWrite.UpdateHonorLevel();
        HonorLevel = byte(ROPC.StatsWrite.HonorLevel);
    }
}

function UpdateComboBoxes()
{
    local int i;

    for (i = 0; i < ComboBoxes.Length; ++i)
    {
        `log("UpdateComboBoxes(): ActiveComboBox = " $ ActiveComboBox,, 'DRDEV');
        `log("UpdateComboBoxes(): ComboBoxes[i]  = " $ ComboBoxes[i],, 'DRDEV');
        if (ComboBoxes[i] != ActiveComboBox)
        {
            ComboBoxes[i].HideList();
        }
    }
}

function SwitchToTab(UIToggleButton ActiveToggle, ROUIWidgetGridScrollable NewActivePanel)
{
    /*
    // Disables fading for the editor
    if (class'Engine'.static.IsEditor())
    {
        TunicSelectionWidget.Fade(0.0, 1.0, 0.3);
        TunicSelectionWidget.SetVisibility(true);
        //TunicMatSelectionWidget.Fade(0.0, 1.0, 0.3);
        //TunicMatSelectionWidget.SetVisibility(true);
        ShirtSelectionWidget.Fade(0.0, 1.0, 0.3);
        ShirtSelectionWidget.SetVisibility(true);
        HeadSelectionWidget.Fade(0.0, 1.0, 0.3);
        HeadSelectionWidget.SetVisibility(true);
        HeadgearSelectionWidget.Fade(0.0, 1.0, 0.3);
        HeadgearSelectionWidget.SetVisibility(true);
        FaceItemSelectionWidget.Fade(0.0, 1.0, 0.3);
        FaceItemSelectionWidget.SetVisibility(true);
        FacialHairSelectionWidget.Fade(0.0, 1.0, 0.3);
        FacialHairSelectionWidget.SetVisibility(true);
        TattooSelectionWidget.Fade(0.0, 1.0, 0.3);
        TattooSelectionWidget.SetVisibility(true);
    }
    else
    {*/
        // Clear all of the Toggles first
        TunicToggle.SetValue(false);
        ShirtToggle.SetValue(false);
        HeadToggle.SetValue(false);
        HeadgearToggle.SetValue(false);
        FaceItemToggle.SetValue(false);
        FacialHairToggle.SetValue(false);
        TattooToggle.SetValue(false);

        // Hide all Panels
        TunicSelectionWidget.Fade(1.0, 0.0, 0.3);
        TunicSelectionWidget.SetVisibility(false);
        //TunicMatSelectionWidget.Fade(1.0, 0.0, 0.3);
        //TunicMatSelectionWidget.SetVisibility(false);
        ShirtSelectionWidget.Fade(1.0, 0.0, 0.3);
        ShirtSelectionWidget.SetVisibility(false);
        HeadSelectionWidget.Fade(1.0, 0.0, 0.3);
        HeadSelectionWidget.SetVisibility(false);
        HeadgearSelectionWidget.Fade(1.0, 0.0, 0.3);
        HeadgearSelectionWidget.SetVisibility(false);
        FaceItemSelectionWidget.Fade(1.0, 0.0, 0.3);
        FaceItemSelectionWidget.SetVisibility(false);
        FacialHairSelectionWidget.Fade(1.0, 0.0, 0.3);
        FacialHairSelectionWidget.SetVisibility(false);
        TattooSelectionWidget.Fade(1.0, 0.0, 0.3);
        TattooSelectionWidget.SetVisibility(false);
    //}

    // Set the new Toggle
    ActiveToggle.SetValue(true);
    ActivePanel = NewActivePanel;
    ActivePanel.Fade(0.0, 1.0, 0.3);
    ActivePanel.SetVisibility(true);
    SetCategoryHeading();
    SetPreviewCameraPos();
    PopulateCurrentPanel();

    ActiveComboBox = none;
    UpdateComboBoxes();
}

function SetCategoryHeading()
{
    super.SetCategoryHeading();

    `log("SetCategoryHeading(): ActivePanel = " $ ActivePanel,, 'DRDEV');
}

function PopulateArmyList()
{
    local int i;
    local int ArrayLength;
    local int TotalArrayLength;
    local DRMapInfo DRMI;

    if( ROPC != none )
    {
        DRMI = DRMapInfo(ROPC.WorldInfo.GetMapInfo());
    }

    if( DRMI != none )
    {
        ROCharCustStringsDataStore.Empty('ROCharCustArmyType');
        ArrayLength = DRMI.GetNumArmiesForTeam(0);
        TotalArrayLength = ArrayLength;

        for(i = 0; i < ArrayLength; i++)
        {
            ROCharCustStringsDataStore.AddStr('ROCharCustArmyType', DRMI.GetArmyNameForTeam(0, true, i));
        }

        FirstSouthIndex = ArrayLength;
        ArrayLength = DRMI.GetNumArmiesForTeam(1);
        TotalArrayLength += ArrayLength;

        for(i = 0; i < ArrayLength; i++)
        {
            ROCharCustStringsDataStore.AddStr('ROCharCustArmyType', DRMI.GetArmyNameForTeam(1, true, i));
        }

        ArmyComboBox.ComboList.RefreshSubscriberValue();
        ArmyComboBox.ComboList.SetRowCount(TotalArrayLength);

        /*
        // Hardcoded reference for now
        if(ArmyIndexActual == SFOR_ARVN && bCombatPilotActual)
            ArmyComboBox.SetSelection(TeamIndexActual * FirstSouthIndex + SFOR_USArmy);
        else
            ArmyComboBox.SetSelection(TeamIndexActual * FirstSouthIndex + ArmyIndexActual);
        */
    }
}

function PopulateRoleList()
{
    local int i, ArrayLength;
    local string ClassName;

    ROCharCustStringsDataStore.Empty('ROCharCustRoleType');
    //ROCharCustStringsDataStore.AddStr('ROCharCustRoleType', BaselineString);  // Baseline
    ClassListIndexArray.Length = 0; //1;

    for(i = 0; i <= `DRCI_TANK_COMMANDER; i++)
    {
        ClassName = class'DRGameStatsRead'.static.GetClassNameByIndex(TeamIndex, i);
        if( ClassName != "Error!" )
        {
            ClassListIndexArray.AddItem(i);
            ROCharCustStringsDataStore.AddStr('ROCharCustRoleType', ClassName);
        }
    }

    ArrayLength = ClassListIndexArray.length;

    RoleComboBox.ComboList.RefreshSubscriberValue();
    RoleComboBox.ComboList.SetRowCount(ArrayLength);

    RoleComboBox.SetSelection(ClassListIndexArray.Find(ClassIndexActual));

    `log("PopulateRoleList(): ClassListIndexArray.Length = " $ ClassListIndexArray.Length,, 'DRDEV');
    for (i = 0; i < ClassListIndexArray.Length; ++i)
    {
        `log("ClassListIndexArray[" $ i $ "] = " $ ClassListIndexArray[i],, 'DRDEV');
    }
}

function PopulateCopyRoleList()
{
    local int i, ArrayLength, ArmyIndexRaw;
    local string ClassName;

    ROCharCustStringsDataStore.Empty('ROCharCustCopyRoleType');
    ROCharCustStringsDataStore.AddStr('ROCharCustCopyRoleType', AllRoleStrings[byte(bPilot)]);  // All Classes
    CopyRoleListIndexArray.length = 1;
    CopyRoleListIndexArray[0] = -1;

    ArmyIndexRaw = ArmyComboBox.ComboList.GetCurrentItem() - FirstSouthIndex * TeamIndex;

    /*
    // Pilot selected?
    if (bPilot)
    {
        // ARVN Combat pilots and Transport pilots are completely different, so never let them copy between each other
        if( ArmyIndexRaw != SFOR_ARVN && ClassIndex != `ROCI_COMBATPILOT )
        {
            ROCharCustStringsDataStore.AddStr('ROCharCustCopyRoleType',
                class'DRGameStatsRead'.static.GetClassNameByIndex(TeamIndex, `ROCI_COMBATPILOT));
            CopyRoleListIndexArray.AddItem(`ROCI_COMBATPILOT);
        }

        if( ArmyIndexRaw != SFOR_ARVN && ClassIndex != `ROCI_TRANSPORTPILOT )
        {
            CopyRoleListIndexArray.AddItem(`ROCI_TRANSPORTPILOT);
            ROCharCustStringsDataStore.AddStr('ROCharCustCopyRoleType',
                class'DRGameStatsRead'.static.GetClassNameByIndex(TeamIndex, `ROCI_TRANSPORTPILOT));
        }
    else
    {
    */
        for(i=0; i <= `DRCI_TANK_COMMANDER; i++)
        {
            ClassName = class'DRGameStatsRead'.static.GetClassNameByIndex(TeamIndex, i);
            if( ClassName != "Error!" && i != ClassIndex )
            {
                CopyRoleListIndexArray.AddItem(i);
                ROCharCustStringsDataStore.AddStr('ROCharCustCopyRoleType', ClassName);
            }
        }
    // }

    ArrayLength = CopyRoleListIndexArray.length;

    CopyRoleComboBox.ComboList.RefreshSubscriberValue();
    CopyRoleComboBox.ComboList.SetRowCount(ArrayLength);

    CopyRoleComboBox.SetSelection(0);
}


function RoleComboUpdated()
{
    local int ArmyIndexRaw;

    ClassIndex = ClassListIndexArray[Max(0,RoleComboBox.ComboList.GetCurrentItem())];

    ArmyIndexRaw = ArmyComboBox.ComboList.GetCurrentItem() - FirstSouthIndex * TeamIndex;

    bPilot = ClassIndex > `DRCI_COMMANDER;

    /*
    // Bit of a hack here for dealing with ARVN combat pilots seeing as they are different, special and a pita
    if( TeamIndex == 1 && ArmyIndexRaw == SFOR_ARVN && ClassIndex == `ROCI_CombatPilot )
        ArmyIndex = SFOR_USArmy;
    else
        ArmyIndex = ArmyIndexRaw;
    */

    ArmyIndex = ArmyIndexRaw;

    GetCurrentConfig();

    /*if( ClassIndex == -1 )
    {
        UseBaselineContainer.SetVisibility(false);
    }
    else
    {
        UseBaselineContainer.SetVisibility(true);
    }*/

    bUseBaseConfig = 0;
    UseBaselineCheckbox.SetValue(bool(bUseBaseConfig));

    bConfigChanged = false;
    ApplyButton.SetEnabled(false);
    CopyRoleButton.SetEnabled(true);

    if( bPostFirstRender && bInitialised )
    {
        PopulateCurrentPanel();
        UpdatePreviewMesh();
    }

    PopulateCopyRoleList();
}

function SetPawnHandler()
{
    local DRMapInfo DRMI;
    local int NorthArmyCount;

    if( ROCCM != none && ROCCM.PawnHandlerClass != none )
    {
        PawnHandlerClass = ROCCM.PawnHandlerClass;
        TunicSelectionWidget.PawnHandlerClass = PawnHandlerClass;
        TunicMatSelectionWidget.PawnHandlerClass = PawnHandlerClass;
        ShirtSelectionWidget.PawnHandlerClass = PawnHandlerClass;
        HeadSelectionWidget.PawnHandlerClass = PawnHandlerClass;
        HairColourSelectionWidget.PawnHandlerClass = PawnHandlerClass;
        HeadgearSelectionWidget.PawnHandlerClass = PawnHandlerClass;
        HeadgearMatSelectionWidget.PawnHandlerClass = PawnHandlerClass;
        FaceItemSelectionWidget.PawnHandlerClass = PawnHandlerClass;
        FacialHairSelectionWidget.PawnHandlerClass = PawnHandlerClass;
        TattooSelectionWidget.PawnHandlerClass = PawnHandlerClass;

        `log("SetPawnHandler(): PawnHandlerClass = " $ PawnHandlerClass,, 'DRDEV');

        DRMI = DRMapInfo(ROCCM.WorldInfo.GetMapInfo());

        if( DRMI != none )
        {
            NorthArmyCount = DRMI.GetNumArmiesForTeam(0);
            TunicSelectionWidget.TeamSplitValue = NorthArmyCount;
            TunicMatSelectionWidget.TeamSplitValue = NorthArmyCount;
            ShirtSelectionWidget.TeamSplitValue = NorthArmyCount;
            HeadSelectionWidget.TeamSplitValue = NorthArmyCount;
            HairColourSelectionWidget.TeamSplitValue = NorthArmyCount;
            HeadgearSelectionWidget.TeamSplitValue = NorthArmyCount;
            HeadgearMatSelectionWidget.TeamSplitValue = NorthArmyCount;
            FaceItemSelectionWidget.TeamSplitValue = NorthArmyCount;
            FacialHairSelectionWidget.TeamSplitValue = NorthArmyCount;
            TattooSelectionWidget.TeamSplitValue = NorthArmyCount;
        }
    }
}

/*
function ROMapInfo GetMapInfo()
{
    local DRMapInfo DRMI;

    if( ROPC != none )
    {
        DRMI = DRMapInfo(ROPC.WorldInfo.GetMapInfo());
    }

    return DRMI;
}
*/

function UpdateHonorDisplay()
{
    local int i, Shown;

    if( ROPC == none || ROPC.StatsWrite == none )
        return;

    UILabel(FindChild(HeaderHonorLevelLabelName, true)).SetValue(string(ROPC.StatsWrite.HonorLevel));

    if( ROPC.StatsWrite.HonorLevel >= 99 )
    {
        UIImage(FindChild(HeaderHonorMedalImageName, true)).ImageComponent.SetImage(
            class'DRUISceneUnitSelect'.default.HonorMedals[10]);

        for ( i = 1; i < 10; i++ )
        {
            UIImage(FindChild(name(string(HeaderHonorStarImageName)$i), true)).SetVisibility(false);
        }
    }
    else
    {
        UIImage(FindChild(HeaderHonorMedalImageName, true)).ImageComponent.SetImage(
            class'DRUISceneUnitSelect'.default.HonorMedals[ROPC.StatsWrite.HonorLevel / 10]);

        Shown = ROPC.StatsWrite.HonorLevel % 10;

        for ( i = 1; i < 10; i++ )
        {
            UIImage(FindChild(name(string(HeaderHonorStarImageName)$i), true)).SetVisibility(Shown >= i);
        }
    }
}

DefaultProperties
{
    PawnHandlerClass=class'DRPawnHandler'
}
