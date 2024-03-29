class DRPawn extends ROPawn
    abstract;

var private bool bLeftVehicleRecently;

// --- BEGIN SOUNDCUE BACKPORT ---

var protected DRAudioComponent DialogAudioComp;

struct DelayedSpeakLineParamStructCustom extends DelayedSpeakLineParamStruct
{
    var SoundCue CustomAudio;
};

var protected DelayedSpeakLineParamStructCustom DelayedSpeakLineParamsCustom;

// --- END SOUNDCUE BACKPORT ---

// cosmetics and other things ~ @adrian
var SkeletalMesh FaceMasks;
var ROSkeletalMeshComponent FaceMasksComponent;
var MaterialInstanceConstant FaceMasksMIC;

var ROSkeletalMeshComponent HideHeadComponent;


simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    if (WorldInfo.NetMode == NM_DedicatedServer)
    {
        DetachComponent(DialogAudioComp);
    }
}

function bool InGodMode()
{
    return DRPlayerController(Controller).bGodDR || Controller.bGodMode;
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum,
    class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Super.TakeDamage((WorldInfo.NetMode == NM_Standalone && InGodMode()) ? 0 : Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

function ClearLeftVehicleFlag()
{
    bLeftVehicleRecently = False;
    ClearTimer('ClearLeftVehicleFlag');
}

function SetLeftVehicleFlag()
{
    bLeftVehicleRecently = True;
    SetTimer(3, False, 'ClearLeftVehicleFlag');
}

simulated function SetPawnElementsByConfig(bool bViaReplication, optional ROPlayerReplicationInfo OverrideROPRI)
{
    local int TeamNum, ArmyIndex, ClassIndex, HonorLevel, VoiceIndex;
    local DRMapInfo DRMI;
    local ROPlayerReplicationInfo ROPRI;
    local byte IsHelmet, TunicID, TunicMatID, ShirtID, HeadID, HairID, HeadgearID, HeadgearMatID, SkinID, FaceItemID, FacialHairID, TattooID, bPilot;
    local Texture2D ShirtD, ShirtN, ShirtS, TattooTex;
    local float TattooUOffset, TattooVOffset, TattooDrawScale;
    local byte bNoHeadgear, bNoFacialHair;

    if( PawnHandlerClass == none )
        PawnHandlerClass = class<ROGameInfo>(WorldInfo.GetGameClass()).default.PawnHandlerClass;

    if( PawnHandlerClass == none )
    {
        `warn(self@"does not have a PawnHandlerClass! Unable to set character customisation.");
        return;
    }

    TeamNum = GetTeamNum();
    DRMI = DRMapInfo(WorldInfo.GetMapInfo());

    if( OverrideROPRI != none )
        ROPRI = OverrideROPRI;
    else
        ROPRI = DRPlayerReplicationInfo(PlayerReplicationInfo);

    if( ROPRI != none )
    {
        if( ROPRI.RoleInfo != none )
        {
            ClassIndex = ROPRI.RoleInfo.ClassIndex;
        }

        if( !ROPRI.bBot )
        {
            if( bViaReplication )
            {
                HonorLevel = int(ROPRI.HonorLevel);
            }
            else if( ROPlayerController(Controller) != none )
            {
                ROPlayerController(Controller).StatsWrite.UpdateHonorLevel();
                HonorLevel = ROPlayerController(Controller).StatsWrite.HonorLevel;
            }
        }
    }

    // Sometimes when joining a game in progress, the team will not replicate in time and will be 255.
    // This failsafe catches that and works out the correct team based on the type of pawn
    if( TeamNum == 255 )
    {
        if( IsA('DRPawnAxis') )
            TeamNum = `AXIS_TEAM_INDEX;
        else if( IsA('DRPawnAllies') )
            TeamNum = `ALLIES_TEAM_INDEX;
    }

    if (DRMI != none)
    {
        if (TeamNum == `AXIS_TEAM_INDEX)
        {
            ArmyIndex = DRMI.NorthernForce;
        }
        else
        {
            ArmyIndex = DRMI.SouthernForce;
        }
    }

    if (ROPRI.RoleInfo != None)
    {
        if (ROPRI.RoleInfo.bCanBeTankCrew)
        {
            bPilot = `BPILOT_TANKCREW;
        }
        else if (ROPRI.RoleInfo.bIsTeamLeader)
        {
            bPilot = `BPILOT_COMMANDER;
        }
    }

    if( !bViaReplication && IsHumanControlled() )
    {
    //  if(  )
            PawnHandlerClass.static.GetCharConfig(TeamNum, ArmyIndex, bPilot, ClassIndex, HonorLevel, TunicID, TunicMatID, ShirtID, HeadID, HairID, HeadgearID, HeadgearMatID, FaceItemID, FacialHairID, TattooID, ROPRI);

            /*
            // Hardcoded for ARVN, until such time as we ever have any other factions that require alternate nationality pilots
            if( ArmyIndex == SFOR_ARVN && bPilot == 2 )
                ROPRI.bUsesAltVoicePacks = true;
            else
            */
                ROPRI.bUsesAltVoicePacks = false;
    //  else
    //      PawnHandlerClass.static.GetCharConfig(TeamNum, ArmyIndex, bPilot, HonorLevel, TunicID, TunicMatID, ShirtID, HeadID, HairID, HeadgearID, FaceItemID, FacialHairID, TattooID, ROPRI, true);
    }
    else if( ROPRI != none )
    {
        TunicID = ROPRI.CurrentCharConfig.TunicMesh;
        TunicMatID = ROPRI.CurrentCharConfig.TunicMaterial;
        ShirtID = ROPRI.CurrentCharConfig.ShirtTexture;
        HeadID = ROPRI.CurrentCharConfig.HeadMesh;
        HairID = ROPRI.CurrentCharConfig.HairMaterial;
        HeadgearID = ROPRI.CurrentCharConfig.HeadgearMesh;
        HeadgearMatID = ROPRI.CurrentCharConfig.HeadgearMaterial;
        FaceItemID = ROPRI.CurrentCharConfig.FaceItemMesh;
        FacialHairID = ROPRI.CurrentCharConfig.FacialHairMesh;
        TattooID = ROPRI.CurrentCharConfig.TattooTex;

        // This is a remote player's config, so lets sanity check it to make sure they've not sent something invalid
        PawnHandlerClass.static.ValidateCharConfig(TeamNum, ArmyIndex, bPilot, HonorLevel, TunicID, TunicMatID, ShirtID, HeadID, HairID, HeadgearID, HeadgearMatID, FaceItemID, FacialHairID, TattooID, ROPRI);
    }
    else
    {
        TunicID = 0;
        TunicMatID = 0;
        ShirtID = 0;
        HeadID = 0;
        HairID = 0;
        HeadgearID = 0;
        HeadgearMatID = 0;
        FaceItemID = 0;
        FacialHairID = 0;
        TattooID = 0;
    }

    if (ROPRI.bBot)
    {
        // Randomizes these for bots as well since vanilla bots dont seem to get any facial hair or tats...
        // FaceItemID = rand(7);
        // TattooID = rand(7);
        if( fRand() < 0.35) // low chance for bots to equip face mask
        {
            FacialHairID = Rand(5);
        }
    }

    // Set Tunic Meshes and Materials
    TunicMesh = PawnHandlerClass.static.GetTunicMeshes(TeamNum, ArmyIndex, bPilot, TunicID, bNoHeadgear);
    BodyMICTemplate = PawnHandlerClass.static.GetBodyMIC(TeamNum, ArmyIndex, bPilot, TunicID, TunicMatID);

    PawnMesh_SV = PawnHandlerClass.static.GetTunicMeshSV(TeamNum, ArmyIndex, ClassIndex, bPilot, bHasFlamethrower, BodyMICTemplate_SV);

    // Set Fieldgear mesh
    if( TeamNum == `AXIS_TEAM_INDEX )
        FieldgearMesh = PawnHandlerClass.static.GetFieldgearMesh(TeamNum, ArmyIndex, TunicID, ClassIndex, TunicMatID);
    else
        FieldgearMesh = PawnHandlerClass.static.GetFieldgearMesh(TeamNum, ArmyIndex, TunicID, ClassIndex, byte(bHasFlamethrower));

    // Set Head Mesh and Mats
    HeadAndArmsMesh = PawnHandlerClass.static.GetHeadAndArmsMesh(TeamNum, ArmyIndex, bPilot, HeadID, SkinID);

    // Quick and dirty hack to fix single variant meshes not having foot textures if the player's actual chosen tunic was fancy
    if( bUseSingleCharacterVariant )
        HeadAndArmsMICTemplate = PawnHandlerClass.static.GetHeadMIC(TeamNum, ArmyIndex, HeadID, 0, bPilot);
    else
        HeadAndArmsMICTemplate = PawnHandlerClass.static.GetHeadMIC(TeamNum, ArmyIndex, HeadID, TunicID, bPilot);

    // Set Shirt Texture if required
    if( ShirtID > 0 && HeadAndArmsMIC != none && PawnHandlerClass.static.GetShirtTextures(TeamNum, ArmyIndex, bPilot, TunicID, ShirtID, ShirtD, ShirtN, ShirtS) )
    {
        HeadAndArmsMIC.SetTextureParameterValue(PawnHandlerClass.default.ShirtDiffuseParam,ShirtD);
        HeadAndArmsMIC.SetTextureParameterValue(PawnHandlerClass.default.ShirtNormalParam,ShirtN);
        HeadAndArmsMIC.SetTextureParameterValue(PawnHandlerClass.default.ShirtSpecParam,ShirtS);
    }

    // Set Tattoo Texture if required
    if( TattooID > 0 )
    {
        TattooTex = PawnHandlerClass.static.GetTattooTexture(TeamNum, ArmyIndex, bPilot, TattooID, TattooUOffset, TattooVOffset, TattooDrawScale);

        if( TattooTex != none && HeadAndArmsMIC != none )
        {
            HeadAndArmsMIC.SetTextureParameterValue(PawnHandlerClass.default.TattooParam,TattooTex);
            HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.TattooUOffsetParam,TattooUOffset);
            HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.TattooVOffsetParam,TattooVOffset);
            HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.TattooDrawScaleParam,TattooDrawScale);
        }
    }

    // Gore meshes
    if( !bUseSingleCharacterVariant )
    {
        UberGoreMesh = PawnHandlerClass.static.GetGoreMeshes(TeamNum, ArmyIndex, TunicID, SkinID, GoreMIC, Gore_LeftHand.GibClass, Gore_RightHand.GibClass, Gore_LeftLeg.GibClass, Gore_RightLeg.GibClass);
    }

    // Set first person arms mesh and skin texture
    ArmsOnlyMeshFP = PawnHandlerClass.static.GetFPArmsMesh(TeamNum, ArmyIndex, bPilot, TunicID, TunicMatID, SkinID, FPArmsSkinMaterialTemplate, FPArmsSleeveMaterialTemplate);

    // Set Headgear
    if( bNoHeadgear == 0 )
        HeadgearMesh = PawnHandlerClass.static.GetHeadgearMesh(TeamNum, ArmyIndex, bPilot, HeadID, HairID, HeadgearID, HeadgearMatID, HeadgearMICTemplate, HairMICTemplate, HeadgearAttachSocket, IsHelmet);
    else
        HeadgearMesh = none;

    // Set the type of sound played on headshot
    if( IsHelmet != 0 )
        bHeadGearIsHelmet = true;
    else
        bHeadGearIsHelmet = false;

    // Set Face Items
    FaceItemMesh = PawnHandlerClass.static.GetFaceItemMesh(TeamNum, ArmyIndex, bPilot, HeadgearID, FaceItemID, FaceItemAttachSocket, bNoFacialHair);
    FacialHairMesh = bNoFacialHair == 1 ? none : PawnHandlerClass.static.GetFacialHairMesh(TeamNum, ArmyIndex, FacialHairID, FacialHairAttachSocket);
    FaceMasks = class'DRPawnHandler'.static.GetCovidMasks(TeamNum, ArmyIndex, FacialHairID);

    // Set the voice locally if we're playing offline or as a listen server
    if( Role == ROLE_Authority && ROPlayerController(Controller) != none )
    {
        if( TeamNum == `AXIS_TEAM_INDEX )
            ROPlayerController(Controller).SetSuitableVoicePack(TeamNum, ArmyIndex, 0);
        else
            ROPlayerController(Controller).SetSuitableVoicePack(TeamNum, ArmyIndex, SkinID);
    }
    else // bot
    {
        if (ROPRI.bBot)
        {
            VoiceIndex = rand(3);
        }

        ROPRI.VoicePackIndex = VoiceIndex;
    }
}

