class DRVWeap_TankTurret extends ROVWeap_TankTurret
    abstract
    HideDropDown;

struct WeaponFireSndInfoCustom extends WeaponFireSndInfo
{
    var() SoundCue SoundCueCustom;
};

var(Sounds) array<WeaponFireSndInfoCustom> WeaponFireSndCustom;

// TODO: Make this a macro so we can avoid duplicates in weapons?
// TODO: AUDIO REPLICATION!
function DRAudioComponent GetPooledAudioComponentCustom(SoundCue ASound, Actor SourceActor,
    bool bStopWhenOwnerDestroyed, optional bool bUseLocation, optional vector SourceLocation,
    optional EAudioClass AudioClass = EAC_SFX)
{
    local DRPlayerController DRPC;
    local DRAudioComponent DRAC;

    `log(string(self) $ "." $ "GetPooledAudioComponentCustom()",, 'DRDEV');

    DRPC = DRPlayerController(ROGameEngine(class'Engine'.static.GetEngine()).GetLocalPlayerController());

    `log("DRPC=" $ DRPC,, 'DRDEV');

    if (DRPC != None)
    {
        DRAC = DRAudioComponent(DRPC.GetPooledAudioComponent(ASound, SourceActor,
            bStopWhenOwnerDestroyed, bUseLocation, SourceLocation));
        DRAC.AudioClass = AudioClass;
    }

    return DRAC;
}

// TODO: Make this a macro so we can avoid duplicates in weapons?
simulated function PlayPooledSoundCustom(SoundCue ASound, Actor SourceActor,
    bool bStopWhenOwnerDestroyed, optional bool bUseLocation, optional vector SourceLocation,
    optional EAudioClass AudioClass = EAC_SFX)
{
    local DRAudioComponent DRAC;

    `log(string(self) $ "." $ "PlayPooledSoundCustom()",, 'DRDEV');

    DRAC = GetPooledAudioComponentCustom(ASound, SourceActor, True, True, SourceLocation);
    `log("DRAC = " $ DRAC,, 'DRDEV');
    if (DRAC != None)
    {
        DRAC.Play();
    }
}

simulated function PlayFiringSound(byte FireModeNum)
{
    `log(string(self) $ "." $ "PlayFiringSound()",, 'DRDEV');

    super.PlayFiringSound(FireModeNum);

    if (!bPlayingLoopingFireSnd)
    {
        if (FireModeNum < WeaponFireSndCustom.Length)
        {
            /*
            PlayPooledSoundCustom(WeaponFireSndCustom[FireModeNum].SoundCueCustom,
                self, false, true, Location);
            */

            WeaponPlayFireSound(WeaponFireSndCustom[FireModeNum].SoundCueCustom, None);
        }
    }
}
