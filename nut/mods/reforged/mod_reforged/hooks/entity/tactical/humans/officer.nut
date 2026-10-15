::Reforged.HooksMod.hook("scripts/entity/tactical/humans/officer", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.Officer);
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_southern");
				this.m.Skills.add(::new("scripts/skills/perks/perk_captain"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_battle_forged"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_brawny"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_blitzkrieg"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_onslaught"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_hold_steady"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_shield_sergeant"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_battle_fervor"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_finesse"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_exude_confidence"));
				this.m.Skills.add(::Reforged.new("scripts/skills/perks/perk_inspiring_presence", function ( o )
				{
					o.m.IsForceEnabled = true;
				}));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rally_the_troops"));
				local rtt = this.m.Skills.getSkillByID("actives.rally_the_troops");

				if (rtt != null)
				{
					rtt.setBaseValue("ActionPointCost", 1);
					rtt.m.Cooldown = 3;
				}
			}

		}.onInit;
	};
	q.assignRandomEquipment = function ( __original )
	{
		return {
			function assignRandomEquipment()
			{
				__original();
				local weapon = this.getMainhandItem();

				if (weapon == null)
				{
					return;
				}

				if (weapon.isItemType(::Const.Items.ItemType.OneHanded))
				{
					this.m.Skills.add(::new("scripts/skills/perks/perk_duelist"));
				}
				else
				{
					this.m.Skills.add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
				}

				::Reforged.Skills.addPerkGroupOfEquippedWeapon(this);

				if (this.isArmedWithShield())
				{
					this.m.Skills.add(::new("scripts/skills/perks/perk_rf_phalanx"));
					this.m.Skills.add(::new("scripts/skills/perks/perk_shield_expert"));
				}
			}

		}.assignRandomEquipment;
	};
});
