::Reforged.HooksMod.hook("scripts/entity/tactical/humans/gladiator", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.Gladiator);
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_southern");
				this.m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_overwhelm"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_footwork"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_poise"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_survival_instinct"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_the_rush_of_battle"));
			}

		}.onInit;
	};
	q.onSpawned = function ( __original )
	{
		return {
			function onSpawned()
			{
				__original();
				::Reforged.Skills.addPerkGroupOfEquippedWeapon(this);
				local weapon = this.getMainhandItem();

				if (weapon != null)
				{
					if (::Reforged.Items.isDuelistValid(weapon))
					{
						this.m.Skills.add(::new("scripts/skills/perks/perk_duelist"));
					}
					else
					{
						this.m.Skills.add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
					}

					if (weapon.getRangeMax() == 2)
					{
						this.m.Skills.add(::new("scripts/skills/perks/perk_mastery_polearm"));
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
					this.m.Skills.add(::new("scripts/skills/perks/perk_rf_pattern_recognition"));
				}

				return ret;
			}

		}.makeMiniboss;
	};
});
