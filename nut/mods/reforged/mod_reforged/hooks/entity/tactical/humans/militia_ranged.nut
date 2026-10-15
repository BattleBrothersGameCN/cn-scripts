::Reforged.HooksMod.hook("scripts/entity/tactical/humans/militia_ranged", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.MilitiaRanged);
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_militia");
				this.getSprite("accessory_special").setBrush("bust_militia_band_01");
				this.m.Skills.add(::new("scripts/skills/perks/perk_bullseye"));
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
				::Reforged.Skills.addPerkGroupOfEquippedWeapon(this, 3);
			}

		}.onSpawned;
	};
});
