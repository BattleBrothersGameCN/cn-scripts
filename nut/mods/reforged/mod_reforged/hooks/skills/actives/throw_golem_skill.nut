::Reforged.HooksMod.hook("scripts/skills/actives/throw_golem_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "将沙石化作巨石投向目标，分裂自身变成更小的活石碎块！";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getDefaultTooltip();
				local entityType = ::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()) ? ::Const.EntityType.SandGolem : this.getContainer().getActor().getType();
				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/special.png",
						text = this.format("在目标旁边生成%s%s", ::Const.Strings.getArticle(::Const.Strings.EntityName[entityType]), ::Const.Strings.EntityName[entityType])
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("缩小一个等级，在自身旁边生成两个" + ::Const.Strings.EntityNamePlural[entityType] + " of this size adjacent to you")
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/vision.png",
						text = "技能范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
});
