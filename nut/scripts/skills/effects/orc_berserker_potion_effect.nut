this.orc_berserker_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		SkillCount = 0,
		RageStacks = 0
	},
	function create()
	{
		this.m.ID = "effects.orc_berserker_potion";
		this.m.Name = "狂战士之怒";
		this.m.Icon = "skills/status_effect_129.png";
		this.m.IconMini = "status_effect_129_mini";
		this.m.Overlay = "status_effect_129";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "此角色的肾上腺素和激素腺发生了变异，导致其情绪一直处于高度敏感状态。在营地里，他们基本上可以控制这种情况，但在高压情况下，这种效应则更为强烈，充满了强烈的、无法平息的愤怒。";
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
				text = "该角色每次受到生命值伤害时获得两层狂暴，每回合结束时失去一层。"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "下次喝下突变药剂会导致更长时间的疾病"
			}
		];

		if (this.m.RageStacks > 0)
		{
			ret.extend([
				{
					id = 12,
					type = "text",
					icon = "ui/icons/sturdiness.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (100 - this.Math.maxf(0.300000, 1.000000 - 0.020000 * this.m.RageStacks) * 100) + "%[/color] 伤害减免"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/damage_dealt.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + 1 * this.m.RageStacks + "[/color] 伤害输出"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + 1 * this.m.RageStacks + "[/color] 决心"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + 1 * this.m.RageStacks + "[/color]主动值"
				}
			]);
		}

		return ret;
	}

	function addRage( _r )
	{
		this.m.RageStacks = this.Math.min(this.m.RageStacks + _r, 15);
		local actor = this.getContainer().getActor();

		if (!actor.isHiddenToPlayer())
		{
			this.spawnIcon("status_effect_143", actor.getTile());
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " 获得狂暴！");
		}
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedTotalMult *= this.Math.maxf(0.300000, 1.000000 - 0.020000 * this.m.RageStacks);
		_properties.Bravery += 1 * this.m.RageStacks;
		_properties.DamageRegularMin += 1 * this.m.RageStacks;
		_properties.DamageRegularMax += 1 * this.m.RageStacks;
		_properties.Initiative += 1 * this.m.RageStacks;
	}

	function onTurnEnd()
	{
		this.m.RageStacks = this.Math.max(0, this.m.RageStacks - 1);
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (this.m.SkillCount == this.Const.SkillCounter)
		{
			return;
		}

		this.m.SkillCount = this.Const.SkillCounter;

		if (_attacker != null && _attacker.getID() != this.getContainer().getActor().getID() && _damageHitpoints > 0)
		{
			this.addRage(3);
		}
	}

	function onCombatStarted()
	{
		this.m.SkillCount = 0;
		this.m.RageStacks = 0;
	}

	function onCombatFinished()
	{
		this.m.SkillCount = 0;
		this.m.RageStacks = 0;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isOrcBerserkerPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isOrcBerserkerPotionAcquired", false);
	}

});
