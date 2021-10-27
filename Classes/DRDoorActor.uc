class DRDoorActor extends Actor
    implements(ROUsableActorInterface);

var() const editconst StaticMeshComponent StaticMeshComponent;

// Added yaw to the door actor when it is activated.
var(DoorActor) int AddedYaw;
// Added roll to the door actor when it is activated.
var(DoorActor) int AddedRoll;
// Added pitch to the door actor when it is activated.
var(DoorActor) int AddedPitch;
// How fast to rotate to target rotation.
var(DoorActor) float RotationSpeed;
// Maximum distance from door until it becomes unusable.
// var(DoorActor) float MaxUsableDistance;

// Cached rotation of the door's default rotation state.
var rotator BaseRot;
var rotator FinishedRot;
// TODO: Refactor bools into a state enum.
var bool bAddingRot;
var bool bSubtractingRot;
var bool bInBaseRot;

replication
{
    if (bNetDirty)
        bAddingRot, bSubtractingRot, bInBaseRot, FinishedRot;
}

simulated function PostBeginPlay()
{
    BaseRot = Rotation;
    bInBaseRot = True;
    super.PostBeginPlay();
}

simulated function Tick(float DeltaTime)
{
    if (bAddingRot)
    {
        `log(self $ "Tick(): add rotation",, 'DRDEV');
        SetRotation(RInterpTo(Rotation, FinishedRot, DeltaTime, RotationSpeed));
        bInBaseRot = False;

        if (Rotation == FinishedRot)
        {
            bAddingRot = False;
        }
    }
    else if (bSubtractingRot)
    {
        `log(self $ "Tick(): sub rotation",, 'DRDEV');
        SetRotation(RInterpTo(Rotation, BaseRot, DeltaTime, RotationSpeed));

        if (Rotation == BaseRot)
        {
            bSubtractingRot = False;
            bInBaseRot = True;
        }
    }

    super.Tick(DeltaTime);
}

/** Function to do things when player is looking at me. It's called every time an actor is found in ROPlayerController.FindUsableActor.
 *  It's called only in client */
simulated function PlayerLookingAtMe(ROPlayerController PlayerController)
{
    local DRPlayerController DRPC;
    local DRPawn DP;

    // `log(self $ " PlayerLookingAtMe(): " $ PlayerController,, 'DRDEV');

    DRPC = DRPlayerController(PlayerController);
    if (DRPC == None)
    {
        return;
    }

    DP = DRPawn(DRPC.Pawn);
    if (DP != None)
    {
        DP.HighlightUsableDoor(self);
        DRPC.CheckUsableDoor(self);
    }
}

/** Returns dot product of looking direction and direction to me. -1 if player is not looking at me */
simulated function float GetDotProdLookingDirection(vector PlayerLookLocation, vector PlayerLookDirection)
{
    // local box BBox;
    // local vector HitLoc;
    // local vector HitNorm;
    // local vector ActorVec;
    local vector ActorDir;
    local float ThisDot;

    // TODO: Trace for more accurate result?
    // ActorVec = Location - PlayerLookLocation;
    // Trace(HitLoc, HitNorm, PlayerLookLocation, Location);

    // GetComponentsBoundingBox(BBox);
    // ActorDir = Normal((BBox.Min / 2 + BBox.Max / 2) - PlayerLookLocation);
    ActorDir = Normal(StaticMeshComponent.Bounds.Origin - PlayerLookLocation);
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
    else if (bInBaseRot)
    {
        bAddingRot = True;
        bSubtractingRot = False;
    }
    else
    {
        bAddingRot = False;
        bSubtractingRot = True;
    }

    `log(self $ " ToggleDoor(): bAddingRot=" $ bAddingRot $ ", bSubtractingRot=" $ bSubtractingRot,, 'DRDEV');

    // Update this here in case AddedYaw/AddedRoll/AddedPitch gets changed after spawning this door.
    FinishedRot = BaseRot;
    FinishedRot.Pitch += (AddedPitch * DegToUnrRot);
    FinishedRot.Roll += (AddedRoll * DegToUnrRot);
    FinishedRot.Yaw += (AddedYaw * DegToUnrRot);

    `log(self $ " ToggleDoor(): " $ FinishedRot,, 'DRDEV');
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

    // // Server side distance check because door actors are
    // // defined to use ServerUse in DRPlayerController.
    // if (VSize(Location - User.Location) > MaxUsableDistance)
    // {
    //     return False;
    // }

    ToggleDoor();
    return True;
}

DefaultProperties
{
    AddedYaw=90
    AddedRoll=0
    AddedPitch=0
    RotationSpeed=1
    // MaxUsableDistance=1000
    // TODO: Need PHYS_Interpolating?
    // Physics=PHYS_Interpolating

    Collision=COLLIDE_BlockAll
    bStatic=False
    bCollideActors=True

    Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
        bCastDynamicShadow=True
        bAllowMergedDynamicShadows=True
        bUsePrecomputedShadows=True
        bForceDirectLightMap=True
        CollideActors=True
        CastShadow=True
        BlockActors=True
        BlockZeroExtent=True
        BlockNonZeroExtent=True
        BlockRigidBody=True
    End Object
    CollisionComponent=StaticMeshComponent0
    StaticMeshComponent=StaticMeshComponent0
    Components.Add(StaticMeshComponent0)

    Begin Object Class=SpriteComponent Name=Sprite
        Sprite=Texture2D'EditorResources.door'
        HiddenGame=True
        AlwaysLoadOnClient=False
        AlwaysLoadOnServer=False
    End Object
    Components.Add(Sprite)
}
