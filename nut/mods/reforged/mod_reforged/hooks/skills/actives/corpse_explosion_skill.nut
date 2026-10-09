::Reforged.HooksMod.hook("scripts/skills/actives/corpse_explosion_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = ::Reforged.Mod.Tooltips.parseString("引爆一具尸体或一处血肉摇篮，骇人的爆炸会将其破坏。冲击波会对任何站在尸体上的目标及其相邻敌人造成伤害，并在受影响的地格上留下挥之不去的瘴气。");
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
					icon = "ui/icons/vision.png",
					text = "技能范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
				});
				return ret;
			}

		}.getTooltip;
	};
});
