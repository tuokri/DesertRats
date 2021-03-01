// TODO: Experimental. Should use actual weapon actors in the future.
class DRStrafingRunAircraft extends RONapalmStrikeAircraftARVN;

var AudioComponent AC1;
var AudioComponent AC2;

var ROParticleSystemComponent PC1;
var ROParticleSystemComponent PC2;
var ROParticleSystemComponent PC3;
var ROParticleSystemComponent PC4;

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
}

simulated event StartStrike()
{
    super.StartStrike();

    SetTimer(0.086, True, 'FireCannon1');
    SetTimer(0.086, True, 'FireCannon2');
    SetTimer(0.086, True, 'FireCannon3');
    SetTimer(0.086, True, 'FireCannon4');

    AC1.VolumeMultiplier = 0.2;
    AC2.VolumeMultiplier = 0.2;

    if (Role < ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
    {
        AC1.Play();
        AC2.Play();
    }
}

simulated function FireCannon1()
{
    local vector SpawnLoc;
    local Projectile Proj;

    if (Role == ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
    {
        Mesh.GetSocketWorldLocationAndRotation('Muzzle_Left_Outer', SpawnLoc);
        Proj = Spawn(class'DRProjectile_Hispano_HE_MkII', Self,, SpawnLoc, Rotation);
        Proj.Init(SpawnLoc);
    }

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        PC1.ActivateSystem(True);
    }
}

simulated function FireCannon2()
{
    local vector SpawnLoc;
    local Projectile Proj;

    if (Role == ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
    {
        Mesh.GetSocketWorldLocationAndRotation('Muzzle_Left_Inner', SpawnLoc);
        Proj = Spawn(class'DRProjectile_Hispano_HE_MkII', Self,, SpawnLoc, Rotation);
        Proj.Init(SpawnLoc);
    }

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        PC2.ActivateSystem(True);
    }
}

simulated function FireCannon3()
{
    local vector SpawnLoc;
    local Projectile Proj;

    if (Role == ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
    {
        Mesh.GetSocketWorldLocationAndRotation('Muzzle_Right_Inner', SpawnLoc);
        Proj = Spawn(class'DRProjectile_Hispano_AP_MkIIZ', Self,, SpawnLoc, Rotation);
        Proj.Init(SpawnLoc);
    }

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        PC3.ActivateSystem(True);
    }
}

simulated function FireCannon4()
{
    local vector SpawnLoc;
    local Projectile Proj;

    if (Role == ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
    {
        Mesh.GetSocketWorldLocationAndRotation('Muzzle_Right_Outer', SpawnLoc);
        Proj = Spawn(class'DRProjectile_Hispano_AP_MkIIZ', Self,, SpawnLoc, Rotation);
        Proj.Init(SpawnLoc);
    }

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        PC4.ActivateSystem(True);
    }
}

DefaultProperties
{
    TeamIndex=`ALLIES_TEAM_INDEX
    Speed=0
    InboundDelay=0.05

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
