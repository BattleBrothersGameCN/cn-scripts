this.ai_explode_corpse <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		PossibleSkills = [
			"actives.corpse_explosion"
		],
		Skill = null
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.ExplodeCorpse;
		this.m.Order = this.Const.AI.Behavior.Order.ExplodeCorpse;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.Skill = null;
		this.m.TargetTile = null;
		local scoreMult = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions()))
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.Skill = this.selectSkill(this.m.PossibleSkills);

		if (this.m.Skill == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		scoreMult = scoreMult * this.getFatigueScoreMult(this.m.Skill);
		local corpses = this.Tactical.Entities.getCorpses();
		local entities = this.Tactical.Entities.getInstancesOfFaction(_entity.getFaction());

		foreach( e in entities )
		{
			if (e.getType() == this.Const.EntityType.FleshCradle)
			{
				corpses.push(e.getTile());
			}
		}

		local bestCorpse = this.selectBestTarget(_entity, corpses);

		if (bestCorpse == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.TargetTile = bestCorpse;
		return this.Const.AI.Behavior.Score.ExplodeCorpse * scoreMult;
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			if (this.m.TargetTile.IsVisibleForPlayer && _entity.isHiddenToPlayer())
			{
				_entity.setDiscovered(true);
				_entity.getTile().addVisibilityForFaction(this.Const.Faction.Player);
			}

			this.getAgent().adjustCameraToTarget(this.m.TargetTile);
			this.m.IsFirstExecuted = false;
			return false;
		}

		if (this.Const.AI.VerboseMode)
		{
			this.logInfo("* " + _entity.getName() + ": Using Corpse Explosion!");
		}

		if (this.m.Skill.use(this.m.TargetTile))
		{
			this.getAgent().declareAction();
			this.getAgent().declareEvaluationDelay();
		}

		this.m.Skill = null;
		this.m.TargetTile = null;
		return true;
	}

	function selectBestTarget( _entity, _corpses )
	{
		local bestCorpse;
		local bestScore = 0;

		foreach( corpse in _corpses )
		{
			if (!corpse.IsCorpseSpawned && !(corpse.getEntity() != null && corpse.getEntity().getType() == this.Const.EntityType.FleshCradle && !corpse.getEntity().getIsDestroyed()))
			{
				continue;
			}

			if (corpse.IsCorpseSpawned && !corpse.Properties.get("Corpse").IsConsumable)
			{
				continue;
			}

			local numTargets = 0;
			local numAllies = 0;
			local score = 0;
			local evaluatedTile = this.evaluateTile(corpse, _entity);
			numAllies = numAllies + evaluatedTile.Allies;
			numTargets = numTargets + evaluatedTile.Targets;
			score = score + evaluatedTile.Score;

			for( local i = 0; i != 6; i = ++i )
			{
				if (!corpse.hasNextTile(i))
				{
				}
				else
				{
					local tile = corpse.getNextTile(i);
					evaluatedTile = this.evaluateTile(tile, _entity);
					numAllies = numAllies + evaluatedTile.Allies;
					numTargets = numTargets + evaluatedTile.Targets;
					score = score + evaluatedTile.Score;
				}
			}

			if (numTargets > numAllies && score > bestScore)
			{
				bestCorpse = corpse;
				bestScore = score;
			}
		}

		return bestCorpse;
	}

	function evaluateTile( _tile, _entity )
	{
		local numAllies = 0;
		local numTargets = 0;
		local score = 0;

		if (_tile.IsOccupiedByActor)
		{
			if (_tile.isSameTileAs(_entity.getTile()))
			{
				score = score + this.Const.AI.Behavior.ExplodeCorpseWouldHitSelfValue;
			}

			local e = _tile.getEntity();

			if (!_entity.isAlliedWith(e))
			{
				numTargets++;
				score = score + this.Const.AI.Behavior.ExplodeCorpseTargetValue;
			}
			else if (e.getType() != this.Const.EntityType.FleshCradle)
			{
				numAllies++;
				score = score + this.Const.AI.Behavior.ExplodeCorpseWouldHitAllyValue;
			}
		}

		return {
			Allies = numAllies,
			Targets = numTargets,
			Score = score
		};
	}

});
