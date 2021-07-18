class DRAnnouncerPack extends ROAnnouncerPack;

struct DRAnnouncerLine extends AnnouncerLine
{
    var SoundCue CustomSound;
};

var array<DRAnnouncerLine> CustomAbilityComs;
var array<DRAnnouncerLine> CustomRadioComs;
var array<DRAnnouncerLine> CustomObjectiveComs;
var array<DRAnnouncerLine> CustomGameModeComs;
var array<DRAnnouncerLine> CustomMiscComs;

/*
// TODO: Out parameter to avoid double access because we first
//       check if it's not null and then later access it again.
function bool IsCustomVoiceCom(byte Type, byte VoiceComIndex, byte SubIndex)
{
    local int ArrayIndex;

    switch (Type)
    {
        case EROAVT_Abilities:
            return CustomAbilityComs[VoiceComIndex].CustomSound != None;
        case EROAVT_Radio:
            return CustomRadioComs[VoiceComIndex].CustomSound != None;
        case EROAVT_GameMode:
            return CustomGameModeComs[VoiceComIndex].CustomSound != None;
        case EROAVT_Objective:
            ArrayIndex = VoiceComIndex + EROAOC_MAX * SubIndex;
            return CustomObjectiveComs[ArrayIndex].CustomSound != None;
        case EROAVT_General:
            return CustomMiscComs[VoiceComIndex].CustomSound != None;
        default:
            return False;
    }
}
*/

function GetAnnouncerSoundCustom(byte Type, byte VoiceComIndex, byte SubIndex,
    float TimeStamp, out SoundCue CustomAnnouncerSound)
{
    local int ArrayIndex;

    switch (Type)
    {
        case EROAVT_Abilities:
            if (TimeStamp > CustomAbilityComs[VoiceComIndex].NextPlayTime)
            {
                CustomAbilityComs[VoiceComIndex].NextPlayTime = TimeStamp + CustomAbilityComs[VoiceComIndex].MinIntervalBetweenEvents;
                CustomAnnouncerSound = CustomAbilityComs[VoiceComIndex].CustomSound;
            }
            break;

        case EROAVT_Radio:
            if (TimeStamp > CustomRadioComs[VoiceComIndex].NextPlayTime)
            {
                CustomRadioComs[VoiceComIndex].NextPlayTime = TimeStamp + CustomRadioComs[VoiceComIndex].MinIntervalBetweenEvents;
                CustomAnnouncerSound = CustomRadioComs[VoiceComIndex].CustomSound;
            }
            break;

        case EROAVT_GameMode:
            if (TimeStamp > CustomGameModeComs[VoiceComIndex].NextPlayTime)
            {
                CustomGameModeComs[VoiceComIndex].NextPlayTime = TimeStamp + CustomGameModeComs[VoiceComIndex].MinIntervalBetweenEvents;
                CustomAnnouncerSound = CustomGameModeComs[VoiceComIndex].CustomSound;
            }
            break;

        case EROAVT_Objective:
            ArrayIndex = VoiceComIndex + EROAOC_MAX * SubIndex;
            if (TimeStamp > CustomObjectiveComs[ArrayIndex].NextPlayTime)
            {
                CustomObjectiveComs[ArrayIndex].NextPlayTime = TimeStamp + CustomObjectiveComs[ArrayIndex].MinIntervalBetweenEvents;
                CustomAnnouncerSound = CustomObjectiveComs[ArrayIndex].CustomSound;
            }
            break;

        case EROAVT_General:
            if (TimeStamp > CustomMiscComs[VoiceComIndex].NextPlayTime)
            {
                CustomMiscComs[VoiceComIndex].NextPlayTime = TimeStamp + CustomMiscComs[VoiceComIndex].MinIntervalBetweenEvents;
                CustomAnnouncerSound = CustomMiscComs[VoiceComIndex].CustomSound;
            }
            break;
    }

    CustomAnnouncerSound = None;
}
