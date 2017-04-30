//=============================================================================
// WFALogWriter.uc
//=============================================================================
// Writes to the game's log file with a customizable header
//=============================================================================
// African Expansion for Heroes of the West by Sgt Joe
// Copyright (C) 2017 Tripwire Interactive LLC
//=============================================================================

class WFALogWriter extends Actor
	// seperate config as placeholder, will work out integration when officially approved
	config(Game_WFA);

struct LogStruct
{
	var string LogType;
	var bool Enabled;
};

var config array <LogStruct> LogOptions;

function WFALog(string Message, optional name Type)
{
	local int i, index;
	local bool LogExists;
	local LogStruct inData;
	
	Type = (Type == 'None') ? 'WFALog' : name('WFALog-'$Type);
	LogExists = false;
	index = 0;
	
	for (i = 0; i < LogOptions.length; i++)
	{
		if ( string(Type) ~= LogOptions[i].LogType )
		{
			LogExists = true;
			index = i;
			break;
		}
	}
	
	if ( LogExists && LogOptions[index].Enabled )
	{
		`log(Message,,Type);
	}
	else if ( !LogExists )
	{
		inData.LogType = string(Type);
		inData.Enabled = true;
		
		LogOptions[LogOptions.length] = inData;
		
		SaveConfig();
	}
}
