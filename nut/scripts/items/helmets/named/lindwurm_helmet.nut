this.lindwurm_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.lindwurm_helmet";
		this.m.Description = "这顶头盔曾经肯定属于一个勇敢而熟练的猎人，因为它覆盖着可怕的林德蠕龙的鳞片。 鳞片不仅可以阻止攻击和击打，而且它们还不会受到酸性林德蠕龙血液的伤害。";
		this.m.NameList = [
			"林德蠕龙的头",
			"蜥蜴头饰",
			"龙穹",
			"林德蠕龙监护",
			"沼泽头盔",
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
