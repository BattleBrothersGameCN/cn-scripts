::Reforged.HooksMod.hook("scripts/items/helmets/sallet_helmet", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "Open Faced Sallet Helmet";
				this.m.Value = 1500;
				this.m.Condition = 125;
				this.m.ConditionMax = 125;
			}

		}.create;
	};
});
