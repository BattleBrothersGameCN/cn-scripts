::Reforged.HooksMod.hook("scripts/skills/effects/fake_charmed_effect", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "神魂颠倒";
				this.m.Description = "该角色被迷得神魂颠倒。失去了自持能力，彻底成为了傀儡，对其主人唯命是从。";
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
					icon = "ui/icons/bravery.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+20") + "[决心|Concept.Bravery]")
				});
				return ret;
			}

		}.getTooltip;
	};
});
