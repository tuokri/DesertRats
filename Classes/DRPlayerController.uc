class DRPlayerController extends ROPlayerController
    config(Game_DesertRats_Client);


// MORALE MUSIC
var bool bWaitingForVictoryMusicToEnd;
var MusicTrackStruct PendingSong;

var(Sounds) SoundCue AxisWinTheme;
var(Sounds) SoundCue AlliesWinTheme;
var(Sounds) SoundCue AxisLossTheme;
var(Sounds) SoundCue AlliesLossTheme;

var(Sounds) SoundCue AxisRoundWinTheme;
var(Sounds) SoundCue AlliesRoundWinTheme;
var(Sounds) SoundCue AxisRoundLostTheme;
var(Sounds) SoundCue AlliesRoundLostTheme;

var DRAudioComponent StingerComp;

var array<class <DRVoicePack> > NorthTeamVoicePacksCustom;    // North Unlocalized Voice Pack classes(used if we are on South and someone on North is speaking).
var array<class <DRVoicePack> > SouthTeamVoicePacksCustom;    // South Unlocalized Voice Pack classes(used if we are on North and someone on South is speaking).
var array<class <DRVoicePack> > SouthTeamAltVoicePacksCustom; // South Unlocalized Voice Pack classes(used if we are on North and someone on South is speaking).
var array<DRVoicePack> TeamVoicePacksCustom;                  // Opposing team in opposing team's language.

// Store each voice pack by "Nation" index.
var array<class <DRVoicePack> > AllTeamVoicePacksOneCustom;
var array<class <DRVoicePack> > AllTeamVoicePacksTwoCustom;
var array<class <DRVoicePack> > AllTeamVoicePacksThreeCustom;

// Array of all available announcer packs (to support multiple nations).
var array<class <DRAnnouncerPack> > AllAnnouncerPacksCustom;

// Assigned announcer voices by team index.
var DRAnnouncerPack AnnouncerPacksCustom[2];

// OLD MORALE MUSIC
// var bool RoundEnd;
// var bool MatchEnd;
// var bool Ducking;
// var(Sounds) SoundCue AxisWinTheme;
// var(Sounds) SoundCue AlliesWinTheme;

// Custom audio volume control.
var DRAudioManager AudioManager;


