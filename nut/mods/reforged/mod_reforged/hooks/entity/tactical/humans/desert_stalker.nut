::Reforged.HooksMod.hook("scripts/entity/tactical/humans/desert_stalker", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.DesertStalker);
				b.Vision = 8;
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_nomads");
				this.m.Skills.add(::new("scripts/skills/perks/perk_crippling_strikes"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_coup_de_grace"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_bullseye"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_battle_flow"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_head_hunter"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
				this.m.Skills.add(::new("scripts/skills/actives/throw_dirt_skill"));
				b.RangedDefense += 15;
				this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_footwork"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_small_target"));
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
	q.makeMiniboss = function ( __original )
	{
		return {
			function makeMiniboss()
			{
				local ret = __original();

				if (ret)
				{
					this.m.Skills.add(::new("scripts/skills/perks/perk_rf_finesse"));
					this.m.Skills.add(::new("scripts/skills/perks/perk_rf_fresh_and_furious"));
				}

				return ret;
			}

		}.makeMiniboss;
	};
});
