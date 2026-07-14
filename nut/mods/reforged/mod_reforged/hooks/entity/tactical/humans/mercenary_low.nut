::Reforged.HooksMod.hook("scripts/entity/tactical/humans/mercenary_low", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.BanditRaider);
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_militia");
				this.m.Skills.add(::new("scripts/skills/perks/perk_brawny"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_battle_forged"));
				b.RangedDefense += 10;
				this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
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
					this.m.Skills.add(::new("scripts/skills/perks/perk_shield_expert"));
				}
			}

		}.onSpawned;
	};
});
