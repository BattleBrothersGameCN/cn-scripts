this.perk_rf_vanquisher <- ::inherit("scripts/skills/skill", {
	m = {
		ValidTiles = [],
		IsSpent = true,
		IsInEffect = false
	},
	function create()
	{
		this.m.ID = "perk.rf_vanquisher";
		this.m.Name = ::Const.Strings.PerkName.RF_Vanquisher;
		this.m.Description = "刚杀死了一名对手，该角色急于收拾下一个！";
		this.m.Icon = "ui/perks/perk_rf_vanquisher.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return !this.m.IsInEffect || this.m.ValidTiles.len() == 0;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("下个技能消耗的[行动点数|Concept.ActionPoints]" + ::MSU.Text.colorPositive("减半") + " [Action Points|Concept.ActionPoints]")
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "会在进行使用技能以外的动作后失效"
		});
		return ret;
	}

	function onAdded()
	{
		this.getContainer().add(::new("scripts/skills/actives/rf_gain_ground_skill"));
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.rf_gain_ground");
	}

	function onOtherActorDeath( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
	{
		if (_deathTile != null && _killer != null && _killer.getID() == this.getContainer().getActor().getID() && ::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
		{
			this.m.ValidTiles.push(_deathTile);
		}
	}

	function onMovementFinished()
	{
		this.m.IsInEffect = false;

		if (this.m.IsSpent)
		{
			return;
		}

		local tile = this.getContainer().getActor().getTile();

		if (this.isTileValid(tile))
		{
			this.m.IsInEffect = true;
			this.m.IsSpent = true;
			this.spawnIcon("perk_rf_vanquisher", tile);
		}
	}

	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local isValid = this.m.IsInEffect;

		if (actor.isPreviewing())
		{
			isValid = actor.getPreviewMovement() != null && this.isTileValid(actor.getPreviewMovement().End) || actor.getPreviewSkill() != null && actor.getPreviewSkill().getID() != "actives.rf_gain_ground";
		}

		if (isValid)
		{
			foreach( skill in this.getContainer().m.Skills )
			{
				if (!skill.isGarbage() && skill.m.ActionPointCost > 1)
				{
					skill.m.ActionPointCost /= 2;
				}
			}
		}
	}

	function onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill.isAttack() && !_forFree)
		{
			this.m.ValidTiles.clear();
		}
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		this.m.IsInEffect = false;
	}

	function onPayForItemAction( _skill, _items )
	{
		this.m.IsInEffect = false;
		this.m.ValidTiles.clear();
	}

	function onWaitTurn()
	{
		this.m.IsInEffect = false;
		this.m.ValidTiles.clear();
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
		this.m.IsInEffect = false;
		this.m.ValidTiles.clear();
	}

	function onTurnEnd()
	{
		this.m.IsInEffect = false;
		this.m.ValidTiles.clear();
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsSpent = true;
		this.m.IsInEffect = false;
		this.m.ValidTiles.clear();
	}

	function isTileValid( _tile )
	{
		if (_tile == null)
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
