this.drunk_effect <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "effects.drunk";
		this.m.Name = "醉酒";
		this.m.Description = "反应迟钝的人。这个人喝醉了，会损害身心的能力。";
		this.m.Icon = "skills/status_effect_61.png";
		this.m.Type = this.m.Type | this.Const.SkillType.StatusEffect | this.Const.SkillType.SemiInjury | this.Const.SkillType.DrugEffect;
		this.m.IsHealingMentioned = false;
		this.m.IsTreatable = false;
		this.m.IsContentWithReserve = false;
		this.m.HealingTimeMin = 1;
		this.m.HealingTimeMax = 1;
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
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] 决心"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] 近战技能"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] 远程技能"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] 近战防御"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] 远程防御"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] 主动性"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "有 [color=" + this.Const.UI.Color.NegativeValue + "]50%[/color] 的几率会有宿醉的症状"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onAdded()
	{
		this.injury.onAdded();
		this.m.Container.removeByID("effects.hangover");
	}

	function onRemoved()
	{
		if (this.Math.rand(1, 100) <= 50)
		{
			this.getContainer().add(this.new("scripts/skills/effects_world/hangover_effect"));
		}
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);
		_properties.BraveryMult *= 1.250000;
		_properties.MeleeSkillMult *= 0.750000;
		_properties.RangedSkillMult *= 0.750000;
		_properties.MeleeDefenseMult *= 0.750000;
		_properties.RangedDefenseMult *= 0.750000;
		_properties.InitiativeMult *= 0.750000;
	}

});
