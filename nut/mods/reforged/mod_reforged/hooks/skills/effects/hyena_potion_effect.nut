::Reforged.HooksMod.hook("scripts/skills/effects/hyena_potion_effect", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( entry in ret )
				{
					if (entry.id == 11)
					{
						entry.text = ::Reforged.Mod.Tooltips.parseString("[$ $|Skill+bleeding_effect]状态的效果" + ::MSU.Text.colorPositive("减半"));
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
				__original(_properties);
				_properties.RF_BleedingEffectMult *= 0.5;
			}

		}.onUpdate;
	};
});
