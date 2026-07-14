::Reforged.HooksMod.hook("scripts/skills/effects/spearwall_effect", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();
				local crowded = this.getContainer().getSkillByID("special.rf_polearm_adjacency");

				if (crowded != null)
				{
					ret.push({
						id = 10,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString(this.format("在非自己[回合|Concept.Turn]内进行的攻击不会受到%s影响", ::Reforged.NestedTooltips.getNestedSkillName(crowded)))
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

				if (::Tactical.isActive() && !::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
				{
					local crowded = this.getContainer().getSkillByID("special.rf_polearm_adjacency");

					if (crowded != null)
					{
						crowded.m.NumEnemiesToIgnore = 99;
						crowded.m.NumAlliesToIgnore = 99;
					}
				}
			}

		}.onUpdate;
	};
});
