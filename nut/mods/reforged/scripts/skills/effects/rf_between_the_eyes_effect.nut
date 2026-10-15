this.rf_between_the_eyes_effect <- ::inherit("scripts/skills/skill", {
	m = {
		MeleeSkillToHeadshotChancePct = 0.5,
		HeadshotDamageMult = 1.5
	},
	function create()
	{
		this.m.ID = "effects.rf_between_the_eyes";
		this.m.Name = "直抵眉心";
		this.m.Description = "该角色正尝试将下次攻击落在对手眉间。";
		this.m.Icon = "ui/perks//perk_rf_between_the_eyes.png";
		this.m.Overlay = "rf_between_the_eyes_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local chanceStr;

		if (::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
		{
			chanceStr = "[近战技能|Concept.MeleeSkill]的" + ::MSU.Text.colorizePct(this.m.MeleeSkillToHeadshotChancePct) + "的[近战技能|Concept.MeleeSkill]值，作为爆头概率";
		}
		else
		{
			chanceStr = ::MSU.Text.colorizeValue(this.getHeadshotChanceAdd(), {
				AddSign = true,
				AddPercent = true
			}) + " chance";
		}

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/chance_to_hit_head.png",
			text = ::Reforged.Mod.Tooltips.parseString("下次近战攻击有" + chanceStr + "命中头部，并造成" + ::MSU.Text.colorizeMultWithText(this.m.HeadshotDamageMult) + "倍伤害")
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("会在[等待|Concept.Wait]或结束[回合|Concept.Turn]后失效")
		});
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.isSkillValid(_skill))
		{
			_properties.HitChance[::Const.BodyPart.Head] += this.getHeadshotChanceAdd();
			_properties.DamageAgainstMult[::Const.BodyPart.Head] *= this.getHeadshotDamageMult();
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.removeSelf();
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.removeSelf();
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

	function onWaitTurn()
	{
		this.removeSelf();
	}

	function getHeadshotChanceAdd()
	{
		return ::Math.max(0, this.getContainer().getActor().getCurrentProperties().getMeleeSkill() * this.m.MeleeSkillToHeadshotChancePct);
	}

	function getHeadshotDamageMult()
	{
		return this.m.HeadshotDamageMult;
	}

	function isSkillValid( _skill )
	{
		return _skill.isAttack() && !_skill.isRanged();
	}

});
