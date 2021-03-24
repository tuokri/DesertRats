// TODO: Hide bombs on the plane mesh.
class DRStrafingRunAircraft extends RONapalmStrikeAircraftARVN;

var AudioComponent AC1;
var AudioComponent AC2;

var ROParticleSystemComponent PC1;
var ROParticleSystemComponent PC2;
var ROParticleSystemComponent PC3;
var ROParticleSystemComponent PC4;

var int SpreadDegree;
var int PitchRate;


simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // AC1.SoundCue = SoundCue'DR_AUD_Hurricane.2x20mm_Hispano_Loop_Cue';
    // AC2.SoundCue = SoundCue'DR_AUD_Hurricane.2x20mm_Hispano_Loop_Cue';
    // AC2.SoundCue = SoundCue'DR_AUD_Hurricane.2x20mm_Hispano_Loop_End_Cue';

    //? Mesh.AttachComponentToSocket(AC1, 'Muzzle_Left_Outer');
    //? Mesh.AttachComponentToSocket(AC2, 'Muzzle_Right_Outer');

    PC1 = new(self) class'ROParticleSystemComponent';
    PC2 = new(self) class'ROParticleSystemComponent';
    PC3 = new(self) class'ROParticleSystemComponent';
    PC4 = new(self) class'ROParticleSystemComponent';

    PC1.bAutoActivate = False;
    PC2.bAutoActivate = False;
    PC3.bAutoActivate = False;
    PC4.bAutoActivate = False;

    PC1.SetTemplate(ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_DShK');
    PC2.SetTemplate(ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_DShK');
    PC3.SetTemplate(ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_DShK');
    PC4.SetTemplate(ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_DShK');

    Mesh.AttachComponentToSocket(PC1, 'Muzzle_Left_Outer');
    Mesh.AttachComponentToSocket(PC2, 'Muzzle_Left_Inner');
    Mesh.AttachComponentToSocket(PC3, 'Muzzle_Right_Inner');
    Mesh.AttachComponentToSocket(PC4, 'Muzzle_Right_Outer');

    SetTimer(25, False, 'Explode');
}

simulated event StartStrike()
{
    super.StartStrike();

    SetTimer(0.080, True, 'FireCannon1');
    SetTimer(0.090, True, 'FireCannon2');
    SetTimer(0.085, True, 'FireCannon3');
    SetTimer(0.078, True, 'FireCannon4');

    AC1.VolumeMultiplier = 0.15;
    AC2.VolumeMultiplier = 0.15;

    if (Role < ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
    {
        AC1.Play();
        SetTimer(0.1, False, 'PlayAC2');
    }

    RotationRate.Pitch = PitchRate;

    SetTimer(5, False, 'StopStrike');
    SetTimer(5, False, 'Ascend');
    SetTimer(10, False, 'GetOuttaHere');
}

simulated function Ascend()
{
    RotationRate.Pitch = 5000;
}

simulated function GetOuttaHere()
{
    RotationRate.Pitch = 0;
}

simulated function PlayAC2()
{
    AC2.Play();
}

simulated event StopStrike()
{
    ClearTimer('FireCannon1');
    ClearTimer('FireCannon2');
    ClearTimer('FireCannon3');
    ClearTimer('FireCannon4');

    if (Role < ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
    {
        AC1.Stop();
        AC2.Stop();
    }
}

simulated function Explode()
{
    AC1.Stop();
    AC2.Stop();

    super.Explode();
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    Velocity = Speed * vector(Rotation);
}

simulated function FireCannon1()
{
    local vector SpawnLoc;
    local rotator SpawnRot;
    local DRProjectile_Hispano_HE_MkII Proj;

    if (bExploded)
    {
        return;
    }

    if (Role == ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
    {
        Mesh.GetSocketWorldLocationAndRotation('Muzzle_Left_Outer', SpawnLoc, SpawnRot);

        SpawnRot.Yaw += SpreadDegree * (Rand(2) - 1);
        SpawnRot.Pitch += SpreadDegree * (Rand(2) - 1);

        Proj = Spawn(class'DRProjectile_Hispano_HE_MkII', InstigatorController,, SpawnLoc, SpawnRot);
        Proj.OwningAircraft = Self;
        Proj.Init(Vector(SpawnRot));
        Proj.InstigatorController = Controller(Owner);
    }

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        PC1.ActivateSystem(True);
    }
}

simulated function FireCannon2()
{
    local vector SpawnLoc;
    local rotator SpawnRot;
    local DRProjectile_Hispano_AP_MkIIZ Proj;

    if (bExploded)
    {
        return;
    }

    if (Role == ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
    {
        Mesh.GetSocketWorldLocationAndRotation('Muzzle_Left_Inner', SpawnLoc, SpawnRot);

        SpawnRot.Yaw += SpreadDegree * (Rand(2) - 1);
        SpawnRot.Pitch += SpreadDegree * (Rand(2) - 1);

        Proj = Spawn(class'DRProjectile_Hispano_AP_MkIIZ', InstigatorController,, SpawnLoc, SpawnRot);
        Proj.OwningAircraft = Self;
        Proj.Init(Vector(SpawnRot));
        Proj.InstigatorController = Controller(Owner);
    }

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        PC2.ActivateSystem(True);
    }
}

simulated function FireCannon3()
{
    local vector SpawnLoc;
    local rotator SpawnRot;
    local DRProjectile_Hispano_AP_MkIIZ Proj;

    if (bExploded)
    {
        return;
    }

    if (Role == ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
    {
        Mesh.GetSocketWorldLocationAndRotation('Muzzle_Right_Inner', SpawnLoc, SpawnRot);

        SpawnRot.Yaw += SpreadDegree * (Rand(2) - 1);
        SpawnRot.Pitch += SpreadDegree * (Rand(2) - 1);

        Proj = Spawn(class'DRProjectile_Hispano_AP_MkIIZ', InstigatorController,, SpawnLoc, SpawnRot);
        Proj.OwningAircraft = Self;
        Proj.Init(Vector(SpawnRot));
        Proj.InstigatorController = Controller(Owner);
    }

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        PC3.ActivateSystem(True);
    }
}

simulated function FireCannon4()
{
    local vector SpawnLoc;
    local rotator SpawnRot;
    local DRProjectile_Hispano_HE_MkII Proj;

    if (bExploded)
    {
        return;
    }

    if (Role == ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
    {
        Mesh.GetSocketWorldLocationAndRotation('Muzzle_Right_Outer', SpawnLoc, SpawnRot);

        SpawnRot.Yaw += SpreadDegree * (Rand(2) - 1);
        SpawnRot.Pitch += SpreadDegree * (Rand(2) - 1);

        Proj = Spawn(class'DRProjectile_Hispano_HE_MkII', InstigatorController,, SpawnLoc, SpawnRot);
        Proj.OwningAircraft = Self;
        Proj.Init(Vector(SpawnRot));
        Proj.InstigatorController = Controller(Owner);
    }

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        PC4.ActivateSystem(True);
    }
}

DefaultProperties
{
    TeamIndex=`ALLIES_TEAM_INDEX
    Speed=6250 // 450 km/h = 125 m/s.
    InboundDelay=5
    SpreadDegree=10

    // AmbientSound=None
    // AmbientComponent=None

    Begin Object Name=PlaneMesh
        SkeletalMesh=SkeletalMesh'DR_VH_CMD.Mesh.Hurricane_BOMB_SKEL'
        PhysicsAsset=PhysicsAsset'DR_VH_CMD.Phy.Hurricane_BOMB_SKEL_Physics'
        AnimSets[0]=AnimSet'VH_VN_ARVN_Skyraider.Animation.AUS_Skyraider_anim'
        Materials[0]=MaterialInstanceConstant'DR_VH_CMD.MIC.M_Hurricane'
    End Object

    Begin Object Class=AudioComponent name=AC1_1
        OcclusionCheckInterval=1.0
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
        bAutoPlay=false
        SoundCue=SoundCue'DR_AUD_Hurricane.2x20mm_Hispano_Loop_Cue';
    End Object
    AC1=AC1_1
    Components.Add(AC1_1)

    Begin Object Class=AudioComponent name=AC2_1
        OcclusionCheckInterval=1.0
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
        bAutoPlay=false
        SoundCue=SoundCue'DR_AUD_Hurricane.2x20mm_Hispano_Loop_Cue';
    End Object
    AC2=AC2_1
    Components.Add(AC2_1)
}
