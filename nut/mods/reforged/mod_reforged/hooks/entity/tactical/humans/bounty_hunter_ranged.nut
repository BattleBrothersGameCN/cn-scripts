::Reforged.HooksMod.hook("scripts/entity/tactical/humans/bounty_hunter_ranged", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.BountyHunterRanged);
				b.TargetAttractionMult = 1.1;
				b.Vision = 8;
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_militia");
				this.m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
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

				if (this.getBodyItem() != null)
				{
					if (::Math.rand(1, 100) <= ::Reforged.Config.ArmorAttachmentChance.Tier2)
					{
						local armorAttachment = ::Reforged.ItemTable.ArmorAttachmentNorthern.roll({
							function Apply( _script, _weight )
							{
								local conditionModifier = ::ItemTables.ItemInfoByScript[_script].ConditionModifier;

								if (conditionModifier > 20)
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
					}
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
