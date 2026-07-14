::Reforged.HooksMod.hook("scripts/entity/tactical/enemies/skeleton_priest", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.ResurrectionValue = 10.5;
			}

		}.create;
	};
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.skeleton.onInit();
				this.getSprite("body").setBrush("bust_skeleton_body_02");
				this.setDirty(true);
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.SkeletonPriest);
				b.TargetAttractionMult = 3.0;
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
				this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
				this.m.Skills.add(::new("scripts/skills/actives/horror_skill"));
				this.m.Skills.add(::new("scripts/skills/actives/miasma_skill"));
				this.m.Skills.add(::Reforged.new("scripts/skills/perks/perk_inspiring_presence", function ( o )
				{
					o.m.IsForceEnabled = true;
				}));
			}

		}.onInit;
	};
});
