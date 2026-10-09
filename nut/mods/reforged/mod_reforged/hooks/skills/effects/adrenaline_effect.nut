::Reforged.HooksMod.hook("scripts/skills/effects/adrenaline_effect", function ( q )
{
	q.m.GrantsInjuryImmunity <- true;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Order = ::Const.SkillOrder.TemporaryInjury - 100;
			}

		}.create;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				if (this.m.GrantsInjuryImmunity)
				{
					ret.push({
						id = 11,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("不会受到[临时创伤|Concept.InjuryTemporary]，也不会被其影响。")
					});
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

				if (this.m.TurnsLeft != 0 && this.m.GrantsInjuryImmunity)
				{
					_properties.IsAffectedByInjuries = false;
				}
			}

		}.onUpdate;
	};
});
