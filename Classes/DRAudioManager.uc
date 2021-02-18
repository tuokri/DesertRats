class DRAudioManager extends Object
    config(Game_DesertRats_AudioManager);

enum EAudioClass
{
    EAC_SFX,
    EAC_MUSIC,
};

var array<AudioComponent> SFXComponents;

/*
var globalconfig    float   AkMasterVolume;
var globalconfig    float   AkMusicVolume;
var globalconfig    float   AkMenuMusicVolume;
var globalconfig    float   AkSFXVolume;
var globalconfig    float   AkDialogVolume;
var globalconfig    float   AkAnnouncerVolume;
*/

/*
function PostBeginPlay()
{
    super.PostBeginPlay();
}
*/

function UpdateVolume(float NewVolume, EAudioClass AudioClass)
{
    local AudioComponent AC;

    switch (AudioClass)
    {
        case EAC_SFX:
            foreach SFXComponents(AC)
            {
                AC.VolumeMultiplier = NewVolume;
                `log("Adjusting " $ AC $ " NewVolume = " $ NewVolume);
            }
            break;
        case EAC_MUSIC:
            break;
        default:
            `warn("UpdateVolume: invalid audio class: " $ AudioClass);
            break;
    }
}

// TODO: Create custom AudioComponent classes that handle the registration
// automatically. E.g. AudioComponentSFX, AudioComponentMusic...
function RegisterAudioComponent(AudioComponent AC, EAudioClass AudioClass)
{
    switch (AudioClass)
    {
        case EAC_SFX:
            SFXComponents.AddItem(AC);
            break;
        case EAC_MUSIC:
            break;
        default:
            `warn("RegisterAudioComponent: invalid audio class: " $ AudioClass);
            break;
    }
}