simulated event PreBeginPlay()
{
    super.PreBeginPlay();

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        AudioManager = new(self) class'DRAudioManager';
        if (AudioManager != None)
        {
            AudioManager.InitSoundClassVolumes();
        }
        else
        {
            `warn("ERROR! Unable to create AudioManager!");
        }
    }
}

simulated event PostBeginPlay()
{
    local AudioDevice Audio;

    super(GamePlayerController).PostBeginPlay();

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        BulletImpactDecalManager = Spawn(class'DecalManager', self,, vect(0,0,0), rot(0,0,0));
        BulletImpactDecalManager.MaxActiveDecals = MaxBulletImpactDecals;

        // TODO: more elegant.
        // MusicComponent.Play();
    }

    Audio = class'Engine'.static.GetAudioDevice();

    if (Audio != None)
    {
        Audio.InitSoundClassVolumes();
        MaxConcurrentHearSounds = Audio.MaxChannels * SoundChannelToHearSoundsRatio;

        if (MaxConcurrentHearSounds < 2)
        {
            MaxConcurrentHearSounds = 1;
        }
        else if (MaxConcurrentHearSounds > Audio.MaxChannels)
        {
            MaxConcurrentHearSounds = Audio.MaxChannels + 1; // +1 for our music hax AudioComponent
        }
    }

    // We have no way to intercept changes in ROUISceneSettings, so we have to just keep checking
    SetTimer(1.0, true, 'CheckForVolumeChanges');

    // SetTimer(120.0, false, 'StartMusicFix');

    if ( OutsideMapWithSteam() )
    {
        CheckWorkshopSubscriptions();
    }

    if (Role < ROLE_Authority)
    {
        ServerUpdatePlayerFOV(PlayerFOV, MyHud.SizeX, MyHud.SizeY);
    }
}

// --- BEGIN SOUNDCUE BACKPORT ---

function DRAudioComponent GetPooledAudioComponentCustom(SoundCue ASound, Actor SourceActor,
    bool bStopWhenOwnerDestroyed, optional bool bUseLocation, optional vector SourceLocation,
    optional EAudioClass AudioClass = EAC_SFX)
{
    local DRAudioComponent DRAC;

    DRAC = DRAudioComponent(GetPooledAudioComponent(ASound, SourceActor,
        bStopWhenOwnerDestroyed, bUseLocation, SourceLocation));
    DRAC.AudioClass = AudioClass;

    if (AudioManager != None)
    {
        AudioManager.RegisterAudioComponent(DRAC);
    }

    return DRAC;
}

/*
// TODO: doesn't work yet!
simulated function class<DRVoicePack> GetCustomVoicePack(class<ROVoicePack> VoicePack)
{
    // TODO: Hashmap? Switch-case?
    // TODO: Hard-coded for now.
    return SouthTeamVoicePacksCustom[0];
}
*/

// TODO: doesn't work yet!
simulated function GetCustomAnnouncerPack(const out ROAnnouncerPack AnnouncerPack, const out DRAnnouncerPack CustomAnnouncerPack)
{
    // CustomAnnouncerPack =
}

reliable client event ReceiveLocalizedVoiceCom(Pawn VoicePawn, byte VoiceSeatIndex,
    ROPlayerReplicationInfo VoicePRI, vector VoiceLocation, int VoiceComIndex,
    optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local class<ROVoicePack> VoicePack;

    // Make the voice be the driver if this is our local turret we are using. That
    // way the code in ROPawn properly handles spatialization for this message.
    if (VoicePawn == Pawn && ROTurret(VoicePawn) != none && ROTurret(VoicePawn).Driver != none)
    {
        VoicePawn = ROTurret(VoicePawn).Driver;
    }

    VoicePack = PlayVoiceCom(VoicePawn, VoiceSeatIndex, VoicePRI, VoiceLocation, VoiceComIndex);

    if (VoicePack != none)
    {
        ReceiveLocalizedMessage(VoicePack.static.GetVoiceComMessageClass(VoiceComIndex),
            VoicePack.static.GetVoiceComMessageIndex(VoiceComIndex), RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }
}

simulated event class<ROVoicePack> PlayVoiceCom(Pawn VoicePawn, byte VoiceSeatIndex,
    ROPlayerReplicationInfo VoicePRI, vector VoiceLocation, int VoiceComIndex)
{
    local ROPawn PawnSpeaker;
    local VehicleCrewProxy ProxySpeaker;
    local class<ROVoicePack> VoicePack;
    local class<DRVoicePack> CustomVoicePack;

    if (`DEBUG_VOICECOMS)
    {
        `log(GetFuncName() @ VoicePawn @ VoiceSeatIndex @ VoicePRI @ VoiceLocation @ VoiceComIndex);
    }

    switch (VoiceComIndex)
    {
        case `VOICECOM_ReconPlaneInRoute:
            PlayAnnouncerSound(EROAVT_Radio, VoicePRI.Team.TeamIndex, EROARC_ReconConfirm,, VoiceLocation,
                ROVehicleBase(VoicePawn), VoiceSeatIndex);
            return none;
        case `VOICECOM_ReconPlaneDenied:
            PlayAnnouncerSound(EROAVT_Radio, VoicePRI.Team.TeamIndex, EROARC_ReconDeny,, VoiceLocation,
                ROVehicleBase(VoicePawn), VoiceSeatIndex);
            return none;
        case `VOICECOM_Ability1Confirm:
            PlayAnnouncerSound(EROAVT_Radio, VoicePRI.Team.TeamIndex, EROARC_Ability1Confirm,, VoiceLocation,
                ROVehicleBase(VoicePawn), VoiceSeatIndex);
            return none;
        case `VOICECOM_Ability2Confirm:
            PlayAnnouncerSound(EROAVT_Radio, VoicePRI.Team.TeamIndex, EROARC_Ability2Confirm,, VoiceLocation,
                ROVehicleBase(VoicePawn), VoiceSeatIndex);
            return none;
        case `VOICECOM_Ability3Confirm:
            PlayAnnouncerSound(EROAVT_Radio, VoicePRI.Team.TeamIndex, EROARC_Ability3Confirm,, VoiceLocation,
                ROVehicleBase(VoicePawn), VoiceSeatIndex);
            return none;
        case `VOICECOM_Ability1Deny:
            PlayAnnouncerSound(EROAVT_Radio, VoicePRI.Team.TeamIndex, EROARC_Ability1Deny,, VoiceLocation,
                ROVehicleBase(VoicePawn), VoiceSeatIndex);
            return none;
        case `VOICECOM_Ability2Deny:
            PlayAnnouncerSound(EROAVT_Radio, VoicePRI.Team.TeamIndex, EROARC_Ability2Deny,, VoiceLocation,
                ROVehicleBase(VoicePawn), VoiceSeatIndex);
            return none;
        case `VOICECOM_Ability3Deny:
            PlayAnnouncerSound(EROAVT_Radio, VoicePRI.Team.TeamIndex, EROARC_Ability3Deny,, VoiceLocation,
                ROVehicleBase(VoicePawn), VoiceSeatIndex);
            return none;
        case `VOICECOM_NoArtillery:
            PlayAnnouncerSound(EROAVT_Radio, VoicePRI.Team.TeamIndex, EROARC_NoAbilityLeft,, VoiceLocation,
                ROVehicleBase(VoicePawn), VoiceSeatIndex);
            return none;
    }

    // If we're on the same team, use localized sounds.
    if (VoicePRI != none && VoicePRI.Team != none)
    {
        if (`DEBUG_VOICECOMS)
        {
            `log("PlayVoiceCom - Good PRI and Team" @ VoicePRI.Team.TeamIndex @ GetTeamNum() @ VoicePRI.VoicePackIndex);
        }

        if (VoicePRI.Team.TeamIndex == `AXIS_TEAM_INDEX)
        {
            if (VoicePRI.VoicePackIndex < NorthTeamVoicePacks.Length)
            {
                VoicePack = NorthTeamVoicePacks[VoicePRI.VoicePackIndex];
                CustomVoicePack = NorthTeamVoicePacksCustom[VoicePRI.VoicePackIndex];
            }
            else
            {
                VoicePack = NorthTeamVoicePacks[0];
                CustomVoicePack = NorthTeamVoicePacksCustom[0];
            }
        }
        else
        {
            if (VoicePRI.bUsesAltVoicePacks)
            {
                if (VoicePRI.VoicePackIndex < SouthTeamAltVoicePacks.Length)
                {
                    VoicePack = SouthTeamAltVoicePacks[VoicePRI.VoicePackIndex];
                    CustomVoicePack = SouthTeamAltVoicePacksCustom[VoicePRI.VoicePackIndex];
                }
                else
                {
                    VoicePack = SouthTeamAltVoicePacks[0];
                    CustomVoicePack = SouthTeamAltVoicePacksCustom[0];
                }
            }
            else
            {
                if (VoicePRI.VoicePackIndex < SouthTeamVoicePacks.Length)
                {
                    VoicePack = SouthTeamVoicePacks[VoicePRI.VoicePackIndex];
                    CustomVoicePack = SouthTeamAltVoicePacksCustom[VoicePRI.VoicePackIndex];
                }
                else
                {
                    VoicePack = SouthTeamVoicePacks[0];
                    CustomVoicePack = SouthTeamVoicePacksCustom[0];
                }
            }
        }
    }
    else
    {
        `log("Failed to play voice/dialog - invalid team");
        return None;
    }

    // if this is a vehicle, try to get the Pawn or Proxy that should be speaking
    if (ROVehicle(VoicePawn) != none)
    {
        if (VoicePack.static.GetVoiceComType(VoiceComIndex) == ROVCT_Vehicle
            || VoicePack.static.GetVoiceComType(VoiceComIndex) == ROVCT_RadioRequest)
        {
            PawnSpeaker = ROVehicle(VoicePawn).GetDriverForSeatIndex(VoiceSeatIndex);

            if (PawnSpeaker == none)
            {
                ProxySpeaker = ROVehicle(VoicePawn).GetSeatProxyActorFromSeatIndex(VoiceSeatIndex);
            }
        }
    }
    else if (ROWeaponPawn(VoicePawn) != none && ROWeaponPawn(VoicePawn).MyVehicle != none)
    {
        PawnSpeaker = ROWeaponPawn(VoicePawn).MyVehicle.GetDriverForSeatIndex(VoiceSeatIndex);

        if (PawnSpeaker == none)
        {
            ProxySpeaker = ROWeaponPawn(VoicePawn).MyVehicle.GetSeatProxyActorFromSeatIndex(VoiceSeatIndex);
        }
    }
    else
    {
        PawnSpeaker = ROPawn(VoicePawn);
    }

    if (ProxySpeaker != none)
    {
        if (VoicePRI.Team.TeamIndex == `AXIS_TEAM_INDEX)
        {
            VoicePack = NorthTeamVoicePacks[ProxySpeaker.VoicePackIndex];
            CustomVoicePack = NorthTeamVoicePacksCustom[ProxySpeaker.VoicePackIndex];
        }
        else
        {
            if(VoicePRI.bUsesAltVoicePacks)
            {
                VoicePack = SouthTeamAltVoicePacks[ProxySpeaker.VoicePackIndex];
                CustomVoicePack = SouthTeamAltVoicePacksCustom[ProxySpeaker.VoicePackIndex];
            }
            else
            {
                VoicePack = SouthTeamVoicePacks[ProxySpeaker.VoicePackIndex];
                CustomVoicePack = SouthTeamVoicePacksCustom[ProxySpeaker.VoicePackIndex];
            }
        }
    }

    // Only play vehicle coms or radio requests when in a vehicle
    if (VoicePRI != none)
    {
        if (VoicePRI.TeamHelicopterArrayIndex != INDEX_NONE &&
            VoicePRI.TeamHelicopterArrayIndex != 255 &&
            VoicePack.static.GetVoiceComType(VoiceComIndex) != ROVCT_Vehicle &&
            VoicePack.static.GetVoiceComType(VoiceComIndex) != ROVCT_RadioRequest)
        {
            return none;
        }
    }

    // CustomVoicePack = GetCustomVoicePack(VoicePack);

    if (`DEBUG_VOICECOMS)
    {
        `log("CustomVoicePack   = " $ CustomVoicePack,, 'DRAudio');
        `log("bIsCustomVoiceCom = " $ CustomVoicePack.static.IsCustomVoiceCom(VoiceComIndex),, 'DRAudio');
    }

    // Determine how we want to play the sound.
    if (PawnSpeaker != none)
    {
        `log("PlayVoiceCom(): PawnSpeaker=" $ PawnSpeaker, `DEBUG_VOICECOMS, 'DRAudio');

        // Make Pawn say the line.
        // TODO: STUPID CASTING, FIX DRPAWN.
        if (PawnSpeaker.GetTeamNum() == `ALLIES_TEAM_INDEX)
        {
            DRPawnAllies(PawnSpeaker).SpeakLineCustom(none, VoicePack.static.GetVoiceComSound(VoiceComIndex), "VoiceComSpeakLine", 0.0,
                VoicePack.static.GetVoiceComPriority(VoiceComIndex), SIC_IfSameOrHigher,,,, CustomVoicePack.static.GetVoiceComSoundCustom(VoiceComIndex));
        }
        else
        {
            DRPawnAxis(PawnSpeaker).SpeakLineCustom(none, VoicePack.static.GetVoiceComSound(VoiceComIndex), "VoiceComSpeakLine", 0.0,
                VoicePack.static.GetVoiceComPriority(VoiceComIndex), SIC_IfSameOrHigher,,,, CustomVoicePack.static.GetVoiceComSoundCustom(VoiceComIndex));
        }
    }
    else if (ProxySpeaker != none)
    {
        `log(GetFuncName() $ ": ProxySpeaker=" $ ProxySpeaker, `DEBUG_VOICECOMS, 'DRAudio');

        // Make the AI Proxy say the line.
        ProxySpeaker.SpeakLine(none, VoicePack.static.GetVoiceComSound(VoiceComIndex), "VoiceComSpeakLine", 0.0,
            VoicePack.static.GetVoiceComPriority(VoiceComIndex), SIC_IfSameOrHigher);
    }
    else
    {
        PlayVoiceCustom(VoicePack, VoiceComIndex, VoiceLocation, CustomVoicePack);
    }

    return VoicePack;
}

simulated function PlayPooledSoundCustom(SoundCue ASound, Actor SourceActor,
    bool bStopWhenOwnerDestroyed, optional bool bUseLocation, optional vector SourceLocation,
    optional EAudioClass AudioClass = EAC_SFX)
{
    local DRAudioComponent DRAC;

    DRAC = GetPooledAudioComponentCustom(ASound, SourceActor, True, True, SourceLocation);
    if (DRAC != None)
    {
        DRAC.Play();
    }
}

simulated function PlayVoiceCustom(class<ROVoicePack> VoicePack, int VoiceComIndex, vector VoiceLocation,
    optional class<DRVoicePack> CustomVoicePack)
{
    `log(GetFuncName(), `DEBUG_VOICECOMS, 'DRAudio');

    if (CustomVoicePack != None && CustomVoicePack.static.IsCustomVoiceCom(VoiceComIndex))
    {
        PlayPooledSoundCustom(CustomVoicePack.static.GetVoiceComSoundCustom(VoiceComIndex),
            Self, True, True, VoiceLocation);
    }
    else
    {
        // Play the sound from VoiceLocation (without any replication).
        PlayVoice(VoicePack.static.GetVoiceComSound(VoiceComIndex), VoiceLocation);
    }
}

function PlayAnnouncerSound(byte VoxType, byte Team, byte VOXIndex, optional byte SubIndex,
    optional vector PlayLocation, optional Actor Speaker, optional int SeatIndex)
{
    local SoundCue CustomAnnouncerSound;
    local DRAnnouncerPack CustomAnnouncerPack;

    GetCustomAnnouncerPack(AnnouncerPacks[Team], CustomAnnouncerPack);

    CustomAnnouncerPack.GetAnnouncerSoundCustom(VoxType, VOXIndex, SubIndex,
        WorldInfo.TimeSeconds, CustomAnnouncerSound);

    if (CustomAnnouncerSound != None)
    {
        switch(VoxType)
        {
            case EROAVT_Objective:
                PlaySoundBase(CustomAnnouncerSound, true);
                break;
            case EROAVT_Radio:
                if (Speaker != none)
                {
                    // TODO: Custom method for radio sounds.
                    // PlayPortableRadioSound(CustomAnnouncerSound, Speaker, SeatIndex);
                    `warn("PlayPortableRadioSound()" @ "not implemented yet",, 'DRAudio');
                }
                else
                {
                    PlaySoundBase(CustomAnnouncerSound, true, false, true, PlayLocation);
                }
                break;
            default:
                PlaySoundBase(CustomAnnouncerSound, true);
        }
    }
    else
    {
        super.PlayAnnouncerSound(VoxType, Team, VOXIndex, SubIndex,
            PlayLocation, Speaker, SeatIndex);
    }
}

/*
// TODO: load all custom voices?
simulated function OnMapInfoReady(ROSeqAct_MapInfoReady Action)
{
    local int i;
    local int j;
    local DRMapInfo DRMI;

    super.OnMapInfoReady(Action);

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        DRMI = DRMapInfo(WorldInfo.GetMapInfo());

        for (i = 0; i < SouthTeamVoicePacksCustom.length; ++i)
        {
            DRMI.SharedContentReferences.AddItem(
                class<SoundCue>(DynamicLoadObject(SouthTeamVoicePacksCustom[i].default.CustomVoiceComs[j].CustomSound)));
        }
    }

    for (i = 0; i < class'WWTeamInfo'.default.AxisLowMoralePlayList.CRef_MusicTracks.length; i++)
    {
        SharedContentReferences.AddItem(class<SoundCue>(DynamicLoadObject(class'WWTeamInfo'.default.AxisLowMoralePlayList.CRef_MusicTracks[i], class'SoundCue')));
    }
}
*/

// --- END SOUNDCUE BACKPORT ---

// --- BEGIN MORALE MUSIC ---

simulated function PendingMoraleMusicUpdate()
{
    //`log(GetFuncName()$" bWaitingForVictoryMusicToEnd = "$bWaitingForVictoryMusicToEnd$" PendingSong = "$PendingSong.TheSoundCue);
    //ClientMessage(GetFuncName()$" bWaitingForVictoryMusicToEnd = "$bWaitingForVictoryMusicToEnd$" PendingSong = "$PendingSong.TheSoundCue);

    if ( !bWaitingForVictoryMusicToEnd )
    {
        ClearTimer('PendingMoraleMusicUpdate');
        SetNewMoraleMusicTrack(PendingSong, false);
    }
}

/**
 * Set a new Morale Music Track to Play
 *
 * @param   NewMusicTrack   New music track to play
 * @param   bMusicStinger   This music track is a "Stinger" so play it at full volume
 */
reliable client function SetNewMoraleMusicTrack(MusicTrackStruct NewMusicTrack, optional bool bMusicStinger)
{
    local AudioDevice Audio;
    local float SoundFXVolume, MusicVolume;

    Audio = class'Engine'.static.GetAudioDevice();
    if ( Audio != None )
    {
        SoundFXVolume = Audio.AkSFXVolume;
        MusicVolume = Audio.AkMusicVolume;
    }

    //`log(GetFuncName()$" NewMusicTrack = "$NewMusicTrack.TheSoundCue$" bMusicStinger = "$bMusicStinger$" bWaitingForVictoryMusicToEnd = "$bWaitingForVictoryMusicToEnd);
    //ClientMessage(GetFuncName()$" NewMusicTrack = "$NewMusicTrack.TheSoundCue$" bMusicStinger = "$bMusicStinger$" bWaitingForVictoryMusicToEnd = "$bWaitingForVictoryMusicToEnd);
    //ScriptTrace();

    if (bWaitingForVictoryMusicToEnd)
    {
        if (PendingSong != NewMusicTrack)
        {
            PendingSong = NewMusicTrack;
        }

        if (!IsTimerActive('PendingMoraleMusicUpdate'))
        {
            SetTimer(0.5, true, 'PendingMoraleMusicUpdate');
        }

        return;
    }

    if (bMusicStinger)
    {
        // If the music isn't turned down, play the stinger at an adjusted
        // volume that will be pretty close to the other music volume.
        if (MusicVolume > 0 && SoundFXVolume > 0 && NewMusicTrack.TheSoundCue.VolumeMultiplier > 0)
        {
            NewMusicTrack.FadeInVolumeLevel = (MusicVolume/SoundFXVolume)/NewMusicTrack.TheSoundCue.VolumeMultiplier;
        }
        // If music is turned off, play the stinger at SoundFXVolume level.
        else
    {
            NewMusicTrack.FadeInVolumeLevel = SoundFXVolume;
        }
    }
    else
    {
        NewMusicTrack.FadeInVolumeLevel = MusicVolume;
    }

    UpdateMoraleMusicTrack(NewMusicTrack);
}

// TODO: fades. Crossfade with 2 components?
// TODO: Volume control of WorldInfo music component?
simulated function UpdateMoraleMusicTrack(MusicTrackStruct NewMusicTrack)
{
    `log("UpdateMoraleMusicTrack()",, 'DRAudio');

    /*
    if (NewMusicTrack.TheSoundCue == none)
    {
        `log("[GameMusic] Waiting for morale track to load. Retry in 1 sec",, 'DRAudio');
        SetTimer(1.0, true, 'UpdateMoraleMusicTrack');
    }
    else
    {
        ClearTimer('UpdateMoraleMusicTrack');
        MusicComponent.FadeOut(NewMusicTrack.FadeOutTime, NewMusicTrack.FadeOutVolumeLevel);
        MusicComponent.SoundCue = NewMusicTrack.TheSoundCue;
        MusicComponent.FadeIn(NewMusicTrack.FadeInTime, NewMusicTrack.FadeInVolumeLevel);
    }
    */

    WorldInfo.UpdateMusicTrack(NewMusicTrack);
}

/**
 * Change the volume of the Morale Music
 *
 * @param   NewVolume       What to change the volume to
 * @param   TransitionTime  How long to take to blend to the new volume
 */
simulated function UpdateMusicVolume(float NewVolume, optional float TransitionTime)
{
    // Check if we are actually playing music
    if ( WorldInfo.MusicComp != none && WorldInfo.CurrentMusicTrack.TheSoundCue != none )
    {
        // Transition time can't be zero
        if( TransitionTime <= 0 )
        {
            TransitionTime = 0.001;
        }
        WorldInfo.MusicComp.AdjustVolume(TransitionTime, NewVolume);
    }
}

simulated function ClearWaitingForVictoryMusicToEnd()
{
    bWaitingForVictoryMusicToEnd = false;
    //`log(GetFuncName()$" bWaitingForVictoryMusicToEnd "$bWaitingForVictoryMusicToEnd);
    //ScriptTrace();
}

/**
 * Lower the volume of the morale music then bring it back up. Used for playing
 * other music or sounds and lowering the morale music while those other sounds
 * are playing.
 *
 * @param   StartDuckFadeLength     How long to take to blend to the new volume
 * @param   DuckVolume              Volume to duck the music volume to
 * @param   DuckDuration            How long to duck the music for
 */
reliable client function DuckMoraleMusic(float StartDuckFadeLength, float DuckVolume, float DuckDuration)
{
    local Float UsedDuration;

    //`log(GetFuncName()$" for "$DuckDuration$" seconds");
    //ScriptTrace();
    UsedDuration = FMax((DuckDuration - 0.5), 0.01);
    UpdateMusicVolume(DuckVolume, StartDuckFadeLength);
    SetTimer(UsedDuration, false, 'ClearMoraleMusicDuck');
}

/**
 * Clear the ducked morale music and return it to normal volume
 */
simulated function ClearMoraleMusicDuck()
{
    local AudioDevice Audio;
    local float MusicVolume;

    Audio = class'Engine'.static.GetAudioDevice();
    if (Audio != None)
    {
        MusicVolume = Audio.AkMusicVolume;
    }

    `log(GetFuncName(),, 'DRAudio');
    UpdateMusicVolume(MusicVolume, 0.5);
}

reliable client function MatchWon(
    byte WinningTeam, byte WinCondition, optional bool bUseCapturesForTieBreaking, optional int NorthTeamPointsTotal, optional int SouthTeamPointsTotal,
    optional int NorthRemainingReinforcements, optional int SouthRemainingReinforcements, optional int NorthTotalObjectivesCaptured,
    optional int SouthTotalObjectivesCaptured, optional int RoundTime, optional int NorthFastestWinTime, optional int SouthFastestWinTime,
    optional float NorthRoundScore, optional float SouthRoundScore, optional int NorthTotalTime, optional int SouthTotalTime,
    optional byte NorthReachedObjectiveIndex, optional byte SouthReachedObjectiveIndex, optional int NorthEnemiesKilled,
    optional int SouthEnemiesKilled, optional int NorthEnemiesRemaining, optional int SouthEnemiesRemaining, optional float RoundToMatchWinDelay,
    optional float FadeOutDuration)
{
    if (WorldInfo.NetMode == NM_DedicatedServer)
    {
        return;
    }

    bWaitingForVictoryMusicToEnd = True;

    if (RoundToMatchWinDelay == 0.f)
    {
        if (PlayerReplicationInfo.Team.TeamIndex == `NEUTRAL_TEAM_INDEX)
        {
            if (WinningTeam == `AXIS_TEAM_INDEX)
            {
                PlayAxisWinThemeStinger();
                // PlaySoundBase(NorthWinTheme, true);
            }
            else if (WinningTeam == `ALLIES_TEAM_INDEX)
            {
                PlayAlliesWinThemeStinger();
                // PlaySoundBase(SouthWinTheme, true);
            }
        }
        else if (WinningTeam == `AXIS_TEAM_INDEX)
        {
            if (PlayerReplicationInfo.Team.TeamIndex == WinningTeam)
            {
                PlayAxisWinThemeStinger();
                // PlaySoundBase(NorthWinTheme, true);
                PlayAnnouncerSound(EROAVT_General, GetTeamNum(), EROAMC_MatchWon);
            }
            else
            {
                PlayAlliesLossThemeStinger();
                // PlaySoundBase(SouthLossTheme, true);
                PlayAnnouncerSound(EROAVT_General, GetTeamNum(), EROAMC_MatchLost);
            }
        }
        else if (WinningTeam == `ALLIES_TEAM_INDEX)
        {
            if (PlayerReplicationInfo.Team.TeamIndex == WinningTeam)
            {
                PlayAlliesWinThemeStinger();
                // PlaySoundBase(SouthWinTheme, true);
                PlayAnnouncerSound(EROAVT_General, GetTeamNum(), EROAMC_MatchWon);
            }
            else
            {
                PlayAxisLossThemeStinger();
                // PlaySoundBase(NorthLossTheme, true);
                PlayAnnouncerSound(EROAVT_General, GetTeamNum(), EROAMC_MatchLost);
            }
        }

        ShowMatchWinScreen(WinningTeam, WinCondition, bUseCapturesForTieBreaking, NorthTeamPointsTotal, SouthTeamPointsTotal, NorthRemainingReinforcements,
                       SouthRemainingReinforcements, NorthTotalObjectivesCaptured, SouthTotalObjectivesCaptured, RoundTime,
                       NorthFastestWinTime, SouthFastestWinTime, NorthRoundScore, SouthRoundScore, NorthTotalTime,
                       SouthTotalTime, NorthReachedObjectiveIndex, SouthReachedObjectiveIndex, NorthEnemiesKilled,
                       SouthEnemiesKilled, NorthEnemiesRemaining, SouthEnemiesRemaining );
    }
    else
    {
        /*RoundWon(RoundWinningTeam, RoundWinCondition, bUseCapturesForTieBreaking, NorthTeamPointsTotal, SouthTeamPointsTotal, NorthRemainingReinforcements,
                       SouthRemainingReinforcements, NorthTotalObjectivesCaptured, SouthTotalObjectivesCaptured, RoundTime,
                       NorthFastestWinTime, SouthFastestWinTime, NorthRoundScore, SouthRoundScore,
                       WinningTeam < `ALLIES_TEAM_INDEX ? NorthReachedObjectiveIndex : SouthReachedObjectiveIndex,
                       NorthEnemiesKilled, SouthEnemiesKilled, NorthEnemiesRemaining, SouthEnemiesRemaining);*/

        if( FadeOutDuration > 0 )
        {
            StartRoundPreEndEffects(FadeOutDuration, RoundToMatchWinDelay);
        }
        else
        {
            // If we're delaying the display, but we have a fade out duration it means that the match is set to a single round,
            // so DelayedMatchWon will get called from elsewhere.
            SetTimer(RoundToMatchWinDelay, false, 'DelayedMatchWon');
        }

        StoredMatchWinInfo.WinningTeam = WinningTeam;
        StoredMatchWinInfo.WinCondition = WinCondition;
        StoredMatchWinInfo.bUseCapturesForTieBreaking = bUseCapturesForTieBreaking;
        StoredMatchWinInfo.NorthTeamPointsTotal = NorthTeamPointsTotal;
        StoredMatchWinInfo.SouthTeamPointsTotal = SouthTeamPointsTotal;
        StoredMatchWinInfo.NorthRemainingReinforcements = NorthRemainingReinforcements;
        StoredMatchWinInfo.SouthRemainingReinforcements = SouthRemainingReinforcements;
        StoredMatchWinInfo.NorthTotalObjectivesCaptured = NorthTotalObjectivesCaptured;
        StoredMatchWinInfo.SouthTotalObjectivesCaptured = SouthTotalObjectivesCaptured;
        StoredMatchWinInfo.RoundTime = RoundTime;
        StoredMatchWinInfo.NorthFastestWinTime = NorthFastestWinTime;
        StoredMatchWinInfo.SouthFastestWinTime = SouthFastestWinTime;
        StoredMatchWinInfo.NorthRoundScore = NorthRoundScore;
        StoredMatchWinInfo.SouthRoundScore = SouthRoundScore;
        StoredMatchWinInfo.NorthTotalTime = NorthTotalTime;
        StoredMatchWinInfo.SouthTotalTime = SouthTotalTime;
        StoredMatchWinInfo.NorthReachedObjectiveIndex = NorthReachedObjectiveIndex;
        StoredMatchWinInfo.SouthReachedObjectiveIndex = SouthReachedObjectiveIndex;
        StoredMatchWinInfo.NorthEnemiesKilled = NorthEnemiesKilled;
        StoredMatchWinInfo.SouthEnemiesKilled = SouthEnemiesKilled;
        StoredMatchWinInfo.NorthEnemiesRemaining = NorthEnemiesRemaining;
        StoredMatchWinInfo.SouthEnemiesRemaining= SouthEnemiesRemaining;
    }
}

