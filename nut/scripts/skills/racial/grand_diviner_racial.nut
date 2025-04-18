this.grand_diviner_racial <- this.inherit("scripts/skills/skill", {
	m = {
		SkillsToAdjust = [
			"actives.censer_castigate",
			"actives.censer_strike"
		],
		APAdjust = -2
	},
	function create()
	{
		this.m.ID = "racial.grand_diviner";
		this.m.Name = "占卜师之怒";
		this.m.Description = "";
		this.m.Icon = "skills/status_effect_161.png";
		this.m.IconMini = "status_effect_161_mini";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		foreach( skill in this.m.SkillsToAdjust )
		{
			_properties.SkillCostAdjustments.push({
				ID = skill,
				APAdjust = this.m.APAdjust,
				FatigueAdjust = 0,
				FatigueMultAdjust = 1.0
			});
		}
	}

});
