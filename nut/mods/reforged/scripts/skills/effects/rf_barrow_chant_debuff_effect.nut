this.rf_barrow_chant_debuff_effect <- ::inherit("scripts/skills/skill", {
	m = {
		DamageMultPerMoraleStateAdd = -0.15
	},
	function create()
	{
		this.m.ID = "effects.rf_barrow_chant_debuff";
		this.m.Name = "墓穴挽歌萦绕";
		this.m.Icon = "ui/perks/perk_32.png";
		this.m.Description = "该角色的耳中回荡着充满恐惧的挽歌。";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function isHidden()
	{
		return this.getContainer().getActor().getMoraleState() == ::Const.MoraleState.Ignore;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("不能[自信|Concept.Morale]")
		});

		if (this.m.DamageMultPerMoraleStateAdd != 0.0)
		{
			if (::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
			{
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = ::Reforged.Mod.Tooltips.parseString("造成的伤害" + ::MSU.Text.colorizeMultWithText(1.0 + this.m.DamageMultPerMoraleStateAdd) + " damage per [morale|Concept.Morale] state below Confident")
				});
			}
			else
			{
				local damageMult = this.getDamageMult();

				if (damageMult != 1.0)
				{
					ret.push({
						id = 11,
						type = "text",
						icon = "ui/icons/regular_damage.png",
						text = ::Reforged.Mod.Tooltips.parseString("造成的伤害" + ::MSU.Text.colorizeMultWithText(damageMult) + " damage")
					});
				}
			}
		}

		return ret;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();

		if (actor.getMoraleState() == ::Const.MoraleState.Confident)
		{
			local newState = ::Const.MoraleState.Confident - 1;

			while (actor.getCurrentProperties().MV_ForbiddenMoraleStates.find(newState) != null)
			{
				newState = --newState;

				if (newState == ::Const.MoraleState.Fleeing + 1)
				{
					break;
				}
			}

			actor.setMoraleState(newState);
		}
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().getMoraleState() != ::Const.MoraleState.Ignore)
		{
			_properties.MV_ForbiddenMoraleStates.push(::Const.MoraleState.Confident);
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		_properties.DamageTotalMult *= this.getDamageMult();
	}

	function getDamageMult()
	{
		return ::Math.maxf(0.0, 1.0 + this.m.DamageMultPerMoraleStateAdd * (::Const.MoraleState.Confident - this.getContainer().getActor().getMoraleState()));
	}

});
