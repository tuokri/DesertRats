class DRCharCustMannequin extends ROCharCustMannequin
    notplaceable;

function UpdateMannequin(byte TeamIndex, byte ArmyIndex, bool bPilot, int ClassIndex, byte HonorLevel, byte TunicID, byte TunicMaterialID, byte ShirtID, byte HeadID, byte HairID, byte HeadgearID, byte HeadgearMatID, byte FaceItemID, byte FacialHairID, byte TattooID, optional bool bMainMenu)
{
    local Texture2D ShirtD, ShirtN, ShirtS, TattooTex;
    local byte bAltFieldgear, byteDisposal; // Out the SkinID to this byte because its used for FP arms (which we don't need).
    local float HonourPct;
    local byte bNoHeadgear, bNoFacialHair;
    local DRMapInfo DRMI;
    local float TattooUOffset, TattooVOffset, TattooDrawScale;
    local rotator InitialRot;

    // When the menu is populating drop downs, this function will get called a lot with invalid values. Don't let it.
    if( ArmyIndex == 255 )
        return;

    InitialRot = mesh.Rotation;

    DisplayedCharConfig.TunicMesh = TunicID;
    DisplayedCharConfig.TunicMaterial = TunicMaterialID;
    DisplayedCharConfig.ShirtTexture = ShirtID;
    DisplayedCharConfig.HeadMesh = HeadID;
    DisplayedCharConfig.HairMaterial = HairID;
    DisplayedCharConfig.HeadgearMesh = HeadgearID;
    DisplayedCharConfig.HeadgearMat = HeadgearMatID;
    DisplayedCharConfig.FaceItemMesh = FaceItemID;
    DisplayedCharConfig.FacialHairMesh = FacialHairID;
    DisplayedCharConfig.TattooTex = TattooID;

    // Build the mesh.
    If(HeadAndArmsMIC == none)
    {
        HeadAndArmsMIC = new class'MaterialInstanceConstant';
    }

    if(BodyMIC == none)
    {
        BodyMIC = new class'MaterialInstanceConstant';
    }

    if(HeadgearMIC == none)
    {
        HeadgearMIC = new class'MaterialInstanceConstant';
    }

    if(HairMIC == none)
    {
        HairMIC = new class'MaterialInstanceConstant';
    }

    if( ThirdPersonHeadgearMeshComponent.AttachedToSkelComponent != none )
        Mesh.DetachComponent(ThirdPersonHeadgearMeshComponent);
    if( FaceItemMeshComponent.AttachedToSkelComponent != none )
        Mesh.DetachComponent(FaceItemMeshComponent);
    if( FacialHairMeshComponent.AttachedToSkelComponent != none )
        Mesh.DetachComponent(FacialHairMeshComponent);
    if( ThirdPersonHeadAndArmsMeshComponent.AttachedToSkelComponent != none )
        Mesh.DetachComponent(ThirdPersonHeadAndArmsMeshComponent);
    if( WeaponMeshComponent.AttachedToSkelComponent != none )
        Mesh.DetachComponent(WeaponMeshComponent);

    if( ClassIndex < 0 || bMainMenu )
    {
        ClassIndex = bPilot ? `DRCI_TANK_CREW : `DRCI_ASSAULT;
    }

    bAltFieldgear = (TeamIndex == `AXIS_TEAM_INDEX) ? TunicMaterialID : 0;
    bIsPilot = bPilot;

    TunicMesh = PawnHandlerClass.static.GetTunicMeshes(TeamIndex, ArmyIndex, byte(bPilot), TunicID, bNoHeadgear);
    BodyMICTemplate = PawnHandlerClass.static.GetBodyMIC(TeamIndex, ArmyIndex, byte(bPilot), TunicID, TunicMaterialID);
    FieldgearMesh = PawnHandlerClass.static.GetFieldgearMesh(TeamIndex, ArmyIndex, TunicID, ClassIndex, bAltFieldgear);
    HeadAndArmsMesh = PawnHandlerClass.static.GetHeadAndArmsMesh(TeamIndex, ArmyIndex, byte(bPilot), HeadID, byteDisposal); // Out the SkinID (last param) to our bogus byte because its used for FP arms (which we don't need).
    HeadAndArmsMICTemplate = PawnHandlerClass.static.GetHeadMIC(TeamIndex, ArmyIndex, HeadID, TunicID, byte(bPilot));
    HeadgearMesh = PawnHandlerClass.static.GetHeadgearMesh(TeamIndex, ArmyIndex, byte(bPilot), HeadID, HairID, HeadgearID, HeadgearMatID, HeadgearMICTemplate, HairMICTemplate, HeadgearAttachSocket, byteDisposal);
    FaceItemMesh = PawnHandlerClass.static.GetFaceItemMesh(TeamIndex, ArmyIndex, byte(bPilot), HeadgearID, FaceItemID, FaceItemAttachSocket, bNoFacialHair);
    FacialHairMesh = PawnHandlerClass.static.GetFacialHairMesh(TeamIndex, ArmyIndex, FacialHairID, FacialHairAttachSocket);

    BodyMIC.SetParent(BodyMICTemplate);
    HeadAndArmsMIC.SetParent(HeadAndArmsMICTemplate);
    HeadgearMIC.SetParent(HeadgearMICTemplate);
    HairMIC.SetParent(HairMICTemplate);

    if(HeadAndArmsMIC != none)
    {
        // Cleanup all params first
        HeadAndArmsMIC.ClearParameterValues();

        // Now set our selections again. Have to do it this way to avoid either shirts or tattoos causing a cleanup of the other
        if( ShirtID > 0 && PawnHandlerClass.static.GetShirtTextures(TeamIndex, ArmyIndex, byte(bPilot), TunicID, ShirtID, ShirtD, ShirtN, ShirtS) )
        {
            HeadAndArmsMIC.SetTextureParameterValue(PawnHandlerClass.default.ShirtDiffuseParam,ShirtD);
            HeadAndArmsMIC.SetTextureParameterValue(PawnHandlerClass.default.ShirtNormalParam,ShirtN);
            HeadAndArmsMIC.SetTextureParameterValue(PawnHandlerClass.default.ShirtSpecParam,ShirtS);
        }

        TattooTex = PawnHandlerClass.static.GetTattooTexture(TeamIndex, ArmyIndex, byte(bPilot), TattooID, TattooUOffset, TattooVOffset, TattooDrawScale);

        if( TattooID > 0 && TattooTex != none )
        {
            HeadAndArmsMIC.SetTextureParameterValue(PawnHandlerClass.default.TattooParam, TattooTex);
            HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.TattooUOffsetParam,TattooUOffset);
            HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.TattooVOffsetParam,TattooVOffset);
            HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.TattooDrawScaleParam,TattooDrawScale);
        }
    }

    DRMI = DRMapInfo(WorldInfo.GetMapInfo());

    if(DRMI != none)
    {
        CompositedBodyMesh = DRMI.GetCachedCompositedPawnMesh(TunicMesh, FieldgearMesh);
    }
    else
    {
        `log("*** WARNING! - "$self$" - DRMI = NONE! Couldn't set composite mesh for customization mannequin.");
        return;
    }

    CompositedBodyMesh.Characterization = PlayerHIKCharacterization;

    // Update the mannequin actor's mesh with the composite ones from our config.
    Mesh.ReplaceSkeletalMesh(CompositedBodyMesh);

    Mesh.SetMaterial(0, BodyMIC);

    // Generate list of bones which override the animation transforms (this is usually the face bones)
    Mesh.GenerateAnimationOverrideBones(HeadAndArmsMesh);

    ThirdPersonHeadAndArmsMeshComponent.SetSkeletalMesh(HeadAndArmsMesh);
    ThirdPersonHeadAndArmsMeshComponent.SetMaterial(0, HeadAndArmsMIC);
    ThirdPersonHeadAndArmsMeshComponent.SetParentAnimComponent(Mesh);
    ThirdPersonHeadAndArmsMeshComponent.SetShadowParent(Mesh);
    ThirdPersonHeadAndArmsMeshComponent.SetLODParent(Mesh);
    AttachComponent(ThirdPersonHeadAndArmsMeshComponent);

    // Apply a wear level to our head and tunic as appropriate for our class' current rank
    HonourPct = FClamp(HonorLevel / 100, 0.0, 1.0);

    // Pilots should not be very dirty since they're not running around on the ground!
    if (bPilot)
    {
        HonourPct *= 0.5;
    }

    HonourPct = 0;

    // TODO:
    // Apply a wear level to our head and tunic as appropriate for our current honour level
    BodyMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicGrimeParam, HonourPct);
    BodyMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicMudParam, HonourPct * 5.0);
    HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.HeadGrimeParam, HonourPct);
    HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.HeadMudParam, HonourPct * 5.0);

    // Attach headgear, if any.
    if( HeadgearMesh != none && bNoHeadgear == 0 )
    {
        AttachNewHeadgear(HeadgearMesh);
    }

    // Attach face item
    if( FaceItemID > 0 && FaceItemMesh != none )
    {
        AttachNewFaceItem(FaceItemMesh);
    }

    // Attach facial hair
    if( FacialHairID > 0 && FacialHairMesh != none && bNoFacialHair == 0 )
    {
        AttachNewFacialHair(FacialHairMesh);
    }

    AttachPreviewWeapon(TeamIndex, ArmyIndex);

    mesh.SetRotation(InitialRot);
}

