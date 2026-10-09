::Reforged.HooksMod.hook("scripts/skills/actives/load_mortar_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "为接邻的臼炮装填一颗大型炮弹。";
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
					id = 20,
					type = "text",
					icon = "ui/icons/warning.png",
					text = ::Reforged.Mod.Tooltips.parseString("每" + ::MSU.Text.colorNegative(this.m.Cooldown) + "[回合|Concept.Turn]限一次")
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
