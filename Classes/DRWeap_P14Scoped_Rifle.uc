class DRWeap_P14Scoped_Rifle extends ROWeap_M40Scoped_Rifle
    abstract;

simulated function InitialiseScopeMaterial()
{
    local vector2D ViewportSize;

    // Only want to spawn sniper lenses on human players, but when PostBeginPlay
    // gets called Instigator isn't valid yet. So using NetMode == NM_Client,
    // since weapons should only exist on owning human clients with that netmode.
    if (Instigator != none && Instigator.IsLocallyControlled()
        && ROPlayerController(Instigator.Controller) != none)
    {
        ViewportSize = ROPlayerController(Instigator.Controller).GetViewportSize();
        UpdateScopeTextureTarget(ViewportSize.X);

        ScopeLenseMIC = new class'MaterialInstanceConstant';
        ScopeLenseMIC.SetParent(ScopeLenseMICTemplate);
        ScopeLenseMIC.SetTextureParameterValue('ScopeTextureTarget', SniperScopeTextureTarget);
        ScopeLenseMIC.SetScalarParameterValue(InterpParamName, 0.0);

        // P14 has different material slot number and order.
        mesh.SetMaterial(5, ScopeLenseMIC);

        // Initialize the scope sight range setting.
        if( ScopeSightRanges.Length > 0 )
        {
            ScopeLenseMIC.SetScalarParameterValue(
                'v_position', ScopeSightRanges[ScopeSightRangeIndex].SightPositionOffset);
        }
    }
}

DefaultProperties
{
    WeaponContentClass(0)="DesertRats.DRWeap_P14Scoped_Rifle_Content"

    RoleSelectionImage(0)=Texture2D'DR_UI.WP_Render.WP_Render_P14'

    WeaponClassType=ROWCT_ScopedRifle
    TeamIndex=`ALLIES_TEAM_INDEX

    WeaponProjectiles(0)=class'DRBullet_P14'
    WeaponProjectiles(ALTERNATE_FIREMODE)=class'DRBullet_P14'
    InstantHitDamageTypes(0)=class'DRDmgType_P14Bullet'
    InstantHitDamageTypes(1)=class'DRDmgType_P14Bullet'
    AmmoClass=class'DRAmmo_P14'

    // PlayerViewOffset=(X=0,Y=0,Z=0)

    IronSightPosition=(X=0,Y=0.02,Z=0)

    bHasScopePosition=True
    ScopePosition=(X=-3.5,Y=0.02,Z=-1)

    /*
    // 2D scene capture
    Begin Object Name=ROSceneCapture2DDPGComponent0
       TextureTarget=TextureRenderTarget2D'WP_Ger_Kar98k_Rifle.Materials.Kar98Lense'
       FieldOfView=15 // "3.0X" = 32.5(our real world FOV determinant)/3
    End Object
    */

    bDebugWeapon=False
}