function PlayIdleAnim()
{
    super.PlayIdleAnim();

    `log("DRCharCustMannequin.PlayIdleAnim()",, 'DRDEV');
}

DefaultProperties
{
    PawnHandlerClass=class'DRPawnHandler'

    // TODO:
    WeaponMeshes.Empty
    WeaponMeshes(0)=(WeaponMesh=SkeletalMesh'DR_WP_DAK_KAR98.Mesh.Kar98_3rd',RelativeLocation=(X=0,Y=0,Z=0),WeaponType=1) // PAVN
    WeaponMeshes(1)=(WeaponMesh=SkeletalMesh'DR_WP_DAK_KAR98.Mesh.Kar98_3rd',RelativeLocation=(X=0,Y=0,Z=0),WeaponType=1) // NLF
    WeaponMeshes(2)=(WeaponMesh=SkeletalMesh'DR_WP_DAK_KAR98.Mesh.Kar98_3rd',RelativeLocation=(X=0,Y=0,Z=0),WeaponType=1) // US Army
    WeaponMeshes(3)=(WeaponMesh=SkeletalMesh'DR_WP_DAK_KAR98.Mesh.Kar98_3rd',RelativeLocation=(X=0,Y=0,Z=0),WeaponType=1) // USMC
    WeaponMeshes(4)=(WeaponMesh=SkeletalMesh'DR_WP_DAK_KAR98.Mesh.Kar98_3rd',RelativeLocation=(X=0,Y=0,Z=0),WeaponType=1) // Aus Army
    WeaponMeshes(5)=(WeaponMesh=SkeletalMesh'DR_WP_DAK_KAR98.Mesh.Kar98_3rd',RelativeLocation=(X=0,Y=0,Z=0),WeaponType=1) // ARVN
}
