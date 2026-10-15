::Reforged.HooksMod.hook("scripts/skills/racial/flesh_golem_racial", function ( q )
{
	q.m.InjuryThresholdMult <- 0.7;
	q.m.MovementAPCostModifier <- 2;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "血肉魔像";
				this.m.Icon = "ui/orientation/flesh_golem_orientation.png";
				this.m.IsHidden = false;

				if (this.isType(::Const.SkillType.Perk))
				{
					this.removeType(::Const.SkillType.Perk);
				}
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();
				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/asset_medicine.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.InjuryThresholdMult) + " [Injury Threshold|Concept.InjuryThreshold]")
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/action_points.png",
						text = "每格移动消耗的[行动点数|Concept.ActionPoints]" + ::MSU.Text.colorizeValue(this.m.MovementAPCostModifier, {
							AddSign = true,
							InvertColor = true
						}) + ::Reforged.Mod.Tooltips.parseString(" [Action Points|Concept.ActionPoints] per tile")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
	q.onUpdate = function ()
	{
		return {
			function onUpdate( _properties )
			{
				_properties.ThresholdToReceiveInjuryMult *= this.m.InjuryThresholdMult;
				_properties.MovementAPCostAdditional += this.m.MovementAPCostModifier;
			}

		}.onUpdate;
	};
});
