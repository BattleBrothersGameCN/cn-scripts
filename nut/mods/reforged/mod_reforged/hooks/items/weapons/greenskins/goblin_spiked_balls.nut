::Reforged.HooksMod.hook("scripts/items/weapons/greenskins/goblin_spiked_balls", function ( q )
{
	q.m.IconLargeFull <- "weapons/ranged/goblin_weapon_07.png";
	q.m.IconFull <- "weapons/ranged/goblin_weapon_07_70x70.png";
	q.m.IconLargeEmpty <- "weapons/ranged/rf_goblin_weapon_07_empty.png";
	q.m.IconEmpty <- "weapons/ranged/rf_goblin_weapon_07_empty_70x70.png";
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Reach = 0;
			}

		}.create;
	};
	q.setAmmo = function ( __original )
	{
		return {
			function setAmmo( _a )
			{
				__original(_a);

				if (this.m.Ammo > 0)
				{
					this.m.Name = "一袋流星锤";
					this.m.IconLarge = this.m.IconLargeFull;
					this.m.Icon = this.m.IconFull;
				}
				else
				{
					this.m.Name = "一袋流星锤(空)";
					this.m.IconLarge = this.m.IconLargeEmpty;
					this.m.Icon = this.m.IconEmpty;
				}

				this.updateAppearance();
			}

		}.setAmmo;
	};
});
