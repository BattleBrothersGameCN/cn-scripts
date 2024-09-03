this.nachzehrer_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.nachzehrer_potion";
		this.m.Name = "急速组织生长";
		this.m.Icon = "skills/status_effect_149.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_149";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "该角色的身体变异使得其皮肤和肌肉组织能异常快速地再生。得益于此，深层伤口的愈合速度比正常情况下更快。另外他也开始变得特别喜欢生肉，但这和他的再生能力应该没什么关系。";
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
				icon = "ui/icons/days_wounded.png",
				text = "所有创伤的恢复时长减少一天，最短一天"
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

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isNachzehrerPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isNachzehrerPotionAcquired", false);
	}

});
