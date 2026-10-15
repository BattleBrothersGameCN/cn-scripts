this.rf_anatomist_potion_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 12,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "下次喝下突变药剂会导致更长时间的疾病"
		});
		return ret;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != ::Const.FatalityType.Unconscious)
		{
			::World.Statistics.getFlags().set(::Reforged.Items.AnatomistPotions.getInfo(this).AcquiredFlagName, false);
		}
	}

	function onDismiss()
	{
		::World.Statistics.getFlags().set(::Reforged.Items.AnatomistPotions.getInfo(this).AcquiredFlagName, false);
	}

});
