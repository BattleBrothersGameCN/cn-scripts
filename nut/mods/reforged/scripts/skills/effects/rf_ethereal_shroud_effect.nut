this.rf_ethereal_shroud_effect <- ::inherit("scripts/skills/skill", {
	m = {
		__IsBeingHitInMelee = false
	},
	function create()
	{
		this.m.ID = "effects.rf_ethereal_shroud";
		this.m.Name = "灵体帷幕";
		this.m.Description = "一层灵体薄雾笼罩着这个角色。";
		this.m.Icon = "skills/rf_ethereal_shroud_effect.png";
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
			text = ::Reforged.Mod.Tooltips.parseString("对所有对你造成[生命值|Concept.Hitpoints]伤害的近战攻击者施加[$ $|Skill+rf_numbness_effect]效果"),
			children = ::new("scripts/skills/effects/rf_numbness_effect").getTooltip().slice(2)
		});
		return ret;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		this.m.__IsBeingHitInMelee = _skill != null && _skill.isAttack() && !_skill.isRanged() && this.isAttackerValid(_attacker);
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints > 0 && this.m.__IsBeingHitInMelee)
		{
			_attacker.getSkills().add(::new("scripts/skills/effects/rf_numbness_effect"));
		}
	}

	function isAttackerValid( _attacker )
	{
		if (_attacker.getFlags().has("undead"))
		{
			return _attacker.getCurrentProperties().FatigueEffectMult != 1.0;
		}

		return true;
	}

});
