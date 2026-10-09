::Reforged.HooksMod.hook("scripts/items/weapons/greatsword", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "双手剑";
				this.m.StaminaModifier = -14;
				this.m.Reach = 7;
			}

		}.create;
	};
	q.onEquip = function ()
	{
		return {
			function onEquip()
			{
				this.weapon.onEquip();
				this.addSkill(::Reforged.new("scripts/skills/actives/overhead_strike"));
				this.addSkill(::Reforged.new("scripts/skills/actives/split"));
				this.addSkill(::Reforged.new("scripts/skills/actives/swing"));
				this.addSkill(::Reforged.new("scripts/skills/actives/split_shield", function ( o )
				{
					o.m.FatigueCost += 5;
				}));
			}

		}.onEquip;
	};
});
