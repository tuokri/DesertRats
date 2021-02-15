
class DRTeamInfo extends ROTeamInfo;

var byte OldMorale;

var bool NoTransitionCheck;

var MusicTrackStruct NewMoraleMusicTrack;
var MusicTrackStruct TransitionMusicTrack;

struct ROMusicPlayList
{
	var name PlaylistName;
	var array<string> CRef_MusicTracks;
};

var ROMusicPlayList	AxisLowMoralePlayList, AxisNormalMoralePlayList, AxisHighMoralePlayList,
					AlliesLowMoralePlayList, AlliesNormalMoralePlayList, AlliesHighMoralePlayList;

var	MusicTrackStruct	AxisHigherMoraleTransitionTrack, AlliesHigherMoraleTransitionTrack,
						AxisLowerMoraleTransitionTrack, AlliesLowerMoraleTransitionTrack;

var int TotalTrackSets, TrackIndex;

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

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	TrackIndex = rand(TotalTrackSets);
}

simulated function SetMoraleMusic()
{
	local string CRef_NewMoralMusicTrack;
	local float TransitionWaitTimer;
	local DRPlayerController PC;

	if (ROPlayerController(GetALocalPlayerController()).GetTeamNum() != TeamIndex)
	{
		return;
	}

	`dr("",'M');

	NewMoraleMusicTrack.TheSoundCue = none;

	/*
	if (Morale < 50)
	{
		if (TeamIndex == `AXIS_TEAM_INDEX)
		{
			CRef_NewMoralMusicTrack = AxisLowMoralePlayList.CRef_MusicTracks[TrackIndex];
		}
		else
		{
			CRef_NewMoralMusicTrack = AlliesLowMoralePlayList.CRef_MusicTracks[TrackIndex];
		}
	}
	else if (Morale < 100)
	{
		if (TeamIndex == `AXIS_TEAM_INDEX)
		{
			CRef_NewMoralMusicTrack = AxisNormalMoralePlayList.CRef_MusicTracks[TrackIndex];
		}
		else
		{
			CRef_NewMoralMusicTrack = AlliesNormalMoralePlayList.CRef_MusicTracks[TrackIndex];
		}
	}
	else if ( Morale < 255 )
	{
		if (TeamIndex == `AXIS_TEAM_INDEX)
		{
			CRef_NewMoralMusicTrack = AxisHighMoralePlayList.CRef_MusicTracks[TrackIndex];
		}
		else
		{
			CRef_NewMoralMusicTrack = AlliesHighMoralePlayList.CRef_MusicTracks[TrackIndex];
		}
	}
	*/

	CRef_NewMoralMusicTrack = "SoundCue'DR__PLACEHOLDER_MUS.TEMPCUE'";

	LoadAsyncMoraleMusicTrack(CRef_NewMoralMusicTrack);

	if (OldMorale == 255 || NoTransitionCheck)
	{
		NoTransitionCheck = false;
		UpdateMoraleMusicTrack();
	}
	else
	{
		TransitionWaitTimer = 7.0;

		foreach WorldInfo.LocalPlayerControllers(class'DRPlayerController', PC)
		{
			if (PC.RoundEnd)
			{
				TransitionWaitTimer = 0.1;
				break;
			}
		}

		if (OldMorale < Morale)
		{
			SetTimer(TransitionWaitTimer, false, 'PlayMoraleTransitionUp');
		}
		else
		{
			SetTimer(TransitionWaitTimer, false, 'PlayMoraleTransitionDown');
		}
	}
}

simulated function LoadAsyncMoraleMusicTrack(string MusicTrack)
{
	if (MusicTrack == "")
	{
		return;
	}

	`dr(MusicTrack,'M');

	NewMoraleMusicTrack.TheSoundCue = SoundCue(DynamicLoadObject(MusicTrack, class'SoundCue'));

	if (NewMoraleMusicTrack.TheSoundCue == none)
	{
		`dr("Failed to load cue!!!",'M');
	}
}

simulated function PlayMoraleTransitionUp()
{
	`dr("",'M');
	PlayTransitionMusicTrack(true);
}

simulated function PlayMoraleTransitionDown()
{
	`dr("",'M');
	PlayTransitionMusicTrack(false);
}

simulated function PlayTransitionMusicTrack(bool bMoraleUp)
{
	if (bMoraleUp)
	{
		if (TeamIndex == `AXIS_TEAM_INDEX)
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
		if (TeamIndex == `AXIS_TEAM_INDEX)
		{
			TransitionMusicTrack = AxisLowerMoraleTransitionTrack;
		}
		else
		{
			TransitionMusicTrack = AlliesLowerMoraleTransitionTrack;
		}
	}

	// Update immediately for transition stinger
	NewMoraleMusicTrack = TransitionMusicTrack;
	UpdateMoraleMusicTrack();

	// Update later for post-transition music
	NoTransitionCheck = true;
	SetTimer(NewMoraleMusicTrack.TheSoundCue.GetCueDuration(), false, 'SetMoraleMusic');
}

