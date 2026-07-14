::Reforged.HooksMod.hook("scripts/skills/actives/slash", function ( q )
{
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
});
