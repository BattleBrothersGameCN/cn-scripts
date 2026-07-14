::Reforged.HooksMod.hook("scripts/skills/effects/hex_master_effect", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "该角色诅咒了一名受害者，使其遭受施加到自己身上的所有痛苦 ———— 一种对怀有敌意者的强大威慑。";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getDefaultUtilityTooltip();

				if (!::MSU.isNull(this.m.Slave) && !::MSU.isNull(this.m.Slave.getContainer()))
				{
					local victim = this.m.Slave.getContainer().getActor();

					if (this.m.Slave.isAlive())
					{
						ret.push({
							id = 10,
							type = "text",
							icon = ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedEntityImage(victim)),
							text = "受害者：" + ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedEntityName(victim))
						});
					}
				}

				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("受到的所有[生命值|Concept.Hitpoints]伤害同时会被全额施加给受害者")
				});
				ret.push({
					id = 20,
					type = "text",
					icon = "ui/icons/warning.png",
					text = ::Reforged.Mod.Tooltips.parseString("会在" + ::MSU.Text.colorNegative(this.m.TurnsLeft) + "[回合|Concept.Turn]后失效")
				});
				return ret;
			}

		}.getTooltip;
	};
});
