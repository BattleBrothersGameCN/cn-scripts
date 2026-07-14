::Reforged.HooksMod.hook("scripts/skills/perks/perk_pathfinder", function ( q )
{
	q.m.RF_ActionPointCostsBackup <- null;
	q.m.RF_FatigueCostsBackup <- null;
	q.m.RF_LevelActionPointCostBackup <- null;
	q.onAdded = function ( __original )
	{
		return {
			function onAdded()
			{
				__original();
				local actor = this.getContainer().getActor();
				this.m.RF_ActionPointCostsBackup = actor.m.ActionPointCosts;
				this.m.RF_FatigueCostsBackup = actor.m.FatigueCosts;
				this.m.RF_LevelActionPointCostBackup = actor.m.LevelActionPointCost;
			}

		}.onAdded;
	};
	q.onRemoved = function ( __original )
	{
		return {
			function onRemoved()
			{
				__original();
				local actor = this.getContainer().getActor();

				if (this.m.RF_ActionPointCostsBackup != null)
				{
					actor.m.ActionPointCosts = this.m.RF_ActionPointCostsBackup;
					actor.m.FatigueCosts = this.m.RF_FatigueCostsBackup;
					actor.m.LevelActionPointCost = this.m.RF_LevelActionPointCostBackup;
				}
				else
				{
					::logError("Reforged: Pathfinder perk removed but could not reset costs as original costs were not saved");
				}
			}

		}.onRemoved;
	};
});
