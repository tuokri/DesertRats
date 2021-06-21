class DRVehicleCrewProxy extends VehicleCrewProxy;

simulated function ReplacePawnMeshWithSelf(out ROPawn InPawn)
{
    // Set the body mesh
    ROSkeletalMeshComponent(InPawn.Mesh).ReplaceSkeletalMesh(Mesh.SkeletalMesh);

    // Generate list of bones which override the animation transforms (this is usually the face bones)
    ROSkeletalMeshComponent(InPawn.Mesh).GenerateAnimationOverrideBones(ThirdPersonHeadAndArmsMeshComponent.SkeletalMesh);

    // Parent the third person head and arms mesh to the body mesh
    InPawn.ThirdPersonHeadAndArmsMeshComponent.ReplaceSkeletalMesh(ThirdPersonHeadAndArmsMeshComponent.SkeletalMesh);
    InPawn.ThirdPersonHeadAndArmsMeshComponent.SetParentAnimComponent(InPawn.Mesh);
    InPawn.ThirdPersonHeadAndArmsMeshComponent.SetShadowParent(InPawn.Mesh);

    // Attach headgear.
    InPawn.AttachNewHeadgear(ThirdPersonHeadgearMeshComponent.SkeletalMesh);

    // Attach face item.
    InPawn.AttachNewFaceItem(ThirdPersonFaceItemMeshComponent.SkeletalMesh);

    // Attach facial hair.
    InPawn.AttachNewFacialHair(ThirdPersonFaceItemMeshComponent.SkeletalMesh);

    // Set Headphones
    // InPawn.ThirdPersonHeadphonesMeshComponent.SetSkeletalMesh(ThirdPersonHeadphonesMeshComponent.SkeletalMesh);
    // InPawn.ThirdPersonHeadphonesMeshComponent.SetParentAnimComponent(InPawn.Mesh);
    // InPawn.ThirdPersonHeadphonesMeshComponent.SetShadowParent(InPawn.Mesh);

    // Third person MICs
    InPawn.HeadAndArmsMIC.SetParent(MaterialInstanceConstant(ThirdPersonHeadAndArmsMeshComponent.GetMaterial(0)).Parent);
    InPawn.ThirdPersonHeadAndArmsMeshComponent.SetMaterial(0, InPawn.HeadAndArmsMIC);
    InPawn.BodyMIC.SetParent(MaterialInstanceConstant(Mesh.GetMaterial(0)).Parent);
    InPawn.Mesh.SetMaterial(0, InPawn.BodyMIC);

    // Handle wetness
}
