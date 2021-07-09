class DRTeamInfo extends ROTeamInfo;

// Morale
var byte OldMorale;
var MusicTrackStruct NewMoraleMusicTrack;
var MusicTrackStruct TransitionMusicTrack;

struct ROMusicPlayList
{
    // Name of this playlist for reference
    var name                PlaylistName;

    // References to all the tracks for this playlist
    var array<string>       CRef_MusicTracks;

    // The current index into the RadomPermutation array. The array is regenerated
    // once the PermutationIndex == MusicTracks.length . At startup, PermutationIndex = -1
    // which also causes the RandomPermutation array to be regenerated.
    var int                 PermutationIndex;

    // The random permutation array in order to to achieve random without replacement
    // behavior. It contains radomized indices of the music tracks above.
    var array<int>          RandomPermutation;
};

// Music / morale playlists.
var ROMusicPlayList AxisLowMoralePlayList;
var ROMusicPlayList AxisNormalMoralePlayList;
var ROMusicPlayList AxisHighMoralePlayList;
var ROMusicPlayList AlliesLowMoralePlayList;
var ROMusicPlayList AlliesNormalMoralePlayList;
var ROMusicPlayList AlliesHighMoralePlayList;

// Morale transition music tracks
var MusicTrackStruct AxisHigherMoraleTransitionTrack;
var MusicTrackStruct AlliesHigherMoraleTransitionTrack;
var MusicTrackStruct AxisLowerMoraleTransitionTrack;
var MusicTrackStruct AlliesLowerMoraleTransitionTrack;

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'Morale')
    {
        SetMoraleMusic();
        OldMorale = Morale;
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
}

simulated function FixupMusicPlayList(out ROMusicPlayList InPlayList)
{
    local int i, SwapVal, RandVal;
    local string NewPermutationString;

    // On startup, initialize the random permutation
    if( InPlayList.PermutationIndex == -1 )
    {
        `logd("[GameMusic] Startup. Generating permutation for playlist " $ InPlayList.PlaylistName);

        InPlayList.RandomPermutation.Remove(0, InPlayList.RandomPermutation.Length);
        for( i=0; i< InPlayList.CRef_MusicTracks.Length; i++ )
        {
            InPlayList.RandomPermutation.AddItem(i);
        }
    }

    // Re-shuffle the random permutation on startup, or if we have finished playing each song in the playlist once
    if( InPlayList.PermutationIndex == -1 || InPlayList.PermutationIndex >= InPlayList.CRef_MusicTracks.Length )
    {
        // Go through the positions 0 through n-1, and for each position i swap the element currently there
        // with an arbitrarily chosen element from positions i through n, inclusive
        // See: http://en.wikipedia.org/wiki/Random_permutation
        for( i=0; i<InPlayList.RandomPermutation.length; i++ )
        {
            RandVal = Rand(InPlayList.RandomPermutation.length);

            SwapVal = InPlayList.RandomPermutation[i];
            InPlayList.RandomPermutation[i] = InPlayList.RandomPermutation[RandVal];
            InPlayList.RandomPermutation[RandVal] = SwapVal;
        }

        NewPermutationString = "";
        for( i=0; i<InPlayList.RandomPermutation.length; i++ )
        {
            NewPermutationString = NewPermutationString $ InPlayList.RandomPermutation[i] $ ", ";
        }
        `logd("[GameMusic] Re-generated radom permutation list for playlist " $ InPlayList.PlaylistName $ " - " $ NewPermutationString);

        // Reset the index so that we start reading from the beginning of the permutation array again
        InPlayList.PermutationIndex = 0;
    }
}

