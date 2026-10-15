::Reforged.HooksMod.hook("scripts/entity/tactical/enemies/schrat_small", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.actor.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.SchratSmall);
				b.IsImmuneToHeadshots = true;
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
				this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
				this.addSprite("socket").setBrush("bust_base_beasts");
				local body = this.addSprite("body");
				body.setBrush("bust_schrat_body_small_01");
				body.varySaturation(0.2);
				body.varyColor(0.05, 0.05, 0.05);
				this.m.BloodColor = body.Color;
				this.addDefaultStatusSprites();
				this.getSprite("status_rooted").Scale = 0.54;
				this.setSpriteOffset("status_rooted", this.createVec(0, 0));
				this.setSpriteOffset("status_stunned", this.createVec(-10, -10));
				this.setSpriteOffset("arrow", this.createVec(-10, -10));
				this.m.Skills.add(::new("scripts/skills/racial/schrat_racial"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_crippling_strikes"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_steel_brow"));
				this.m.Skills.add(::new("scripts/skills/actives/uproot_small_zoc_skill"));
				this.m.BaseProperties.Reach = ::Reforged.Reach.Default.BeastSmall;
				this.m.Skills.add(::new("scripts/skills/actives/rf_schrat_small_root_skill"));
				this.m.IsActingImmediately = true;
			}

		}.onInit;
	};
});
