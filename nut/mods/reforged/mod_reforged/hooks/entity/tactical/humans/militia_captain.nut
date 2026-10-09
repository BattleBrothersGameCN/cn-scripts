::Reforged.HooksMod.hook("scripts/entity/tactical/humans/militia_captain", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.MilitiaCaptain);
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_militia");
				this.getSprite("accessory_special").setBrush("bust_militia_band_02");
				this.m.Skills.add(::new("scripts/skills/perks/perk_captain"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rally_the_troops"));
				local rtt = this.m.Skills.getSkillByID("actives.rally_the_troops");

				if (rtt != null)
				{
					rtt.setBaseValue("ActionPointCost", 1);
					rtt.m.Cooldown = 3;
				}

				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_onslaught"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_hold_steady"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_shield_sergeant"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_exude_confidence"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_strength_in_numbers"));
			}

		}.onInit;
	};
	q.onSpawned = function ( __original )
	{
		return {
			function onSpawned()
			{
				__original();
				::Reforged.Skills.addPerkGroupOfEquippedWeapon(this, 4);

				if (this.isArmedWithShield())
				{
					this.m.Skills.add(::new("scripts/skills/perks/perk_rf_phalanx"));
					this.m.Skills.add(::new("scripts/skills/perks/perk_shield_expert"));
				}
			}

		}.onSpawned;
	};
});
