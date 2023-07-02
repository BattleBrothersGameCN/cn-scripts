this.decayed_closed_flat_top_with_mail <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.decayed_closed_flat_top_with_mail";
		this.m.Name = "腐朽的覆面链甲平顶盔";
		this.m.Description = "一个破旧的封闭式头盔，有一个完整的脸罩和一个包裹着脖子的链甲。 显然，它已经在户外凉了一段时间了。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		local variants = [
			55,
			58,
			61
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 1250;
		this.m.Condition = 230;
		this.m.ConditionMax = 230;
		this.m.StaminaModifier = -19;
		this.m.Vision = -3;
	}

});
