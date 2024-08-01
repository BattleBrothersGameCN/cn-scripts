this.metal_pauldrons_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.metal_pauldrons";
		this.m.Name = "金属肩铠";
		this.m.Description = "可以安装到任何盔甲上，增强上身防护的坚固金属肩铠。当然了，这也会使盔甲稍有加重。";
		this.m.ArmorDescription = "这件盔甲加装有一套金属肩铠，以额外重量为代价，加强了肩部和上身的防护能力。";
		this.m.Icon = "armor_upgrades/upgrade_11.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_11.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_11.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_11_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_11_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_11_back_dead";
		this.m.Value = 500;
		this.m.ConditionModifier = 40;
		this.m.StaminaModifier = 4;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+40[/color] 耐久度"
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
