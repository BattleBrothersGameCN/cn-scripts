::Reforged.HooksMod.hook("scripts/skills/effects/smoke_effect", function ( q )
{
	q.m.RangedDefenseBonus <- 30;
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( entry in ret )
				{
					if (entry.id == 12 && entry.icon == "ui/icons/ranged_defense.png")
					{
						entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+" + this.m.RangedDefenseBonus) + "[远程防御|Concept.RangeDefense]");
						break;
					}
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onUpdate = function ( __original )
	{
		return {
			function onUpdate( _properties )
			{
				local oldRangedDefenseMult = _properties.RangedDefenseMult;
				__original(_properties);
				_properties.RangedDefenseMult = oldRangedDefenseMult;

				if (this.isGarbage() == true)
				{
					return;
				}

				_properties.RangedDefense += this.m.RangedDefenseBonus;
			}

		}.onUpdate;
	};
});