simulated function SetMoraleMusic()
{
    local string CRef_NewMoralMusicTrack;
    local int TrackIndex;
    local ROPlayerController ROPC;

    // Don't load the music if it is not for the current team
    ROPC = ROPlayerController(GetALocalPlayerController());
    if( ROPC.GetTeamNum() !=  TeamIndex )
    {
        return;
    }

    if ( OldMorale != Morale )
    {
        // Clear out the currently playing morale track. This will be populated by the
        // async loading code once the package containing the new morale music track is loaded
        NewMoraleMusicTrack.TheSoundCue = none;

        if ( Morale < 50 )
        {
            if ( TeamIndex == 0 )
            {
                FixupMusicPlayList(AxisLowMoralePlayList);
                TrackIndex = AxisLowMoralePlayList.RandomPermutation[AxisLowMoralePlayList.PermutationIndex++];
                CRef_NewMoralMusicTrack = AxisLowMoralePlayList.CRef_MusicTracks[TrackIndex];
            }
            else if ( TeamIndex == 1 )
            {
                FixupMusicPlayList(AlliesLowMoralePlayList);
                TrackIndex = AlliesLowMoralePlayList.RandomPermutation[AlliesLowMoralePlayList.PermutationIndex++];
                CRef_NewMoralMusicTrack = AlliesLowMoralePlayList.CRef_MusicTracks[TrackIndex];
            }
        }
        else if ( Morale < 100 )
        {
            if ( TeamIndex == 0 )
            {
                FixupMusicPlayList(AxisNormalMoralePlayList);
                TrackIndex = AxisNormalMoralePlayList.RandomPermutation[AxisNormalMoralePlayList.PermutationIndex++];
                CRef_NewMoralMusicTrack = AxisNormalMoralePlayList.CRef_MusicTracks[TrackIndex];
            }
            else if ( TeamIndex == 1 )
            {
                FixupMusicPlayList(AlliesNormalMoralePlayList);
                TrackIndex = AlliesNormalMoralePlayList.RandomPermutation[AlliesNormalMoralePlayList.PermutationIndex++];
                CRef_NewMoralMusicTrack = AlliesNormalMoralePlayList.CRef_MusicTracks[TrackIndex];
            }
        }
        else if ( Morale < 255 )
        {
            if ( TeamIndex == 0 )
            {
                FixupMusicPlayList(AxisHighMoralePlayList);
                TrackIndex = AxisHighMoralePlayList.RandomPermutation[AxisHighMoralePlayList.PermutationIndex++];
                CRef_NewMoralMusicTrack = AxisHighMoralePlayList.CRef_MusicTracks[TrackIndex];
            }
            else if ( TeamIndex == 1 )
            {
                FixupMusicPlayList(AlliesHighMoralePlayList);
                TrackIndex = AlliesHighMoralePlayList.RandomPermutation[AlliesHighMoralePlayList.PermutationIndex++];
                CRef_NewMoralMusicTrack = AlliesHighMoralePlayList.CRef_MusicTracks[TrackIndex];
            }
        }

        // Kick off the asynchronous load of the new morale music track
        `log("[ContentLoading] Async content loading for " $ CRef_NewMoralMusicTrack $ " started at " $ WorldInfo.TimeSeconds);
        LoadAsyncMoraleMusicTrack(CRef_NewMoralMusicTrack);

        // Only do the transition if its not the initial setup,
        // of if the morale changes to low or high, not to neutral
        if ( OldMorale != 255 /*&& (Morale < 50 || Morale >= 100)*/ ) // Uncomment this to have it only play for morale changes to high or low, but not neutral
        {
            if ( OldMorale < Morale )
            {
                // Just using 7 seconds for now so that the transitions don't override the objective caps. Add a var or do something better later
                SetTimer(7.0, false, 'PlayMoraleTransitionUp');
            }
            else
            {
                // Just using 7 seconds for now so that the transitions don't override the objective caps. Add a var or do something better later
                SetTimer(7.0, false, 'PlayMoraleTransitionDown');
            }
        }
        else
        {
            UpdateMoraleMusicTrack();
        }
    }
}

simulated event LoadAsyncMoraleMusicTrack(string MusicTrack)
{
    if (MusicTrack == "")
    {
        return;
    }

    `log("[ContentLoading] Async content loading for " $ MusicTrack
        $ " ended at " $ WorldInfo.TimeSeconds,, 'DRAudio');

    NewMoraleMusicTrack.TheSoundCue = SoundCue(DynamicLoadObject(MusicTrack, class'SoundCue'));
    if( NewMoraleMusicTrack.TheSoundCue == none )
    {
        `warn("[ContentLoading] Could not load SoundCue: " $ MusicTrack
            $ "Game music will not work correctly",, 'DRAudio');
    }
}

simulated function PlayMoraleTransitionUp()
{
    PlayTransitionMusicTrack(true);
}

simulated function PlayMoraleTransitionDown()
{
    PlayTransitionMusicTrack(false);
}

simulated function PlayTransitionMusicTrack(bool bMoraleUp)
{
    local DRPlayerController DRPC;
    local float TransitionTime;

    if ( bMoraleUp )
    {
        if ( TeamIndex == 0 )
        {
            TransitionMusicTrack = AxisHigherMoraleTransitionTrack;
        }
        else
        {
            TransitionMusicTrack = AlliesHigherMoraleTransitionTrack;
        }
    }
    else
    {
        if ( TeamIndex == 0 )
        {
            TransitionMusicTrack = AxisLowerMoraleTransitionTrack;
        }
        else
        {
            TransitionMusicTrack = AlliesLowerMoraleTransitionTrack;
        }
    }

    TransitionTime = TransitionMusicTrack.TheSoundCue.GetCueDuration();

    foreach WorldInfo.LocalPlayerControllers(class'DRPlayerController', DRPC)
    {
        if (DRPC.GetTeamNum() == TeamIndex)
        {
            DRPC.SetNewMoraleMusicTrack(TransitionMusicTrack, True);
        }
    }

    SetTimer(TransitionTime, false, 'UpdateMoraleMusicTrack');
}

simulated function UpdateMoraleMusicTrack()
{
    local DRPlayerController DRPC;

    if( NewMoraleMusicTrack.TheSoundCue == none )
    {
        `log("[GameMusic] Waiting for morale track to load. Retry in 1 sec",, 'DRAudio');
        SetTimer(1.0, true, 'UpdateMoraleMusicTrack');
    }
    else
    {
        ClearTimer('UpdateMoraleMusicTrack');

        foreach WorldInfo.LocalPlayerControllers(class'DRPlayerController', DRPC)
        {
            if( DRPC.GetTeamNum() == TeamIndex )
            {
                DRPC.SetNewMoraleMusicTrack(NewMoraleMusicTrack);
            }
        }
    }
}

simulated function class<ROAerialReconPlane> GetAerialReconPlaneClass()
{
    `drtrace;
    if (TeamIndex == `ALLIES_TEAM_INDEX)
    {
        return class 'DRAerialReconPlaneAllies';
    }
    else if (TeamIndex == `AXIS_TEAM_INDEX)
    {
        return class 'DRAerialReconPlaneAxis';
    }
    else
    {
        `log("GetAerialReconPlaneClass: invalid TeamIndex : " $ TeamIndex);
        return None;
    }
}

