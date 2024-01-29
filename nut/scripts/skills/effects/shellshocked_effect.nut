this.shellshocked_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.shellshocked";
		this.m.Name = "炮火震撼";
		this.m.Icon = "skills/status_effect_119.png";
		this.m.IconMini = "status_effect_119_mini";
		this.m.Overlay = "status_effect_119";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/shellshocked_01.wav",
			"sounds/combat/dlc6/shellshocked_02.wav",
			"sounds/combat/dlc6/shellshocked_03.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "这个角色在附近的臼炮炮火中受到冲击。他们头晕耳鸣，他们视力模糊，他们有点找不着北。效果会在 [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] 回合中慢慢消退。";
	}

	function getTooltip()
	{
		return [
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
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] 伤害"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] 主动性"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] 决心"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] 近战技能"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] 远程技能"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] 近战防御"
			},
			{
				id = 17,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] 远程防御"
			}
		];
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "因为他不自然的生理机能抵抗了炮火震撼");
			}

			this.removeSelf();
		}
		else
		{
			this.m.TurnsLeft = this.Math.max(1, 3 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 0.800000, this.getContainer().getActor().getPos());
			}

			this.getContainer().getActor().checkMorale(-1, 0);
		}
	}

	function onRefresh()
	{
		this.m.TurnsLeft = this.Math.max(1, 3 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
		this.spawnIcon("status_effect_119", this.getContainer().getActor().getTile());

		if (this.m.SoundOnUse.len() != 0)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 0.800000, this.getContainer().getActor().getPos());
		}
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		_properties.DamageTotalMult *= 1.000000 - 0.050000 * this.m.TurnsLeft;
		_properties.InitiativeMult *= 1.000000 - 0.050000 * this.m.TurnsLeft;
		_properties.BraveryMult *= 1.000000 - 0.050000 * this.m.TurnsLeft;
		_properties.MeleeSkillMult *= 1.000000 - 0.050000 * this.m.TurnsLeft;
		_properties.RangedSkillMult *= 1.000000 - 0.050000 * this.m.TurnsLeft;
		_properties.MeleeDefenseMult *= 1.000000 - 0.050000 * this.m.TurnsLeft;
		_properties.RangedDefenseMult *= 1.000000 - 0.050000 * this.m.TurnsLeft;
	}

	function onTurnStart()
	{
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});
