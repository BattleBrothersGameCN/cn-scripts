::Reforged.HooksMod.hook("scripts/entity/tactical/enemies/goblin_fighter", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.goblin.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.GoblinFighter);
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
				this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
				this.getSprite("head").setBrush("bust_goblin_01_head_0" + ::Math.rand(1, 3));
				this.addDefaultStatusSprites();
				this.m.Skills.add(::new("scripts/skills/perks/perk_backstabber"));
				this.m.Skills.add(::Reforged.new("scripts/skills/perks/perk_rf_passing_step", function ( o )
				{
					o.m.RequiredDamageType = null;
					o.m.RequiredWeaponType = null;
					o.m.RequireOffhandFree = false;
				}));
			}

		}.onInit;
	};
	q.onSpawned = function ( __original )
	{
		return {
			function onSpawned()
			{
				__original();
				local weapon = this.getMainhandItem();

				if (weapon != null)
				{
					if (weapon.isItemType(::Const.Items.ItemType.OneHanded))
					{
						::Reforged.Skills.addPerkGroupOfEquippedWeapon(this, 4);
					}
					else
					{
						::Reforged.Skills.addPerkGroupOfEquippedWeapon(this, 3);
						this.m.Skills.add(::new("scripts/skills/perks/perk_crippling_strikes"));
					}
				}

				foreach( item in this.m.Items.getAllItemsAtSlot(::Const.ItemSlot.Bag) )
				{
					if (item.isItemType(::Const.Items.ItemType.Weapon) && item.isWeaponType(::Const.Items.WeaponType.Throwing))
					{
						this.m.Skills.add(::new("scripts/skills/perks/perk_mastery_throwing"));
						break;
					}
				}
			}

		}.onSpawned;
	};
	q.makeMiniboss = function ( __original )
	{
		return {
			function makeMiniboss()
			{
				local ret = __original();

				if (ret)
				{
					this.m.Skills.removeByID("perk.nine_lives");
					::Reforged.Skills.addPerkGroupOfEquippedWeapon(this);
					this.m.Skills.add(::new("scripts/skills/perks/perk_duelist"));
				}

				return ret;
			}

		}.makeMiniboss;
	};
});