simulated function CreatePawnMesh()
{
    local DRMapInfo DRMI;
    local float HonourPct;
    local ROPlayerReplicationInfo ROPRI;
    local MaterialInterface GearMat;

    // Since this function now gets called twice, make sure that it can't run if the player is dead, as that leads to major problems
    if( Health <= 0 )
        return;

    // Third person MICs
    if( HeadAndArmsMIC == none )
        HeadAndArmsMIC = new class'MaterialInstanceConstant';
    if( BodyMIC == none )
        BodyMIC = new class'MaterialInstanceConstant';
    if( GearMIC == none )
        GearMIC = new class'MaterialInstanceConstant';
    if( HeadgearMIC == none )
        HeadgearMIC = new class'MaterialInstanceConstant';
    if( HairMIC == none && HairMICTemplate != none )
        HairMIC = new class'MaterialInstanceConstant';
    if( FPArmsSleeveMaterial == none && FPArmsSleeveMaterialTemplate != none )
        FPArmsSleeveMaterial = new class'MaterialInstanceConstant';
    if( FPArmsSkinMaterial == none && FPArmsSkinMaterialTemplate != none )
        FPArmsSkinMaterial = new class'MaterialInstanceConstant';

    if( bUseSingleCharacterVariant && BodyMICTemplate_SV != none )
        BodyMIC.SetParent(BodyMICTemplate_SV);
    else
        BodyMIC.SetParent(BodyMICTemplate);

    HeadAndArmsMIC.SetParent(HeadAndArmsMICTemplate);
    HeadgearMIC.SetParent(HeadgearMICTemplate);

    if( HairMIC != none )
        HairMIC.SetParent(HairMICTemplate);

    if( FPArmsSleeveMaterial != none )
        FPArmsSleeveMaterial.SetParent(FPArmsSleeveMaterialTemplate);

    if( FPArmsSkinMaterial != none )
        FPArmsSkinMaterial.SetParent(FPArmsSkinMaterialTemplate);

    MeshMICs.Length = 0;
    MeshMICs.AddItem(BodyMIC);
    MeshMICs.AddItem(HeadAndArmsMIC);
    MeshMICs.AddItem(HeadgearMIC);
    MeshMICs.AddItem(GearMIC);

    // Remove existing attachments before we start setting new ones. If we don't do this, we cause a whole world of problems later
    if( ThirdPersonHeadgearMeshComponent.AttachedToSkelComponent != none )
        mesh.DetachComponent(ThirdPersonHeadgearMeshComponent);
    if( FaceItemMeshComponent.AttachedToSkelComponent != none )
        mesh.DetachComponent(FaceItemMeshComponent);
    if( FacialHairMeshComponent.AttachedToSkelComponent != none )
        mesh.DetachComponent(FacialHairMeshComponent);
    if( ThirdPersonHeadAndArmsMeshComponent.AttachedToSkelComponent != none )
        DetachComponent(ThirdPersonHeadAndArmsMeshComponent);
    if( TrapDisarmToolMeshTP.AttachedToSkelComponent != none )
        mesh.DetachComponent(TrapDisarmToolMeshTP);

    DRMI = DRMapInfo(WorldInfo.GetMapInfo());

    if( !bUseSingleCharacterVariant && DRMI != none)
    {
        CompositedBodyMesh = DRMI.GetCachedCompositedPawnMesh(TunicMesh, FieldgearMesh);
    }
    else
    {
        // Use the single-variant mesh
        CompositedBodyMesh = PawnMesh_SV;
    }

    // Assign the HumanIK characterization
    CompositedBodyMesh.Characterization = PlayerHIKCharacterization;

    // Apply the body mesh and material to the pawn's third person mesh
    ROSkeletalMeshComponent(mesh).ReplaceSkeletalMesh(CompositedBodyMesh);


    mesh.SetMaterial(0, BodyMIC);

    //GearMat = mesh.GetMaterial(1);
    GearMat = FieldgearMesh.Materials[1];

    if( GearMIC != none && GearMat != none )
    {
        GearMIC.SetParent(GearMat);
        mesh.SetMaterial(1, GearMIC);
    }


    BodyMIC.SetScalarParameterValue('Grime_Scaler', 0.5);
    GearMIC.SetScalarParameterValue('Grime_Scaler', 0.5);
    HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.HeadGrimeParam, 0.5);
    HeadgearMIC.SetScalarParameterValue('Grime_Scaler', 0.5);

    // Generate list of bones which override the animation transforms (this is usually the face bones)
    ROSkeletalMeshComponent(mesh).GenerateAnimationOverrideBones(HeadAndArmsMesh);

    // Parent the third person head and arms mesh to the body mesh
    ThirdPersonHeadAndArmsMeshComponent.SetSkeletalMesh(HeadAndArmsMesh);
    ThirdPersonHeadAndArmsMeshComponent.SetMaterial(0, HeadAndArmsMIC);
    ThirdPersonHeadAndArmsMeshComponent.SetParentAnimComponent(mesh);
    ThirdPersonHeadAndArmsMeshComponent.SetShadowParent(mesh);
    ThirdPersonHeadAndArmsMeshComponent.SetLODParent(mesh);
    AttachComponent(ThirdPersonHeadAndArmsMeshComponent);

    // if(WorldInfo.NetMode != NM_DedicatedServer)
    // {
    //  HeadAndArmsMIC.SetTextureParameterValue(HitMaskParamName, HitMaskRenderTargetHeadArms);
    // }

    HideHeadComponent.SetSkeletalMesh(ArmsOnlyMesh);
    HideHeadComponent.SetMaterial(0, HeadAndArmsMIC);
    HideHeadComponent.SetLODParent(mesh);
    HideHeadComponent.SetParentAnimComponent(mesh);
    HideHeadComponent.SetShadowParent(mesh);

    // Attach headgear
    if( HeadgearMesh != none )
    {
        AttachNewHeadgear(HeadgearMesh);
    }

    // Attach face item
    if( FaceItemMesh != none )
    {
        AttachNewFaceItem(FaceItemMesh);
    }

    // Attach facial hair
    if( FacialHairMesh != none )
    {
        AttachNewFacialHair(FacialHairMesh);
    }

    // Attach cloth if there is any
    if ( ClothComponent != None )
    {
        ClothComponent.SetParentAnimComponent(mesh);
        ClothComponent.SetShadowParent(mesh);
        AttachComponent(ClothComponent);
        ClothComponent.SetEnableClothSimulation(true);
        ClothComponent.SetAttachClothVertsToBaseBody(true);
    }

    // Set first person arms mesh
    if ( ArmsMesh != None )
    {
        ArmsMesh.SetSkeletalMesh(ArmsOnlyMeshFP);

        if( FPArmsSkinMaterial != none )
            ArmsMesh.SetMaterial(0, FPArmsSkinMaterial);

        if( FPArmsSleeveMaterial != none )
            ArmsMesh.SetMaterial(1, FPArmsSleeveMaterial);
    }

    // Set first person bandage
    if ( BandageMesh != none )
    {
        BandageMesh.SetSkeletalMesh(BandageMeshFP);
        BandageMesh.SetHidden(true);
    }

    if( FaceMasksComponent != none)
    {
        if( FaceMasksMIC != none)
        {
            FaceMasksMIC = new class'MaterialInstanceConstant';
        }

        FaceMasksMIC.SetParent(FaceMasks.Materials[0]);

        FaceMasksComponent.SetMaterial(0, FaceMasksMIC);
        FaceMasksComponent.SetSkeletalMesh(FaceMasks);
        FaceMasksComponent.SetParentAnimComponent(mesh);
        FaceMasksComponent.SetShadowParent(mesh);
        FaceMasksComponent.SetActorCollision(false, false);
        FaceMasksComponent.SetNotifyRigidBodyCollision(false);
        FaceMasksComponent.SetTraceBlocking(false, false);

        MeshMICs.AddItem(FaceMasksMIC);

        AttachCovidMasks(FaceMasks);

        //AttachComponent(FaceMasksComponent);
    }

    // Set first and third person trap disarm tool
    if ( DRMI != none )
    {
        // First Person
        if ( TrapDisarmToolMesh != none )
        {
            TrapDisarmToolMesh.SetSkeletalMesh(GetTrapDisarmToolMesh(true));
        }

        // Third Person
        if ( TrapDisarmToolMeshTP != none )
        {
            TrapDisarmToolMeshTP.SetSkeletalMesh(GetTrapDisarmToolMesh(false));
        }
    }

    if ( TrapDisarmToolMesh != none )
    {
        TrapDisarmToolMesh.SetHidden(true);
    }

    if ( TrapDisarmToolMeshTP != none )
    {
        Mesh.AttachComponentToSocket(TrapDisarmToolMeshTP, GrenadeSocket);
        TrapDisarmToolMeshTP.SetHidden(true);
    }

    ROPRI = ROPlayerReplicationInfo(PlayerReplicationInfo);

    if( ROPRI != none )
    {
        HonourPct = FClamp(ROPRI.HonorLevel / 100.f, 0.0, 1.0);
    }

    // PAX Build, to randomise grime when everyone's level 0
    //HonourPct = FRand();

    // Pilots should not be very dirty since they're not running around on the ground!
    if( bIsPilot )
    {
        HonourPct *= 0.5;
    }

    HonourPct = 0;

    if( PawnHandlerClass != none )
    {
        // TODO: dynamic dirt.
        // Apply a wear level to our head and tunic as appropriate for our current honour level
        BodyMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicGrimeParam, HonourPct);
        BodyMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicMudParam, HonourPct * 5.0);
        HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.HeadGrimeParam, HonourPct);
        HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.HeadMudParam, HonourPct * 5.0);

        if( GearMIC != none && GearMat != none )
        {
            GearMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicGrimeParam, HonourPct);
            GearMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicMudParam, HonourPct * 5.0);
        }

        if( HeadgearMIC != none )
        {
            HeadgearMIC.SetScalarParameterValue(PawnHandlerClass.default.HeadGrimeParam, HonourPct);
            HeadgearMIC.SetScalarParameterValue(PawnHandlerClass.default.HeadMudParam, HonourPct * 5.0);
        }
    }

    if ( bOverrideLighting )
    {
        ThirdPersonHeadAndArmsMeshComponent.SetLightingChannels(LightingOverride);
        ThirdPersonHeadgearMeshComponent.SetLightingChannels(LightingOverride);
    }

    // Set the server to use the lowest LOD for the mesh
    if( WorldInfo.NetMode == NM_DedicatedServer )
    {
        mesh.ForcedLODModel = 1000;
        ThirdPersonHeadAndArmsMeshComponent.ForcedLodModel = 1000;
        ThirdPersonHeadgearMeshComponent.ForcedLodModel = 1000;
        FaceItemMeshComponent.ForcedLodModel = 1000;
        FacialHairMeshComponent.ForcedLodModel = 1000;
    }
}

