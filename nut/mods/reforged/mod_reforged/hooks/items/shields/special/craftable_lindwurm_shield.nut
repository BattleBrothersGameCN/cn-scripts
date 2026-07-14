::Reforged.HooksMod.hook("scripts/items/shields/special/craftable_lindwurm_shield", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Condition = 200;
				this.m.ConditionMax = 200;
				this.m.Description = "这面盾牌用林德蠕龙的闪亮鳞片制成，堪称轻巧灵便，坚不可摧。";
				this.m.StaminaModifier = -8;
				this.m.MeleeDefense = 20;
				this.m.RangedDefense = 20;
				this.m.ReachIgnore = 3;
			}

		}.create;
	};
});
