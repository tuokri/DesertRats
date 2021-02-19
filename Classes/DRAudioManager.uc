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
var array<DRAudioComponent> MasterComponents;
var array<DRAudioComponent> SFXComponents;
var array<DRAudioComponent> MusicComponents;

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

// TODO: Refactor? Is switch-case really good for this?
function UpdateVolume(float NewVolume, EAudioClass AudioClass)
{
    local DRAudioComponent DRAC;

    switch (AudioClass)
    {
        case EAC_MASTER:
            MasterVolume = NewVolume;
            foreach MasterComponents(DRAC)
            {
                DRAC.VolumeMultiplier = MasterVolume;
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
                DRAC.VolumeMultiplier = GetAdjustedAudioClassVolume(AudioClass);
                `log("Adjusting " $ DRAC $ " SFXVolume = " $ SFXVolume);
            }
            break;
        case EAC_MUSIC:
            MusicVolume = NewVolume;
            foreach MusicComponents(DRAC)
            {
                DRAC.VolumeMultiplier = GetAdjustedAudioClassVolume(AudioClass);
                `log("Adjusting " $ DRAC $ " MusicVolume = " $ MusicVolume);
            }
            break;
        default:
            `warn("UpdateVolume: invalid audio class: " $ AudioClass);
            break;
    }

    SaveConfig();
}

function RegisterAudioComponent(DRAudioComponent DRAC)
{
    local EAudioClass AudioClass;

    AudioClass = DRAC.AudioClass;
    DRAC.VolumeMultiplier = GetAdjustedAudioClassVolume(AudioClass);

    switch (AudioClass)
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
            `warn("RegisterAudioComponent: invalid audio class: " $ AudioClass);
            break;
    }
}
