this.rf_numbness_effect <- ::inherit("scripts/skills/skill", {
	m = {
		DamageTotalMult = 0.75,
		TurnsLeft = 1
	},
	function create()
	{
		this.m.ID = "effects.rf_numbness";
		this.m.Name = "麻木";
		this.m.Description = "该角色四肢麻木";
		this.m.Icon = "skills/rf_numbness_effect.png";
		this.m.IconMini = "rf_numbness_effect_mini";
		this.m.Overlay = "rf_numbness_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.DamageTotalMult) + " damage inflicted")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("会在" + this.m.TurnsLeft + "[回合|Concept.Turn]后消退")
		});
		return ret;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local warmth = actor.getSkills().getSkillByID("effects.rf_warmth_potion");

		if (warmth != null)
		{
			this.removeSelf();
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " resists being numbed thanks to " + warmth.getName());
			return;
		}

		if (actor.getCurrentProperties().IsResistantToAnyStatuses && ::Math.rand(1, 100) <= 50)
		{
			if (!actor.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + "靠其非自然的生理机能免于麻木");
			}

			this.removeSelf();
			return;
		}

		if (actor.isTurnStarted())
		{
			this.m.TurnsLeft++;
		}

		this.m.TurnsLeft = ::Math.max(1, this.m.TurnsLeft + actor.getCurrentProperties().NegativeStatusEffectDuration);
	}

	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= this.m.DamageTotalMult;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft == 0)
		{
			this.removeSelf();
		}
	}

});
