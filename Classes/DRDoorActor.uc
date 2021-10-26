class DRDoorActor extends StaticMeshActor
    implements(ROUsableActorInterface);

// Added yaw to the door actor when it is activated.
var(DoorActor) int AddedYaw;
// Added roll to the door actor when it is activated.
var(DoorActor) int AddedRoll;
// Added pitch to the door actor when it is activated.
var(DoorActor) int AddedPitch;
// How fast to rotate to target rotation.
var(DoorActor) float RotationSpeed;
// Maximum distance from door until it becomes unusable.
var(DoorActor) float MaxUsableDistance;

// Cached rotation of the door's default rotation state.
var rotator BaseRot;
var rotator FinishedRot;
var bool bAddingRot;
var bool bSubtractingRot;

replication
{
    if (bNetDirty)
        bAddingRot, bSubtractingRot;
}

simulated function PostBeginPlay()
{
    BaseRot = Rotation;
    super.PostBeginPlay();
}

simulated function Tick(float DeltaTime)
{
    if (bAddingRot)
    {
        SetRotation(RInterpTo(Rotation, FinishedRot, DeltaTime, RotationSpeed));

        if (Rotation == FinishedRot)
        {
            bAddingRot = False;
        }
    }
    else if (bSubtractingRot)
    {
        SetRotation(RInterpTo(Rotation, BaseRot, DeltaTime, RotationSpeed));

        if (Rotation == BaseRot)
        {
            bSubtractingRot = False;
        }
    }

    super.Tick(DeltaTime);
}

/** Function to do things when player is looking at me. It's called every time an actor is found in ROPlayerController.FindActorAimedAt.
 *  It's called only in client */
simulated function PlayerLookingAtMe(ROPlayerController PlayerController)
{
    local DRPlayerController DRPC;
    local DRPawn DP;

    DRPC = DRPlayerController(PlayerController);
    if (DRPC == None)
    {
        return;
    }

    DP = DRPawn(DRPC.Pawn);
    if (DP != None && VSize(Location - DP.Location) <= MaxUsableDistance) // Client side distance check.
    {
        DP.HighlightUsableDoor(self);
    }

    DRPC.CheckUsableDoor(self);
}

/** Returns dot product of looking direction and direction to me. -1 if player is not looking at me */
simulated function float GetDotProdLookingDirection(vector PlayerLookLocation, vector PlayerLookDirection)
{
    local vector ActorDir;
    local float ThisDot;

    ActorDir = Normal(Location - PlayerLookLocation);
    ThisDot = ActorDir dot PlayerLookDirection;
    return ThisDot >= 0.9f ? ThisDot : -1.f;
}

simulated function ToggleDoor()
{
    if (bAddingRot)
    {
        bAddingRot = False;
        bSubtractingRot = True;
    }
    else if (bSubtractingRot)
    {
        bSubtractingRot = False;
        bAddingRot = True;
    }

    // Update this here in case AddedYaw/AddedRoll/AddedPitch gets changed after spawning this door.
    FinishedRot = BaseRot;
    FinishedRot.Pitch += AddedPitch;
    FinishedRot.Roll += AddedRoll;
    FinishedRot.Yaw += AddedYaw;
}

function bool UsedBy(Pawn User)
{
    local DRPlayerController DRPC;

    `log(self $ " UsedBy(): User = " $ User,, 'DRDEV');

    DRPC = DRPlayerController(User.Controller);
    if (DRPC == None)
    {
        return False;
    }

    // Server side distance check because door actors are
    // defined to use ServerUse in DRPlayerController.
    if (VSize(Location - User.Location) > MaxUsableDistance)
    {
        return False;
    }

    ToggleDoor();
    return True;
}

DefaultProperties
{
    // 90 * DegToUnrRot ~= 16384.
    AddedYaw=16384
    AddedRoll=0
    AddedPitch=0
    RotationSpeed=10
    MaxUsableDistance=500
    // TODO: Need PHYS_Interpolating?
    // Physics=PHYS_Interpolating
}
