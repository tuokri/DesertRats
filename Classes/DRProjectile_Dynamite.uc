class DRProjectile_Dynamite extends ROEggGrenadeProjectile
    implements(ROUsableActorInterface);

/** Function to do things when player is looking at me. It's called every time an actor is found in ROPlayerController.FindActorAimedAt.
 *  It's called only in client */
// TODO: Check distance to projectile.
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
    if (DP != None)
    {
        DP.HighlightKickableProjectile(self);
    }

    DRPC.CheckKickableProjectile(self);
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

function bool UsedBy(Pawn User)
{
    local DRPlayerController DRPC;
    local vector KickVel;
    local vector PawnLocNoZ;

    `log(self $ " UsedBy(): User = " $ User,, 'DRDEV');

    DRPC = DRPlayerController(User.Controller);
    if (DRPC == None)
    {
        return False;
    }

    PawnLocNoZ = User.Location;
    PawnLocNoZ.Z = Location.Z;

    SetPhysics(PHYS_Falling);
    Bounces = default.Bounces;
    bBounce = True;
    SetCollisionSize(1.0, 1.0);

    // TODO: How much force?
    KickVel = Normal(Location - PawnLocNoZ) * (500 / ThrowableMesh.GetRootBodyInstance().GetBodyMass());
    KickVel.Z += TossZ / 2;
    DRPC.KickProjectile(self, KickVel);

    RandomSpin(10000);
    // bNeedNewRotation = True;

    return True;
}

DefaultProperties
{
    MyDamageType=class'DRDmgType_Dynamite'

    Begin Object Name=ThowableMeshComponent
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_Dynamite.Mesh.Dynamite_Projectile'
        PhysicsAsset=PhysicsAsset'DR_WP_DAK_Dynamite.Phy.Dynamite_Projectile_Physics'
    End Object

    ExplosionSound=AkEvent'WW_EXP_C4.Play_EXP_C4_Explosion'
    ProjExplosionTemplate=ParticleSystem'FX_VN_Weapons.Explosions.FX_VN_C4'
    WaterExplosionTemplate=ParticleSystem'FX_VN_Weapons.Explosions.FX_VN_C4'

    ShakeScale=2.5
    SuppressBlurScalar=1.75
    SuppressAnimationScalar=0.65
    ExplodeExposureScale=0.40

    Begin Object Name=CollisionCylinder
        CollisionRadius=4.5
        CollisionHeight=22
        AlwaysLoadOnClient=True
        AlwaysLoadOnServer=True
    End Object

    ExplosionOffsetDist=10

    Speed=400
    MinSpeed=100
    MaxSpeed=500
    MinTossSpeed=100
    MaxTossSpeed=300
    MomentumTransfer=5000

    TossZ=150.0
    UnderhandTossZ=100
    bBounce=true
    Bounces=4
    DampenFactor=0.25
    DampenFactorParallel=0.8

    FuseLength=10.0
    LifeSpan=10.0
    Damage=500
    DamageRadius=1000
    RadialDamageFalloffExponent=3.0
}