simulated function PlayAxisWinThemeStinger()
{
    StingerComp.SoundCue = AxisWinTheme;
    StingerComp.Play();
    SetTimer(AxisWinTheme.GetCueDuration(),, 'ClearWaitingForVictoryMusicToEnd');
    DuckMoraleMusic(0.05, 0.0, AxisWinTheme.GetCueDuration());
}

simulated function PlayAlliesWinThemeStinger()
{
    StingerComp.SoundCue = AlliesWinTheme;
    StingerComp.Play();
    SetTimer(AlliesWinTheme.GetCueDuration(),, 'ClearWaitingForVictoryMusicToEnd');
    DuckMoraleMusic(0.05, 0.0, AlliesWinTheme.GetCueDuration());
}

// TODO:
simulated function PlayAlliesLossThemeStinger()
{

}

// TODO:
simulated function PlayAxisLossThemeStinger()
{

}

// --- END MORALE MUSIC ---

/*
function StartMusicFix()
{
    // Sometimes the music just cuts off entirely for an unknown reason.
    // Clients can restart it with the RestartMusic command, but
    // since people won't know how to do that, let's just try this.

    SetTimer(30.0, true, 'RestartMusic');
}

function float UserVolumeSetting()
{
    local AudioDevice Audio;
    Audio = class'Engine'.static.GetAudioDevice();

    if (Audio == none)
    {
        return 0.2;
    }

    return Audio.AkMusicVolume;
}

function CheckForVolumeChanges()
{
    if (WorldInfo.MusicComp != none)
    {
        // Don't change the volume if it's currently ducked
        if (WorldInfo.MusicComp.VolumeMultiplier != UserVolumeSetting() && !Ducking)
        {
            `dr("Volume does not match user settings, updating now",'M');

            // If the VolumeMultiplier is 0 we have to call PlayMusic so it can do FadeIn
            if (WorldInfo.MusicComp.VolumeMultiplier <= 0)
            {
                WorldInfo.CurrentMusicTrack.FadeInVolumeLevel = UserVolumeSetting();
                PlayMusic();
            }

            WorldInfo.MusicComp.VolumeMultiplier = UserVolumeSetting();
        }
    }

    if (StingerComp != none)
    {
        StingerComp.VolumeMultiplier = UserVolumeSetting();
    }
}

function DelayClearMusicComp()
{
    WorldInfo.MusicComp = none;
}

function UpdateCurrentMoraleMusicTrack()
{
    `dr("",'M');

    if (WorldInfo.MusicComp != none)
    {
        UpdateMoraleMusicTrack(WorldInfo.CurrentMusicTrack);
    }
}

function UpdateMoraleMusicTrack(MusicTrackStruct NewMusicTrack)
{
    local AudioComponent AC;

    if (MatchEnd)
    {
        `dr("Match over, clearing",'M');
        Ducking = true;
        WorldInfo.MusicComp.FadeOut(0.9, 0.0);
        SetTimer(1.0, false, 'DelayClearMusicComp');
        return;
    }

    `dr(""$ NewMusicTrack.TheSoundCue,'M');

    if (WorldInfo.MusicComp == none)
    {
        AC = GetPooledAudioComponent(NewMusicTrack.TheSoundCue, none, false, false);

        AC.bIsMusic = true;
        AC.bUseOwnerLocation = true;
        AC.PitchMultiplier = 1.0;
        AC.VolumeMultiplier = 1.0;
        AC.bWasOccluded = false;
        AC.OcclusionCheckInterval = 0.f;

        WorldInfo.MusicComp = AC;
    }
    // This is run AFTER we close the Round End screen and about to spawn in a new round
    else if (RoundEnd)
    {
        `dr("Round over, restarting",'M');

        // We don't need this atm since the round winning MoraleTransitionUp cue stops the background music
        // WorldInfo.MusicComp.FadeOut(0.9, 0.0);
        // SetTimer(1.0, false, 'DelayClearMusicComp');
    }
    else
    {
        Ducking = true;
        WorldInfo.MusicComp.FadeOut(0.9, 0.0);
    }

    RoundEnd = false;

    if (WorldInfo.CurrentMusicTrack != NewMusicTrack)
    {
        `dr("Setting new track",'M');
        WorldInfo.CurrentMusicTrack = NewMusicTrack;
    }

    SetTimer(1.0, false, 'PlayMusic');
}

function PlayMusic()
{
    `dr("",'M');

    Ducking = false;
    WorldInfo.MusicComp.VolumeMultiplier = UserVolumeSetting();
    WorldInfo.MusicComp.SoundCue = WorldInfo.CurrentMusicTrack.TheSoundCue;
    WorldInfo.MusicComp.FadeIn(0.0, WorldInfo.CurrentMusicTrack.FadeInVolumeLevel);
}

// If for some reason the music bugs out the client can restart it with this command
exec function RestartMusic()
{
    if (WorldInfo.MusicComp == none || Ducking || RoundEnd || MatchEnd || UserVolumeSetting() < 0.01)
    {
        `dr("Not Running",'M');
        return;
    }

    if (WorldInfo.MusicComp.SoundCue == none || WorldInfo.MusicComp.VolumeMultiplier < UserVolumeSetting())
    {
        `dr("Performing Music Fix",'M');

        WorldInfo.MusicComp.VolumeMultiplier = UserVolumeSetting();
        WorldInfo.MusicComp.SoundCue = WorldInfo.CurrentMusicTrack.TheSoundCue;
        WorldInfo.MusicComp.FadeIn(0.0, WorldInfo.CurrentMusicTrack.FadeInVolumeLevel);
    }
    else
    {
        `dr("Not Performing",'M');
    }
}
*/

