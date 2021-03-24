class DRDmgType_Hispano_HE_MkII extends RODamageType_CannonShell_HE
    abstract;

// From RODmgType_M195Shell.
static function bool ShouldApplyGore(int DamageAmount, out GoreType ApplyGoreType,
    optional int DistFromKillerSq = 999999)
{
    if( DamageAmount >= Default.GoreDamageAmount[GT_LowDismemberment] )
    {
        ApplyGoreType = GT_LowDismemberment;
        return true;
    }

    return false;
}

DefaultProperties
{
    WeaponShortName="HS 404 HE Shell"
    bCanUberGore=False
    bForceHitZoneInstantDeath=False

    VehicleDamageScaling=0.15
    AirVehicleDamageScaling=0.5
    RadialDamageImpulse=500
    KDamageImpulse=1500
}
