::Reforged.HooksMod.hook("scripts/entity/tactical/humans/mercenary_ranged", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.MercenaryRanged);
				b.TargetAttractionMult = 1.1;
				b.Vision = 8;
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_militia");
				this.m.Skills.add(::new("scripts/skills/perks/perk_bullseye"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_crippling_strikes"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_coup_de_grace"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_fast_adaption"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_overwhelm"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_footwork"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_through_the_ranks"));
			}

		}.onInit;
	};
	q.assignRandomEquipment = function ( __original )
	{
		return {
			function assignRandomEquipment()
			{
				__original();

				if (this.getBodyItem() != null && ::Math.rand(1, 100) <= ::Reforged.Config.ArmorAttachmentChance.Tier3)
				{
					local armor = this.getBodyItem();
					local conditionModifierCutoff = armor.getConditionMax() < 115 ? 10 : 20;
					local armorAttachment = ::Reforged.ItemTable.ArmorAttachmentNorthern.roll({
						function Apply( _script, _weight )
						{
							local conditionModifier = ::ItemTables.ItemInfoByScript[_script].ConditionModifier;

							if (conditionModifier > conditionModifierCutoff)
							{
								return 0.0;
							}

							return _weight;
						}

					});

					if (armorAttachment != null)
					{
						armor.setUpgrade(::new(armorAttachment));
					}

					  // [050]  OP_CLOSE          0      1    0    0
				}
			}

		}.assignRandomEquipment;
	};
	q.onSpawned = function ( __original )
	{
		return {
			function onSpawned()
			{
				__original();
				::Reforged.Skills.addPerkGroupOfEquippedWeapon(this);
			}

		}.onSpawned;
	};
});
