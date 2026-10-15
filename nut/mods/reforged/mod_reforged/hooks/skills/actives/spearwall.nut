::Reforged.HooksMod.hook("scripts/skills/actives/spearwall", function ( q )
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
						text = ::Reforged.Mod.Tooltips.parseString(this.format("你[回合|Concept.Turn]外的攻击不受%s影响", ::Reforged.NestedTooltips.getNestedSkillName(crowded)))
					});
				}

				return ret;
			}

		}.getTooltip;
	};
});
