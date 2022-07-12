class DRWeap_Lewis_LMG extends ROWeap_DP28_LMG
    abstract;

// Animation hacks.
var name FakeMagOuterBoneName;
var name FakeMagInnerBoneName;

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    local SkeletalMeshComponent FPSkelMesh;

    super.PostInitAnimTree(SkelComp);

    FPSkelMesh = SkeletalMeshComponent(Mesh);

    if (FPSkelMesh != None)
    {
        FPSkelMesh.HideBoneByName(FakeMagOuterBoneName, PBO_None);
        FPSkelMesh.HideBoneByName(FakeMagInnerBoneName, PBO_None);
    }
}

DefaultProperties
{
    RoleSelectionImage(0)=Texture2D'DR_UI.WP_Render.WP_Render_Lewis'
    WeaponContentClass(0)="DesertRats.DRWeap_Lewis_LMG_Content"

    WeaponProjectiles(0)=class'DRBullet_Lewis'
    InstantHitDamageTypes(0)=class'DRDmgType_LewisBullet'
    InstantHitDamageTypes(1)=class'DRDmgType_LewisBullet'
    AmmoClass=class'DRAmmo_Lewis'
    TracerClass=class'DP28BulletTracer'

    TracerFrequency=5
    // Equip and putdown
    WeaponPutDownAnim=MG34_putaway
    WeaponEquipAnim=MG34_pullout
    WeaponDownAnim=MG34_Down
    WeaponUpAnim=MG34_Up

    // Fire Anims
    // Hip fire
    WeaponFireAnim(0)=MG34_shoulder_shoot
    WeaponFireAnim(1)=MG34_shoulder_shoot
    WeaponFireLastAnim=MG34_shoulder_shoot
    // Shouldered fire
    WeaponFireShoulderedAnim(0)=MG34_shoulder_shoot
    WeaponFireShoulderedAnim(1)=MG34_shoulder_shoot
    WeaponFireLastShoulderedAnim=MG34_shoulder_shoot
    // Fire using iron sights
    WeaponFireSightedAnim(0)=MG34_deploy_shoot
    WeaponFireSightedAnim(1)=MG34_deploy_shoot
    WeaponFireLastSightedAnim=MG34_deploy_shoot

    // Idle Anims
    // Hip Idle
    WeaponIdleAnims(0)=MG34_shoulder_idle
    WeaponIdleAnims(1)=MG34_shoulder_idle
    // Shouldered idle
    WeaponIdleShoulderedAnims(0)=MG34_shoulder_idle
    WeaponIdleShoulderedAnims(1)=MG34_shoulder_idle
    // Sighted Idle
    WeaponIdleSightedAnims(0)=MG34_deploy_idle
    WeaponIdleSightedAnims(1)=MG34_deploy_idle

    // Prone Crawl
    WeaponCrawlingAnims(0)=MG34_CrawlF
    WeaponCrawlStartAnim=MG34_Crawl_into
    WeaponCrawlEndAnim=MG34_Crawl_out
    // Deployed Prone Crawl
    RedeployCrawlingAnims(0)=MG34_Deployed_CrawlF

    // Reloading
    WeaponReloadEmptyMagAnim=MG34_reloadempty_crouch
    WeaponReloadNonEmptyMagAnim=MG34_reloadhalf_crouch
    WeaponRestReloadEmptyMagAnim=MG34_reloadempty_rest
    WeaponRestReloadNonEmptyMagAnim=MG34_reloadhalf_rest
    DeployReloadEmptyMagAnim=MG34_deploy_reloadempty
    DeployReloadHalfMagAnim=MG34_deploy_reloadhalf
    // Ammo check
    WeaponAmmoCheckAnim=MG34_ammocheck_crouch
    WeaponRestAmmoCheckAnim=MG34_ammocheck_rest
    DeployAmmoCheckAnim=MG34_deploy_ammocheck

    // Sprinting
    WeaponSprintStartAnim=MG34_sprint_into
    WeaponSprintLoopAnim=MG34_Sprint
    WeaponSprintEndAnim=MG34_sprint_out
    Weapon1HSprintStartAnim=MG34_ger_sprint_into
    Weapon1HSprintLoopAnim=MG34_ger_sprint
    Weapon1HSprintEndAnim=MG34_ger_sprint_out

    // Mantling
    WeaponMantleOverAnim=MG34_Mantle

    // Cover/Blind Fire Anims
    WeaponRestAnim=MG34_rest_idle
    WeaponEquipRestAnim=MG34_pullout_rest
    WeaponPutDownRestAnim=MG34_putaway_rest
    WeaponIdleToRestAnim=MG34_shoulderTOrest
    WeaponRestToIdleAnim=MG34_restTOshoulder

    FakeMagOuterBoneName=Dual_Mag_Outer_Dup
    FakeMagInnerBoneName=Dual_Mag_Inner_Dup
}