simulated function NotifyLocalPlayerTeamReceived()
{
	NoTransitionCheck = true;
	SetMoraleMusic();
}

simulated function UpdateMoraleMusicTrack()
{
	local DRPlayerController PC;

	if (NewMoraleMusicTrack.TheSoundCue == none)
	{
		// `dr("Waiting for morale track to load. Retry in 1 sec",'M');
		SetTimer(1.0, true, 'UpdateMoraleMusicTrack');
	}
	else
	{
		ClearTimer('UpdateMoraleMusicTrack');

		foreach WorldInfo.LocalPlayerControllers(class'DRPlayerController', PC)
		{
			PC.SetNewMoraleMusicTrack(NewMoraleMusicTrack);
		}
	}
}

simulated function class<ROAerialReconPlane> GetAerialReconPlaneClass()
{
	`drtrace;
	if (TeamIndex == `ALLIES_TEAM_INDEX)
	{
		// return class 'WWAerialReconPlaneSoviet';
	}

	return none;
}

defaultproperties
{
	OldMorale=255
	NoTransitionCheck=false

	NewMoraleMusicTrack=(bAutoPlay=true,bPersistentAcrossLevels=false,FadeInTime=1.0,FadeInVolumeLevel=1.0,FadeOutTime=0.5,FadeOutVolumeLevel=0.0)

	// Don't forget to update this as more tracks are added
	TotalTrackSets=1
	/*
	AxisLowMoralePlayList={(
		PlaylistName=Axis_LowMorale,
		CRef_MusicTracks=(
			"SoundCue'WinterWar_AUD_MUS.FIN.F_L_1_Cue'"
		)
	)}

	AxisNormalMoralePlayList={(
		PlaylistName=Axis_NeutralMorale,
		CRef_MusicTracks=(
			"SoundCue'WinterWar_AUD_MUS.FIN.F_N_1_Cue'",
			"SoundCue'WinterWar_AUD_MUS.FIN.F_N_2_Cue'"
		)
	)}

	AxisHighMoralePlayList={(
		PlaylistName=Axis_HighMorale,
		CRef_MusicTracks=(
			"SoundCue'WinterWar_AUD_MUS.FIN.F_H_1_Cue'",
			"SoundCue'WinterWar_AUD_MUS.FIN.F_H_2_Cue'"
		)
	)}

	AlliesLowMoralePlayList={(
		PlaylistName=Allies_LowMorale,
		CRef_MusicTracks=(
			"SoundCue'WinterWar_AUD_MUS.SOV.R_L_1_Cue'",
			"SoundCue'WinterWar_AUD_MUS.SOV.R_L_1_Cue'"
		)
	)}

	AlliesNormalMoralePlayList={(
		PlaylistName=Allies_NeutralMorale,
		CRef_MusicTracks=(
			"SoundCue'WinterWar_AUD_MUS.SOV.R_N_1_Cue'",
			"SoundCue'WinterWar_AUD_MUS.SOV.R_N_1_Cue'"
		)
	)}

	AlliesHighMoralePlayList={(
		PlaylistName=Allies_HighMorale,
		CRef_MusicTracks=(
			"SoundCue'WinterWar_AUD_MUS.SOV.R_H_1_Cue'",
			"SoundCue'WinterWar_AUD_MUS.SOV.R_H_1_Cue'"
		)
	)}

	AxisHigherMoraleTransitionTrack=(TheSoundCue=SoundCue'WinterWar_AUD_MUS.FIN.F_Trans_2H_Cue',bAutoPlay=true,bPersistentAcrossLevels=false,FadeInTime=0.1,FadeInVolumeLevel=1.0,FadeOutTime=0.1,FadeOutVolumeLevel=0.0)
	AxisLowerMoraleTransitionTrack=(TheSoundCue=SoundCue'WinterWar_AUD_MUS.FIN.F_Trans_2L_Cue',bAutoPlay=true,bPersistentAcrossLevels=false,FadeInTime=0.1,FadeInVolumeLevel=1.0,FadeOutTime=0.1,FadeOutVolumeLevel=0.0)

	AlliesHigherMoraleTransitionTrack=(TheSoundCue=SoundCue'WinterWar_AUD_MUS.SOV.R_Trans_2H_Cue',bAutoPlay=true,bPersistentAcrossLevels=false,FadeInTime=0.1,FadeInVolumeLevel=1.0,FadeOutTime=0.1,FadeOutVolumeLevel=0.0)
	AlliesLowerMoraleTransitionTrack=(TheSoundCue=SoundCue'WinterWar_AUD_MUS.SOV.R_Trans_2L_Cue',bAutoPlay=true,bPersistentAcrossLevels=false,FadeInTime=0.1,FadeInVolumeLevel=1.0,FadeOutTime=0.1,FadeOutVolumeLevel=0.0)
	 */
}
