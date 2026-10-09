this.rf_onslaught_effect <- ::inherit("scripts/skills/skill", {
	m = {
		RoundsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.rf_onslaught";
		this.m.Name = "冲击阵线";
		this.m.Description = "该角色随时准备冲破敌人阵线。";
		this.m.Icon = "ui/perks/perk_rf_onslaught.png";
		this.m.IconMini = "rf_onslaught_effect_mini";
		this.m.Overlay = "rf_onslaught_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(10, {
					AddSign = true
				}) + "[近战技能|Concept.MeleeSkill]")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(20, {
					AddSign = true
				}) + "[主动值|Concept.Initiative]")
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("获得一次性的[$ $|Skill+rf_line_breaker_onslaught_skill]技能")
			},
			{
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("会在" + this.m.RoundsLeft + "[轮|Concept.Round]后失效")
			}
		]);
		return ret;
	}

	function onAdded()
	{
		this.getContainer().add(::new("scripts/skills/actives/rf_line_breaker_onslaught_skill"));
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.rf_line_breaker_onslaught");
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += 10;
		_properties.Initiative += 20;
	}

	function onRoundEnd()
	{
		if (--this.m.RoundsLeft == 0)
		{
			this.removeSelf();
		}
	}

});
