::Reforged.HooksMod.hook("scripts/skills/effects/possessing_undead_effect", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "该角色通过秘法直接控制了一头僵尸";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();

				if (!::MSU.isNull(this.m.Possessed) && this.m.Possessed.isAlive())
				{
					ret.push({
						id = 10,
						type = "text",
						icon = ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedEntityImage(this.m.Possessed)),
						text = "正在支配" + ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedEntityName(this.m.Possessed))
					});
				}

				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/warning.png",
					text = ::Reforged.Mod.Tooltips.parseString("会在受到" + ::MSU.Text.colorDamage(::Const.Combat.InjuryMinDamage) + "点[生命值伤害|Concept.Hitpoints]或被支配的角色死亡后失效")
				});
				return ret;
			}

		}.getTooltip;
	};
});
