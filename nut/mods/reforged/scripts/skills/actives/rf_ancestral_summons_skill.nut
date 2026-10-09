this.rf_ancestral_summons_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Barrows = [],
		PossibleSpawns = null
	},
	function create()
	{
		this.m.ID = "actives.rf_ancestral_summons";
		this.m.Name = "先祖召唤";
		this.m.Description = "召唤一名被埋葬的墓穴族，使其复苏并为你而战.";
		this.m.Icon = "skills/rf_ancestral_summons_skill.png";
		this.m.IconDisabled = "skills/rf_ancestral_summons_skill_sw.png";
		this.m.Overlay = "rf_ancestral_summons_skill";
		this.m.SoundOnHit = [
			"sounds/enemies/rf_ancestral_summons_skill_01.wav",
			"sounds/enemies/rf_ancestral_summons_skill_02.wav",
			"sounds/enemies/rf_ancestral_summons_skill_03.wav"
		];
		this.m.SoundVolume = 1.2;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.RF_AncestralSummons;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "可将地图上的任何墓穴作为目标"
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "无法对同一个墓穴使用两次"
		});
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile.IsEmpty)
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (!::isKindOf(target, "rf_barrows") || target.isSpent())
		{
			return false;
		}

		return ::MSU.Tile.getNeighbors(_targetTile).filter(function ( _, _t )
		{
			return _t.IsEmpty && _t.Level == _targetTile.Level;
		}).len() != 0;
	}

	function onUse( _user, _targetTile )
	{
		local adjacentTiles = ::MSU.Tile.getNeighbors(_targetTile).filter(function ( _, _t )
		{
			return _t.IsEmpty && _t.Level == _targetTile.Level;
		});

		if (adjacentTiles.len() == 0)
		{
			return false;
		}

		if (_targetTile.IsVisibleForPlayer)
		{
			if (::Const.Tactical.RaiseUndeadParticles.len() != 0)
			{
				for( local i = 0; i < ::Const.Tactical.RaiseUndeadParticles.len(); i = i )
				{
					::Tactical.spawnParticleEffect(true, ::Const.Tactical.RaiseUndeadParticles[i].Brushes, _targetTile, ::Const.Tactical.RaiseUndeadParticles[i].Delay, ::Const.Tactical.RaiseUndeadParticles[i].Quantity, ::Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, ::Const.Tactical.RaiseUndeadParticles[i].SpawnRate, ::Const.Tactical.RaiseUndeadParticles[i].Stages);
					i = ++i;
				}
			}

			if (_user.isDiscovered() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + "使出" + this.getName());

				if (this.m.SoundOnHit.len() != 0)
				{
					::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), ::Const.Sound.Volume.Skill * 1.2, _user.getPos());
				}
			}
		}

		_targetTile.getEntity().setSpent(true);
		this.spawnUndead(_user, ::MSU.Array.rand(adjacentTiles));
		return true;
	}

	function spawnUndead( _user, _tile )
	{
		local script = this.m.PossibleSpawns.roll();
		this.m.PossibleSpawns.setWeight(script, this.m.PossibleSpawns.getWeight(script) * 0.5);
		local e = ::Tactical.spawnEntity(script, _tile.Coords.X, _tile.Coords.Y);

		if (e != null)
		{
			e.setFaction(_user.getFaction());
			e.assignRandomEquipment();
			e.riseFromGround();
			e.playSound(::Const.Sound.ActorEvent.Resurrect, ::Const.Sound.Volume.Actor * e.m.SoundVolume[::Const.Sound.ActorEvent.Resurrect] * e.m.SoundVolumeOverall);
		}
	}

	function onActorSpawned( _actor )
	{
		if (::MSU.isEqual(_actor, this.getContainer().getActor()))
		{
			this.m.Barrows.clear();
			local mapSize = ::Tactical.getMapSize();
			local width = mapSize.X - 1;
			local height = mapSize.Y - 1;

			for( local x = 1; x < width; x++ )
			{
				for( local y = 1; y < height; y++ )
				{
					local tile = ::Tactical.getTileSquare(x, y);

					if (!tile.IsEmpty && ::isKindOf(tile.getEntity(), "rf_barrows"))
					{
						this.m.Barrows.push(tile.getEntity());
					}
				}
			}

			this.setupPossibleSpawns();
		}
	}

	function setupPossibleSpawns()
	{
		this.m.PossibleSpawns = ::MSU.Class.WeightedContainer();
		local maxXP = 0;
		local maxXPScript;

		foreach( ally in ::Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction()) )
		{
			if (!::isKindOf(ally, "rf_draugr") || ally.ClassName == "rf_draugr_shaman")
			{
				continue;
			}

			this.m.PossibleSpawns.add("scripts/entity/tactical/enemies/" + ally.ClassName);
			local xp = ally.getXPValue();

			if (xp > maxXP)
			{
				maxXP = xp;
				maxXPScript = ::IO.scriptFilenameByHash(ally.ClassNameHash);
			}
		}

		if (this.m.PossibleSpawns.len() > 1)
		{
			this.m.PossibleSpawns.remove(maxXPScript);
		}
		else if (this.m.PossibleSpawns.len() == 0)
		{
			this.m.PossibleSpawns.addMany(1, [
				"scripts/entity/tactical/enemies/rf_draugr_thrall",
				"scripts/entity/tactical/enemies/rf_draugr_warrior",
				"scripts/entity/tactical/enemies/rf_draugr_huskarl"
			]);
		}
	}

	function getBarrows()
	{
		return this.m.Barrows;
	}

});
