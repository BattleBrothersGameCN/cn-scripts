this.rf_gain_ground_skill <- ::inherit("scripts/skills/skill", {
	m = {
		ValidTiles = []
	},
	function create()
	{
		this.m.ID = "actives.rf_gain_ground";
		this.m.Name = "夺取立足点";
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("继续前进！无视[控制区域|Concept.ZoneOfControl]，杀死接邻敌人后立即移动到他占据的地格当中。");
		this.m.Icon = "skills/rf_gain_ground_skill.png";
		this.m.IconDisabled = "skills/rf_gain_ground_skill_sw.png";
		this.m.Overlay = "rf_gain_ground_skill";
		this.m.SoundOnUse = [
			"sounds/combat/footwork_01.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Last;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsDisengagement = true;
		this.m.ActionPointCost = -2;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 1;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.RF_PassingStep;
	}

	function getActionPointCost()
	{
		return ::Math.max(0, this.skill.getActionPointCost());
	}

	function getCostString()
	{
		if (this.getContainer().getActor().isPlacedOnMap())
		{
			return this.skill.getCostString();
		}

		local ret = "消耗" + (this.m.ActionPointCost == 0 ? "+0" : ::MSU.Text.colorizeValue(this.m.ActionPointCost, {
			AddSign = true,
			InvertColor = true
		})) + "点[行动点数|Concept.ActionPoints]，比起常规移动消耗，积累的[疲劳值|Concept.Fatigue]";
		ret = ret + ((this.m.FatigueCost == 0 ? "+0" : ::MSU.Text.colorizeValue(this.m.FatigueCost, {
			AddSign = true,
			InvertColor = true
		})) + "点[疲劳|Concept.Fatigue]，相较于起始地格的移动消耗计算");
		return ::Reforged.Mod.Tooltips.parseString(ret);
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("被定身时无法使用")
			});
		}

		if (this.m.ValidTiles.len() == 0)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("只能在击杀接邻敌人后立即使用")
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.m.ValidTiles.len() != 0 && this.skill.isUsable() && !this.getContainer().getActor().getCurrentProperties().IsRooted;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.isTileValid(_targetTile) && this.skill.onVerifyTarget(_originTile, _targetTile);
	}

	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap())
		{
			return;
		}

		local myTile = actor.getTile();
		this.m.ActionPointCost += actor.getActionPointCosts()[myTile.Type];
		this.m.FatigueCost += actor.getFatigueCosts()[myTile.Type];
	}

	function onUse( _user, _targetTile )
	{
		::Tactical.getNavigator().teleport(_user, _targetTile, null, null, false);
		this.m.ValidTiles.clear();
		return true;
	}

	function onOtherActorDeath( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
	{
		if (_deathTile == null)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (actor.isPlacedOnMap() && _killer != null && _killer.getID() == actor.getID() && ::Tactical.TurnSequenceBar.isActiveEntity(actor) && actor.getTile().getDistanceTo(_deathTile) == 1)
		{
			this.m.ValidTiles.push(_deathTile);
		}
	}

	function onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill != this && !_forFree)
		{
			this.m.ValidTiles.clear();
		}
	}

	function onPayForItemAction( _skill, _items )
	{
		this.m.ValidTiles.clear();
	}

	function onWaitTurn()
	{
		this.m.ValidTiles.clear();
	}

	function onTurnStart()
	{
		this.m.ValidTiles.clear();
	}

	function onTurnEnd()
	{
		this.m.ValidTiles.clear();
	}

	function onMovementFinished()
	{
		this.m.ValidTiles.clear();
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.ValidTiles.clear();
	}

	function isTileValid( _tile )
	{
		if (_tile == null || !_tile.IsEmpty)
		{
			return false;
		}

		foreach( t in this.m.ValidTiles )
		{
			if (_tile.isSameTileAs(t))
			{
				return true;
			}
		}

		return false;
	}

});
