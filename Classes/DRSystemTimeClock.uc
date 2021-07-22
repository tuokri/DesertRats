class DRSystemTimeClock extends Actor
    placeable;

var StaticMeshComponent ClockMesh;
var Material ClockMaterial;
var MaterialInstanceConstant ClockMIC;

simulated event PostBeginPlay()
{
    local int Year;
    local int Month;
    local int DayOfWeek;
    local int Day;
    local int Hour;
    local int Min;
    local int Sec;
    local int MSec;

    local float AdjustedHour;
    local float AdjustedMin;

    super.PostBeginPlay();

    GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);

    ClockMIC = new class'MaterialInstanceConstant';
    ClockMIC.SetParent(ClockMaterial);

    // Material clock always starts at 12:00:00.
    // We can set seconds directly because they always point at a whole number on the clock.
    ClockMIC.SetScalarParameterValue('SecondsAdd', Sec);

    AdjustedMin = float(Min);
    AdjustedMin += Sec / 60.0;
    ClockMIC.SetScalarParameterValue('MinutesAdd', AdjustedMin);

    if (Hour > 12)
    {
        AdjustedHour = Hour - 12.0;
    }
    else
    {
        AdjustedHour = float(Hour);
    }
    AdjustedHour += Min / 60.0;
    ClockMIC.SetScalarParameterValue('HoursAdd', AdjustedHour);

    ClockMesh.SetMaterial(0, ClockMIC);

    `log("H = " $ AdjustedHour);
    `log("M = " $ AdjustedMin);
    `log("S = " $ Sec);
}

DefaultProperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bSynthesizeSHLight=true
    End Object
    Components.Add(MyLightEnvironment)

    Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
        StaticMesh=StaticMesh'ENV_VN_Office.Meshes.Small_Pieces.S_Clock'
        Materials(0)=Material'ENV_VN_Office.Materials.M_realClock'
        RBChannel=RBCC_Vehicle
        BlockActors=false
        BlockZeroExtent=false
        BlockRigidBody=false
        BlockNonzeroExtent=false
        CollideActors=false
        bNotifyRigidBodyCollision=false
        ScriptRigidBodyCollisionThreshold=10.0
        LightEnvironment=MyLightEnvironment
        Scale=5
    End Object
    ClockMesh=StaticMeshComponent0
    Components.Add(StaticMeshComponent0)

    ClockMaterial=Material'ENV_VN_Office.Materials.M_realClock'
}
