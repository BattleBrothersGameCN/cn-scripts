::Reforged.HooksMod.hook("scripts/items/shields/special/craftable_schrat_shield", function ( q )
{
	q.m.SpawnSaplingConditionThreshold <- 125;
	q.m.SpawnSaplingConditionLoss <- 50;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Condition = 150;
				this.m.ConditionMax = 150;
				this.m.ReachIgnore = 3;
			}

		}.create;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("在不是你的[回合|Concept.Turn]时若遭到近战命中，且耐久至少为" + ::MSU.Text.colorPositive(this.m.SpawnSaplingConditionThreshold) + "点，在接邻地格上生成一个小" + ::Const.Strings.EntityName[::Const.EntityType.Schrat] + "，失去" + ::MSU.Text.colorNegative(this.m.SpawnSaplingConditionLoss) + "点耐久度")
				});
				return ret;
			}

		}.getTooltip;
	};
	q.onShieldHit = function ()
	{
		return {
			function onShieldHit( _attacker, _skill )
			{
				if (!_skill.isRanged() && !::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()) && this.getCondition() >= this.m.SpawnSaplingConditionThreshold && this.getCondition() > this.m.SpawnSaplingConditionLoss)
				{
					this.spawnSapling();
				}
			}

		}.onShieldHit;
	};
	q.spawnSapling <- {
		function spawnSapling()
		{
			local actor = this.getContainer().getActor();

			if (!actor.isPlacedOnMap())
			{
				return;
			}

			local myTile = actor.getTile();
			local neighboringTiles = ::MSU.Tile.getNeighbors(myTile).filter(function ( _, _t )
			{
				return _t.IsEmpty && ::Math.abs(myTile.Level - _t.Level) <= 1;
			});

			if (neighboringTiles.len() != 0)
			{
				local sapling = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/rf_schrat_small_from_shield", ::MSU.Array.rand(neighboringTiles).Coords);
				sapling.setFaction(actor.isPlayerControlled() ? ::Const.Faction.PlayerAnimals : actor.getFaction());
				sapling.m.ConfidentMoraleBrush = "icon_confident";
				sapling.riseFromGround();
				this.setCondition(::Math.max(0, this.m.Condition - this.m.SpawnSaplingConditionLoss));
			}
		}

	}.spawnSapling;
});
