class DRProjectile_M39Grenade extends ROEggGrenadeProjectile;

DefaultProperties
{
    TossZ=180//300
    UnderhandTossZ=150//100
    AccelRate=1.0
    ProjExplosionTemplate=ParticleSystem'FX_VN_Weapons.Explosions.FX_VN_Grenade_explosion'
    Damage=200
    DamageRadius=625//500//750
    MomentumTransfer=50000
    bCollideWorld=true
    Speed=1000//650
    MinSpeed=650//600
    MaxSpeed=1200//1000//1000
    MinTossSpeed=400
    MaxTossSpeed=600//600
    bUpdateSimulatedPosition=true
    Bounces=5//10
    ExplosionSound=AkEvent'WW_EXP_Shared.Play_EXP_Grenade_Explosion'
    bWaitForEffects=true
    MyDamageType=class'DRDmgType_M39Grenade'

    DampenFactor=0.33//0.5

    Begin Object Name=CollisionCylinder
        CollisionRadius=2
        CollisionHeight=2
        AlwaysLoadOnClient=True
        AlwaysLoadOnServer=True
    End Object

    Begin Object Name=ThowableMeshComponent
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_M39.Mesh.M39_Projectile'
        PhysicsAsset=PhysicsAsset'DR_WP_DAK_M39.Phy.M39_3rd_Physics'
    End Object

    SpottedBattleChatterIndex=`BATTLECHATTER_Grenade

    DecalHeight=625
    DecalWidth=625
}