simulated function AttachCovidMasks(SkeletalMesh NewHeadgearMesh)
{
    local SkeletalMeshSocket FacialHairSocket;

    FacialHairSocket = ThirdPersonHeadAndArmsMeshComponent.GetSocketByName(FacialHairAttachSocket);

    if( FacialHairSocket != none )
    {
       if( mesh.MatchRefBone(FacialHairSocket.BoneName) != INDEX_NONE )
       {
           FaceMasksComponent.SetShadowParent(mesh);
           FaceMasksComponent.SetLODParent(mesh);
           mesh.AttachComponent(FaceMasksComponent, FacialHairSocket.BoneName, FacialHairSocket.RelativeLocation, FacialHairSocket.RelativeRotation, FacialHairSocket.RelativeScale);
       }
       else
       {
            `warn("Bone name specified in socket not found in parent anim component. Facial Mask component will not be attached");
       }
    }
}

simulated function AttachNewHeadgear(SkeletalMesh NewHeadgearMesh)
{
    local SkeletalMeshSocket HeadSocket;

    ThirdPersonHeadgearMeshComponent.SetSkeletalMesh(NewHeadgearMesh);
    // ThirdPersonHeadgearMeshComponent.SetMaterial(0, HeadgearMIC);

    HeadSocket = ThirdPersonHeadAndArmsMeshComponent.GetSocketByName(HeadgearAttachSocket);

    if( HeadSocket != none )
    {
        if( mesh.MatchRefBone(HeadSocket.BoneName) != INDEX_NONE )
        {
            ThirdPersonHeadgearMeshComponent.SetShadowParent(mesh);
            ThirdPersonHeadgearMeshComponent.SetLODParent(mesh);
            mesh.AttachComponent( ThirdPersonHeadgearMeshComponent, HeadSocket.BoneName, HeadSocket.RelativeLocation, HeadSocket.RelativeRotation, HeadSocket.RelativeScale);
        }
    }
}

simulated function SetMeshVisibility(bool bVisible)
{
    super.SetMeshVisibility(bVisible);

    if ( FaceMasksComponent != None )
    {
        FaceMasksComponent.SetOwnerNoSee(!bVisible);
    }

    // For local player and servers, update the mesh even if not rendered. For, all simulated pawns
    // update it for a few seconds when they come into view, otherwise animations are not updated
    if( !bVisible || WorldInfo.NetMode == NM_DedicatedServer || WorldInfo.NetMode == NM_ListenServer )
    {
        mesh.bUpdateSkelWhenNotRendered = true;
        ThirdPersonHeadAndArmsMeshComponent.bUpdateSkelWhenNotRendered = true;
        ThirdPersonHeadgearMeshComponent.bUpdateSkelWhenNotRendered = true;

        if( FaceMasksComponent != None )
        {
            FaceMasksComponent.bUpdateSkelWhenNotRendered = true;
        }
    }
    else
    {
        Mesh.AnimatingIntoView(2.f);
        ThirdPersonHeadAndArmsMeshComponent.AnimatingIntoView(2.0);
        ThirdPersonHeadgearMeshComponent.AnimatingIntoView(2.0);

        if( FaceMasksComponent != none )
        {
            FaceMasksComponent.AnimatingIntoView(2.0);
        }
    }
    // Handle third person weapon
    SetWeaponAttachmentVisibility(bVisible);

    SetWeaponVisibility(!bVisible);
}

simulated function SetLightingChannels(LightingChannelContainer InLightingChannels)
{
    super.SetLightingChannels(InLightingChannels);

    if( FaceMasksComponent != none)
    {
        FaceMasksComponent.SetLightingChannels(InLightingChannels);
    }
}

simulated function SetLightEnvironment(LightEnvironmentComponent InLightEnvironment)
{
    super.SetLightEnvironment(InLightEnvironment);

    if( FaceMasksComponent != none)
    {
        FaceMasksComponent.SetLightEnvironment(InLightEnvironment);
    }
}


simulated event StartDriving(Vehicle V)
{
    Super.StartDriving(V);

    if ( ROVehicleBase(V) != none && V.Mesh.DepthPriorityGroup == SDPG_Foreground && Mesh.DepthPriorityGroup == SDPG_World )
    {
        if( FaceMasksComponent != none )
        {
            FaceMasksComponent.SetDepthPriorityGroup(SDPG_Foreground);
        }
    }
}


simulated event StopDriving(Vehicle V)
{
    Super.StopDriving(V);

    if ( V != none && V.Mesh.DepthPriorityGroup == SDPG_World && Mesh.DepthPriorityGroup == SDPG_Foreground )
    {
        if( FaceMasksComponent != none )
        {
            FaceMasksComponent.SetDepthPriorityGroup(SDPG_World);
        }
    }
}

simulated function UpdateWetnessValue(float DeltaTime)
{
    local bool bWetnessChanged;

    if( WetnessValue > TargetWetnessValue )
    {
        WetnessValue = FInterpConstantTo(WetnessValue, TargetWetnessValue, DeltaTime, 0.02);
        bWetnessChanged = true;
    }
    else if( WetnessValue < TargetWetnessValue )
    {
        WetnessValue = FInterpConstantTo(WetnessValue, TargetWetnessValue, DeltaTime, WetnessSpeedModifier);
        bWetnessChanged = true;
    }

    if( bWetnessChanged )
    {
        BodyMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicWetnessParam, WetnessValue);
        HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.HeadWetnessParam, WetnessValue);
        GearMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicWetnessParam, WetnessValue);

        if( FaceMasksMIC != none )
        {
            FaceMasksMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicWetnessParam, WetnessValue);
        }
    }
}
// HEY WE HAVE OUR FULL SHADOW NOW WHEN WE DIE YAYYYY
simulated function HideHead(PlayerController LocalPC)
{
    super.HideHead(LocalPC);

    AttachComponent(HideHeadComponent);

    // Headgear
    ThirdPersonHeadgearMeshComponent.bCastHiddenShadow=true;
    ThirdPersonHeadgearMeshComponent.CastShadow=true;

    // Head and Arms
    ThirdPersonHeadAndArmsMeshComponent.SetSkeletalMesh(HeadAndArmsMesh);
    ThirdPersonHeadAndArmsMeshComponent.SetHidden(true);
    ThirdPersonHeadAndArmsMeshComponent.bCastHiddenShadow=true;
    ThirdPersonHeadAndArmsMeshComponent.CastShadow=true;

    // Face Items
    FaceItemMeshComponent.bCastHiddenShadow=true;
    FaceItemMeshComponent.CastShadow=true;

    // Facial Hair
    FacialHairMeshComponent.bCastHiddenShadow=true;
    FacialHairMeshComponent.CastShadow=true;

    FaceMasksComponent.bCastHiddenShadow=true;
    FaceMasksComponent.CastShadow=true;
}


simulated function UnHideHead(PlayerController LocalPC)
{
    local ROPlayerController ROPC;

    ROPC = ROPlayerController(LocalPC);
    if ( ROPC != None )
    {
        ROPC.RestoreWorldNearClippingPlane();
    }

    DetachComponent(HideHeadComponent);

    // Headgear
    ThirdPersonHeadgearMeshComponent.SetHidden(false);
    ThirdPersonHeadgearMeshComponent.bCastHiddenShadow=true;
    ThirdPersonHeadgearMeshComponent.CastShadow=true;

    // Head and Arms
    ThirdPersonHeadAndArmsMeshComponent.SetSkeletalMesh(HeadAndArmsMesh);
    ThirdPersonHeadAndArmsMeshComponent.SetHidden(false);
    ThirdPersonHeadAndArmsMeshComponent.bCastHiddenShadow=true;
    ThirdPersonHeadAndArmsMeshComponent.CastShadow=true;

    // Face Items
    FaceItemMeshComponent.SetHidden(false);
    FaceItemMeshComponent.bCastHiddenShadow=true;
    FaceItemMeshComponent.CastShadow=true;

    // Facial Hair
    FaceItemMeshComponent.SetHidden(false);
    FacialHairMeshComponent.bCastHiddenShadow=true;
    FacialHairMeshComponent.CastShadow=true;

    FaceMasksComponent.SetHidden(false);
    FaceMasksComponent.bCastHiddenShadow=true;
    FaceMasksComponent.CastShadow=true;
}

function TakeFallingDamage()
{
    local float EffectiveSpeed;
    local float SpeedOverMax;
    local float HurtRatio;
    local float ActualDamage;
    local float Threshold1;
    local float Threshold2;
    local float SpeedXY;

    Threshold1 = -0.5 * MaxFallSpeed;
    Threshold2 = -1 * MaxFallSpeed;

    // For exiting vehicles at high speed.
    // TODO: needs fine tuning.
    SpeedXY = VSize2D(Velocity);

    if (Velocity.Z < Threshold1 || SpeedXY > Abs(Threshold1))
    {
        if (Role == ROLE_Authority)
        {
            MakeNoise(1.0);
            if (Velocity.Z < Threshold2 || SpeedXY > Abs(Threshold2))
            {
                if (bLeftVehicleRecently)
                {
                    EffectiveSpeed = FMax(Velocity.Z * -1, SpeedXY);
                }
                else
                {
                    EffectiveSpeed = Velocity.Z * -1;
                }

                if (TouchingWaterVolume())
                {
                    EffectiveSpeed -= 250;
                    // Velocity.Z += 100;
                }
                if (EffectiveSpeed > MaxFallSpeed)
                {
                    // See how much we are over the MaxFallSpeed, and scale
                    // damage as a function of how far over the MaxFallSpeed
                    // we are in relation to the LethalFallSpeed
                    SpeedOverMax = EffectiveSpeed - MaxFallSpeed;
                    HurtRatio = SpeedOverMax/(LethalFallSpeed - MaxFallSpeed);

                    ActualDamage = 100 * HurtRatio;

                    // reduce the zone health by the actual damage, and prevent the player from taking negative zone damage
                    // Damage the legs
                    if( ActualDamage > 35 )
                    {
                        // Slow the player down if they hurt their legs badly enough
                        if( ROGameInfo(WorldInfo.Game) != none && ROGameInfo(WorldInfo.Game).bLegDamageSlowsPlayer )
                        {
                            LegInjuryTime = WorldInfo.TimeSeconds;
                            LegInjuryAmount = 255;
                            SetSprinting(false);
                        }

                        // Right Thigh
                        PlayerHitZones[14].ZoneHealth -= Min(ActualDamage, Max(PlayerHitZones[14].ZoneHealth, 0));
                        PackHitZoneHealth(14); // Pack this Hit Zone's new Health into the replicated array

                        // Left Thigh
                        PlayerHitZones[18].ZoneHealth -= Min(ActualDamage, Max(PlayerHitZones[18].ZoneHealth, 0));
                        PackHitZoneHealth(18); // Pack this Hit Zone's new Health into the replicated array
                    }

                    if( ActualDamage > 15 )
                    {
                        // Right Calf
                        PlayerHitZones[16].ZoneHealth -= Min(ActualDamage, Max(PlayerHitZones[16].ZoneHealth, 0));
                        PackHitZoneHealth(16); // Pack this Hit Zone's new Health into the replicated array

                        // Left Calf
                        PlayerHitZones[20].ZoneHealth -= Min(ActualDamage, Max(PlayerHitZones[20].ZoneHealth, 0));
                        PackHitZoneHealth(20); // Pack this Hit Zone's new Health into the replicated array
                    }

                    if( ActualDamage > 0 )
                    {
                        // Right Foot
                        PlayerHitZones[17].ZoneHealth -= Min(ActualDamage, Max(PlayerHitZones[17].ZoneHealth, 0));
                        PackHitZoneHealth(17); // Pack this Hit Zone's new Health into the replicated array

                        // Left Foot
                        PlayerHitZones[21].ZoneHealth -= Min(ActualDamage, Max(PlayerHitZones[21].ZoneHealth, 0));
                        PackHitZoneHealth(21); // Pack this Hit Zone's new Health into the replicated array
                    }
                    //`log("ActualDamage Is "$ActualDamage$" HurtRatio = "$HurtRatio$" EffectiveSpeed = "$EffectiveSpeed$" MaxFallSpeed = "$MaxFallSpeed$" LethalFallSpeed = "$LethalFallSpeed);

                    TakeDamage(100 * HurtRatio, None, Location, vect(0,0,0), class'DmgType_Fell');
                }
            }
        }
    }
    else if (Velocity.Z < -1.4 * JumpZ)
        MakeNoise(0.5);
    else if ( Velocity.Z < -0.8 * JumpZ )
        MakeNoise(0.2);
}

