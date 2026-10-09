this.perk_rf_man_of_steel <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.rf_man_of_steel";
		this.m.Name = ::Const.Strings.PerkName.RF_ManOfSteel;
		this.m.Description = "攻击对于这个角色来说只能叫不痛不痒。";
		this.m.Icon = "ui/perks/perk_rf_man_of_steel.png";
		this.m.IconMini = "perk_rf_man_of_steel_mini";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return this.getBonus(::Const.BodyPart.Head) == 0 && this.getBonus(::Const.BodyPart.Body) == 0;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local headBonus = this.getBonus(::Const.BodyPart.Head);
		local bodyBonus = this.getBonus(::Const.BodyPart.Body);

		if (headBonus > 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "穿过头盔的伤害降低" + ::MSU.Text.colorPositive(headBonus + "%")
			});
		}
		else
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("该角色的头盔损坏太严重了")
			});
		}

		if (bodyBonus > 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "穿过身甲的伤害降低" + ::MSU.Text.colorPositive(bodyBonus + "%")
			});
		}
		else
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("该角色的身甲损坏太严重了")
			});
		}

		return ret;
	}

	function getBonus( _bodyPart )
	{
		return ::Math.min(100, this.getContainer().getActor().getArmor(_bodyPart) * 0.1);
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
		{
			return;
		}

		_properties.DamageReceivedDirectMult *= 1.0 - this.getBonus(_hitInfo.BodyPart) * 0.01;
	}

});
