this.hide_and_bone_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.hide_and_bone_armor";
		this.m.Name = "兽皮骨甲";
		this.m.Description = "兽皮与骨头在北方是常见的材料。 这件盔甲是用这两者做成且提供了合适的防护。";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 92;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorBoneImpact;
		this.m.InventorySound = this.Const.Sound.ArmorBoneImpact;
		this.m.Value = 220;
		this.m.Condition = 95;
		this.m.ConditionMax = 95;
		this.m.StaminaModifier = -10;
	}

});
