::Reforged.HooksMod.hook("scripts/skills/actives/root_skill", function ( q )
{
	q.m.Cooldown <- 0;
	q.m.TurnsRemaining <- 0;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "从地上升起粗壮的藤蔓，将敌人固定在原地，限制其自我保护和移动能力";
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
					text = ::Reforged.Mod.Tooltips.parseString("对目标和相邻敌人施加[$ $|Skill+rooted_effect]效果")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "技能范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
				});
				return ret;
			}

		}.getTooltip;
	};
	q.onUse = function ( __original )
	{
		return {
			function onUse( _user, _targetTile )
			{
				this.m.TurnsRemaining = this.m.Cooldown;
				return __original(_user, _targetTile);
			}

		}.onUse;
	};
	q.isUsable = function ()
	{
		return {
			function isUsable()
			{
				return this.skill.isUsable() && this.m.TurnsRemaining == 0;
			}

		}.isUsable;
	};
	q.onTurnEnd = function ()
	{
		return {
			function onTurnEnd()
			{
				this.m.TurnsRemaining = ::Math.max(0, this.m.TurnsRemaining - 1);
			}

		}.onTurnEnd;
	};
});
