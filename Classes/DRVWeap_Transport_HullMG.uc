class DRVWeap_Transport_HullMG extends ROVWeap_Transport_HullMG
    abstract
    HideDropDown;

simulated function StartLoopingFireSound(byte FireModeNum)
{
    local ROPawn ROP;

    if (FireModeNum < bLoopingFireSnd.Length && bLoopingFireSnd[FireModeNum] && !ShouldForceSingleFireSound())
    {
        bPlayingLoopingFireSnd = true;

        ROP = ROPawn(ROWeaponPawn(Instigator).Driver);
        if (ROP != none)
        {
            ROP.SetWeaponAmbientSound(WeaponFireSnd[FireModeNum].DefaultCue, WeaponFireSnd[FireModeNum].FirstPersonCue);
        }
    }
}

simulated function StopLoopingFireSound(byte FireModeNum)
{
    local ROPawn ROP;

    if (bPlayingLoopingFireSnd)
    {
        ROP = ROPawn(ROWeaponPawn(Instigator).Driver);
        if (ROP != none)
        {
            ROP.SetWeaponAmbientSound(None);
        }
        
        if (FireModeNum < WeaponFireLoopEndSnd.Length)
        {
            WeaponPlayFireSound(WeaponFireLoopEndSnd[FireModeNum].DefaultCue, WeaponFireLoopEndSnd[FireModeNum].FirstPersonCue);
        }

        bPlayingLoopingFireSnd = false;
    }
}

simulated function EndFire(byte FireModeNum)
{
    Super.EndFire(FireModeNum);

    StopLoopingFireSound(FireModeNum);
}
