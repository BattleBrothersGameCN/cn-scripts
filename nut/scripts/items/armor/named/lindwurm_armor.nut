this.lindwurm_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.lindwurm_armor";
		this.m.Description = "一件缝上了凶猛林德蠕龙坚固鳞片的重型链甲。不仅是伟大猎人的战利品，还能挡开最猛烈的打击，甚至能凭借其闪光鳞片，免受林德蠕龙血液的腐蚀。";
		this.m.NameList = [
			"林德蠕龙鳞片",
			"龙皮",
			"蜥蜴外衣",
			"林德蠕龙胄",
			"林德蠕龙外衣",
			"蠕龙鳞片",
			"林德蠕龙外套"
		];
		this.m.Variant = 113;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 7500;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -26;
		this.randomizeValues();
	}

	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "不受林德蠕龙的酸血影响"
		});
		return result;
	}

	function onEquip()
	{
		this.named_armor.onEquip();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			this.m.Container.getActor().getFlags().add("body_immune_to_acid");
		}
	}

	function onUnequip()
	{
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			this.m.Container.getActor().getFlags().remove("body_immune_to_acid");
		}

		this.armor.onUnequip();
	}

});
