::Reforged.HooksMod.hook("scripts/entity/tactical/humans/executioner", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.Executioner);
				b.TargetAttractionMult = 1.0;
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_nomads");
				this.m.Skills.add(::new("scripts/skills/perks/perk_crippling_strikes"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_coup_de_grace"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_battle_forged"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_killing_frenzy"));
				this.m.Skills.add(::new("scripts/skills/actives/throw_dirt_skill"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_calculated_strikes"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_fearsome"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_menacing"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_skirmisher"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_survival_instinct"));
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

					if (weapon.isAoE())
					{
						this.m.Skills.add(::new("scripts/skills/perks/perk_rf_sweeping_strikes"));
					}
					else
					{
						this.m.Skills.add(::new("scripts/skills/perks/perk_rf_small_target"));
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
					this.m.Skills.removeByID("perk.reach_advantage");
					this.m.Skills.add(::new("scripts/skills/perks/perk_relentless"));
				}

				return ret;
			}

		}.makeMiniboss;
	};
});
