this.adorned_closed_flat_top_with_mail <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.adorned_closed_flat_top_with_mail";
		this.m.Name = "装饰平顶覆面盔";
		this.m.Description = "一顶带有全面罩和链甲护颈的封闭头盔。因频繁使用而磨损严重，但饰有圣物，保养良好。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 238;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 2000;
		this.m.Condition = 250;
		this.m.ConditionMax = 250;
		this.m.StaminaModifier = -15;
		this.m.Vision = -3;
	}

});
