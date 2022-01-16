// Oddly specific.
class DRSkelControl_SdKfz222_TurretChainTranslation extends SkelControlSingleBone;

var() InterpCurveFloat TurretPitchToChainRodTranslationCurve;

var ROSkelControl_TurretConstrained TurretPitchControl;

event TickSkelControl(float DeltaTime, SkeletalMeshComponent SkelComp)
{
    super.TickSkelControl(DeltaTime, SkelComp);

    if (TurretPitchControl != None)
    {
        ControlStrength = EvalInterpCurveFloat(TurretPitchToChainRodTranslationCurve, TurretPitchControl.BoneRotation.Pitch);
    }
}

DefaultProperties
{
    bShouldTickInScript=True

    // Turret pitch in unreal rotator units to chain rod translation controller strength.
    TurretPitchToChainRodTranslationCurve=(Points=((InVal=-910,OutVal=0.00),(InVal=0,OutVal=0.00),(InVal=911,OutVal=0.02),(InVal=1821,OutVal=0.04),(InVal=3186,OutVal=0.10),(InVal=4552,OutVal=0.20),(InVal=6827,OutVal=0.48),(InVal=8192,OutVal=0.75),(InVal=8648,OutVal=0.86),(InVal=9103,OutVal=1.00)))
}

/*
TurretPitch "strength" -> ChainRod translation strength.
(InVal=-0.1,OutVal=0.00),
(InVal=0.00,OutVal=0.00),
(InVal=0.10,OutVal=0.02),
(InVal=0.20,OutVal=0.04),
(InVal=0.35,OutVal=0.10),
(InVal=0.50,OutVal=0.20),
(InVal=0.75,OutVal=0.48),
(InVal=0.90,OutVal=0.75),
(InVal=0.95,OutVal=0.86),
(InVal=1.00,OutVal=1.00),

TurretPitch unreal rot units.
(InVal=-910,OutVal=0.00),
(InVal=0,OutVal=0.00),
(InVal=911,OutVal=0.02),
(InVal=1821,OutVal=0.04),
(InVal=3186,OutVal=0.10),
(InVal=4552,OutVal=0.20),
(InVal=6827,OutVal=0.48),
(InVal=8192,OutVal=0.75),
(InVal=8648,OutVal=0.86),
(InVal=9103,OutVal=1.00),
*/
