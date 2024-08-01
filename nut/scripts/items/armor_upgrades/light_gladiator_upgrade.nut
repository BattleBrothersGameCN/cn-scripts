this.light_gladiator_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.light_gladiator_upgrade";
		this.m.Name = "填充护甲片";
		this.m.Description = "提供了额外防护的填充护甲片。";
		this.m.ArmorDescription = "这件盔甲安装了一块填充护甲片，提供了额外的防护。";
		this.m.Icon = "armor_upgrades/upgrade_24.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_24.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_24.png";
		this.m.SpriteFront = "upgrade_24_front";
		this.m.SpriteBack = null;
		this.m.SpriteDamagedFront = "upgrade_24_front_damaged";
		this.m.SpriteDamagedBack = null;
		this.m.SpriteCorpseFront = "upgrade_24_front_dead";
		this.m.SpriteCorpseBack = null;
		this.m.Value = 200;
		this.m.ConditionModifier = 60;
		this.m.StaminaModifier = 4;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+60[/color] 耐久度"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-4[/color] 疲劳值上限"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
	}

});
