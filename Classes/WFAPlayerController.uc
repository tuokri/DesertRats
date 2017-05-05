//=============================================================================
// WFAPlayerController.uc
//=============================================================================
// Temporary Player Controller for testing
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFAPlayerController extends WFPlayerController
	// seperate config as placeholder, will work out integration when officially approved
	config(Game_WFA); 

exec function Camera(name NewMode)
{
	ServerCamera(NewMode);
}

reliable server function ServerCamera(name NewMode)
{
	if (NewMode == '1st' )
	{
		SetCameraMode('FirstPerson');
	}
	else
	{
		SetCameraMode('ThirdPerson');
	}
}

exec reliable client function ShowPreGameServerAd() {}

defaultproperties
{
	CheatClass=class'WFACheatManager'
}
