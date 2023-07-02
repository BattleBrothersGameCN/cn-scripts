this.hyena_fur_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.hyena_fur";
		this.m.Name = "鬣狗毛皮披风";
		this.m.Description = "从凶猛的鬣狗身上取下的毛皮，缝在一起，作为猎兽者的战利品戴在脖子上。 像这样穿上野兽的皮能增强你行动的动力。";
		this.m.ArmorDescription = "披着鬣狗毛皮的外套附在这件盔甲上，增强了穿戴者行动的动力。";
		this.m.Icon = "armor_upgrades/upgrade_26.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_26.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_26.png";
		this.m.SpriteFront = "upgrade_26_front";
		this.m.SpriteBack = "upgrade_26_back";
		this.m.SpriteDamagedFront = "upgrade_26_front_damaged";
		this.m.SpriteDamagedBack = "upgrade_26_back";
		this.m.SpriteCorpseFront = "upgrade_26_front_dead";
		this.m.SpriteCorpseBack = "upgrade_26_back_dead";
		this.m.Value = 600;
		this.m.ConditionModifier = 15;
		this.m.StaminaModifier = 0;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] 耐久度"
		});
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] 主动性"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] 主动性"
		});
	}

	function onUpdateProperties( _properties )
	{
		_properties.Initiative += 15;
	}

});