/*
function DelayedMatchWon()
{
    MatchEnd = true;
    UpdateCurrentMoraleMusicTrack();

    if (CurrentAfterActionReportScene != none)
    {
        LocalPlayer(Player).ViewportClient.UIController.SceneClient.CloseScene(CurrentAfterActionReportScene);
        CurrentAfterActionReportScene = none;
    }

    if (StoredMatchWinInfo.WinningTeam == `AXIS_TEAM_INDEX)
    {
        PlayStinger(AxisWinTheme);
        SetTimer(AxisWinTheme.GetCueDuration(),, 'ClearWaitingForVictoryMusicToEnd');
    }
    else if (StoredMatchWinInfo.WinningTeam == `ALLIES_TEAM_INDEX)
    {
        PlayStinger(AlliesWinTheme);
        SetTimer(AlliesWinTheme.GetCueDuration(),, 'ClearWaitingForVictoryMusicToEnd');
    }

    ShowMatchWinScreen(StoredMatchWinInfo.WinningTeam, StoredMatchWinInfo.WinCondition, StoredMatchWinInfo.bUseCapturesForTieBreaking,
                        StoredMatchWinInfo.NorthTeamPointsTotal, StoredMatchWinInfo.SouthTeamPointsTotal, StoredMatchWinInfo.NorthRemainingReinforcements,
                        StoredMatchWinInfo.SouthRemainingReinforcements, StoredMatchWinInfo.NorthTotalObjectivesCaptured,
                        StoredMatchWinInfo.SouthTotalObjectivesCaptured, StoredMatchWinInfo.RoundTime, StoredMatchWinInfo.NorthFastestWinTime,
                        StoredMatchWinInfo.SouthFastestWinTime, StoredMatchWinInfo.NorthRoundScore, StoredMatchWinInfo.SouthRoundScore,
                        StoredMatchWinInfo.NorthTotalTime, StoredMatchWinInfo.SouthTotalTime, StoredMatchWinInfo.NorthReachedObjectiveIndex,
                        StoredMatchWinInfo.SouthReachedObjectiveIndex, StoredMatchWinInfo.NorthEnemiesKilled, StoredMatchWinInfo.SouthEnemiesKilled,
                        StoredMatchWinInfo.NorthEnemiesRemaining, StoredMatchWinInfo.SouthEnemiesRemaining );
}
*/

/*
reliable client function ClientCloseTeamWinScreen()
{
    `dr("",'M');

    super.ClientCloseTeamWinScreen();

    RoundEnd = true;
}

reliable client function SetNewMoraleMusicTrack(MusicTrackStruct NewMusicTrack, optional float WaitTime)
{
    NewMusicTrack.FadeInVolumeLevel = UserVolumeSetting();

    UpdateMoraleMusicTrack(NewMusicTrack);
}

simulated function UpdateMusicVolume(float NewVolume, optional float TransitionTime)
{
    if (WorldInfo.MusicComp != none && WorldInfo.CurrentMusicTrack.TheSoundCue != none)
    {
        if (TransitionTime <= 0)
        {
            TransitionTime = 0.001;
        }

        `dr("Adjusting volume to" @ NewVolume,'M');

        WorldInfo.MusicComp.AdjustVolume(TransitionTime, NewVolume);
    }
}

reliable client function DuckMoraleMusic(float StartDuckFadeLength, float DuckVolumeModifier, float DuckDuration)
{
    local float UsedDuration, MusicVolume;

    `dr("",'M');

    Ducking = true;

    UsedDuration = FMax(DuckDuration (DuckDuration - 0.5), 0.01);

    MusicVolume = UserVolumeSetting() * DuckVolumeModifier;

    UpdateMusicVolume(MusicVolume, StartDuckFadeLength);

    ClearTimer('ClearMoraleMusicDuck');

    SetTimer(UsedDuration, false, 'ClearMoraleMusicDuck');
}

simulated function ClearMoraleMusicDuck()
{
    `dr("",'M');

    Ducking = false;

    UpdateMusicVolume(UserVolumeSetting(), 0.5);
}
*/

