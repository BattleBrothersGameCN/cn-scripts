::Reforged.HooksMod.hook("scripts/entity/tactical/humans/assassin", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.Assassin);
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_southern");
				this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_overwhelm"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_footwork"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_backstabber"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_coup_de_grace"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_duelist"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_relentless"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_double_strike"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_ghostlike"));
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
				::Reforged.Skills.addPerkGroupOfEquippedWeapon(this);
			}

		}.onSpawned;
	};
});
