this.rf_dismantled_effect <- ::inherit("scripts/skills/skill", {
	m = {
		DamageIncrease = 20,
		BodyHitCount = 0,
		HeadHitCount = 0
	},
	function create()
	{
		this.m.ID = "effects.rf_dismantled";
		this.m.Name = "拆散护甲";
		this.m.Description = "这个角色的盔甲正在分崩离析，会在战斗的余下时间内增加穿甲伤害。";
		this.m.Icon = "skills/rf_dismantled_effect.png";
		this.m.IconMini = "rf_dismantled_effect_mini";
		this.m.Overlay = "rf_dismantled_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		if (this.m.BodyHitCount + this.m.HeadHitCount <= 1)
		{
			return this.m.Name;
		}
		else
		{
			return this.m.Name + " (x" + (this.m.BodyHitCount + this.m.HeadHitCount) + ")";
		}
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.HeadHitCount > 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = ::MSU.Text.colorNegative(this.m.HeadHitCount * this.m.DamageIncrease + "%") + " more damage received through Head Armor"
			});
		}

		if (this.m.BodyHitCount > 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = ::MSU.Text.colorNegative(this.m.BodyHitCount * this.m.DamageIncrease + "%") + " more damage received through Body Armor"
			});
		}

		return ret;
	}

	function onRefresh()
	{
		this.spawnIcon("rf_dismantled_effect", this.getContainer().getActor().getTile());
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null || !_skill.isAttack() || _attacker == null || _attacker.getID() == this.getContainer().getActor().getID())
		{
			return;
		}

		local count = _hitInfo.BodyPart == ::Const.BodyPart.Body ? this.m.BodyHitCount : this.m.HeadHitCount;
		_properties.DamageReceivedDirectMult *= 1.0 + count * this.m.DamageIncrease * 0.01;
	}

});
