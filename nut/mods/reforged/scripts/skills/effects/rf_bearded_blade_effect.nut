this.rf_bearded_blade_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rf_bearded_blade";
		this.m.Name = "钩刃";
		this.m.Description = "该角色已经做好准备，用斧子上的钩刃来缴械一名对手。";
		this.m.Icon = "skills/rf_bearded_blade_effect.png";
		this.m.IconMini = "rf_bearded_blade_effect_mini";
		this.m.Overlay = "rf_bearded_blade_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("下次攻击有概率[缴械|Skill+disarmed_effect]你的对手，概率等于命中率。")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("直到你的下个[回合|Concept.Turn]，任何未命中你的攻击者都有概率被[缴械|Skill+disarmed_effect]，概率等于攻击落空概率。")
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("在攻击、成功[缴械|Skill+disarmed_effect]对手或切换武器后失效。")
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		if (_properties.IsStunned || this.getContainer().getActor().getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			this.removeSelf();
		}
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.__onTargetAttacked(_targetEntity);
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.__onTargetAttacked(_targetEntity);
	}

	function onMissed( _attacker, _skill )
	{
		if (_skill.isRanged() || !_attacker.isAlive() || _attacker.isAlliedWith(this.getContainer().getActor()) || ::MSU.isNull(::Tactical.State.MV_getCurrentAttackInfo()) || ::Math.rand(1, 100) <= ::Tactical.State.MV_getCurrentAttackInfo().ChanceToHit)
		{
			return;
		}

		local weapon = _attacker.getMainhandItem();

		if (weapon == null)
		{
			return;
		}

		this.removeSelf();
		this.__disarmEntity(_attacker);
	}

	function __onTargetAttacked( _targetEntity )
	{
		this.removeSelf();

		if (!_targetEntity.isAlive() || ::MSU.isNull(::Tactical.State.MV_getCurrentAttackInfo()) || ::Math.rand(1, 100) > ::Tactical.State.MV_getCurrentAttackInfo().ChanceToHit || _targetEntity.getMainhandItem() == null)
		{
			return;
		}

		this.__disarmEntity(_targetEntity);
	}

	function __disarmEntity( _entity )
	{
		local effect = ::new("scripts/skills/effects/disarmed_effect");
		_entity.getSkills().add(effect);

		if (!effect.isGarbage() && ::Tactical.TurnSequenceBar.isActiveEntity(_entity))
		{
			effect.addTurns(1);
		}

		if (!this.getContainer().getActor().isHiddenToPlayer() && _entity.getTile().IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "缴械了" + ::Const.UI.getColorizedEntityName(_entity) + "，持续" + effect.m.TurnsLeft + "回合");
		}
	}

});
