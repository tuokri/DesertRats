// TODO: Should we also manage raw cues (without components)?
class DRAudioManager extends Object
    config(Game_DesertRats_AudioManager);

// NOTE: DRAudioComponents shouldn't use EAC_MASTER as their audio class.
// TODO: Announcer volume?
enum EAudioClass
{
    EAC_MASTER,
    EAC_SFX,
    EAC_MUSIC,
};

// SFX or Music should always be preferred over Master,
// but it's here as a fallback option.
var private array<DRAudioComponent> MasterComponents;
var private array<DRAudioComponent> SFXComponents;
var private array<DRAudioComponent> MusicComponents;

var config float MasterVolume;
var config float SFXVolume;
var config float MusicVolume;


function InitSoundClassVolumes()
{
    local AudioDevice AD;

    AD = class'Engine'.static.GetAudioDevice();

    if (AD != None)
    {
        MasterVolume = AD.AkMasterVolume;
        SFXVolume = AD.AkSFXVolume;
        MusicVolume = AD.AkMusicVolume;
        SaveConfig();
    }
}

// Audio class volume adjusted by master volume.
function float GetAdjustedAudioClassVolume(EAudioClass AudioClass)
{
    switch (AudioClass)
    {
        case EAC_MASTER:
            return MasterVolume;
        case EAC_SFX:
            return SFXVolume * MasterVolume;
        case EAC_MUSIC:
            return MusicVolume * MasterVolume;
        default:
            `warn("GetAudioClassVolume: invalid audio class: " $ AudioClass);
            return 0.2;
    }
}

function UpdateVolume(float NewVolume, EAudioClass AudioClass)
{
    local DRAudioComponent DRAC;

    switch (AudioClass)
    {
        case EAC_MASTER:
            MasterVolume = NewVolume;
            foreach MasterComponents(DRAC)
            {
                DRAC.AdjustVolume(0.1, MasterVolume);
                `log("Adjusting " $ DRAC $ " MasterVolume = " $ MasterVolume);
            }
            // Need to also update other classes if master is changed.
            UpdateVolume(SFXVolume, EAC_SFX);
            UpdateVolume(MusicVolume, EAC_MUSIC);
            break;
        case EAC_SFX:
            SFXVolume = NewVolume;
            foreach SFXComponents(DRAC)
            {
                DRAC.AdjustVolume(0.1, GetAdjustedAudioClassVolume(AudioClass));
                `log("Adjusting " $ DRAC $ " SFXVolume = " $ SFXVolume);
            }
            break;
        case EAC_MUSIC:
            MusicVolume = NewVolume;
            foreach MusicComponents(DRAC)
            {
                DRAC.AdjustVolume(0.1, GetAdjustedAudioClassVolume(AudioClass));
                `log("Adjusting " $ DRAC $ " MusicVolume = " $ MusicVolume);
            }
            break;
        default:
            `warn("UpdateVolume: invalid audio class: " $ AudioClass);
            break;
    }

    SaveConfig();
}

// TODO: Store original volume modifier of component / cue?
function RegisterAudioComponent(const out DRAudioComponent DRAC)
{
    `log(DRAC $ " original AC VolumeMultiplier = " $ DRAC.VolumeMultiplier);
    `log(DRAC.SoundCue $ " original SC VolumeMultiplier = " $ DRAC.SoundCue.VolumeMultiplier);
    DRAC.AdjustVolume(0.1, GetAdjustedAudioClassVolume(DRAC.AudioClass));
    `log(DRAC $ " adjusted AC VolumeMultiplier = " $ DRAC.VolumeMultiplier);
    `log(DRAC.SoundCue $ " original SC VolumeMultiplier = " $ DRAC.SoundCue.VolumeMultiplier);

    switch (DRAC.AudioClass)
    {
        case EAC_MASTER:
            MasterComponents.AddItem(DRAC);
            break;
        case EAC_SFX:
            SFXComponents.AddItem(DRAC);
            break;
        case EAC_MUSIC:
            MusicComponents.AddItem(DRAC);
            break;
        default:
            `warn("RegisterAudioComponent: invalid audio class: " $ DRAC.AudioClass);
            break;
    }
}
