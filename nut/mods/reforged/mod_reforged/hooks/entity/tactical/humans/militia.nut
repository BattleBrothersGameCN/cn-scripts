::Reforged.HooksMod.hook("scripts/entity/tactical/humans/militia", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.Militia);
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_militia");
				this.getSprite("accessory_special").setBrush("bust_militia_band_01");
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_strength_in_numbers"));
			}

		}.onInit;
	};
	q.onSpawned = function ()
	{
		return {
			function onSpawned()
			{
				local mainhandItem = this.getMainhandItem();

				if (mainhandItem != null)
				{
					if (mainhandItem.isWeaponType(::Const.Items.WeaponType.Mace) && mainhandItem.isWeaponType(::Const.Items.WeaponType.Spear))
					{
						::Reforged.Skills.addPerkGroup(this, "pg.rf_spear", 3);
					}
					else
					{
						::Reforged.Skills.addPerkGroupOfEquippedWeapon(this, 3);
					}
				}

				if (this.isArmedWithShield())
				{
					this.m.Skills.add(::new("scripts/skills/perks/perk_rf_phalanx"));
				}
			}

		}.onSpawned;
	};
});
