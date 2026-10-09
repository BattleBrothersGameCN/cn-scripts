::Reforged.HooksMod.hook("scripts/entity/tactical/enemies/orc_berserker", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.actor.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.OrcBerserker);
				b.IsAffectedByFreshInjuries = false;
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
				this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
				this.m.Items.getAppearance().Body = "bust_orc_02_body";
				this.addSprite("socket").setBrush("bust_base_orcs");
				local body = this.addSprite("body");
				body.setBrush("bust_orc_02_body");
				body.varySaturation(0.1);
				body.varyColor(0.08, 0.08, 0.08);
				local tattoo_body = this.addSprite("tattoo_body");

				if (::Math.rand(1, 100) <= 50)
				{
					tattoo_body.setBrush("bust_orc_02_body_paint_0" + ::Math.rand(1, 3));
				}

				local injury_body = this.addSprite("injury_body");
				injury_body.Visible = false;
				injury_body.setBrush("bust_orc_02_body_injured");
				this.addSprite("armor");
				local head = this.addSprite("head");
				head.setBrush("bust_orc_02_head_0" + ::Math.rand(1, 3));
				head.Saturation = body.Saturation;
				head.Color = body.Color;
				local tattoo_head = this.addSprite("tattoo_head");

				if (::Math.rand(1, 100) <= 50)
				{
					tattoo_head.setBrush("bust_orc_02_head_paint_0" + ::Math.rand(1, 3));
				}

				local injury = this.addSprite("injury");
				injury.Visible = false;
				injury.setBrush("bust_orc_02_head_injured");
				this.addSprite("helmet");
				local body_rage = this.addSprite("body_rage");
				body_rage.Visible = false;
				body_rage.Alpha = 220;
				this.addDefaultStatusSprites();
				this.getSprite("status_rooted").Scale = 0.6;
				this.m.Skills.add(::new("scripts/skills/special/double_grip"));
				this.m.Skills.add(::new("scripts/skills/actives/hand_to_hand_orc"));
				this.m.Skills.add(::new("scripts/skills/actives/charge"));
				this.m.Skills.add(::new("scripts/skills/effects/berserker_rage_effect"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_battering_ram"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_berserk"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_battle_flow"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_hold_out"));
				this.m.BaseProperties.Reach = ::Reforged.Reach.Default.Orc;
				this.m.Skills.add(::new("scripts/skills/racial/rf_orc_racial"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_menacing"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_vigorous_assault"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_survival_instinct"));
			}

		}.onInit;
	};
	q.assignRandomEquipment = function ( __original )
	{
		return {
			function assignRandomEquipment()
			{
				__original();

				if (::Math.rand(1, 100) <= 20)
				{
					local weapon = this.getMainhandItem();

					if (weapon != null && !weapon.isItemType(::Const.Items.ItemType.Named))
					{
						this.m.Items.unequip(weapon);
						this.m.Items.equip(::new("scripts/items/weapons/greenskins/rf_orc_mace_2h"));
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
				::Reforged.Skills.addPerkGroupOfEquippedWeapon(this, 4);
			}

		}.onSpawned;
	};
	q.onSkillsUpdated = function ( __original )
	{
		return {
			function onSkillsUpdated()
			{
				__original();
				local weapon = this.getMainhandItem();

				if (weapon == null)
				{
					return;
				}

				if (weapon.isWeaponType(::Const.Items.WeaponType.Axe))
				{
					this.m.Skills.removeByID("actives.rf_bearded_blade");
					this.m.Skills.removeByID("actives.rf_hook_shield");
				}
			}

		}.onSkillsUpdated;
	};
	q.generateCorpse = function ( __original )
	{
		return {
			function generateCorpse( _tile, _fatalityType, _killer )
			{
				local ret = __original(_tile, _fatalityType, _killer);
				ret.IsResurrectable = _fatalityType != ::Const.FatalityType.Decapitated && _fatalityType != ::Const.FatalityType.Smashed;
				ret.Type = "scripts/entity/tactical/enemies/rf_zombie_orc_berserker";
				return ret;
			}

		}.generateCorpse;
	};
});
