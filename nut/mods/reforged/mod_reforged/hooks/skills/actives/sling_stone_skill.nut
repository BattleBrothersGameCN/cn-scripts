::Reforged.HooksMod.hook("scripts/skills/actives/sling_stone_skill", function ( q )
{
	q.m.AdditionalAccuracy = 0;
	q.m.AdditionalHitChance = -5;
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getRangedTooltip(this.skill.getDefaultTooltip());
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("命中目标头部时，有" + ::MSU.Text.colorNegative("100%") + "几率使目标[$ $|Skill+dazed_effect]")
				});

				if (this.getContainer().getActor().isEngagedInMelee())
				{
					ret.push({
						id = 9,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("角色[陷入近战|Concept.ZoneOfControl]，无法使用"))
					});
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onAfterUpdate = function ( __original )
	{
		return {
			function onAfterUpdate( _properties )
			{
				local additionalAccuracy = this.m.AdditionalAccuracy;
				__original(_properties);
				this.m.AdditionalAccuracy = additionalAccuracy;
			}

		}.onAfterUpdate;
	};
	q.onAnySkillUsed = function ()
	{
		return {
			function onAnySkillUsed( _skill, _targetEntity, _properties )
			{
				if (_skill == this)
				{
					_properties.RangedSkill += this.m.AdditionalAccuracy;
					_properties.HitChanceAdditionalWithEachTile += this.m.AdditionalHitChance;
				}
			}

		}.onAnySkillUsed;
	};
});
