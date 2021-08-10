class DRProjectile_M24_Grenade extends ROStickGrenadeProjectile;

DefaultProperties
{
    TossZ=180
    UnderhandTossZ=150
    AccelRate = 1.0;
    ProjExplosionTemplate=ParticleSystem'FX_VN_Weapons.Explosions.FX_VN_Grenade_explosion'
    Damage=200
    DamageRadius=750
    MomentumTransfer=50000
    bCollideWorld=true
    Speed=1000//700//650
    MinSpeed=650//650//600
    MaxSpeed=1200//1000//1000
    MinTossSpeed=400
    MaxTossSpeed=600//600
    bUpdateSimulatedPosition = true;
    Bounces=5//10
    ExplosionSound=AkEvent'WW_EXP_Shared.Play_EXP_Grenade_Explosion'
    bWaitForEffects=true
    MyDamageType=class'DRDmgType_M24_Grenade'

    Begin Object Name=CollisionCylinder
        CollisionRadius=2
        CollisionHeight=3//4
        AlwaysLoadOnClient=True
        AlwaysLoadOnServer=True
    End Object
    //Components.Add(CollisionCylinder)

    Begin Object Name=ThowableMeshComponent
        SkeletalMesh=SkeletalMesh'DR_WP_DAK_M24_Grenade.Mesh.M1939_Grenade_Projectile'
        PhysicsAsset=PhysicsAsset'DR_WP_DAK_M24_Grenade.Phy.M1939_Grenade_Projectile_Physics'
    End Object

    SpottedBattleChatterIndex=`BATTLECHATTER_Grenade
    DampenFactor=0.33//0.5
}
