class DRVoicePack extends ROVoicePack;

// We only need to define CustomSound for custom voice coms.
// The other properties can be fetched from the vanilla soundpack. For now.
struct DRVoiceCommunication extends ROVoiceCommunication
{
    var SoundCue CustomSound;
};

var array<DRVoiceCommunication> CustomVoiceComs;

// Is custom SoundCue voice com defined for this pack in this VoiceComIndex?
static function bool IsCustomVoiceCom(int VoiceComIndex)
{
    return (default.CustomVoiceComs[VoiceComIndex].CustomSound != None);
}

/*
static function EROVoiceComType GetVoiceComTypeCustom(int VoiceComIndex)
{
    return default.CustomVoiceComs[VoiceComIndex].Type;
}

static function class<LocalMessage> GetVoiceComMessageClassCustom(int VoiceComIndex)
{
    return default.CustomVoiceComs[VoiceComIndex].MessageClass;
}

static function int GetVoiceComMessageIndexCustom(int VoiceComIndex)
{
    return default.CustomVoiceComs[VoiceComIndex].MessageIndex;
}


static function ESpeechPriority GetVoiceComPriorityCustom(int VoiceComIndex)
{
    if (VoiceComIndex < default.CustomVoiceComs.Length)
    {
        return default.CustomVoiceComs[VoiceComIndex].Priority;
    }

    return Speech_None;
}
*/

static function SoundCue GetVoiceComSoundCustom(int VoiceComIndex)
{
    return default.CustomVoiceComs[VoiceComIndex].CustomSound;
}
