::Reforged.HooksMod.hook("scripts/entity/tactical/humans/gunner", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.Gunner);
				b.TargetAttractionMult = 1.1;
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_southern");
				this.m.Skills.add(::new("scripts/skills/perks/perk_overwhelm"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_fearsome"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_mastery_crossbow"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rf_through_the_ranks"));
			}

		}.onInit;
	};
});
