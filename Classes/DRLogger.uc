
class DRLogger extends Object;

static function DRDebugLog(string Message, string FuncTrace, optional name Type)
{
`ifndef(RELEASE)
	local DRPlayerController PC;
	PC = DRPlayerController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController());
	
	Type = (Type == 'None') ? 'DEBUG' : Type;
	
	if (PC != none)
	{
		PC.ClientMessage("("$Type$")" @ FuncTrace @ Message);
		
		if (Message == "")
		{
			`log(FuncTrace,,name("DR-"$Type));
		}
		else
		{
			`log(FuncTrace @ Message,,name("DR-"$Type));
		}
	}
	else
	{
		foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'DRPlayerController', PC)
		{
			PC.ClientMessage("("$Type$")" @ FuncTrace @ Message);
		}
		
		`log(FuncTrace @ Message,,name("DR-"$Type));
	}
`endif
}

static function DRDebugTrace(string FuncTrace)
{
`ifndef(RELEASE)
	local DRPlayerController PC;
	PC = DRPlayerController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController());
	
	if (PC != none)
	{
		PC.ClientMessage(""$FuncTrace);
	}
	else
	{
		foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'DRPlayerController', PC)
		{
			PC.ClientMessage(""$FuncTrace);
		}
	}
`endif
}