function bool IsInCamo()
{
    return False;
}

// --- BEGIN SOUNDCUE BACKPORT ---

simulated function bool IsSpeakingCustom()
{
    if (DialogAkComp != None)
    {
        if (DialogAudioComp == None)
        {
            // caution: this is a wwise thread query so watch perf!
            return DialogAkComp.IsPlaying();
        }
        else
        {
            return DialogAkComp.IsPlaying() && DialogAudioComp.IsPlaying();
        }
    }

    return false;
}

simulated final function bool SpeakLineCustom(Actor Addressee, AkEvent Audio, String DebugText,
    float DelaySec, optional ESpeechPriority Priority, optional SpeechInterruptCondition IntCondition,
    optional bool bNoHeadTrack, optional int BroadcastFilter, optional bool bSuppressSubtitle,
    optional Soundcue CustomAudio)
{
    local bool bInterrupt;

    `log("SpeakLineCustom() CustomAudio = " $ CustomAudio, `DEBUG_VOICECOMS, 'DRAudio');

    // Vanilla handling for vanilla audio.
    if (CustomAudio == None)
    {
        return SpeakLine(Addressee, Audio, DebugText, DelaySec, Priority,
            IntCondition, bNoHeadTrack, BroadcastFilter, bSuppressSubtitle);
    }

    switch (IntCondition)
    {
        case SIC_Never:
            bInterrupt = false;
            break;
        case SIC_IfHigher:
            bInterrupt = (Priority > CurrentSpeechPriority) ? true : false;
            break;
        case SIC_IfSameOrHigher:
            bInterrupt = (Priority >= CurrentSpeechPriority) ? true : false;
            break;
        case SIC_Always:
            bInterrupt = true;
            break;
    }

    if ( bInterrupt || !IsSpeakingCustom() )
    {
        //`log("Speaking Line" @ ( !bSpeaking || bInterrupt ));

        DelayedSpeakLineParamsCustom.Addressee = Addressee;
        DelayedSpeakLineParamsCustom.CustomAudio = CustomAudio;
        DelayedSpeakLineParamsCustom.DebugText = DebugText;
        DelayedSpeakLineParamsCustom.bNoHeadTrack = bNoHeadTrack;
        DelayedSpeakLineParamsCustom.Priority = Priority;
        DelayedSpeakLineParamsCustom.BroadcastFilter = ESpeakLineBroadcastFilter(BroadcastFilter);
        DelayedSpeakLineParamsCustom.bSuppressSubtitle = bSuppressSubtitle;
        DelayedSpeakLineParamsCustom.DelayTime = DelaySec;

        if (DelaySec > 0.f)
        {
//          `log("queuing line");
            // play later
            SetTimer(DelaySec, FALSE, 'PlayQueuedSpeakLine');
        }
        else
        {
//          `log("playing now");
            // play now!
            PlayQueuedSpeakLine();
        }

        bNetDirty = true; // have to force because struct member assignment doesn't do it automatically
        //NetUpdateTime = WorldInfo.TimeSeconds - 1.0f;

        return TRUE;
    }

    return FALSE;
}

