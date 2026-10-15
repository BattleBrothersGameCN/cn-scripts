this.rf_undead_injury_receiver <- ::inherit("scripts/skills/skill", {
	m = {
		ThresholdToReceiveInjuryMult = 1.33
	},
	function create()
	{
		this.m.ID = "special.rf_undead_injury_receiver";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Type = ::Const.SkillType.Special;
		this.m.Order = ::Const.SkillOrder.Trait;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onUpdate( _properties )
	{
		_properties.ThresholdToReceiveInjuryMult *= this.m.ThresholdToReceiveInjuryMult;
		_properties.IsAffectedByInjuries = true;
		_properties.IsAffectedByFreshInjuries = true;
	}

	function onQueryTooltip( _skill, _tooltip )
	{
		switch(_skill.getID())
		{
		case "racial.rf_zombie":
		case "racial.skeleton":
			local idx;

			foreach( i, entry in _tooltip )
			{
				if (entry.id == 21)
				{
					if (this.m.ThresholdToReceiveInjuryMult == 1.0)
					{
						_tooltip.remove(i);
					}
					else
					{
						entry.text = ::Reforged.Mod.Tooltips.parseString(this.format("[创伤|Concept.InjuryTemporary][阈值|Concept.InjuryThreshold]%s", ::MSU.Text.colorizeMultWithText(this.m.ThresholdToReceiveInjuryMult, {
							Text = [
								"提高",
								"降低"
							]
						})));
					}

					break;
				}
			}

			break;
		}
	}

});
