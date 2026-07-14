::Reforged.HooksMod.hook("scripts/skills/actives/merge_golem_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "汇集周围的活沙，让石头长得更大！";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getDefaultUtilityTooltip();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("完全恢复所有[生命值|Concept.Hitpoints]")
				});
				local entityType = ::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()) ? ::Const.EntityType.SandGolem : this.getContainer().getActor().getType();
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("消耗2个相邻" + ::Const.Strings.EntityNamePlural[entityType] + "，使你[长得更大|Skill+golem_racial]")
				});
				return ret;
			}

		}.getTooltip;
	};
});
