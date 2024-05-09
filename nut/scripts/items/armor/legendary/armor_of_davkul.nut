this.armor_of_davkul <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.armor_of_davkul";
		this.m.Name = "达库尔的神体";
		this.m.Description = "达库尔(Davkul)骇人的一面，这是来自异界的古老力量，以及 %sacrifice% 身体最后的遗留和重塑。它永远不会破裂，而是在原地不断地再生它那伤痕累累的皮肤。";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IsIndestructible = true;
		this.m.Variant = 81;
		this.updateVariant();
		this.m.ImpactSound = [
			"sounds/combat/cleave_hit_hitpoints_01.wav",
			"sounds/combat/cleave_hit_hitpoints_02.wav",
			"sounds/combat/cleave_hit_hitpoints_03.wav"
		];
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Value = 20000;
		this.m.Condition = 270;
		this.m.ConditionMax = 270;
		this.m.StaminaModifier = -18;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "每回合回复自身[color=" + this.Const.UI.Color.PositiveValue + "]90[/color]点耐久。"
		});
		return result;
	}

	function onTurnStart()
	{
		this.m.Condition = this.Math.minf(this.m.ConditionMax, this.m.Condition + 90.0);
		this.updateAppearance();
	}

	function onCombatFinished()
	{
		this.m.Condition = this.m.ConditionMax;
		this.updateAppearance();
	}

	function onSerialize( _out )
	{
		this.armor.onSerialize(_out);
		_out.writeString(this.m.Description);
	}

	function onDeserialize( _in )
	{
		this.armor.onDeserialize(_in);
		this.m.Description = _in.readString();
	}

});