/*
function HitThisCommon(ROTriggerRadio ROTR, optional ROVehicle ROV = none, optional int SeatIndex = -1)
{
    local ROGameReplicationInfo ROGRI;
    local int PawnTeam, SupportToRequest;
    local float RadioDelay;
    local bool bIsVehicle, bSpotBecameInvalid;
    local ROTeamInfo ROTI;
    local Actor ActualTalker;
    local ROPlayerReplicationInfo ROPRIForBroadcast;

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);

    bIsVehicle = ROV != none;
    PawnTeam = Pawn.GetTeamNum();
    SupportToRequest = SavedArtyType;

    ActualTalker = (bIsVehicle) ? ROV : ROTR;
    ROPRIForBroadcast = (ROTR != none) ? ROPlayerReplicationInfo(PlayerReplicationInfo) : none;

    RadioDelay = 10.0;

    if ( WorldInfo != none && WorldInfo.GRI != none && ROTeamInfo(WorldInfo.GRI.Teams[PawnTeam]) != none && ROTeamInfo(WorldInfo.GRI.Teams[PawnTeam]).SavedArtilleryCoords == vect(-999999.0,-999999.0,-999999.0) )
    {
        bSpotBecameInvalid = true;
    }
    `drtrace;

    if ( ROGRI.bArtilleryAvailable[PawnTeam] == 1 && !bSpotBecameInvalid )
    {
        if (SupportToRequest == 2)
        {
            ROGameInfo(WorldInfo.Game).BroadcastLocalizedVoiceCom(`VOICECOM_Ability3Confirm, Pawn, SeatIndex, ActualTalker, ROPRIForBroadcast, true, PawnTeam);

            SetTimer(10, false, 'ServerBombingRun');
            ReceiveLocalizedMessage(class'ROLocalMessageAirSupport', ROMSG_BomberConfirmed,,, self);
        }
        else if (SupportToRequest == 1)
        {
            ReceiveLocalizedMessage(class'ROLocalMessageArtillery', 3,,, self);
            ROGameInfo(WorldInfo.Game).BroadcastLocalizedVoiceCom(`VOICECOM_Ability2Confirm, Pawn, SeatIndex, ActualTalker, ROPRIForBroadcast, true, PawnTeam);
            SetTimer(8, false, 'ServerArtyStrike');
        }
        else
        {
            ReceiveLocalizedMessage(class'ROLocalMessageArtillery', 3,,, self);
            ROGameInfo(WorldInfo.Game).BroadcastLocalizedVoiceCom(`VOICECOM_Ability1Confirm, Pawn, SeatIndex, ActualTalker, ROPRIForBroadcast, true, PawnTeam);
            SetTimer(8, false, 'ServerArtyStrike');
        }

        SetTimer(10, false, 'ResetCommanderMadeRequest');
        DelayedClearRadioCallin(RadioDelay);
    }
    else
    {
        ClientSetArtyMarkStatusBits(0);

        ROTI = ROTeamInfo(PlayerReplicationInfo.Team);

        if ( ROTI != none )
        {
            ROTI.SetCommanderHasMadeRequest(false);
        }

        DelayedClearRadioCallin(8.5);

        if ( ROGRI.TotalStrikes[PawnTeam] >= ROGRI.ArtilleryStrikeLimit[PawnTeam] )
        {
            ReceiveLocalizedMessage(class'ROLocalMessageArtillery', ROAMSG_OutOfStrikes,,,ROV);
        }
        else
        {
            if( SupportToRequest == 2 )
            {
                ReceiveLocalizedMessage(class'ROLocalMessageAirSupport', ROMSG_BomberDenied,,,ROV);
            }
            else
            {
                ReceiveLocalizedMessage(class'ROLocalMessageArtillery', ROAMSG_StrikeDenied,,,ROV);
            }
        }
    }

    SetTimer(35, false, 'ResetArtyMarkStatusBitTimerDelegate');
}

simulated function AttemptRequestAerialRecon(optional ROTriggerRadio RadioUsed)
{
    `dr("",'CMDA');

    if (Pawn == none || ROMapInfo(WorldInfo.GetMapInfo()) == none)
    {
        return;
    }

    if( ROPlayerReplicationInfo(PlayerReplicationInfo) == none || ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none || !ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.bIsTeamLeader )
    {
        return;
    }

    bRadioCallinProgress = true;

    ServerRequestAerialRecon(RadioUsed);
}

reliable protected server function ServerRequestAerialRecon(optional ROTriggerRadio RadioUsed)
{
    local ROTeamInfo ROTI;
    local int Team;

    if( Pawn == none )
    {
        ClientClearRadioCallin();
        return;
    }

    Team = GetTeamNum();

    switch ( Team )
    {
        case `AXIS_TEAM_INDEX:
            ROTI = ROTeamInfo(WorldInfo.GRI.Teams[`AXIS_TEAM_INDEX]);
            break;

        case `ALLIES_TEAM_INDEX:
            ROTI = ROTeamInfo(WorldInfo.GRI.Teams[`ALLIES_TEAM_INDEX]);
            break;

        default:
            ClientClearRadioCallin();
            return;
    }

    if( RadioUsed == none || VSizeSq(Pawn.Location - RadioUsed.Location) > 10000 )
    {
        ClientClearRadioCallin();
        return;
    }

    AerialReconRadio = RadioUsed;

    if( ROVehicleBase(Pawn) != none )
    {
        ROGameInfo(WorldInfo.Game).BroadcastLocalizedVoiceCom(`VOICECOM_CallForReconPlane, Pawn, , , , true, Team, ROPlayerReplicationInfo(PlayerReplicationInfo).SquadIndex);
    }
    else
    {
        ROGameInfo(WorldInfo.Game).HandleBattleChatterEvent(Pawn, `BATTLECHATTER_CallForReconPlane);
    }

    if(ROPlayerReplicationInfo(PlayerReplicationInfo) == none
        || ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none
        || !ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.bIsTeamLeader
        || ROTI == none
        || ROTI.NextAerialReconTime < WorldInfo.GRI.RemainingTime)
    {
        SetTimer(9.0f, false, 'ReconPlaneDenied');
        return;
    }
    else
    {
        SetTimer(9.0f, false, 'ReconPlaneOnTheWay');
    }

    NotifyCommanderAbilityRequested(3, 9.f);
}

function SpawnAerialRecon()
{
    local Sequence GameSeq;
    local array<SequenceObject> AerialReconSeqEvents;
    local Actor AerialReconBaseActor;
    local int Team, i;
    local float ReconDuration;
    local ROTeamInfo ROTI;

    Team = GetTeamNum();

    if( Team > `ALLIES_TEAM_INDEX )
        return;

    ROTI = ROTeamInfo(WorldInfo.GRI.Teams[Team]);

    GameSeq = WorldInfo.GetGameSequence();
    if ( GameSeq != none )
    {
        GameSeq.FindSeqObjectsByClass(class'ROSeqEvent_AerialRecon', true, AerialReconSeqEvents);

        for (i = 0; i < AerialReconSeqEvents.Length; i++)
        {
            AerialReconBaseActor = ROSeqEvent_AerialRecon(AerialReconSeqEvents[i]).TriggerRecon(Team, false, ReconDuration);

            if (AerialReconBaseActor != none)
            {
                if (DRGameInfoTerritories(WorldInfo.Game) != none)
                {
                    DRGameInfoTerritories(WorldInfo.Game).SpawnAerialReconPlane(AerialReconBaseActor, ReconDuration, self);
                }
                else
                {
                    AerialReconBaseActor = none;
                }

                break;
            }
        }
    }

    if( AerialReconBaseActor == none )
    {
        ROTI.NextAerialReconTime = WorldInfo.GRI.RemainingTime;
    }

    BroadcastLocalizedTeamMessage(GetTeamNum(), class'ROLocalMessageGameRedAlert', RORAMSG_ReconEnRoute);
}

simulated function AttemptRequestArtillery(ROTriggerRadio RadioUsed, byte ArtyType)
{
    local ROPlayerReplicationInfo ROPRI;
    ROPRI = ROPlayerReplicationInfo(PlayerReplicationInfo);

    if ( ROPRI == none || ROPRI.RoleInfo == none || !ROPRI.RoleInfo.bIsTeamLeader )
    {
        return;
    }

    bRadioCallinProgress = true;

    SavedArtyType = ArtyType;

    `dr("ArtyType" @ ArtyType,'CMDA');

    ServerRequestArtillery(RadioUsed, ArtyType);
}

reliable protected server function ServerRequestArtillery(ROTriggerRadio RadioUsed, byte ArtyType)
{
    local ROPlayerReplicationInfo ROPRI;
    local ROTeamInfo ROTI;

    ROPRI = ROPlayerReplicationInfo(PlayerReplicationInfo);

    if ( ROPRI == none || ROPRI.RoleInfo == none || !ROPRI.RoleInfo.bIsTeamLeader )
    {
        ClientClearRadioCallin();
        return;
    }

    ROTI = ROTeamInfo(PlayerReplicationInfo.Team);

    if ( ROTI != none )
    {
        ROTI.SetCommanderHasMadeRequest(true);
        SetSpotterIndexByDamageType(ArtyType, ROTI.SelectedArtyIndex);
    }

    SavedArtyType = ArtyType;

    if ( RadioUsed != none )
    {
        RadioUsed.RequestArty(Pawn, ArtyType);
    }
    else if ( ROPRI.RoleInfo.bCanBeTankCrew )
    {
        VehicleRequestArty();
    }
}

reliable protected server function ServerArtyStrike()
{
    local ROGameReplicationInfo ROGRI;
    local vector SpawnLocation, MyGravity;
    local ROArtillerySpawner Spawner;
    local PlayerController C;
    local ROTeamInfo ROTI;
    local int CachedArtyTime;
    local int TeamNum;

    `dr("",'CMDA');

    if (ROPlayerReplicationInfo(PlayerReplicationInfo) == none || ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none || Pawn == none )
    {
        return;
    }

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);
    ROTI = ROTeamInfo(PlayerReplicationInfo.Team);

    TeamNum = GetTeamNum();

    MyGravity.X = 0.0;
    MyGravity.Y = 0.0;
    MyGravity.Z = PhysicsVolume.GetGravityZ();

    if (SavedArtyType < 1)
    {
        CachedArtyTime = ROGRI.NextAbilityOneTime[TeamNum];
        ROGRI.NextAbilityOneTime[TeamNum] = WorldInfo.GRI.RemainingTime - GetNextAbilityDelay(1);
    }
    else
    {
        CachedArtyTime = ROGRI.NextAbilityTwoTime[TeamNum];
        ROGRI.NextAbilityTwoTime[TeamNum] = WorldInfo.GRI.RemainingTime - GetNextAbilityDelay(2);
    }

    ROGRI.bArtilleryAvailable[TeamNum] = 0;
    ROGRI.TotalStrikes[TeamNum]++;

    if (ROTI != none)
    {
        ROTI.ArtyStrikeLocation = ROTI.SavedArtilleryCoords;
    }

    SpawnLocation = ROTI.SavedArtilleryCoords;
    SpawnLocation.Z = ROGameReplicationInfo(WorldInfo.GRI).ArtySpawn.Z;

    Spawner = Spawn(class'WWArtillerySpawner',self,, SpawnLocation, rotator(MyGravity));

    if (Spawner != none)
    {
        Spawner.OriginalArtyLocation = ROTI.SavedArtilleryCoords;
        Spawner.CachedArtyTime = CachedArtyTime;
        Spawner.SpawnTeam = TeamNum;
    }

    `dr("Created" @ Spawner, 'CMDA');

    foreach WorldInfo.AllControllers(class'PlayerController', C)
    {
        if (C != none && C.GetTeamNum() == TeamNum )
        {
            C.ReceiveLocalizedMessage(class'ROLocalMessageGameRedAlert', RORAMSG_ArtilleryStrike);
        }
    }
}

reliable protected server function ServerBombingRun()
{
    local ROGameReplicationInfo ROGRI;
    local vector TargetLocation, SpawnLocation;
    local vector2D StrikeDirection;
    local ROCarpetBomberAircraft Aircraft;
    local PlayerController C;
    local ROTeamInfo ROTI;
    local int SpawnedCnt;

    `dr("",'CMDA');

    if (ROPlayerReplicationInfo(PlayerReplicationInfo) == none || ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none || Pawn == none)
    {
        return;
    }

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);
    ROTI = ROTeamInfo(PlayerReplicationInfo.Team);

    ROGRI.NextAbilityThreeTime[GetTeamNum()] = WorldInfo.GRI.RemainingTime - GetNextAbilityDelay(3);
    ROGRI.bArtilleryAvailable[GetTeamNum()] = 0;
    ROGRI.TotalStrikes[GetTeamNum()]++;

    if ( ROTI != none )
    {
        ROTI.ArtyStrikeLocation = ROTI.SavedArtilleryCoords;
        ROTI.StrikeDirection = ROTI.SavedStrikeDirection;

        TargetLocation = ROTI.SavedArtilleryCoords;
        StrikeDirection = ROTI.SavedStrikeDirection;
    }

    // SpawnLocation = GetBestAircraftSpawnLoc(TargetLocation, WWMapInfo(WorldInfo.GetMapInfo()).SovietBomberHeightOffset, class'WWCarpetBomberAircraft', StrikeDirection);

    TargetLocation.Z = SpawnLocation.Z;
    if( ROTI.StrikeDirection == vect2D(0,0) )
        ROTI.StrikeDirection = StrikeDirection;

    Aircraft = Spawn(class'WWCarpetBomberAircraft',self,, SpawnLocation, rotator(TargetLocation - SpawnLocation));

    if ( Aircraft == none )
    {
        return;
    }
    else
    {
        Aircraft.TargetLocation = ROTI.ArtyStrikeLocation;
        Aircraft.SetDropPoint();
        Aircraft.SetOffset(1);
        SpawnedCnt++;
    }

    Aircraft = Spawn(class'WWCarpetBomberAircraft',self,, SpawnLocation, rotator(TargetLocation - SpawnLocation));

    if ( Aircraft == none )
    {
        return;
    }
    else
    {
        Aircraft.TargetLocation = ROTI.ArtyStrikeLocation;
        Aircraft.InboundDelay += 1;
        Aircraft.SetDropPoint();
        Aircraft.SetOffset(2);
        SpawnedCnt++;
    }

    if( SpawnedCnt == 0 )
        return;

    foreach WorldInfo.AllControllers(class'PlayerController', C)
    {
        if (C != none && C.GetTeamNum() == GetTeamNum())
        {
            C.ReceiveLocalizedMessage(class'ROLocalMessageGameRedAlert', RORAMSG_BombingRun);
        }
    }
}

simulated function AttemptRequestAntiAir(ROTriggerRadio RadioUsed)
{
    if (Pawn == none || ROMapInfo(WorldInfo.GetMapInfo()) == none)
    {
        return;
    }

    if (ROPlayerReplicationInfo(PlayerReplicationInfo) == none || ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none || !ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.bIsTeamLeader)
    {
        return;
    }

    `dr("",'CMDA');

    bRadioCallinProgress = true;

    ServerRequestAntiAirNew(RadioUsed);
}

reliable server function ServerRequestAntiAirNew(ROTriggerRadio RadioUsed)
{
    if (RadioUsed != none)
    {
        RadioUsed.RequestAntiAir(Pawn);
    }
}

function HandleRequestAntiAir(ROTriggerRadio ROTR)
{
    local ROGameReplicationInfo ROGRI;
    local int TimeTilNextUse;
    local int PawnTeam;

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);
    PawnTeam = Pawn.GetTeamNum();

    if (ROGRI.bAntiAirAvailable[PawnTeam] == 1)
    {
        DelayedClearRadioCallin(12.5);

        ReceiveLocalizedMessage(class'ROLocalMessageAirSupport', ROMSG_AntiAirConfirmed,,, self);
        ROGameInfo(WorldInfo.Game).BroadcastLocalizedVoiceCom(`VOICECOM_Ability3Confirm, Pawn, , ROTR, , true, PawnTeam);

        ServerEnableAntiAir();
    }
    else
    {
        TimeTilNextUse = ROGRI.RemainingTime - ROGRI.NextAbilityThreeTime[PawnTeam];

        DelayedClearRadioCallin(10.0);

        if ( TimeTilNextUse >= 20 )
        {
            ReceiveLocalizedMessage(class'ROLocalMessageAirSupport', ROMSG_AntiAirTryLater,,,ROTR);
        }
        else if ( TimeTilNextUse >= 0 )
        {
            ReceiveLocalizedMessage(class'ROLocalMessageAirSupport', ROMSG_AntiAirTrySoon,,,ROTR);
        }
        else
        {
            ReceiveLocalizedMessage(class'ROLocalMessageAirSupport', ROMSG_AntiAirDenied,,,ROTR);
        }
    }
}

reliable protected server function ServerEnableAntiAir()
{
    local ROGameReplicationInfo ROGRI;
    local PlayerController C;

    if (ROPlayerReplicationInfo(PlayerReplicationInfo) == none || ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none || Pawn == none)
    {
        return;
    }

    `dr("",'CMDA');

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);
    ROGRI.NextAbilityThreeTime[GetTeamNum()] = WorldInfo.GRI.RemainingTime - GetNextAbilityDelay(3);
    ROGRI.bAntiAirAvailable[GetTeamNum()] = 0;

    // Spawn(class'WWFighterPlaneManager', self,, GetSAMSpawnLoc());

    foreach WorldInfo.AllControllers(class'PlayerController', C)
    {
        if (C != none && C.GetTeamNum() == GetTeamNum())
        {
            C.ReceiveLocalizedMessage(class'ROLocalMessageGameRedAlert', RORAMSG_SAMStrike);
        }
    }
}
*/

