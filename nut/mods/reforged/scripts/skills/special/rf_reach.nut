this.rf_reach <- ::inherit("scripts/skills/skill", {
	m = {
		CurrBonus = 0,
		RootedReachMult = 0.5,
		HitEnemies = []
	},
	function create()
	{
		this.m.ID = "special.rf_reach";
		this.m.Name = "触及距离";
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("Reach is a depiction of how far a character\'s attacks can reach, making melee combat easier against targets with shorter reach.\n\n[Melee skill|Concept.MeleeSkill] is increased when attacking opponents with shorter reach, and reduced against opponents with longer reach. Reach has diminishing returns, starting at " + ::Reforged.Reach.BonusPerReach + " and dropping by 1 to a minimum of 1. It only applies when attacking a target adjacent to you or up to 2 tiles away with nothing between you and the target.\n\nAfter a successful hit, the target\'s [Reach Advantage|Concept.ReachAdvantage] is lost until the attacker waits or ends their turn.\n\nShields can negate some or all of the target\'s [Reach Advantage|Concept.ReachAdvantage]. Characters who are rooted have their Reach halved. Those without a melee attack have no Reach.");
		this.m.Icon = "skills/rf_reach_effect.png";
		this.m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.VeryLast + 100;
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
	}

	function getName()
	{
		local ret = this.m.Name;

		if (this.getContainer().getActor().getCurrentProperties().IsAffectedByReach)
		{
			ret = ret + (" (" + this.getContainer().getActor().getCurrentProperties().getReach() + ")");
		}
		else
		{
			ret = ret + "（不受影响）";
		}

		return ret;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (!::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/rf_reach.png",
				text = "当前触及：" + this.getContainer().getActor().getCurrentProperties().getReach()
			});
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getAttackOfOpportunity() == null)
		{
			_properties.ReachMult = 0.0;
		}
		else if (_properties.IsRooted)
		{
			_properties.ReachMult = this.m.RootedReachMult;
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		this.m.CurrBonus = 0;

		if (!_skill.isAttack() || _skill.isRanged() || !_properties.IsAffectedByReach || _targetEntity == null || !_targetEntity.getCurrentProperties().IsAffectedByReach || !::Reforged.Reach.hasLineOfSight(this.getContainer().getActor(), _targetEntity))
		{
			return;
		}

		local targetProperties = _targetEntity.getSkills().buildPropertiesForDefense(this.getContainer().getActor(), _skill);
		local diff = _properties.getReach() - targetProperties.getReach();

		if (diff == 0)
		{
			return;
		}

		if (diff > 0)
		{
			diff = ::Math.max(0, diff - targetProperties.DefensiveReachIgnore);
		}
		else
		{
			if (this.m.HitEnemies.find(_targetEntity.getID()) != null)
			{
				diff = 0;
			}

			diff = ::Math.min(0, diff + _properties.OffensiveReachIgnore);
		}

		if (diff == 0)
		{
			return;
		}

		local bonus = 0;
		local absDiff = ::Math.abs(diff);

		for( local i = 0; i < absDiff; i++ )
		{
			bonus = bonus + ::Math.max(1, ::Reforged.Reach.BonusPerReach - i);
		}

		if (diff > 0)
		{
			this.m.CurrBonus = bonus + diff * _properties.BonusPerReachAdvantage;
		}
		else
		{
			this.m.CurrBonus = -bonus + diff * targetProperties.BonusPerReachAdvantage;
		}

		_properties.MeleeSkill += this.m.CurrBonus;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!_skill.isRanged() && _targetEntity.isAlive() && ::Reforged.Reach.hasLineOfSight(this.getContainer().getActor(), _targetEntity) && this.m.HitEnemies.find(_targetEntity.getID()) == null)
		{
			this.m.HitEnemies.push(_targetEntity.getID());
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		::MSU.Array.removeByValue(this.m.HitEnemies, _targetEntity.getID());
	}

	function onTurnStart()
	{
		this.m.HitEnemies.clear();
	}

	function onTurnEnd()
	{
		this.m.HitEnemies.clear();
	}

	function onWaitTurn()
	{
		this.m.HitEnemies.clear();
	}

	function onPayForItemAction( _skill, _items )
	{
		this.m.HitEnemies.clear();
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.HitEnemies.clear();
	}

	function onGetHitFactors( _skill, _targetTile, _tooltip )
	{
		if (this.m.CurrBonus != 0)
		{
			_tooltip.push({
				icon = this.m.CurrBonus > 0 ? "ui/tooltips/positive.png" : "ui/tooltips/negative.png",
				text = ::MSU.Text.colorizeValue(this.m.CurrBonus, {
					AddPercent = true
				}) + (this.m.CurrBonus > 0 ? "触及优势" : "触及劣势")
			});
		}
	}

	function onQueryTooltip( _skill, _tooltip )
	{
		if (_skill.isType(::Const.SkillType.Racial) && this.getContainer().getActor().getBaseProperties().getReach() >= ::Reforged.Reach.Default.NetImmune)
		{
			_tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("体型太大，不会被[网住|Skill+net_effect]")
			});
		}
	}

});
