this.new_knowledge_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Battles = 0,
		IsCountingBattle = false
	},
	function create()
	{
		this.m.ID = "effects.knowledge_potion";
		this.m.Name = "强化学习";
		this.m.Description = "由于一种被委婉地称为“知识药水”的热带混合体，这个角色的认知功能，特别是他的记忆和学习能力，随着他表现出紧张的滴答声的倾向而得到增强。";
		this.m.Icon = "skills/status_effect_94.png";
		this.m.Type = this.m.Type | this.Const.SkillType.StatusEffect | this.Const.SkillType.DrugEffect;
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
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+100%[/color] 经验获取"
			}
		];
		ret.push({
			id = 7,
			type = "hint",
			icon = "ui/icons/action_points.png",
			text = "将在之后消失" + (3 - this.m.Battles) + "更多战斗"
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 2.000000;
	}

	function onCombatStarted()
	{
		this.m.IsCountingBattle = true;
	}

	function onCombatFinished()
	{
		if (!this.m.IsCountingBattle)
		{
			return;
		}

		this.m.IsCountingBattle = false;
		++this.m.Battles;

		if (this.m.Battles >= 3)
		{
			this.removeSelf();
		}
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU16(this.m.Battles);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.Battles = _in.readU16();
	}

});
