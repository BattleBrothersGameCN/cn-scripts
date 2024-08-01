this.bone_platings_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {
		IsUsed = false
	},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.bone_platings";
		this.m.Name = "骨质甲板";
		this.m.Description = "这层精巧的外板由强悍但异常轻质的骨头制成，作为穿戴在常规盔甲外的崩落装甲使用。";
		this.m.ArmorDescription = "一层精巧的骨板安装在这件盔甲上。";
		this.m.Icon = "armor_upgrades/upgrade_06.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_06.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_06.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_06_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_06_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_06_back_dead";
		this.m.StaminaModifier = 2;
		this.m.Value = 850;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/special.png",
			text = "完全吸收每场战斗中不能无视护甲的第一次命中伤害"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] 疲劳值上限"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/special.png",
			text = "完全吸收每场战斗中不能无视护甲的第一次命中伤害"
		});
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (this.m.IsUsed)
		{
			return;
		}

		if (_hitInfo.BodyPart == this.Const.BodyPart.Body && _hitInfo.DamageDirect < 1.0)
		{
			this.m.IsUsed = true;
			_properties.DamageReceivedTotalMult = 0.0;
		}
	}

	function onCombatFinished()
	{
		this.m.IsUsed = false;
	}

});
