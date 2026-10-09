this.perk_rf_vigorous_assault <- ::inherit("scripts/skills/skill", {
	m = {
		BonusEveryXTiles = 2,
		NumTilesMoved = 0
	},
	function create()
	{
		this.m.ID = "perk.rf_vigorous_assault";
		this.m.Name = ::Const.Strings.PerkName.RF_VigorousAssault;
		this.m.Description = "该角色运动的冲劲使得下次攻击动作更快，更轻松。";
		this.m.Icon = "ui/perks/perk_rf_vigorous_assault.png";
		this.m.IconMini = "perk_rf_vigorous_assault_mini";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return this.m.NumTilesMoved / this.m.BonusEveryXTiles == 0;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local actionPointCostModifier = this.getActionPointCostModifier();

		if (actionPointCostModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString("下次攻击消耗的[行动点数|Concept.ActionPoints]" + ::MSU.Text.colorizeValue(actionPointCostModifier, {
					AddSign = true,
					InvertColor = true
				}) + " [Action Point(s)|Concept.ActionPoints]")
			});
		}

		local fatigueCostMultMult = this.getFatigueCostMultMult();

		if (fatigueCostMultMult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString("下次攻击积累的[疲劳|Concept.Fatigue]" + ::MSU.Text.colorizeMultWithText(this.getFatigueCostMultMult(), {
					InvertColor = true
				}) + " [Fatigue|Concept.Fatigue]")
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("会在[等待、|Concept.Wait]结束[回合、|Concept.Turn]使用技能或切换物品后失效，切换掉/成投掷武器除外")
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap() || actor.isPreviewing() && actor.getPreviewSkill() != null)
		{
			return;
		}

		local numTilesMoved_backup = this.m.NumTilesMoved;

		if (actor.isPreviewing())
		{
			this.m.NumTilesMoved += actor.getPreviewMovement().Tiles;
		}

		if (!actor.isPlayerControlled() && this.m.NumTilesMoved < this.m.BonusEveryXTiles && ::Tactical.TurnSequenceBar.isActiveEntity(actor))
		{
			local aoo = this.getContainer().getAttackOfOpportunity();

			if (aoo != null)
			{
				local numEnemiesInRange = 0;
				local numEnemiesApproachable = 0;
				local myTile = actor.getTile();

				foreach( faction, actors in ::Tactical.Entities.getAllInstances() )
				{
					if (actor.isAlliedWith(faction))
					{
						continue;
					}

					foreach( enemy in actors )
					{
						if (!enemy.isPlacedOnMap())
						{
							continue;
						}

						local distance = enemy.getTile().getDistanceTo(myTile);

						if (distance <= aoo.getMaxRange())
						{
							numEnemiesInRange++;
							break;
						}

						if (distance >= this.m.BonusEveryXTiles + aoo.getMaxRange())
						{
							numEnemiesApproachable++;
						}
					}
				}

				if (numEnemiesInRange == 0 && numEnemiesApproachable > 0)
				{
					this.m.NumTilesMoved = this.m.BonusEveryXTiles;
				}
			}
		}

		foreach( skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active) )
		{
			if (this.isSkillValid(skill))
			{
				if (skill.m.ActionPointCost > 1)
				{
					skill.m.ActionPointCost = ::Math.max(1, skill.m.ActionPointCost + this.getActionPointCostModifier());
				}

				skill.m.FatigueCostMult *= this.getFatigueCostMultMult();
			}
		}

		this.m.NumTilesMoved = numTilesMoved_backup;
	}

	function getActionPointCostModifier()
	{
		return -this.m.NumTilesMoved / this.m.BonusEveryXTiles;
	}

	function getFatigueCostMultMult()
	{
		return ::Math.maxf(0.0, 1.0 - 0.1 * (this.m.NumTilesMoved / this.m.BonusEveryXTiles));
	}

	function onMovementStarted( _tile, _numTiles )
	{
		this.m.NumTilesMoved += _numTiles;
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		this.m.NumTilesMoved = 0;
	}

	function onWaitTurn()
	{
		this.m.NumTilesMoved = 0;
	}

	function onResumeTurn()
	{
		this.m.NumTilesMoved = 0;
	}

	function onPayForItemAction( _skill, _items )
	{
		foreach( item in _items )
		{
			if (item != null && item.isItemType(::Const.Items.ItemType.Weapon) && item.isWeaponType(::Const.Items.WeaponType.Throwing))
			{
				return;
			}
		}

		this.m.NumTilesMoved = 0;
	}

	function onTurnStart()
	{
		this.m.NumTilesMoved = 0;
	}

	function onTurnEnd()
	{
		this.m.NumTilesMoved = 0;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.NumTilesMoved = 0;
	}

	function isSkillValid( _skill )
	{
		if (!_skill.isAttack())
		{
			return false;
		}

		if (!_skill.isRanged())
		{
			return true;
		}

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Throwing);
	}

});
