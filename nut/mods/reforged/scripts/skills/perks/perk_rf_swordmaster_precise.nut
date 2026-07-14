this.perk_rf_swordmaster_precise <- ::inherit("scripts/skills/perks/perk_rf_swordmaster_abstract", {
	m = {},
	function create()
	{
		this.perk_rf_swordmaster_abstract.create();
		this.m.ID = "perk.rf_swordmaster_precise";
		this.m.Name = ::Const.Strings.PerkName.RF_SwordmasterPrecise;
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("该角色的剑法精准异常，能够持续击中弱点。[等级|Concept.Level]越高，效果越强。");
		this.m.Icon = "ui/perks/perk_rf_swordmaster_precise.png";
		this.m.Type = this.m.Type | ::Const.SkillType.StatusEffect;
	}

	function isHidden()
	{
		return !this.isEnabled();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local skillModifier = this.getMeleeSkillModifier();

		if (skillModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(skillModifier, {
					AddSign = true
				}) + "[近战技能|Concept.MeleeSkill]")
			});
		}

		local defenseModifier = this.getMeleeDefenseModifier();

		if (defenseModifier != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(defenseModifier, {
					AddSign = true
				}) + "[近战防御|Concept.MeleeDefense]")
			});
		}

		local directDamageModifier = this.getDirectDamageModifier();

		if (directDamageModifier != 0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMult(1.0 + this.getDirectDamageModifier(), {
					AddSign = true
				}) + "伤害穿甲率")
			});
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		if (!this.isEnabled())
		{
			return;
		}

		_properties.MeleeSkill += this.getMeleeSkillModifier();
		_properties.MeleeDefense += this.getMeleeDefenseModifier();
		_properties.DamageDirectAdd += this.getDirectDamageModifier();
	}

	function getDirectDamageModifier()
	{
		local actor = this.getContainer().getActor();
		local ret = ::MSU.isKindOf(actor, "player") ? actor.getLevel() * 0.01 : 0;
		local weapon = actor.getMainhandItem();

		if (weapon != null && weapon.isItemType(::Const.Items.ItemType.RF_Fencing))
		{
			ret = ret + 0.25;
		}

		return ret;
	}

	function getMeleeSkillModifier()
	{
		local actor = this.getContainer().getActor();
		return ::MSU.isKindOf(actor, "player") ? actor.getLevel() : 0;
	}

	function getMeleeDefenseModifier()
	{
		local actor = this.getContainer().getActor();
		return ::MSU.isKindOf(actor, "player") ? actor.getLevel() : 0;
	}

});
