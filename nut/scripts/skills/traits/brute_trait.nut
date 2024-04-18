this.brute_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.brute";
		this.m.Name = "粗野";
		this.m.Icon = "ui/traits/trait_icon_01.png";
		this.m.Description = "不太擅长精准攻击，在近战中，这个角色会全力击打对手的头部，以准头为代价造成额外伤害。";
		this.m.Titles = [
			"公牛(the Bull)",
			"壮牛(the Ox)",
			"大锤(the Hammer)"
		];
		this.m.Excluded = [
			"trait.tiny",
			"trait.fragile",
			"trait.insecure",
			"trait.hesitant"
		];
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
				id = 10,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] 伤害于击中头部时"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] 近战技能"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += -5;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAttack() && !_skill.isRanged())
		{
			_properties.DamageAgainstMult[this.Const.BodyPart.Head] += 0.150000;
		}
	}

});
