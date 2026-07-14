::Reforged.HooksMod.hook("scripts/entity/tactical/humans/conscript", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.Conscript);
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_southern");
				this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_backstabber"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_phalanx"));
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
			}

		}.onSpawned;
	};
});
