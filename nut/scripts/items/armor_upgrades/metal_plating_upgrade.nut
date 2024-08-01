this.metal_plating_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.metal_plating";
		this.m.Name = "金属甲片配铆钉";
		this.m.Description = "用来铆接在基甲上的厚重金属甲片。粗放但简捷的防护增强手段。";
		this.m.ArmorDescription = "这件盔甲粗放地铆接着一些金属甲片，提供了额外的防护。";
		this.m.Icon = "armor_upgrades/upgrade_12.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_12.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_12.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_12_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_12_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_12_back_dead";
		this.m.Value = 300;
		this.m.ConditionModifier = 30;
		this.m.StaminaModifier = 3;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+30[/color] 耐久度"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-3[/color] 疲劳值上限"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
	}

});
