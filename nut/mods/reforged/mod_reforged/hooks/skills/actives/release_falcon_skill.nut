::Reforged.HooksMod.hook("scripts/skills/actives/release_falcon_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Order = ::Const.SkillOrder.BeforeLast + 5;
			}

		}.create;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();
				local effect = ::new("scripts/skills/effects/rf_falcon_released_effect");
				effect.m.Container = ::MSU.getDummyPlayer().getSkills();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString(this.format("所有未被[$ $|Skill+stunned_effect]、定身或正在[溃逃|Concept.Morale]的盟友获得%s效果", ::Reforged.NestedTooltips.getNestedSkillName(effect))),
					children = effect.getTooltip().slice(2)
				});
				effect.m.Container = null;
				return ret;
			}

		}.getTooltip;
	};
	q.onUse = function ( __original )
	{
		return {
			function onUse( _user, _targetTile )
			{
				local ret = __original(_user, _targetTile);

				if (ret)
				{
					foreach( ally in ::Tactical.Entities.getAlliedActors(_user.getFaction()) )
					{
						if (ally.getCurrentProperties().IsStunned || ally.getCurrentProperties().IsRooted || ally.getMoraleState() == ::Const.MoraleState.Fleeing)
						{
							continue;
						}

						ally.getSkills().add(::new("scripts/skills/effects/rf_falcon_released_effect"));
					}
				}

				return ret;
			}

		}.onUse;
	};
});
