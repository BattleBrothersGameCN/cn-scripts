::Reforged.HooksMod.hook("scripts/skills/traits/bleeder_trait", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "这个角色容易流血，而且出血量比大多数人更多。";
			}

		}.create;
	};
	q.onUpdate = function ( __original )
	{
		return {
			function onUpdate( _properties )
			{
				__original(_properties);
				_properties.RF_BleedingEffectMult *= 2.0;
			}

		}.onUpdate;
	};
	q.getPerkGroupMultiplier = function ()
	{
		return {
			function getPerkGroupMultiplier( _groupID, _perkTree )
			{
				if (_groupID == "pg.rf_vigorous")
				{
					return 0;
				}
			}

		}.getPerkGroupMultiplier;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( entry in ret )
				{
					if (entry.id == 10)
					{
						entry.text = ::Reforged.Mod.Tooltips.parseString("[流血|Skill+bleeding_effect]的效果" + ::MSU.Text.colorNegative("加倍"));
						break;
					}
				}

				return ret;
			}

		}.getTooltip;
	};
});
