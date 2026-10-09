this.perk_rf_deep_cuts <- ::inherit("scripts/skills/skill", {
	m = {
		ThresholdToInflictInjuryMult = 0.66,
		__NumInjuriesBefore = 0,
		__TargetID = 0
	},
	function create()
	{
		this.m.ID = "perk.rf_deep_cuts";
		this.m.Name = ::Const.Strings.PerkName.RF_DeepCuts;
		this.m.Description = "该角色已经做好准备，在下次攻击同一目标时，造成相当深的伤口。";
		this.m.Icon = "ui/perks/perk_rf_deep_cuts.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return this.m.__TargetID == 0;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local e = ::Tactical.getEntityByID(this.m.__TargetID);

		if (e != null && e.isAlive())
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("本回合中的下次" + ::MSU.Text.colorDamage("挥砍") + "攻击对" + ::MSU.Text.colorNegative(e.getName()) + "造成[创伤|Concept.InjuryTemporary]的[阈值|Concept.InjuryThreshold]" + ::MSU.Text.colorizeMultWithText(this.m.ThresholdToInflictInjuryMult, {
					Text = [
						"提高",
						"降低"
					]
				}) + " [threshold|Concept.InjuryThreshold] to inflict [injuries|Concept.InjuryTemporary]")
			});
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("这些攻击在造成至少[$ $|Skill+bleeding_effect]时" + ::MSU.Text.colorDamage(::Const.Combat.MinDamageToApplyBleeding) + "点[生命值|Concept.Hitpoints]伤害时，还会施加[$ $|Skill+bleeding_effect]效果")
			});
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("会在攻击其他目标、移动、切换物品、[等待|Concept.Wait]、结束[回合|Concept.Turn]或使用非挥砍攻击时失效"))
			});
		}

		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity != null && this.m.__TargetID == _targetEntity.getID() && this.isSkillValid(_skill) && ::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
		{
			_properties.ThresholdToInflictInjuryMult *= this.m.ThresholdToInflictInjuryMult;
		}
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (this.m.__TargetID == _targetEntity.getID())
		{
			this.m.__NumInjuriesBefore = _targetEntity.getSkills().getAllSkillsOfType(::Const.SkillType.TemporaryInjury).len();
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.m.__TargetID != _targetEntity.getID())
		{
			this.m.__TargetID = _targetEntity.getID();
			return;
		}

		if (!_targetEntity.isAlive() || _damageInflictedHitpoints < ::Const.Combat.MinDamageToApplyBleeding)
		{
			return;
		}

		if (!this.RF_isNewSkillUseOrEntity(_targetEntity))
		{
			return;
		}

		local actor = this.getContainer().getActor();
		_targetEntity.getSkills().add(::new("scripts/skills/effects/bleeding_effect"));

		if (_targetEntity.getSkills().getAllSkillsOfType(::Const.SkillType.TemporaryInjury).len() > this.m.__NumInjuriesBefore)
		{
			_targetEntity.getSkills().add(::new("scripts/skills/effects/bleeding_effect"));
		}
	}

	function onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_targetEntity == null || this.m.__TargetID != _targetEntity.getID() || _targetEntity.getCurrentProperties().IsImmuneToBleeding || !this.isSkillValid(_skill) || !::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
		{
			this.m.__TargetID = 0;
			return;
		}

		this.m.__TargetID = _targetEntity.getID();
	}

	function onTurnEnd()
	{
		this.m.__TargetID = 0;
	}

	function onWaitTurn()
	{
		this.m.__TargetID = 0;
	}

	function onPayForItemAction( _skill, _items )
	{
		this.m.__TargetID = 0;
	}

	function onMovementFinished()
	{
		this.m.__TargetID = 0;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.__TargetID = 0;
	}

	function isSkillValid( _skill )
	{
		return _skill.isAttack() && _skill.getDamageType().contains(::Const.Damage.DamageType.Cutting);
	}

});
