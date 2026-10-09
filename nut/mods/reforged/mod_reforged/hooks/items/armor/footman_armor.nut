::Reforged.HooksMod.hook("scripts/items/armor/footman_armor", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "A transitional armor consisting of a long mail shirt and a riveted leather gambeson.";
			}

		}.create;
	};
});
