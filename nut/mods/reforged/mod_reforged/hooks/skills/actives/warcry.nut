::Reforged.HooksMod.hook("scripts/skills/actives/warcry", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Icon = "skills/active_49.png";
				this.m.IconDisabled = "skills/active_49_sw.png";
				this.m.Description = ::Reforged.Mod.Tooltips.parseString("丹田发力，放声怒吼，鼓舞盟友[士气|Concept.Morale]，让敌人[三思而后行|Concept.Morale]！");
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getDefaultUtilityTooltip();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("使所有盟友和敌人相应接受正面或负面[士气检定|Concept.Morale]，距离越近，检定越强")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = ::Reforged.Mod.Tooltips.parseString("战场上所有盟友恢复" + ::MSU.Text.colorPositive(20) + "点[疲劳值|Concept.Fatigue]")
				});
				return ret;
			}

		}.getTooltip;
	};
});
