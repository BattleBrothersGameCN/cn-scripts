this.lindwurm_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.lindwurm_armor";
		this.m.Description = "缝上了可怕的坚固林德蠕龙鳞片的沉重链甲。不仅仅是伟大猎人的战利品，也能应付最猛烈的战斗，闪闪发光的鳞片不会受到林德蠕龙酸性血液的腐蚀。";
		this.m.NameList = [
			"林德蠕龙鳞片",
			"龙皮",
			"蜥蜴大衣",
			"林德蠕龙胄",
			"林德蠕龙大衣",
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
