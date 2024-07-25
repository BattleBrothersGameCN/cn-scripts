this.night_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.night";
		this.m.Name = "黑夜";
		this.m.Description = "刚刚那影子是不是动了？昏暗的月光让人很难看清前方几英尺以外的地方，缩小了视野范围，对于那些在黑暗中看不见东西的人来说，使用远程武器是一个糟糕的提议。";
		this.m.Icon = "skills/status_effect_35.png";
		this.m.IconMini = "status_effect_35_mini";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.Special;
		this.m.IsActive = false;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = true;
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
			}
		];
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] 视野"
		});
		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/ranged_skill.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] 远程技能"
		});
		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] 远程防御"
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = !_properties.IsAffectedByNight;

		if (_properties.IsAffectedByNight)
		{
			_properties.Vision -= 2;
			_properties.RangedSkillMult *= 0.7;
			_properties.RangedDefense *= 0.7;
		}
	}

});
