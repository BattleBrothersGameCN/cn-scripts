this.negative_mouldered_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.negative_moulderedd";
		this.m.Name = "腐朽";
		this.m.Description = "";
		this.m.ArmorDescription = "这件盔甲长时间暴露在自然环境中。皮革碎裂，布料腐坏，连金属件都锈穿了。";
		this.m.Icon = null;
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_downgrade_03.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_downgrade_03.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "downgrade_03_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "downgrade_03_back";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "downgrade_03_back_dead";
		this.m.Value = -250;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "无盔甲附件槽位"
		});
	}

	function onAdded()
	{
		this.m.Armor.m.Condition += -30;
		this.m.Armor.m.ConditionMax += -30;
	}

});
