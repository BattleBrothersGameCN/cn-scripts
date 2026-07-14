::Reforged.HooksMod.hook("scripts/skills/actives/rupture", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( entry in ret )
				{
					if (entry.id == 8)
					{
						entry.text = ::Reforged.Mod.Tooltips.parseString("当造成至少[$ $|Skill+bleeding_effect]时" + ::MSU.Text.colorDamage(::Const.Combat.MinDamageToApplyBleeding) + "点[生命值|Concept.Hitpoints]伤害时，施加[$ $|Skill+bleeding_effect]效果");
						break;
					}
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onAfterUpdate = function ()
	{
		return {
			function onAfterUpdate( _properties )
			{
				if (_properties.IsSpecializedInPolearms)
				{
					this.m.FatigueCostMult *= ::Const.Combat.WeaponSpecFatigueMult;
				}
			}

		}.onAfterUpdate;
	};
});
