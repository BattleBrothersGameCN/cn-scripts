this.lindwurm_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.lindwurm_helmet";
		this.m.Description = "其余其上覆盖着的可怖林德蠕龙鳞片，这顶头盔的原主人肯定是一位勇敢而熟练的猎人。鳞片不仅能抵御攻击，还能免受林德蠕龙酸性血液的腐蚀。";
		this.m.NameList = [
			"林德蠕龙之头",
			"蜥蜴头冠",
			"龙之顶",
			"林德蠕龙之守护",
			"蠕龙鳞盔",
			"林德蠕龙面罩"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 152;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 7500;
		this.m.Condition = 265;
		this.m.ConditionMax = 265;
		this.m.StaminaModifier = -18;
		this.m.Vision = -2;
		this.randomizeValues();
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
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
		this.named_helmet.onEquip();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			this.m.Container.getActor().getFlags().add("head_immune_to_acid");
		}
	}

	function onUnequip()
	{
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			this.m.Container.getActor().getFlags().remove("head_immune_to_acid");
		}

		this.helmet.onUnequip();
	}

});
