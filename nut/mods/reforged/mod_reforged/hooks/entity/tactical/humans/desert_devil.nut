::Reforged.HooksMod.hook("scripts/entity/tactical/humans/desert_devil", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.DesertDevil);
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_nomads");
				this.m.Skills.add(::new("scripts/skills/perks/perk_battle_flow"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_overwhelm"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
				this.m.Skills.add(::new("scripts/skills/actives/throw_dirt_skill"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_footwork"));
				this.m.Skills.add(::Reforged.new("scripts/skills/perks/perk_rf_passing_step", function ( o )
				{
					o.m.RequiredDamageType = null;
					o.m.RequiredWeaponType = null;
					o.m.RequireOffhandFree = false;
				}));
				this.m.Skills.add(::new("scripts/skills/perks/perk_relentless"));
			}

		}.onInit;
	};
	q.assignRandomEquipment = function ()
	{
		return {
			function assignRandomEquipment()
			{
				if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Mainhand))
				{
					local weapons = ::MSU.Class.WeightedContainer([
						[
							2,
							"scripts/items/weapons/shamshir"
						]
					]);

					if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Offhand))
					{
						weapons.addArray([
							[
								1,
								"scripts/items/weapons/oriental/swordlance"
							],
							[
								1,
								"scripts/items/weapons/rf_voulge"
							]
						]);
					}

					this.m.Items.equip(::new(weapons.roll()));
				}

				if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Offhand))
				{
					this.m.Items.equip(::new("scripts/items/shields/oriental/southern_light_shield"));
				}

				if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Body))
				{
					local armor = ::MSU.Class.WeightedContainer([
						[
							1,
							"scripts/items/armor/oriental/assassin_robe"
						],
						[
							1,
							"scripts/items/armor/leather_scale_armor"
						]
					]).roll();
					this.m.Items.equip(::new(armor));
				}

				if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Head))
				{
					this.m.Items.equip(::new("scripts/items/helmets/oriental/blade_dancer_head_wrap"));
				}
			}

		}.assignRandomEquipment;
	};
	q.makeMiniboss = function ()
	{
		return {
			function makeMiniboss()
			{
				if (!this.actor.makeMiniboss())
				{
					return false;
				}

				this.getSprite("miniboss").setBrush("bust_miniboss");

				if (::Math.rand(1, 100) <= 75)
				{
					if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Mainhand))
					{
						local weapon = ::MSU.Class.WeightedContainer([
							[
								2,
								"scripts/items/weapons/named/named_shamshir"
							],
							[
								1,
								"scripts/items/weapons/named/named_swordlance"
							],
							[
								1,
								"scripts/items/weapons/named/named_rf_voulge"
							]
						]).roll();
						this.m.Items.equip(::new(weapon));
					}
				}
				else if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Body))
				{
					this.m.Items.equip(::new("scripts/items/armor/named/black_leather_armor"));
				}

				return true;
			}

		}.makeMiniboss;
	};
	q.onSpawned = function ()
	{
		return {
			function onSpawned()
			{
				local mainhandItem = this.getMainhandItem();

				if (mainhandItem != null)
				{
					if (mainhandItem.isWeaponType(::Const.Items.WeaponType.Cleaver))
					{
						::Reforged.Skills.addPerkGroupOfEquippedWeapon(this);
						this.m.Skills.add(::new("scripts/skills/perks/perk_mastery_polearm"));
						this.m.Skills.add(::new("scripts/skills/perks/perk_rf_combo"));
					}
					else if (mainhandItem.isWeaponType(::Const.Items.WeaponType.Polearm))
					{
						::Reforged.Skills.addPerkGroupOfEquippedWeapon(this, 4);
						this.m.Skills.add(::new("scripts/skills/perks/perk_rf_finesse"));
						this.m.Skills.add(::new("scripts/skills/perks/perk_rf_sweeping_strikes"));
					}
					else if (mainhandItem.isWeaponType(::Const.Items.WeaponType.Sword))
					{
						::Reforged.Skills.addPerkGroupOfEquippedWeapon(this);
						this.m.Skills.add(::new("scripts/skills/perks/perk_duelist"));
					}

					if (this.m.IsMiniboss)
					{
						if (mainhandItem.isWeaponType(::Const.Items.WeaponType.Cleaver))
						{
							this.m.Skills.add(::new("scripts/skills/perks/perk_fearsome"));
						}
						else if (mainhandItem.isWeaponType(::Const.Items.WeaponType.Polearm))
						{
							this.m.Skills.add(::new("scripts/skills/perks/perk_rf_death_dealer"));
						}
						else if (mainhandItem.isWeaponType(::Const.Items.WeaponType.Sword))
						{
							this.m.Skills.add(::new("scripts/skills/perks/perk_rf_swordmaster_blade_dancer"));
						}
					}
				}
			}

		}.onSpawned;
	};
});
