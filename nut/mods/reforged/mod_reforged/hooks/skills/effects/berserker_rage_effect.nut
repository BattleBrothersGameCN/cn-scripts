::Reforged.HooksMod.hook("scripts/skills/effects/berserker_rage_effect", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "该角色正处于狂战士狂怒当中。";
			}

		}.create;
	};
	q.getDescription = function ( __original )
	{
		return {
			function getDescription()
			{
				return this.skill.getDescription();
			}

		}.getDescription;
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
						icon = "ui/icons/special.png",
						text = "受到的所有伤害降低" + ::MSU.Text.colorNegative(100.0 - this.calcDamageTakenMult() * 100.0 + "%")
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/regular_damage.png",
						text = ::MSU.Text.colorPositive("+" + this.m.RageStacks) + "伤害"
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+" + this.m.RageStacks) + " [决心|Concept.Bravery]")
					},
					{
						id = 13,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+" + this.m.RageStacks) + " [主动值|Concept.Initiative]")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
	q.calcDamageTakenMult <- {
		function calcDamageTakenMult()
		{
			return ::Math.maxf(0.3, 1.0 - 0.02 * this.m.RageStacks);
		}

	}.calcDamageTakenMult;
});
