class DRWeap_Thompson_M1928A1_SMG_Content extends DRWeap_Thompson_M1928A1_SMG;

// Experimental closed bolt reload set ~ adrian

var protected bool      bDryFiring;             // track if the weapon is currently dry firing, to prevent spam

var(Animations) name    WeaponDryFireAnim;
var(Animations) name    WeaponDryFireSightedAnim;

var(Animations) name    WeaponClosedBoltReload;

simulated function EndDryFiring()
{
    bDryFiring = false;
}

// Plays dry firing animation and returns the length of the animation played
simulated function float PlayDryFireAnimation()
{
    local float AnimLength;

    // Play Weapon fire animation
    if ( bUsingSights )
    {
        if ( WeaponDryFireSightedAnim != '' )
        {
            AnimLength = SkeletalMeshComponent(Mesh).GetAnimLength(WeaponDryFireSightedAnim);
            PlayAnimation( WeaponDryFireSightedAnim, AnimLength,,FireTweenTime );
        }
    }
    else
    {
        if ( WeaponDryFireAnim != '' )
        {
            AnimLength = SkeletalMeshComponent(Mesh).GetAnimLength(WeaponDryFireAnim);
            PlayAnimation( WeaponDryFireAnim, AnimLength,,FireTweenTime );
        }
    }

    // return AnimLength;
    return FireInterval[0];
}

simulated function name GetReloadMagAnimName()
{
    if ( HasAnyAmmo() )
    {
        if ( UseRestingAnim() )
        {
            return WeaponRestReloadNonEmptyMagAnim;
        }
        else
        {
            return ( (bUsingSights || bZoomingOut) && WeaponReloadNonEmptyMagIronAnim != '' ) ? WeaponReloadNonEmptyMagIronAnim : WeaponReloadNonEmptyMagAnim;
        }
    }
    else if (NumDryFires > 0)
    {
        return WeaponClosedBoltReload;

        NumDryFires = 0; // Reset
    }
    else
    {
        if ( UseRestingAnim() )
        {
            return WeaponRestReloadEmptyMagAnim;
        }
        else
        {
            return ( (bUsingSights || bZoomingOut) && WeaponReloadEmptyMagIronAnim != '' ) ? WeaponReloadEmptyMagIronAnim : WeaponReloadEmptyMagAnim;
        }
    }
}

simulated function bool AttemptAutoReload(byte FireModeNum)
{
    local ROPlayerController ROPC;

    if( IsInState('Reloading') || IsInState('SwitchingAmmo') || IsInState('SwitchingSpecialOpMode') )
    {
        return false;
    }

    if( Instigator != none )
    {
        ROPC = ROPlayerController(Instigator.Controller);
    }

    // Do dry fire sounds/auto reload, but only if this weapon is autoreload capable (i.e. don't make dry fire sounds on binoculars, etc)
    if( bCanAutoReload && !HasAmmo(FireModeNum) && ROPC != none && ROPC.IsLocalPlayerController() )
    {
        // If bAutoReloading is off you could potentially get to 255 dry fires
        // so just make it wrap around in that case
        if( NumDryFires < 255 )
        {
            NumDryFires++;
        }
        else
        {
            NumDryFires = 0;
        }

        if( !bDryFiring && (!HasAnyAmmoOrMags() || !ROPC.bAutoReloading || (ROPC.bAutoReloading && NumDryFires == 1) ) )
        {

            // New addition for dry firing the M1917
            // TODO: Maybe get a specific animation for this
            bDryFiring = true;
            SetTimer( PlayDryFireAnimation(), false, 'EndDryFiring' );
            // End new addition

            // Allow the anim notifies to play sounds so they sync up. We
            // still use ServerPlayDryFireSound for everyone else to hear our empty gun though
             WeaponPlaySound(WeaponDryFireSnd);

            if( Role < ROLE_Authority )
            {
                ServerPlayDryFireSound();
            }
        }

        // If we can autoreload, do an autoreload
        if( bCanAutoReload && ROPC.bAutoReloading && (NumDryFires > 1 || MaxAmmoCount == 1) )
        {
            if(FireModeNum == ALTERNATE_FIREMODE)
            {
                return super.AttemptAutoReload(FireModeNum);
            }
            DoReload();
            return true;
        }
    }
    else
    {
        NumDryFires = 0;
    }

    return false;
}

simulated function SetupArmsAnim()
{
    super.SetupArmsAnim();

    // ArmsMesh.AnimSets has slots 0-2-3 filled, so we need to back fill slot 1 and then move to slot 4
    ROPawn(Instigator).ArmsMesh.AnimSets[1] = SkeletalMeshComponent(Mesh).AnimSets[0];
    ROPawn(Instigator).ArmsMesh.AnimSets[4] = SkeletalMeshComponent(Mesh).AnimSets[1];
}

DefaultProperties
{
    AttachmentClass=class'DRWeapAttach_Thompson_M1928A1_SMG'

    WeaponDryFireAnim=Thompson_Dry
    WeaponDryFireSightedAnim=Thompson_Dry

    WeaponClosedBoltReload=Thompson_BoltReload

    BoltControllerNames[0]=BoltSlide_M1A1

    Begin Object Name=FirstPersonMesh
        DepthPriorityGroup=SDPG_Foreground
        SkeletalMesh=SkeletalMesh'DR_WP_UK_M1928A1.Mesh.M1928A1_Thompson'
        PhysicsAsset=PhysicsAsset'DR_WP_UK_M1928A1.Phy.M1928A1_Thompson_Physics'
        AnimSets(0)=AnimSet'WP_VN_ARVN_ThompsonM1A1_SMG.Animation.WP_M1A1ThompsonHands'
        AnimSets(1)= // TODO: REPLACE ME!!!!!!!!!!!!!!!!!!!!!!
        AnimTreeTemplate=AnimTree'WP_VN_ARVN_ThompsonM1A1_SMG.Animation.ARVN_M1Thompson_AnimTree'
        Scale=1.0
        FOV=70
    End Object

    ArmsAnimSet=AnimSet'WP_VN_ARVN_ThompsonM1A1_SMG.Animation.WP_M1A1ThompsonHands'

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'DR_WP_UK_M1928A1.Mesh.Thompson_3rd_Master_UPGD2'
        PhysicsAsset=PhysicsAsset'DR_WP_UK_M1928A1.Phy.Thompson_3rd_Master_UPGD2_Physics'
        AnimTreeTemplate=AnimTree'WP_VN_ARVN_3rd_Master.AnimTree.M1Thompson_SMG_3rd_Tree'
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=true
        BlockNonZeroExtent=true//false
        BlockRigidBody=true
        bHasPhysicsAssetInstance=false
        bUpdateKinematicBonesFromAnimation=false
        PhysicsWeight=1.0
        RBChannel=RBCC_GameplayPhysics
        RBCollideWithChannels=(Default=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
        bSkipAllUpdateWhenPhysicsAsleep=TRUE
        bSyncActorLocationToRootRigidBody=true
    End Object
}
