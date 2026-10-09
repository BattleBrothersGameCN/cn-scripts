::Reforged.HooksMod.hook("scripts/items/shields/special/craftable_kraken_shield", function ( q )
{
	q.m.ThreatModifier <- 10;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Condition = 220;
				this.m.ConditionMax = 220;
				this.m.ReachIgnore = 3;
			}

		}.create;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				if (this.m.ThreatModifier != 0)
				{
					ret.push({
						id = 10,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("使接邻敌人在[士气检定|Concept.Morale]中的[决心|Concept.Bravery]降低" + ::MSU.Text.colorNegative(10) + "点，用于[士气检定|Concept.Morale]")
					});
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onUpdateProperties = function ( __original )
	{
		return {
			function onUpdateProperties( _properties )
			{
				__original(_properties);
				_properties.Threat += this.m.ThreatModifier;
			}

		}.onUpdateProperties;
	};
});
