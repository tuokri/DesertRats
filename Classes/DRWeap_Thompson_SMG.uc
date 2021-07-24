class DRWeap_Thompson_SMG extends ROWeap_M1A1_SMG
	abstract;

`include(DesertRats\Classes\DRWeaponPickupMessagesOverride.uci)

// Experimental closed bolt reload set ~ adrian

var protected bool 		bDryFiring;				// track if the weapon is currently dry firing, to prevent spam

var(Animations) name 	WeaponDryFireAnim;
var(Animations) name 	WeaponDryFireSightedAnim;

var(Animations) name    WeaponClosedBoltReload;

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
	else if (NumDryFires >= 1)
	{
		return WeaponClosedBoltReload;

		NumDryFires = 0 // Reset the counter!
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

	if(FireModeNum == ALTERNATE_FIREMODE)
	{
		return super.AttemptAutoReload(FireModeNum);
	}

	// from ROWeapon::AttempAutoReload(byte FireModeNum)

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

function AddKill(Pawn KilledPawn, optional class<DamageType> dmgType)
{
	super(ROProjectileWeapon).AddKill(KilledPawn, dmgType);
}

DefaultProperties
{
	WeaponContentClass(0)="DesertRats.DRWeap_Thompson_SMG_Content"

	WeaponDryFireAnim=Thompson_shootLAST  // TODO: REPLACE ME
	WeaponDryFireSightedAnim=Thompson_shootLAST // TODO: REPLACE ME

	WeaponClosedBoltReload=Thompson_reloadempty

	InvIndex=`DRII_THOMPSON_SMG

	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Loop_3P', FirstPersonCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Auto_LP')
	WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue= AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Single_3P', FirstPersonCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Fire_Single')

	bLoopingFireSnd(DEFAULT_FIREMODE)=true
	WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Tail_3P', FirstPersonCue=AkEvent'WW_WEP_M1A1.Play_WEP_M1A1_Auto_Tail')
	bLoopHighROFSounds(DEFAULT_FIREMODE)=true
}
