::Reforged.HooksMod.hook("scripts/items/shields/oriental/metal_round_shield", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "Sipar";
				this.m.Condition = 300;
				this.m.ConditionMax = 300;
				this.m.MeleeDefense = 25;
				this.m.RangedDefense = 10;
				this.m.StaminaModifier = -22;
				this.m.ReachIgnore = 3;
			}

		}.create;
	};
});
