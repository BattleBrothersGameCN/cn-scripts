::Reforged.HooksMod.hook("scripts/retinue/followers/drill_sergeant_follower", function ( q )
{
	q.create = function ( __original )
	{
		return function ()
		{
			__original();
			this.m.Effects[0] = "使你的人获得更多的经验，1级时为40%，每提高一级就减少4%";
			this.m.Requirements.clear();
		};
	};
	q.onEvaluate = function ()
	{
		return {
			function onEvaluate()
			{
			}

		}.onEvaluate;
	};
});
