this.negative_weathered_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.negative_weathered";
		this.m.Name = "风化";
		this.m.Description = "";
		this.m.ArmorDescription = "这件盔甲因尘土和雨水而轻度风化，金属失去光泽，皮革硬化变脆。";
		this.m.Icon = null;
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_downgrade_04.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_downgrade_04.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "downgrade_04_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "downgrade_04_back";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "downgrade_04_back_dead";
		this.m.Value = -150;
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
		this.m.Armor.m.Condition += -15;
		this.m.Armor.m.ConditionMax += -15;
	}

});
