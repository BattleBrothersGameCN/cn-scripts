this.hexe_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.hexe_potion";
		this.m.Name = "痛苦锁链";
		this.m.Icon = "skills/status_effect_148.png";
		this.m.IconMini = "status_effect_148_mini";
		this.m.Overlay = "status_effect_148";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "这个角色有些异于常人。从外观上看他们似乎没有不同，但不知何故，他们会给人一种莫名的恐惧感。他在战场上或战场外承受的任何伤害似乎都会影响到周围的另一个人。这个特性在战斗中很有用，但在营地里会令人讨厌，在日常生活中中肯定会被孤立的。";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "反射 [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] 生命值伤害到攻击者"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "下次喝下突变药剂会导致更长时间的疾病"
			}
		];
		return ret;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints > 0 && _attacker != null && _attacker.isAlive() && _attacker.getHitpoints() > 0 && _attacker.getID() != this.getContainer().getActor().getID() && !_attacker.getCurrentProperties().IsImmuneToDamageReflection)
		{
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = _damageHitpoints;
			hitInfo.DamageArmor = 0.000000;
			hitInfo.DamageDirect = 1.000000;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.000000;
			hitInfo.FatalityChanceMult = 0.000000;
			_attacker.onDamageReceived(_attacker, null, hitInfo);
		}
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isHexePotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isHexePotionAcquired", false);
	}

});