function CheckPickup(out ROPawn P, out ROWeapon SwapWeapon, class<Inventory> ItemClass)
{
    `drtrace;
    /*
    local int IsAmmoPickup;

    if ( ROInventoryManager(P.InvManager).IsPickupCausingWeaponSwap(ItemClass, ActorAimedAt, SwapWeapon, IsAmmoPickup) )
    {
        if( P.InvManager.PendingWeapon != SwapWeapon )
        {
            ReceiveLocalizedMessage(class'DRLocalMessageGamePickup', ItemClass.default.InvIndex + class'DRLocalMessageGamePickup'.const.ROMSG_PickupSwap,PlayerReplicationInfo,,SwapWeapon);
        }
    }
    else
    {
        if ( IsAmmoPickup < 1 )
        {
            if( ROInventoryManager(P.InvManager).HandlePickupQuery(ItemClass, SwapWeapon, true) )
                ReceiveLocalizedMessage(class'WWLocalMessageGamePickup', ItemClass.default.InvIndex,PlayerReplicationInfo);
        }
        else
        {
            ReceiveLocalizedMessage(class'DRLocalMessageGamePickup', ItemClass.default.InvIndex + class'DRLocalMessageGamePickup'.const.ROMSG_PickupAmmo, PlayerReplicationInfo);
        }
    }
    */
}

function UsePickup(class<Inventory> ItemClass)
{
    local Inventory Inv;
    local bool bWasAmmo;
    local int DesiredClips, NewClips;
    local EROInventoryCategory AmmoCategory;

    for ( Inv = ROInventoryManager(Pawn.InvManager).InventoryChain; Inv != None; Inv = Inv.Inventory )
    {
        if ( ROWeapon(Inv) != None && class<ROWeapon>(ItemClass) != none && ROWeapon(Inv).InvIndex == ItemClass.default.InvIndex )
        {
            if (RODroppedPickup(ActorAimedAt) != none)
            {
                if( class<ROWeapon>(ItemClass).default.WeaponClassType == ROWCT_Melee )
                {
                    break;
                }

                if(ROWeapon(Inv).Category == ROIC_Grenade)
                {
                    AmmoCategory = ROIC_Grenade;
                }
                else
                {
                    AmmoCategory = ROIC_Ammo;
                }

                DesiredClips = ROWeapon(RODroppedPickup(ActorAimedAt).Inventory).GetTotalAmmoCount() / ROWeapon(Inv).default.MaxAmmoCount;
                NewClips = Min((ROInventoryManager(Pawn.InvManager).CategoryLimits[AmmoCategory] - ROInventoryManager(Pawn.InvManager).CategoryCounts[AmmoCategory]) * ROWeapon(Inv).AmmoClass.default.ClipsPerSlot, DesiredClips);
                NewClips = Min(NewClips, ROWeapon(Inv).MaxNumPrimaryMags - ROWeapon(Inv).AmmoArray.length);

                if( NewClips <= 0)
                {
                    `drtrace;
                    // ReceiveLocalizedMessage(class'DRLocalMessageGamePickup', class'DRLocalMessageGamePickup'.const.ROMSG_PickupAmmoFail + ItemClass.default.InvIndex);
                    SetTimer(0.5, false, 'FindActorAimedAt');
                    bWasAmmo = true;
                    break;
                }

                ROWeapon(Inv).GiveClips(NewClips);
                RODroppedPickup(ActorAimedAt).PickedUpBy(Pawn);
            }
            else if (ROPickupFactory(ActorAimedAt) != none)
            {
                if(!ROPickupFactory(ActorAimedAt).CanBeUsed(Pawn))
                {
                    break;
                }

                DesiredClips = (ROWeapon(Inv).default.MaxAmmoCount * ROWeapon(Inv).default.InitialNumPrimaryMags) / ROWeapon(Inv).default.MaxAmmoCount;
                NewClips = Min((ROInventoryManager(Pawn.InvManager).CategoryLimits[AmmoCategory] - ROInventoryManager(Pawn.InvManager).CategoryCounts[AmmoCategory]) * ROWeapon(Inv).AmmoClass.default.ClipsPerSlot, DesiredClips);

                if( NewClips <= 0)
                {
                    `drtrace;
                    // ReceiveLocalizedMessage(class'DRLocalMessageGamePickup', class'DRLocalMessageGamePickup'.const.ROMSG_PickupAmmoFail + ItemClass.default.InvIndex);
                    SetTimer(0.5, false, 'FindActorAimedAt');
                    bWasAmmo = true;
                    break;
                }

                ROWeapon(Inv).RefillAmmo();
                ROPickupFactory(ActorAimedAt).PickedUpBy(Pawn);
            }
            `drtrace;
            // ReceiveLocalizedMessage(class'WWLocalMessageGamePickup', class'WWLocalMessageGamePickup'.const.ROMSG_PickedupAmmo + ItemClass.default.InvIndex);
            bWasAmmo = true;
            break;
        }
    }
    if ( Pawn.bCanPickupInventory && WorldInfo.Game.PickupQuery(Pawn, ItemClass, ActorAimedAt) )
    {
        if ( !bWasAmmo )
        {
            if (RODroppedPickup(ActorAimedAt) != none)
            {
                if( class<ROWeapon>(ItemClass).default.WeaponClassType == ROWCT_Melee )
                {
                    ROPawn(Pawn).TossWeapon(ROWeapon(Inv));
                }
                RODroppedPickup(ActorAimedAt).GiveTo(Pawn);
                `drtrace;
                // ReceiveLocalizedMessage(class'WWLocalMessageGamePickup', class'WWLocalMessageGamePickup'.const.ROMSG_Pickedup + ItemClass.default.InvIndex);
            }
            else if (ROPickupFactory(ActorAimedAt) != none && ROPickupFactory(ActorAimedAt).CanBeUsed(Pawn)) // Fix CLBIT-102 - Nate.
            {
                ROPickupFactory(ActorAimedAt).GiveTo(Pawn);
                `drtrace;
                // ReceiveLocalizedMessage(class'WWLocalMessageGamePickup', class'WWLocalMessageGamePickup'.const.ROMSG_Pickedup + ItemClass.default.InvIndex);

                for ( Inv = ROInventoryManager(Pawn.InvManager).InventoryChain; Inv != None; Inv = Inv.Inventory )
                {
                    if ( ROWeapon(Inv) != None && class<ROWeapon>(ROPickupFactory(ActorAimedAt).InventoryType) != none && ROWeapon(Inv).InvIndex == ROPickupFactory(ActorAimedAt).InventoryType.default.InvIndex )
                    {
                        ROWeapon(Inv).RefillAmmo();
                        ROWeapon(Inv).GiveInitialAmmo();
                        break;
                    }
                }
                ROPickupFactory(ActorAimedAt).SetRespawn();
            }
            ActorAimedAt = none;
        }
    }
}

// TODO: tank squad system.
reliable protected server function ServerJoinSquad(int NewSquadIndex, optional bool bViaInvite)
{
    if (ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.RoleType == RORIT_Tank)
    {
        return;
    }
    else
    {
        super.ServerJoinSquad(NewSquadIndex, bViaInvite);
    }
}

/*
simulated function FindUsableActor()
{
    super.FindUsableActor();

    if (bInVehicleRange && ActorAimedAt.IsA('WWVehicleTank') && ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.RoleType != RORIT_Tank && !ActorAimedAt.IsA('WWVehicleStaticATGun'))
    {
        bInVehicleRange = false;
    }
}
*/

// TODO: check the need for this:
/*
function PlayAnnouncerSound(byte VoxType, byte Team, byte VOXIndex, optional byte SubIndex, optional vector PlayLocation, optional Actor Speaker, optional int SeatIndex)
{
    if (VoxType == EROAVT_Radio)
    {
        super.PlayAnnouncerSound(VoxType, Team, VOXIndex, SubIndex, PlayLocation, Speaker, SeatIndex);
    }
}
*/

// TODO:
// function TriggerHint(int HintID, optional bool bTriggerDead) {}

/*
function InitialiseCCMs()
{
    local ROCharacterPreviewActor ROCPA, CPABoth;
    local ROCharCustMannequin TempCCM;

    if( WorldInfo.NetMode == NM_DedicatedServer )
        return;

    if( ROCCC == none )
    {
        ROCCC = Spawn(class'ROCharCustController');

        if( ROCCC != none )
            ROCCC.ROPCRef = self;
    }

    foreach WorldInfo.DynamicActors(class'ROCharacterPreviewActor', ROCPA)
    {
        if( ROCPA.OwningTeam == EOT_Both )
        {
            CPABoth = ROCPA;
        }
        else if( AllCCMs[ROCPA.OwningTeam] == none )
        {
            AllCCMs[ROCPA.OwningTeam] = Spawn(class'DRCharCustMannequin', self,, ROCPA.Location, ROCPA.Rotation);
        }
    }

    if( AllCCMs[0] == none || AllCCMs[1] == none )
    {
        if( CPABoth != none )
            TempCCM = Spawn(class'DRCharCustMannequin', self,, CPABoth.Location, CPABoth.Rotation);
        else
        {
            TempCCM = Spawn(class'DRCharCustMannequin', self, , vect(0,0,100));
        }

        TempCCM.SetOwningTeam(EOT_Both);

        if( AllCCMs[0] == none )
            AllCCMs[0] = TempCCM;

        if( AllCCMs[1] == none )
            AllCCMs[1] = TempCCM;
    }
}
*/

/*
simulated function CreateVoicePacks(byte TeamIndex)
{
    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        AnnouncerPacks[`AXIS_TEAM_INDEX] = new(Outer) AllAnnouncerPacks[`AXIS_TEAM_INDEX];
        AnnouncerPacks[`ALLIES_TEAM_INDEX] = new(Outer) AllAnnouncerPacks[`ALLIES_TEAM_INDEX];
    }
}
*/

simulated function CreateVoicePacks(byte TeamIndex)
{
    local ROMapInfo ROMI;
    local int NorthNationIndex;
    local int SouthNationIndex;

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    // Allow announcer packs in PIE.
    if (ROMI != none)
    {
        NorthNationIndex = ROMI.GetNorthernNation();
        SouthNationIndex = ROMI.GetSouthernNation();
    }

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        AnnouncerPacks[`AXIS_TEAM_INDEX] = new(Outer) AllAnnouncerPacks[NorthNationIndex];
        AnnouncerPacks[`ALLIES_TEAM_INDEX] = new(Outer) AllAnnouncerPacks[SouthNationIndex];

        AnnouncerPacks[`AXIS_TEAM_INDEX].InitObjCooldowns();
        AnnouncerPacks[`ALLIES_TEAM_INDEX].InitObjCooldowns();

        AnnouncerPacksCustom[`AXIS_TEAM_INDEX] = new(Outer) AllAnnouncerPacksCustom[NorthNationIndex];
        AnnouncerPacksCustom[`ALLIES_TEAM_INDEX] = new(Outer) AllAnnouncerPacksCustom[SouthNationIndex];

        AnnouncerPacksCustom[`AXIS_TEAM_INDEX].InitObjCooldowns();
        AnnouncerPacksCustom[`ALLIES_TEAM_INDEX].InitObjCooldowns();
    }

    NorthTeamVoicePacks[0] = AllTeamVoicePacksOne[NorthNationIndex];
    NorthTeamVoicePacks[1] = AllTeamVoicePacksTwo[NorthNationIndex];
    NorthTeamVoicePacks[2] = AllTeamVoicePacksThree[NorthNationIndex];

    SouthTeamVoicePacks[0] = AllTeamVoicePacksOne[SouthNationIndex];
    SouthTeamVoicePacks[1] = AllTeamVoicePacksTwo[SouthNationIndex];
    SouthTeamVoicePacks[2] = AllTeamVoicePacksThree[SouthNationIndex];

    NorthTeamVoicePacksCustom[0] = AllTeamVoicePacksOneCustom[NorthNationIndex];
    NorthTeamVoicePacksCustom[1] = AllTeamVoicePacksTwoCustom[NorthNationIndex];
    NorthTeamVoicePacksCustom[2] = AllTeamVoicePacksThreeCustom[NorthNationIndex];

    SouthTeamVoicePacksCustom[0] = AllTeamVoicePacksOneCustom[SouthNationIndex];
    SouthTeamVoicePacksCustom[1] = AllTeamVoicePacksTwoCustom[SouthNationIndex];
    SouthTeamVoicePacksCustom[2] = AllTeamVoicePacksThreeCustom[SouthNationIndex];

    /*
    // Hardcoded handler for ARVN combat pilots, who are spawned as US chars.
    // Not worth writing a proper system unless we somehow end up with a second nation requiring someone else's pilots.
    if( ROMI != none && SouthIndex == SFOR_ARVN && ROMI.TeamHasCombatPilots(`ALLIES_TEAM_INDEX) )
    {
        SouthTeamAltVoicePacks[0] = AllTeamVoicePacksOne[1];
        SouthTeamAltVoicePacks[1] = AllTeamVoicePacksTwo[1];
        SouthTeamAltVoicePacks[2] = AllTeamVoicePacksThree[1];
    }
    */
}

function RightLeftLean()
{
    ServerLeanLeft(bWantsToLeanLeft);
}

function LeftRightLean()
{
    ServerLeanRight(bWantsToLeanRight);
}

exec function LeanRight()
{
    if (Pawn != None)
    {
        if (ROPawn(Pawn) != None)
        {
            ROPawn(Pawn).LeanRight();
        }
    }

    ServerLeanRight(True);
}

exec function LeanLeft()
{
    if (Pawn != None)
    {
        if (ROPawn(Pawn) != None)
        {
            ROPawn(Pawn).LeanLeft();
        }
    }


    ServerLeanLeft(True);
}

exec function LeanRightReleased()
{
    if (Pawn != None)
    {
        if (ROPawn(Pawn) != None)
        {
            ROPawn(Pawn).LeanRightReleased();
        }
    }

    ServerLeanRight(false);
}

exec function LeanLeftReleased()
{
    if (Pawn != None)
    {
        if (ROPawn(Pawn) != None)
        {
            ROPawn(Pawn).LeanLeftReleased();
        }
    }

    ServerLeanLeft(False);
}

