this.new_trained_effect <- this.inherit("scripts/skills/skill", {
	m = {
		XPGainMult = 1.000000,
		Duration = 0,
		Battles = 0,
		IsCountingBattle = false
	},
	function create()
	{
		this.m.ID = "effects.trained";
		this.m.Name = "训练经验(Training Experience)";
		this.m.Description = "这个角色最近有幸与经验丰富的战士一起训练和学习，他已经浸透了知识，现在需要运用他在战场上所学的知识，以便完全掌握并使之成为自己的。";
		this.m.Icon = "skills/status_effect_62.png";
		this.m.Type = this.m.Type | this.Const.SkillType.StatusEffect;
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (this.m.XPGainMult * 100 - 100) + "%[/color] 经验获取"
			}
		];
		ret.push({
			id = 7,
			type = "hint",
			icon = "ui/icons/action_points.png",
			text = "将在之后消失" + (this.m.Duration - this.m.Battles) + "更多战斗"
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= this.m.XPGainMult;
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

		if (this.m.Battles >= this.m.Duration)
		{
			this.removeSelf();
		}
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU16(this.m.Duration);
		_out.writeU16(this.m.Battles);
		_out.writeF32(this.m.XPGainMult);
		_out.writeString(this.m.Icon);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.Duration = _in.readU16();
		this.m.Battles = _in.readU16();
		this.m.XPGainMult = _in.readF32();
		this.m.Icon = _in.readString();
	}

});
