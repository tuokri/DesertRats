class DRProjectile_MillsGrenade extends ROEggGrenadeProjectile;

// `include(RSVoiceComs.uci)

DefaultProperties
{
    TossZ=300
    UnderhandTossZ=100
    AccelRate = 1.0;
    ProjExplosionTemplate=ParticleSystem'FX_VN_Weapons.Explosions.FX_VN_Grenade_explosion'
    Damage=200
    DamageRadius=500
    MomentumTransfer=50000
    bCollideWorld=true
    Speed=600
    MinSpeed=600
    MaxSpeed=1000
    MinTossSpeed=300
    MaxTossSpeed=500
    bUpdateSimulatedPosition = true;
    Bounces=10
    ExplosionSound=AkEvent'WW_EXP_Shared.Play_EXP_Grenade_Explosion'
    bWaitForEffects=false
    bRotationFollowsVelocity=true
    MyDamageType=class'DRDmgType_MillsGrenade'

    Begin Object Name=CollisionCylinder
        CollisionRadius=4
        CollisionHeight=4
        AlwaysLoadOnClient=True
        AlwaysLoadOnServer=True
    End Object

    Begin Object Name=ThowableMeshComponent
        SkeletalMesh=SkeletalMesh'WP_VN_3rd_Projectile.Mesh.M61_Grenade_Projectile'
        PhysicsAsset=PhysicsAsset'WP_VN_3rd_Projectile.Phy.M61Grenade_Projectile_3rd_Physics'
    End Object

    SpottedBattleChatterIndex=`BATTLECHATTER_Grenade
}
