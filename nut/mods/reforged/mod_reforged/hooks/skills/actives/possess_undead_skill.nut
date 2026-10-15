::Reforged.HooksMod.hook("scripts/skills/actives/possess_undead_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "集中在一头僵尸身上，让他获得巨额加成！";
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
					icon = "ui/icons/warning.png",
					text = ::Reforged.Mod.Tooltips.parseString("获得[支配亡灵|Skill+possessing_undead_effect]效果，使目标获得[被支配|Skill+possessed_undead_effect]效果")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "技能范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
				});

				if (this.getContainer().getActor().isEngagedInMelee())
				{
					ret.push({
						id = 21,
						type = "text",
						icon = "ui/icons/warning.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("角色[陷入近战|Concept.ZoneOfControl]，无法使用"))
					});
				}

				return ret;
			}

		}.getTooltip;
	};
});
