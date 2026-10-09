::Reforged.HooksMod.hook("scripts/skills/actives/gash_skill", function ( q )
{
	q.m.BleedStacks <- 3;
	q.m.MeleeSkillAdd <- 5;
	q.softReset = function ( __original )
	{
		return {
			function softReset()
			{
				__original();
				this.resetField("IsIgnoredAsAOO");
			}

		}.softReset;
	};
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.AIBehaviorID = ::Const.AI.Behavior.ID.Gash;
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getDefaultTooltip();

				if (this.m.MeleeSkillAdd != 0)
				{
					ret.push({
						id = 6,
						type = "text",
						icon = "ui/icons/hitchance.png",
						text = "命中率提高" + ::MSU.Text.colorizeValue(this.m.MeleeSkillAdd, {
							AddSign = true,
							AddPercent = true
						}) + " chance to hit"
					});
				}

				if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInSwords)
				{
					ret.push({
						id = 6,
						type = "text",
						icon = "ui/icons/hitchance.png",
						text = ::Reforged.Mod.Tooltips.parseString("造成[创伤|Concept.InjuryTemporary]的[阈值|Concept.InjuryThreshold]降低" + ::MSU.Text.colorNegative("50%") + " lower [threshold|Concept.InjuryThreshold] to inflict [injuries|Concept.InjuryTemporary]")
					});
				}
				else
				{
					ret.push({
						id = 6,
						type = "text",
						icon = "ui/icons/hitchance.png",
						text = ::Reforged.Mod.Tooltips.parseString("造成[创伤|Concept.InjuryTemporary]的[阈值|Concept.InjuryThreshold]降低" + ::MSU.Text.colorNegative("33%") + " lower [threshold|Concept.InjuryThreshold] to inflict [injuries|Concept.InjuryTemporary]")
					});
				}

				if (this.m.BleedStacks != 0)
				{
					ret.push({
						id = 7,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("造成的伤害超过" + ::MSU.Text.colorPositive(this.m.BleedStacks) + "层[$ $|Skill+bleeding_effect]，若造成至少" + ::MSU.Text.color(::Const.UI.Color.DamageValue, ::Const.Combat.MinDamageToApplyBleeding) + "层[$ $|Skill+bleeding_effect]效果")
					});
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onAnySkillUsed = function ()
	{
		return {
			function onAnySkillUsed( _skill, _targetEntity, _properties )
			{
				if (_skill == this)
				{
					_properties.MeleeSkill += this.m.MeleeSkillAdd;
				}
			}

		}.onAnySkillUsed;
	};
	q.onTargetHit = function ( __original )
	{
		return {
			function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

				if (_skill == this && _targetEntity.isAlive() && _damageInflictedHitpoints >= ::Const.Combat.MinDamageToApplyBleeding && !_targetEntity.getCurrentProperties().IsImmuneToBleeding)
				{
					for( local i = 0; i < this.m.BleedStacks; i++ )
					{
						_targetEntity.getSkills().add(::new("scripts/skills/effects/bleeding_effect"));
					}
				}
			}

		}.onTargetHit;
	};
});
