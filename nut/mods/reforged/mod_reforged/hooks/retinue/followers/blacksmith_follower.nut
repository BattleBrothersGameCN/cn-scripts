::Reforged.HooksMod.hook("scripts/retinue/followers/blacksmith_follower", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Effects[0] = ::MSU.String.replace(this.m.Effects[0], ", weapons", "");
			}

		}.create;
	};
});
