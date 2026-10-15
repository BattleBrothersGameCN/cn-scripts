this.rf_arrow_to_the_knee_debuff_effect <- ::inherit("scripts/skills/skill", {
	m = {
		StartingTurnsLeft = 2,
		TurnsLeft = 2,
		MovementAPCostAdditional = 2
	},
	function create()
	{
		this.m.ID = "effects.rf_arrow_to_the_knee_debuff";
		this.m.Name = "膝盖中箭";
		this.m.Description = "该角色曾经和你一样行动自由，直到他膝盖中了一箭。";
		this.m.Icon = "skills/rf_arrow_to_the_knee_debuff_effect.png";
		this.m.IconMini = "rf_arrow_to_the_knee_debuff_effect_mini";
		this.m.Overlay = "rf_arrow_to_the_knee_debuff_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative(this.m.MovementAPCostAdditional) + " additional [Action Points|Concept.ActionPoints] per tile moved")
		});
		return ret;
	}

	function onAdded()
	{
		this.m.TurnsLeft = ::Math.max(1, this.m.StartingTurnsLeft + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
	}

	function onRefresh()
	{
		this.m.TurnsLeft = ::Math.max(1, this.m.StartingTurnsLeft + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
	}

	function onUpdate( _properties )
	{
		_properties.MovementAPCostAdditional += this.m.MovementAPCostAdditional;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft == 0)
		{
			this.removeSelf();
		}
	}

});