DefaultProperties
{
    OldMorale=255
    // NoTransitionCheck=false

    NewMoraleMusicTrack=(bAutoPlay=true,bPersistentAcrossLevels=false,FadeInTime=1.0,FadeInVolumeLevel=1.0,FadeOutTime=0.5,FadeOutVolumeLevel=0.0)

    AxisLowMoralePlayList={(
        PlaylistName=Axis_LowMorale,
        PermutationIndex=-1,
        CRef_MusicTracks=("DR__PLACEHOLDER_MUS.TEMPCUE")
    )}

    AxisNormalMoralePlayList={(
        PlaylistName=Axis_NeutralMorale,
        PermutationIndex=-1,
        CRef_MusicTracks=("DR__PLACEHOLDER_MUS.TEMPCUE")
    )}

    AxisHighMoralePlayList={(
        PlaylistName=Axis_HighMorale,
        PermutationIndex=-1,
        CRef_MusicTracks=("DR__PLACEHOLDER_MUS.TEMPCUE")
    )}

    AlliesLowMoralePlayList={(
        PlaylistName=Allies_LowMorale,
        PermutationIndex=-1,
        CRef_MusicTracks=("DR__PLACEHOLDER_MUS.TEMPCUE")
    )}

    AlliesNormalMoralePlayList={(
        PlaylistName=Allies_NeutralMorale,
        PermutationIndex=-1,
        CRef_MusicTracks=("DR__PLACEHOLDER_MUS.TEMPCUE")
    )}

    AlliesHighMoralePlayList={(
        PlaylistName=Allies_HighMorale,
        PermutationIndex=-1,
        CRef_MusicTracks=("DR__PLACEHOLDER_MUS.TEMPCUE")
    )}

    /*
    AxisHigherMoraleTransitionTrack=(
        TheSoundCue=SoundCue'Music_Ger.G_Trans_2H_Cue',
        bAutoPlay=true,
        bPersistentAcrossLevels=false,
        FadeInTime=0.1,
        FadeInVolumeLevel=0.8,
        FadeOutTime=0.1,
        FadeOutVolumeLevel=0.0
    )
    AxisLowerMoraleTransitionTrack=(
        TheSoundCue=SoundCue'Music_Ger.G_Trans_2L_Cue',
        bAutoPlay=true,
        bPersistentAcrossLevels=false,
        FadeInTime=0.1,
        FadeInVolumeLevel=0.8,
        FadeOutTime=0.1,
        FadeOutVolumeLevel=0.0
    )

    AlliesHigherMoraleTransitionTrack=(
        TheSoundCue=SoundCue'Music_Sov.R_Trans_2H_Cue',
        bAutoPlay=true,
        bPersistentAcrossLevels=false,
        FadeInTime=0.1,
        FadeInVolumeLevel=0.8,
        FadeOutTime=0.1,
        FadeOutVolumeLevel=0.0
    )
    AlliesLowerMoraleTransitionTrack=(
        TheSoundCue=SoundCue'Music_Sov.R_Trans_2L_Cue',
        bAutoPlay=true,
        bPersistentAcrossLevels=false,
        FadeInTime=0.1,
        FadeInVolumeLevel=0.8,
        FadeOutTime=0.1,
        FadeOutVolumeLevel=0.0
    )
    */
}
