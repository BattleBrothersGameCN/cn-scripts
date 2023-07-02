this.decayed_closed_flat_top_with_sack <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.decayed_closed_flat_top_with_sack";
		this.m.Name = "腐朽异教徒平顶链盔";
		this.m.Description = "一个破旧的封闭式头盔，有一个完整的脸罩和一个包裹着脖子的链甲，下面是一个腐烂的布袋。 显然，它已经在户外凉了一段时间了。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		local variants = [
			57
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