simulated private function PlayQueuedSpeakLine()
{
    local bool bVersusMulti;
    local PlayerController LocalPC;
    local bool bLocalPlayersTurretPawn;
    local bool bAllowSpatialization;
    local bool bCustomAudio;
    local AudioDevice Audio;

    Audio = class'Engine'.static.GetAudioDevice();

    if ( DialogAkComp == None || bPlayedDeath )
    {
        return;
    }

    // Handle current speech, if any.
    DialogAkComp.StopEvents();
    DialogAudioComp.Stop();

    bVersusMulti = true;

    if (DelayedSpeakLineParamsCustom.CustomAudio != None)
    {
        if (!DialogAudioComp.bAttached)
        {
            AttachComponent(DialogAudioComp);
        }

        bCustomAudio = True;

        `log("PlayQueuedSpeakLine(): bCustomAudio = " $ bCustomAudio, `DEBUG_VOICECOMS, 'DRAudio');
    }

    if (DelayedSpeakLineParams.Audio != none || bCustomAudio)
    {
        if (bVersusMulti)
        {
            if (ShouldFilterOutSpeech(DelayedSpeakLineParams.BroadcastFilter))
            {
                // `log(self@"Skipping line"@IsLocallyControlled());
                return;
            }
        }

        if (!DialogAkComp.bAttached)
        {
            AttachComponent(DialogAkComp);
        }

        LocalPC = GetALocalPlayerController();

        // Don't spatialize the voice if it is being played from the pawn
        // attached to the turret our local controller is using!
        if (DrivenVehicle != none && ROTurret(DrivenVehicle) != None &&
            DrivenVehicle == LocalPC.Pawn)
        {
            bLocalPlayersTurretPawn = true;
        }

        //DialogAkComp.bAutoDestroy = true;
        //DialogAkComp.Location = Location;
        bAllowSpatialization = Controller != LocalPC && !bLocalPlayersTurretPawn && (LocalPC.ViewTarget != self || !LocalPC.UsingFirstPersonCamera());
        //DialogAkComp.bSuppressSubtitles = DelayedSpeakLineParams.bSuppressSubtitle || ShouldSuppressSubtitlesForQueuedSpeakLine(bVersusMulti);
        //DialogAkComp.OcclusionCheckInterval = (CurrentlySpeakingLine.bAllowSpatialization ? 0.1 : 0.0);
        //DialogAkComp.PitchMultiplier = DelayedSpeakLineParams.PitchMultiplier;
        //DialogAkComp.bAlwaysPlay = DelayedSpeakLineParams.Priority >= Speech_Spawning;

        // @todo: modulate priority based on distance to the player?
        //DialogAkComp.SubtitlePriority = DelayedSpeakLineParams.Priority * SubtitlePriorityScale;

        // jack priority for scripted lines
        // TODO: RO, Cooney, need to reimplement priority
        // CurrentlySpeakingLine.PriorityMultiplier = (DelayedSpeakLineParams.Priority >= Speech_Scripted) ? 5.f : 1.f;

        if (bCustomAudio)
        {
            `log("DialogAudioComp =" $ DialogAudioComp, `DEBUG_VOICECOMS, 'DRAudio');
            `log("CustomAudio     =" $ DelayedSpeakLineParamsCustom.CustomAudio, `DEBUG_VOICECOMS, 'DRAudio');

            DialogAudioComp.SoundCue = DelayedSpeakLineParamsCustom.CustomAudio;
            DialogAudioComp.bAlwaysPlay = DelayedSpeakLineParamsCustom.Priority >= Speech_Spawning;
            DialogAudioComp.bAllowSpatialization = bAllowSpatialization;
            DialogAudioComp.VolumeMultiplier = 1.5 * (Audio.AKDialogVolume * Audio.AKMasterVolume);
            DialogAudioComp.FadeIn(0.05f, 1.f);
            CurrentSpeechPriority = DelayedSpeakLineParamsCustom.Priority;
        }
        else
        {
            DialogAkComp.PlayEvent(DelayedSpeakLineParams.Audio, bAllowSpatialization);
            CurrentSpeechPriority = DelayedSpeakLineParams.Priority;
        }

        //`log(GetFuncName()@"played line "$CurrentlySpeakingLine.SoundCue);
    }

    CurrentSpeechPriority = DelayedSpeakLineParams.Priority;

    ClearTimer('PlayQueuedSpeakLine');      // just in case
}