reliable protected server function ServerLeanRight(bool leanstate)
{
    bWantsToLeanRight = leanstate;

    if( Pawn != none )
    {
        if( ROPawn(Pawn) != none )
        {
            if (leanstate)
            {
                ROPawn(Pawn).LeanRight();
            }
            else
            {
                ROPawn(Pawn).LeanRightReleased();
                bWantsToLeanRight = false;

                if( bWantsToLeanLeft )
                {
                    SetTimer(0.2f, false, 'RightLeftLean');
                }
            }
        }
        else if ( leanstate && ROVWeap_TankTurret(ROWeaponPawn(Pawn).MyVehicleWeapon) != none )
        {
            bWantsToLeanRight = false;
            ROVWeap_TankTurret(ROWeaponPawn(Pawn).MyVehicleWeapon).IncrementRange();
        }
        // TODO: Add bHasTransferCase or something similar instead of class equivalency check.
        else if (leanstate && DRVehicle_Willys(Pawn) != None)
        {
            bWantsToLeanLeft = false;
            // DRVehicle_Willys(Pawn).ShiftTransferCase(ETCR_High);
            ROVehicleSimTreaded(DRVehicle_Willys(Pawn).SimObj).GearArray[DRVehicle_Willys(Pawn).OutputGear].AccelRate += 0.25;
        }
    }
}

