::Reforged.HooksMod.hook("scripts/skills/actives/web_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "向目标撒出蛛网，将其困在原地，限制其自我保护和全力攻击的能力。";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getDefaultUtilityTooltip();
				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("目标变为[$ $|Skill+web_effect]")
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("每" + ::MSU.Text.colorNegative(3) + "回合限用一次。")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
});