// --- END SOUNDCUE BACKPORT ---

function HighlightKickableProjectile(Actor Highlightable)
{
    if (Highlightable == None)
    {
        return;
    }

    if (ROThrowableExplosiveProjectile(Highlightable) != None)
    {
        HighlightPickupHandler(ROThrowableExplosiveProjectile(Highlightable).ThrowableMesh);
    }
}

// TODO: Check if this actually works. Depends on the door material?
function HighlightUsableDoor(Actor Highlightable)
{
    if (Highlightable == None)
    {
        return;
    }

    if (DRDoorActor(Highlightable) != None)
    {
        HighlightStaticPickupHandler(DRDoorActor(Highlightable).StaticMeshComponent);
    }
}

DefaultProperties
{
    PawnMesh_SV=SkeletalMesh'DR_CHR.Mesh.CharRef_Full'
    bCanCamouflage=False

    // --- BEGIN SOUNDCUE BACKPORT ---
    Begin Object Class=DRAudioComponent Name=DialogAudioComp0
        AudioClass=EAC_SFX
        bStopWhenOwnerDestroyed=True
    End Object
    DialogAudioComp=DialogAudioComp0
    Components.Add(DialogAudioComp0)
    // --- END SOUNDCUE BACKPORT ---

    Begin Object class=ROSkeletalMeshComponent name=Covid
        LightEnvironment = MyLightEnvironment
        bUpdateSkelWhenNotRendered=false
        bNoSkeletonUpdate=true
        CastShadow=FALSE
        MaxDrawDistance=2500    // 50m, beyond that they're barely visible so avoid the extra drawcall
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object
    FaceMasksComponent=Covid

    Begin Object class=ROSkeletalMeshComponent name=DeadGuy0
        LightEnvironment = MyLightEnvironment
        bUpdateSkelWhenNotRendered=false
        bNoSkeletonUpdate=true
        CastShadow=FALSE
        MaxDrawDistance=2500    // 50m, beyond that they're barely visible so avoid the extra drawcall
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object
    HideHeadComponent=DeadGuy0

    Begin Object Name=ROPawnSkeletalMeshComponent
        AnimSets(0)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Stand_anim'
        AnimSets(1)=AnimSet'CHR_Playeranim_Master.Anim.CHR_ChestCover_anim'
        AnimSets(2)=AnimSet'CHR_Playeranim_Master.Anim.CHR_WaistCover_anim'
        AnimSets(3)=AnimSet'CHR_Playeranim_Master.Anim.CHR_StandCover_anim'
        AnimSets(4)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Crouch_anim'
        AnimSets(5)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Prone_anim'
        AnimSets(6)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Hand_Poses_Master'
        AnimSets(7)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Death_anim'
        AnimSets(8)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Tripod_anim'
        AnimSets(9)=AnimSet'CHR_Playeranim_Master.Anim.Special_Actions'
        AnimSets(10)=AnimSet'CHR_Playeranim_Master.Anim.CHR_Melee'
        AnimSets(11)=none // Team specific sprinting animations
        AnimSets(12)=none // Reserved for weapon specific animations
        AnimSets(13)=AnimSet'CHR_VN_Playeranim_Master.Anim.CHR_VN_Tripod_anim'
        AnimSets(14)=AnimSet'CHR_VN_Playeranim_Master.Anim.CHR_VN_Stand_anim'
        AnimSets(15)=AnimSet'CHR_VN_Playeranim_Master.Anim.CHR_VN_ChestCover_anim'
        AnimSets(16)=AnimSet'CHR_VN_Playeranim_Master.Anim.CHR_VN_WaistCover_anim'
        AnimSets(17)=AnimSet'CHR_VN_Playeranim_Master.Anim.CHR_VN_StandCover_anim'
        AnimSets(18)=AnimSet'CHR_VN_Playeranim_Master.Anim.CHR_VN_Crouch_anim'
        AnimSets(19)=AnimSet'CHR_VN_Playeranim_Master.Anim.CHR_VN_Prone_anim'
        AnimSets(20)=AnimSet'CHR_VN_Playeranim_Master.Anim.CHR_VN_Hand_Poses_Master'
        AnimSets(21)=AnimSet'CHR_VN_Playeranim_Master.Anim.VN_Special_Actions'
    End Object

    Gore_LeftHand=(GibClass=class'ROGameContent.ROGib_HumanArm_Gore_BareArm')
    Gore_RightHand=(GibClass=class'ROGameContent.ROGib_HumanArm_Gore_BareArm')
    Gore_LeftLeg=(GibClass=class'ROGameContent.ROGib_HumanLeg_Gore_BareLeg')
    Gore_RightLeg=(GibClass=class'ROGameContent.ROGib_HumanLeg_Gore_BareLeg')

    // BulletHitHelmetSound=none
    // BulletHitMyHeadSound=none
    // BulletHitMyHelmetSound=none
    // MyBulletHitHelmetSound=none

    FootstepSounds.Add((MaterialType=EMT_Default,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Dirt')()
    FootstepSounds.Add((MaterialType=EMT_Rock,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Gravel'))
    FootstepSounds.Add((MaterialType=EMT_Dirt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Dirt'))
    FootstepSounds.Add((MaterialType=EMT_Metal,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Metal'))
    FootstepSounds.Add((MaterialType=EMT_Wood,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Wood'))
    FootstepSounds.Add((MaterialType=EMT_Asphalt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Rock'))
    FootstepSounds.Add((MaterialType=EMT_RedBrick,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Rock'))
    FootstepSounds.Add((MaterialType=EMT_WhiteBrick,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Rock'))
    FootstepSounds.Add((MaterialType=EMT_Plant,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Grass'))
    FootstepSounds.Add((MaterialType=EMT_HollowMetal,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Metal'))
    FootstepSounds.Add((MaterialType=EMT_HollowWood,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Wood'))
    FootstepSounds.Add((MaterialType=EMT_Mud,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Mud'))
    FootstepSounds.Add((MaterialType=EMT_Dirt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Dirt'))
    FootstepSounds.Add((MaterialType=EMT_Water,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Water'))
    FootstepSounds.Add((MaterialType=EMT_ShallowWater,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Mud'))
    FootstepSounds.Add((MaterialType=EMT_Gravel,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Gravel'))
    FootstepSounds.Add((MaterialType=EMT_Plaster,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Rock'))
    FootstepSounds.Add((MaterialType=EMT_Concrete,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Rock'))
    FootstepSounds.Add((MaterialType=EMT_Poop,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Mud'))
    FootstepSounds.Add((MaterialType=EMT_Plastic,Sound=AkEvent'WW_FOL_US.Play_FS_US_Jog_Rock'))

    CrawlFootStepSounds.Add((MaterialType=EMT_Default,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Dirt'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Rock,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Gravel'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Dirt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Dirt'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Metal,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Metal'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Wood,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Wood'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Asphalt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Rock'))
    CrawlFootStepSounds.Add((MaterialType=EMT_RedBrick,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Rock'))
    CrawlFootStepSounds.Add((MaterialType=EMT_WhiteBrick,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Rock'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Plant,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Grass'))
    CrawlFootStepSounds.Add((MaterialType=EMT_HollowMetal,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Metal'))
    CrawlFootStepSounds.Add((MaterialType=EMT_HollowWood,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Wood'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Mud,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Mud'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Dirt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Dirt'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Water,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Water'))
    CrawlFootStepSounds.Add((MaterialType=EMT_ShallowWater,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Water'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Gravel,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Gravel'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Plaster,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Rock'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Concrete,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Rock'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Poop,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Mud'))
    CrawlFootStepSounds.Add((MaterialType=EMT_Plastic,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crawl_Rock'))

    SprintFootStepSounds.Add((MaterialType=EMT_Default,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Dirt'))
    SprintFootStepSounds.Add((MaterialType=EMT_Rock,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Gravel'))
    SprintFootStepSounds.Add((MaterialType=EMT_Dirt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Dirt'))
    SprintFootStepSounds.Add((MaterialType=EMT_Metal,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Metal'))
    SprintFootStepSounds.Add((MaterialType=EMT_Wood,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Wood'))
    SprintFootStepSounds.Add((MaterialType=EMT_Asphalt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Rock'))
    SprintFootStepSounds.Add((MaterialType=EMT_RedBrick,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Rock'))
    SprintFootStepSounds.Add((MaterialType=EMT_WhiteBrick,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Rock'))
    SprintFootStepSounds.Add((MaterialType=EMT_Plant,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Grass'))
    SprintFootStepSounds.Add((MaterialType=EMT_HollowMetal,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Metal'))
    SprintFootStepSounds.Add((MaterialType=EMT_HollowWood,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Wood'))
    SprintFootStepSounds.Add((MaterialType=EMT_Mud,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Mud'))
    SprintFootStepSounds.Add((MaterialType=EMT_Dirt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Dirt'))
    SprintFootStepSounds.Add((MaterialType=EMT_Water,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Water'))
    SprintFootStepSounds.Add((MaterialType=EMT_ShallowWater,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Mud'))
    SprintFootStepSounds.Add((MaterialType=EMT_Gravel,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Gravel'))
    SprintFootStepSounds.Add((MaterialType=EMT_Plaster,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Rock'))
    SprintFootStepSounds.Add((MaterialType=EMT_Concrete,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Rock'))
    SprintFootStepSounds.Add((MaterialType=EMT_Poop,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Mud'))
    SprintFootStepSounds.Add((MaterialType=EMT_Plastic,Sound=AkEvent'WW_FOL_US.Play_FS_US_Sprint_Rock'))

    WalkFootStepSounds.Add((MaterialType=EMT_Default,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Dirt'))
    WalkFootStepSounds.Add((MaterialType=EMT_Rock,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Gravel'))
    WalkFootStepSounds.Add((MaterialType=EMT_Dirt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Dirt'))
    WalkFootStepSounds.Add((MaterialType=EMT_Metal,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Metal'))
    WalkFootStepSounds.Add((MaterialType=EMT_Wood,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Wood'))
    WalkFootStepSounds.Add((MaterialType=EMT_Asphalt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Rock'))
    WalkFootStepSounds.Add((MaterialType=EMT_RedBrick,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Rock'))
    WalkFootStepSounds.Add((MaterialType=EMT_WhiteBrick,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Rock'))
    WalkFootStepSounds.Add((MaterialType=EMT_Plant,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Grass'))
    WalkFootStepSounds.Add((MaterialType=EMT_HollowMetal,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Metal'))
    WalkFootStepSounds.Add((MaterialType=EMT_HollowWood,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Wood'))
    WalkFootStepSounds.Add((MaterialType=EMT_Mud,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Mud'))
    WalkFootStepSounds.Add((MaterialType=EMT_Dirt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Dirt'))
    WalkFootStepSounds.Add((MaterialType=EMT_Water,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Water'))
    WalkFootStepSounds.Add((MaterialType=EMT_ShallowWater,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Mud'))
    WalkFootStepSounds.Add((MaterialType=EMT_Gravel,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Gravel'))
    WalkFootStepSounds.Add((MaterialType=EMT_Plaster,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Rock'))
    WalkFootStepSounds.Add((MaterialType=EMT_Concrete,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Rock'))
    WalkFootStepSounds.Add((MaterialType=EMT_Poop,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Mud'))
    WalkFootStepSounds.Add((MaterialType=EMT_Plastic,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Rock'))

    CrouchFootStepSounds.Add((MaterialType=EMT_Default,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Dirt'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Rock,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Gravel'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Dirt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Dirt'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Metal,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Metal'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Wood,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Wood'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Asphalt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Rock'))
    CrouchFootStepSounds.Add((MaterialType=EMT_RedBrick,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Rock'))
    CrouchFootStepSounds.Add((MaterialType=EMT_WhiteBrick,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Rock'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Plant,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Grass'))
    CrouchFootStepSounds.Add((MaterialType=EMT_HollowMetal,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Metal'))
    CrouchFootStepSounds.Add((MaterialType=EMT_HollowWood,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Wood'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Mud,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Mud'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Dirt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Dirt'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Water,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Water'))
    CrouchFootStepSounds.Add((MaterialType=EMT_ShallowWater,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Mud'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Gravel,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Gravel'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Plaster,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Rock'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Concrete,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Rock'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Poop,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Mud'))
    CrouchFootStepSounds.Add((MaterialType=EMT_Plastic,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Rock'))

    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Default,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Dirt'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Rock,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Gravel'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Dirt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Dirt'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Metal,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Metal'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Wood,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Wood'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Asphalt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Rock'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_RedBrick,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Rock'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_WhiteBrick,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Rock'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Plant,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Grass'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_HollowMetal,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Metal'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_HollowWood,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Wood'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Mud,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Mud'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Dirt,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Dirt'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Water,Sound=AkEvent'WW_FOL_US.Play_FS_US_Walk_Water'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_ShallowWater,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Mud'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Gravel,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Gravel'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Plaster,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Rock'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Concrete,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Rock'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Poop,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Mud'))
    CrouchWalkFootStepSounds.Add((MaterialType=EMT_Plastic,Sound=AkEvent'WW_FOL_US.Play_FS_US_Crouch_Rock'))
}
