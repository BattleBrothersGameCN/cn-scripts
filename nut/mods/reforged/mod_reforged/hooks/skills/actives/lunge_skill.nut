::Reforged.HooksMod.hook("scripts/skills/actives/lunge_skill", function ( q )
{
	q.m.MeleeSkillAdd <- -20;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.AIBehaviorID = ::Const.AI.Behavior.ID.RF_AttackLunge;
			}

		}.create;
	};
	q.isDuelistValid <- {
		function isDuelistValid()
		{
			return this.getBaseValue("ActionPointCost") <= 4;
		}

	}.isDuelistValid;
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getDefaultTooltip();
				ret.extend([
					{
						id = 6,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("无视[控制区|Concept.ZoneOfControl]，将使用者移动到目标身边")
					},
					{
						id = 7,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("造成额外伤害，使用者[主动值|Concept.Initiative]越高，伤害越高")
					}
				]);

				if (this.m.MeleeSkillAdd != 0)
				{
					ret.push({
						id = 10,
						type = "text",
						icon = "ui/icons/hitchance.png",
						text = "命中率" + ::MSU.Text.colorizeValue(this.m.MeleeSkillAdd, {
							AddSign = true,
							AddPercent = true
						}) + " chance to hit"
					});
				}

				if (this.getMaxRange() > 2)
				{
					ret.push({
						id = 20,
						type = "text",
						icon = "ui/icons/warning.png",
						text = "和目标之间不受阻挡才能使用，且最多只能跨越一次高度变化"
					});
				}

				if (this.getContainer().getActor().getCurrentProperties().IsRooted)
				{
					ret.push({
						id = 9,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = ::MSU.Text.colorNegative("被[定身|Concept.Rooted]时无法使用")
					});
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onAnySkillUsed = function ( __original )
	{
		return {
			function onAnySkillUsed( _skill, _targetEntity, _properties )
			{
				__original(_skill, _targetEntity, _properties);

				if (_skill == this)
				{
					if (!this.getContainer().getActor().isPlayerControlled())
					{
						_properties.MeleeSkill += this.m.MeleeSkillAdd;
					}
				}
			}

		}.onAnySkillUsed;
	};
	q.getDestinationTile <- {
		function getDestinationTile( _targetTile, _originTile = null )
		{
			local myTile = this.getContainer().getActor().getTile();

			if (_originTile == null)
			{
				_originTile = myTile;
			}

			local isTileEmpty = function ( _tile )
			{
				return _tile.IsEmpty || _tile.isSameTileAs(myTile);
			};
			local maxDist = this.m.MaxRange - 1;
			local destTiles = [];

			foreach( destTile in ::MSU.Tile.getNeighbors(_targetTile).filter(function ( _, _t )
			{
				return isTileEmpty(_t) && _t.getDistanceTo(_originTile) <= maxDist && ::Math.abs(_targetTile.Level - _t.Level) <= 1;
			}) )
			{
				if (this.m.MaxRange == 2 || destTile.getDistanceTo(_originTile) == 1)
				{
					if (::Math.abs(_originTile.Level - destTile.Level) <= 1)
					{
						return destTile;
					}
				}
				else if (::MSU.Tile.getNeighbors(destTile).filter(function ( _, _t )
				{
					return isTileEmpty(_t) && _t.getDistanceTo(_originTile) == 1 && ::Math.abs(_originTile.Level - _t.Level) + ::Math.abs(_t.Level - destTile.Level) <= 1;
				}).len() != 0)
				{
					destTiles.push(destTile);
				}
			}

			  // [069]  OP_CLOSE          0      7    0    0

			if (destTiles.len() != 0)
			{
				return destTiles[0];
			}
		}

	}.getDestinationTile;
	q.onVerifyTarget = function ()
	{
		return {
			function onVerifyTarget( _originTile, _targetTile )
			{
				return this.skill.onVerifyTarget(_originTile, _targetTile) && this.getDestinationTile(_targetTile, _originTile) != null;
			}

		}.onVerifyTarget;
	};
	q.onUse = function ()
	{
		return {
			function onUse( _user, _targetTile )
			{
				local destTile = this.getDestinationTile(_targetTile);

				if (destTile == null)
				{
					return false;
				}

				this.getContainer().setBusy(true);
				local tag = {
					Skill = this,
					User = _user,
					OldTile = _user.getTile(),
					TargetTile = _targetTile,
					OnRepelled = this.onRepelled
				};
				_user.spawnTerrainDropdownEffect(_user.getTile());
				::Tactical.getNavigator().teleport(_user, destTile, this.onTeleportDone.bindenv(this), tag, false, 3.0);
				return true;
			}

		}.onUse;
	};
});
