class DRLocalMessageKickableProjectile extends ROLocalMessage;

// TODO: Actually localized.
static function string GetString(
    optional int Switch,
    optional bool bPRI1HUD,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    return "Kick Projectile [" $ GetUseKeyName(RelatedPRI_1) $ "]";
}

static function float GetLifeTime(int Switch)
{
    return default.LifeTime;
}

static function string GetUseKeyName(PlayerReplicationInfo PRI)
{
    local name KeyName;
    local string ReturnString;
    local PlayerController PC;

    PC = PRI.Owner.GetALocalPlayerController();

    if ( PC != none && !PC.PlayerInput.FindKeyNameForCommand("Interact", KeyName, true) )
    {
        PC.PlayerInput.FindKeyNameForCommand("UseKey", KeyName, true);
    }

    ReturnString = LocalizeOptional("KeyBinding_FriendlyNames", string(KeyName), "ROGame");

    return ReturnString != "" ? ReturnString : string(KeyName);
}

DefaultProperties
{
    bLowerAlert=true
    Lifetime=1.0
    bIsConsoleMessage=false
}
