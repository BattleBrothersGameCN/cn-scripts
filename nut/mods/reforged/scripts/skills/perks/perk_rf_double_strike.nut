this.perk_rf_double_strike <- ::inherit("scripts/skills/skill", {
	m = {
		IsInEffect = false,
		DamageBonus = 20
	},
	function create()
	{
		this.m.ID = "perk.rf_double_strike";
		this.m.Name = ::Const.Strings.PerkName.RF_DoubleStrike;
		this.m.Description = "一击既中，该角色已准备好使出强大的后续攻击！下一次攻击将造成更多伤害。如果攻击未命中，则效果无效。";
		this.m.Icon = "ui/perks/perk_rf_double_strike.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return !this.m.IsInEffect;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = "单目标攻击造成的伤害提高" + ::MSU.Text.colorizeValue(this.m.DamageBonus, {
				AddSign = true,
				AddPercent = true
			}) + " more damage"
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("会在移动、交换物品、使用单目标攻击以外技能、攻击未命中、[等待|Concept.Wait]或结束[回合|Concept.Turn]时失效")
		});
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.m.IsInEffect && this.isSkillValid(_skill))
		{
			_properties.MeleeDamageMult *= 1.0 + this.m.DamageBonus * 0.01;
		}
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (!this.isSkillValid(_skill))
		{
			this.m.IsInEffect = false;
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.m.IsInEffect = this.isSkillValid(_skill);
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.m.IsInEffect = false;
	}

	function onTurnEnd()
	{
		this.m.IsInEffect = false;
	}

	function onWaitTurn()
	{
		this.m.IsInEffect = false;
	}

	function onTurnStart()
	{
		this.m.IsInEffect = false;
	}

	function onResumeTurn()
	{
		this.m.IsInEffect = false;
	}

	function onPayForItemAction( _skill, _items )
	{
		this.m.IsInEffect = false;
	}

	function onMovementFinished()
	{
		this.m.IsInEffect = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsInEffect = false;
	}

	function isSkillValid( _skill )
	{
		return _skill.isAttack() && !_skill.isRanged() && !_skill.isAOE();
	}

});