reliable protected server function ServerLeanLeft(bool leanstate)
{
    bWantsToLeanLeft = leanstate;

    if( Pawn != none )
    {
        if( ROPawn(Pawn) != none )
        {
            if (leanstate)
            {
                ROPawn(Pawn).LeanLeft();
            }
            else
            {
                ROPawn(Pawn).LeanLeftReleased();

                if( bWantsToLeanRight )
                {
                    SetTimer(0.2f, false, 'LeftRightLean');
                }
            }
        }
        else if ( leanstate && ROVWeap_TankTurret(ROWeaponPawn(Pawn).MyVehicleWeapon) != none )
        {
            bWantsToLeanLeft = false;
            ROVWeap_TankTurret(ROWeaponPawn(Pawn).MyVehicleWeapon).DecrementRange();
        }
        // TODO: Add bHasTransferCase or something similar instead of class equivalency check.
        else if (leanstate && DRVehicle_Willys(Pawn) != None)
        {
            bWantsToLeanLeft = false;
            // DRVehicle_Willys(Pawn).ShiftTransferCase(ETCR_Low);
            ROVehicleSimTreaded(DRVehicle_Willys(Pawn).SimObj).GearArray[DRVehicle_Willys(Pawn).OutputGear].AccelRate -= 0.25;
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef(RELEASE)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function DumpScriptTrace()
{
    ScriptTrace();
}

exec function BlowupVehicles(optional bool bHitAmmo = false, optional int DeadVehicleType = 999)
{
    ServerBlowUpVehicles(bHitAmmo, DeadVehicleType);
}

private reliable server function ServerBlowUpVehicles(optional bool bHitAmmo = false,
    optional int DeadVehicleType = 999)
{
    local ROVehicle ROV;

    ForEach AllActors(class'ROVehicle', ROV)
    {
        ROV.bHitAmmo = bHitAmmo;

        ROV.BlowupVehicle();

        // Useless? Is set in ROV.BlowupVehicle()?
        if (DeadVehicleType != 999)
        {
            ROV.DeadVehicleType = DeadVehicleType;
        }
    }
}

private reliable server function DoAddBotsDR(int Num, optional int NewTeam = -1, optional bool bNoForceAdd)
{
    local ROAIController ROBot;
    local byte ChosenTeam;
    local byte SuggestedTeam;
    local ROPlayerReplicationInfo ROPRI;
    local ROGameInfo ROGI;

    ROGI = ROGameInfo(WorldInfo.Game);

    // do not add bots during server travel
    if( ROGI.bLevelChange )
    {
        return;
    }

    while (Num > 0 && ROGI.NumBots + ROGI.NumPlayers < ROGI.MaxPlayers)
    {
        // Create a new Controller for this Bot
        ROBot = ROGI.Spawn(ROGI.AIControllerClass);

        // Assign the bot a Player ID
        ROBot.PlayerReplicationInfo.PlayerID = ROGI.CurrentID++;

        // Suggest a team to put the AI on
        if ( ROGI.bBalanceTeams || NewTeam == -1 )
        {
            if ( ROGI.GameReplicationInfo.Teams[`AXIS_TEAM_INDEX].Size - ROGI.GameReplicationInfo.Teams[`ALLIES_TEAM_INDEX].Size <= 0
                && ROGI.BotCapableNorthernRolesAvailable() )
            {
                SuggestedTeam = `AXIS_TEAM_INDEX;
            }
            else if( ROGI.BotCapableSouthernRolesAvailable() )
            {
                SuggestedTeam = `ALLIES_TEAM_INDEX;
            }
            // If there are no roles available on either team, don't allow this to go any further
            else
            {
                ROBot.Destroy();
                return;
            }
        }
        else if (ROGI.BotCapableNorthernRolesAvailable() || ROGI.BotCapableSouthernRolesAvailable())
        {
            SuggestedTeam = NewTeam;
        }
        else
        {
            ROBot.Destroy();
            return;
        }

        // Put the new Bot on the Team that needs it
        ChosenTeam = ROGI.PickTeam(SuggestedTeam, ROBot);
        // Set the bot name based on team
        ROGI.ChangeName(ROBot, ROGI.GetDefaultBotName(ROBot, ChosenTeam, ROTeamInfo(ROGI.GameReplicationInfo.Teams[ChosenTeam]).NumBots + 1), false);

        ROGI.JoinTeam(ROBot, ChosenTeam);

        ROBot.SetTeam(ROBot.PlayerReplicationInfo.Team.TeamIndex);

        // Have the bot choose its role
        if( !ROBot.ChooseRole() )
        {
            ROBot.Destroy();
            continue;
        }

        ROBot.ChooseSquad();

        // GRIP BEGIN
        // Remove. Debugging purpose only.
        ROPRI = ROPlayerReplicationInfo(ROBot.PlayerReplicationInfo);
        if( ROPRI.RoleInfo.bIsTankCommander )
        {
            ROGI.ChangeName(ROBot, ROPRI.GetHumanReadableName()$" (TankAI)", false);
        }
        // GRIP END

        if ( ROTeamInfo(ROBot.PlayerReplicationInfo.Team) != none && ROTeamInfo(ROBot.PlayerReplicationInfo.Team).ReinforcementsRemaining > 0 )
        {
            // Spawn a Pawn for the new Bot Controller
            ROGI.RestartPlayer(ROBot);
        }

        if ( ROGI.bInRoundStartScreen )
        {
            ROBot.AISuspended();
        }

        // Note that we've added another Bot
        if( !bNoForceAdd )
            ROGI.DesiredPlayerCount++;

        ROGI.NumBots++;
        Num--;
        ROGI.UpdateGameSettingsCounts();
    }
}

exec function AddBotsDR(int Num, optional int NewTeam = -1, optional bool bNoForceAdd)
{
    DoAddBotsDR(Num, NewTeam, bNoForceAdd);
}

exec function SetSFXVolume(float NewVolume)
{
    AudioManager.UpdateVolume(NewVolume, EAC_SFX);
}

/*
simulated exec function DisableRagdoll()
{
    ROPawn(Pawn).DisableRagdoll();
}

simulated exec function EnableRagdoll()
{
    ROPawn(Pawn).EnableRagdoll();
}
*/

exec function ForceAerialRecon()
{
    ServerForceAerialRecon();
}

reliable private server function ServerForceAerialRecon()
{
    local Sequence GameSeq;
    local ROGameReplicationInfo ROGRI;
    local float ReconDuration;
    local array<SequenceObject> AerialReconSeqEvents;
    local int i;
    local int Team;
    local Actor AerialReconBaseActor;

    ROGRI = ROGameReplicationInfo(WorldInfo.GRI);
    GameSeq = WorldInfo.GetGameSequence();
    Team = GetTeamNum();

    if (GameSeq != None)
    {
        // find any Level Loaded events that exist
        GameSeq.FindSeqObjectsByClass(class'ROSeqEvent_AerialRecon', True, AerialReconSeqEvents);

        // activate them
        for (i = 0; i < AerialReconSeqEvents.Length; i++)
        {
            AerialReconBaseActor = ROSeqEvent_AerialRecon(
                AerialReconSeqEvents[i]).TriggerRecon(Team, ROGRI.bReverseRolesAndSpawns, ReconDuration);

            if (AerialReconBaseActor != None)
            {
                ROGameInfo(WorldInfo.Game).SpawnAerialReconPlane(AerialReconBaseActor, ReconDuration, self);
                break;
            }
        }
    }
}

exec function ForceStukaStrike(optional bool bAircraftPOV = False,
    optional int Altitude = 0, optional int PayloadDropHeight = 0,
    optional int AngleOfDive = 0)
{
    DoTestStukaStrike(bAircraftPOV, Altitude, PayloadDropHeight, AngleOfDive);
}

exec function ForceStrafingRun(int PitchRate, int Altitude, int DistanceToTarget)
{
    ServerForceStrafingRun(PitchRate, Altitude, DistanceToTarget);
}

reliable private server function ServerForceStrafingRun(int PitchRate, int Altitude, int Distance)
{
    local DRStrafingRunAircraft Aircraft;
    local ROTeamInfo ROTI;
    local rotator FlightRot;
    local vector TargetLocation;

    Aircraft = Spawn(class'DRStrafingRunAircraft', self,,
        Pawn.Location + MakeVector(Distance, 0, Altitude), Pawn.Rotation);

    ROTI = ROTeamInfo(PlayerReplicationInfo.Team);

    if ( ROTI != none )
    {
        ROTI.ArtyStrikeLocation = ROTI.SavedArtilleryCoords;
    }

    if( ROTI.ArtyStrikeLocation != vect(-999999.0,-999999.0,-999999.0) )
        TargetLocation = ROTI.ArtyStrikeLocation;
    else
        TargetLocation = Pawn.Location;

    FlightRot = rotator(Normal(TargetLocation - Aircraft.Location));
    FlightRot.Roll = 0;
    Aircraft.SetRotation(FlightRot);

    Aircraft.PitchRate = PitchRate;
}

reliable private server function DoTestStukaStrike(bool bAircraftPOV,
    int Altitude, int PayloadDropHeight, int AngleOfDive)
{
    local int SpawnAltitude;
    local vector TargetLocation;
    local vector SpawnLocation;
    local class<DRDiveBomberAircraft> AircraftClass;
    local DRDiveBomberAircraft Aircraft;
    local ROTeamInfo ROTI;
    local DRMapInfo DRMI;

    if ( ROPlayerReplicationInfo(PlayerReplicationInfo) == none ||
         ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo == none ||
         Pawn == none )
    {
        return;
    }

    ROTI = ROTeamInfo(PlayerReplicationInfo.Team);

    if ( ROTI != none )
    {
        ROTI.ArtyStrikeLocation = ROTI.SavedArtilleryCoords;
    }

    if( ROTI.ArtyStrikeLocation != vect(-999999.0,-999999.0,-999999.0) )
        TargetLocation = ROTI.ArtyStrikeLocation;
    else
        TargetLocation = Pawn.Location;

    AircraftClass = class'DRDiveBomberAircraft';

    DRMI = DRMapInfo(WorldInfo.GetMapInfo());

    if (Altitude > 0)
    {
        SpawnAltitude = Altitude;
    }
    else
    {
        SpawnAltitude = AircraftClass.default.Altitude;
    }

    SpawnAltitude += TargetLocation.Z + DRMI.DiveBomberHeightOffset;

    SpawnLocation = GetBestAircraftSpawnLoc(TargetLocation, SpawnAltitude, AircraftClass);

    TargetLocation.Z = SpawnLocation.Z;

    Aircraft = Spawn(AircraftClass,self,, SpawnLocation, rotator(TargetLocation - SpawnLocation));

    if ( Aircraft == none )
    {
        `log("Error Spawning Support Aircraft");
    }
    else
    {
        if (PayloadDropHeight > 0)
        {
            Aircraft.PayloadDropHeight = PayloadDropHeight;
        }

        if (AngleOfDive > 0)
        {
            Aircraft.AngleOfDive = AngleOfDive;
        }

        Aircraft.TargetLocation = ROTI.ArtyStrikeLocation;
        Aircraft.CalculateTrajectory();
        Aircraft.SetDropPoint();
    }

    if (bAircraftPOV)
    {
        SetViewTarget(Aircraft);
    }

    //? KillsWithCurrentNapalm = 0; // Reset Napalm Kills as We call it in!!!
}

// Temporary Bren 3rd person left hand debugging.
simulated exec function SetLeftHandYaw(float YawValue)
{
    local DRWeapAttach_Bren_LMG Bren;

    Bren = DRWeapAttach_Bren_LMG(ROPawn(Pawn).CurrentWeaponAttachment);
    if (Bren != None)
    {
        Bren.SetLeftHandYaw(YawValue);
    }
}

function vector MakeVector(float X, float Y, float Z)
{
    local vector V;

    V.X = X;
    V.Y = Y;
    V.Z = Z;

    return V;
}

simulated exec function SetScopePosition(float X, float Y, float Z)
{
    ROSniperWeapon(Pawn.Weapon).ScopePosition = MakeVector(X, Y, Z);
}

exec function SetScopeZ(float NewScopeZ)
{
    ROSniperWeapon(Pawn.Weapon).ScopeLenseMIC.SetScalarParameterValue('v_position', NewScopeZ);
}

simulated exec function SetShoulderedPosition(float X, float Y, float Z)
{
    ROWeapon(Pawn.Weapon).ShoulderedPosition = MakeVector(X, Y, Z);
}

simulated exec function SetSightPitch(int RangeIndex, int NewSightPitch)
{
    ROWeapon(Pawn.Weapon).SightRanges[RangeIndex].SightPitch = NewSightPitch;
    ROWeapon(Pawn.Weapon).SightIndexUpdated();
}

simulated exec function SetSightSlideOffset(int RangeIndex, float NewSightSlideOffset)
{
    ROWeapon(Pawn.Weapon).SightRanges[RangeIndex].SightSlideOffset = NewSightSlideOffset;
    ROWeapon(Pawn.Weapon).SightIndexUpdated();
}

simulated exec function SetSightPositionOffset(int RangeIndex, float NewSightPositionOffset)
{
    ROWeapon(Pawn.Weapon).SightRanges[RangeIndex].SightPositionOffset = NewSightPositionOffset;
    ROWeapon(Pawn.Weapon).SightIndexUpdated();
}

simulated exec function SetAddedPitch(int RangeIndex, int NewAddedPitch)
{
    ROWeapon(Pawn.Weapon).SightRanges[RangeIndex].AddedPitch = NewAddedPitch;
    ROWeapon(Pawn.Weapon).SightIndexUpdated();
}

simulated exec function SetPlayerViewOffset(float X, float Y, float Z)
{
    ROWeapon(Pawn.Weapon).PlayerViewOffset = MakeVector(X, Y, Z);
}

simulated exec function SetZoomInRotation(int Pitch, int Yaw, int Roll)
{
    ROWeapon(Pawn.Weapon).ZoomInRotation.Pitch = Pitch;
    ROWeapon(Pawn.Weapon).ZoomInRotation.Yaw = Yaw;
    ROWeapon(Pawn.Weapon).ZoomInRotation.Roll = Roll;
}

simulated exec function SetIronsightPosX(float NewX)
{
    ROWeapon(Pawn.Weapon).IronSightPosition.X = NewX;
    ROWeapon(Pawn.Weapon).PlayerViewOffset.X = NewX;
}

// Helper function for working out a nice ironsight position when changing the weapon zoom FoV
exec function SetIronsightPosY(float NewY)
{
    ROWeapon(Pawn.Weapon).IronSightPosition.Y = NewY;
    ROWeapon(Pawn.Weapon).PlayerViewOffset.Y = NewY;
}

// Helper function for working out a nice ironsight position when changing the weapon zoom FoV
exec function SetIronsightPosZ(float NewZ)
{
    ROWeapon(Pawn.Weapon).IronSightPosition.Z = NewZ;
    ROWeapon(Pawn.Weapon).PlayerViewOffset.Z = NewZ;
}

exec function SetISFocusDepth(float NewDepth)
{
    ROWeapon(Pawn.Weapon).ISFocusDepth = NewDepth;
}

exec function SetISFocusBlendRadius(float NewRadius)
{
    ROWeapon(Pawn.Weapon).ISFocusBlendRadius = NewRadius;
}

exec function SetSightRot(int SightRot)
{
    ROWeapon(Pawn.Weapon).SightRotController.SetSkelControlStrength( 1.0f , 0.0f );
    ROWeapon(Pawn.Weapon).SightRotController.BoneRotation.Pitch = SightRot * -1;
}

exec function SetSightSlide(float SlideLoc)
{
    ROWeapon(Pawn.Weapon).SightSlideController.SetSkelControlStrength( 1.0f , 0.0f );
    ROWeapon(Pawn.Weapon).SightSlideController.BoneTranslation.X = SlideLoc;
}

exec function SetSightZ(float NewZ)
{
    ROWeapon(Pawn.Weapon).IronSightPosition.Z = NewZ;
    ROWeapon(Pawn.Weapon).PlayerViewOffset.Z = NewZ;
}

exec function Camera(name NewMode)
{
    ServerCamera(NewMode);
}

reliable server function ServerCamera(name NewMode)
{
    if (NewMode == '1st')
    {
        NewMode = 'FirstPerson';
    }
    else if (NewMode == '3rd')
    {
        NewMode = 'ThirdPerson';
    }
    else if (NewMode == 'free')
    {
        NewMode = 'FreeCam';
    }
    else if (NewMode == 'fixed')
    {
        NewMode = 'Fixed';
    }

    SetCameraMode(NewMode);

    if (PlayerCamera != None)
    {
        `dr("CameraStyle=" $ PlayerCamera.CameraStyle);
    }
}

exec function ListMats()
{
    local int i;

    if (self.Pawn.Mesh.Materials.length == 0)
    {
        `dr("Materials list is empty!",'M');
        return;
    }

    for (i = 0; i < self.Pawn.Mesh.Materials.length; i++)
    {
        `dr("MIC" @ i @ MaterialInstanceConstant(self.Pawn.mesh.Materials[i]).Parent,'M');
    }
}

exec function BleedTest()
{
    ROPawn(self.Pawn).PlayerHitZones[5].ZoneBleedingStatus = ROBS_Slow;
    ROPawn(self.Pawn).PlayerHitZones[5].bBleeding = true;
    ROPawn(self.Pawn).BleedingInstigator = self;
    ROPawn(self.Pawn).LastTakeHitInfo.DamageType = class'RODamageType';
    ROPawn(self.Pawn).StartBleeding();
}

exec function ShowProxies()
{
    local ROVehicle ROV;
    local int i;

    ROV = ROVehicle(Pawn);

    if (ROV == none && ROWeaponPawn(Pawn) != none)
    {
        ROV = ROWeaponPawn(Pawn).MyVehicle;
    }

    for (i = 0; i < ROV.SeatProxies.Length; i++)
    {
        ROV.SeatProxies[i].ProxyMeshActor.HideMesh(false);
        ROV.ChangeCrewCollision(true, i);
    }
}

/*
simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    super.DisplayDebug(HUD, out_YL, out_YPos);

    if (WorldInfo.MusicComp != none)
    {
        HUD.Canvas.SetDrawColor(0,255,0);
        HUD.Canvas.DrawText("MUSIC VOLUME:" @ WorldInfo.MusicComp.VolumeMultiplier @ " FadeInTargetVolume:" @  WorldInfo.MusicComp.FadeInTargetVolume @ "CurrentVolumeMultiplier" @  WorldInfo.MusicComp.CurrentVolumeMultiplier, FALSE);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4, out_YPos);
        HUD.Canvas.SetDrawColor(0,255,0);
        HUD.Canvas.DrawText("MUSIC VOLUME SETTING :" @ UserVolumeSetting(), FALSE);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4, out_YPos);

        if (WorldInfo.CurrentMusicTrack.TheSoundCue != none)
        {
            HUD.Canvas.SetDrawColor(0,255,0);
            HUD.Canvas.DrawText("MUSIC TRACK:" @ WorldInfo.CurrentMusicTrack.TheSoundCue @ "INDEX:" @ DRTeamInfo(WorldInfo.GRI.Teams[self.GetTeamNum()]).TrackIndex, FALSE);
            out_YPos += out_YL;
            HUD.Canvas.SetPos(4, out_YPos);
        }
        else
        {
            HUD.Canvas.SetDrawColor(255,0,0);
            HUD.Canvas.DrawText("MUSIC TRACK: NONE", FALSE);
            out_YPos += out_YL;
            HUD.Canvas.SetPos(4, out_YPos);
        }
    }
    else
    {
        HUD.Canvas.SetDrawColor(255,0,0);
        HUD.Canvas.DrawText("NULL WORLD MUSIC COMP", FALSE);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4, out_YPos);
    }

    if (StingerComp != none)
    {
        HUD.Canvas.SetDrawColor(0,255,0);
        HUD.Canvas.DrawText("STINGER VOLUME:" @ StingerComp.VolumeMultiplier @ " FadeInTargetVolume:" @ StingerComp.FadeInTargetVolume @ "CurrentVolumeMultiplier" @ StingerComp.CurrentVolumeMultiplier, FALSE);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4, out_YPos);

        if (StingerComp.SoundCue != none)
        {
            HUD.Canvas.SetDrawColor(0,255,0);
            HUD.Canvas.DrawText("STINGER TRACK:" @ StingerComp.SoundCue, FALSE);
            out_YPos += out_YL;
            HUD.Canvas.SetPos(4, out_YPos);
        }
        else
        {
            HUD.Canvas.SetDrawColor(255,0,0);
            HUD.Canvas.DrawText("STINGER TRACK: NONE", FALSE);
            out_YPos += out_YL;
            HUD.Canvas.SetPos(4, out_YPos);
        }
    }
    else
    {
        HUD.Canvas.SetDrawColor(255,0,0);
        HUD.Canvas.DrawText("NULL STINGER COMP", FALSE);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4, out_YPos);
    }

    HUD.Canvas.SetDrawColor(0,255,0);
    HUD.Canvas.DrawText("ROUNDEND:" @ RoundEnd, FALSE);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4, out_YPos);

    HUD.Canvas.SetDrawColor(0,255,0);
    HUD.Canvas.DrawText("MATCHEND:" @ MatchEnd, FALSE);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4, out_YPos);

    HUD.Canvas.SetDrawColor(0,255,0);
    HUD.Canvas.DrawText("DUCKING:" @ Ducking, FALSE);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4, out_YPos);
}
*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`endif
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

DefaultProperties
{
    TeamSelectSceneTemplate=DRUISceneTeamSelect'DR_UI.UIScene.DRUIScene_TeamSelect'
    // UnitSelectSceneTemplate=WWUISceneUnitSelect'WinterWar_UI.UIScene.WWUIScene_UnitSelect'
    // CharacterSceneTemplate=WWUISceneCharacter'WinterWar_UI.UIScene.WWUIScene_Character'
    // AfterActionReportSceneTemplate=WWUISceneAfterActionReport'WinterWar_UI.UIScene.WWUIScene_AfterAction'
    StoreSceneTemplate=None

    Begin Object Class=DRAudioComponent name=StingerComponent
        OcclusionCheckInterval=0.0
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
        AudioClass=EAC_Music
    End Object
    StingerComp=StingerComponent

    // NorthTeamVoicePacks[0]=class'WWVoicePack_FIN_1'
    // NorthTeamVoicePacks[1]=class'WWVoicePack_FIN_2'
    // NorthTeamVoicePacks[2]=class'WWVoicePack_FIN_3'

    // SouthTeamVoicePacks[0]=class'ROVoicePackAusTeam01'
    // SouthTeamVoicePacks[1]=class'ROVoicePackAusTeam01'
    // SouthTeamVoicePacks[2]=class'ROVoicePackAusTeam01'

    // SouthTeamVoicePacksCustom[0]=class'DRVoicePackUKTeam01'
    // SouthTeamVoicePacksCustom[1]=class'DRVoicePackUKTeam01'
    // SouthTeamVoicePacksCustom[2]=class'DRVoicePackUKTeam01'

    AllTeamVoicePacksOneCustom[1]=class'DRVoicePackUKTeam01'

    AllTeamVoicePacksTwoCustom[1]=class'DRVoicePackUKTeam02'

    // AllAnnouncerPacks[`AXIS_TEAM_INDEX]=class'WWVoicePack_FIN_C'
    // AllAnnouncerPacks[`ALLIES_TEAM_INDEX]=class'WWVoicePack_RUS_C'

    // AxisWinTheme=SoundCue'WinterWar_AUD_MUS.FIN.F_Victory_Cue'
    // AlliesWinTheme=SoundCue'WinterWar_AUD_MUS.SOV.R_Victory_Cue'
    // AxisLossTheme=SoundCue''
    // AlliesLossTheme=SoundCue''

    // RoundEnd=false
    // MatchEnd=false
    // Ducking=false

    NorthWinTheme=none
    NorthLossTheme=none
    SouthWinTheme=none
    SouthLossTheme=none
    NorthRoundWinTheme=none
    NorthRoundLostTheme=none
    SouthRoundWinTheme=none
    SouthRoundLostTheme=none
}
