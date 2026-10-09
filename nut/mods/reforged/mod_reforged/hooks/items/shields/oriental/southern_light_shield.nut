::Reforged.HooksMod.hook("scripts/items/shields/oriental/southern_light_shield", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "Adarga";
				this.m.StaminaModifier = -8;
				this.m.Condition = 40;
				this.m.ConditionMax = 40;
			}

		}.create;
	};
});
