::Reforged.HooksMod.hook("scripts/entity/tactical/humans/bounty_hunter", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.BountyHunter);
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_militia");
				this.m.Skills.add(::new("scripts/skills/perks/perk_bullseye"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_overwhelm"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_footwork"));
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
					local conditionModifierCutoff = armor.getConditionMax() < 115 ? 20 : 30;
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
						this.getBodyItem().setUpgrade(::new(armorAttachment));
					}

					  // [052]  OP_CLOSE          0      1    0    0
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
				::Reforged.Skills.addPerkGroupOfEquippedWeapon(this, 4);
			}

		}.onSpawned;
	};
});
