this.negative_shabby_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.negative_shabby";
		this.m.Name = "破旧";
		this.m.Description = "";
		this.m.ArmorDescription = "看来前任主人根本没把它当回事。有些零件彻底丢了，有些则是拿别的什么顶上了。";
		this.m.Icon = null;
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_downgrade_02.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_downgrade_02.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "downgrade_02_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "downgrade_02_back";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "downgrade_02_back_dead";
		this.m.Value = -100;
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
		this.m.Armor.m.Condition += -10;
		this.m.Armor.m.ConditionMax += -10;
	}

});
