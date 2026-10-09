this.perk_rf_vigilant <- ::inherit("scripts/skills/skill", {
	m = {
		CurrBonus = 0
	},
	function create()
	{
		this.m.ID = "perk.rf_vigilant";
		this.m.Name = ::Const.Strings.PerkName.RF_Vigilant;
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("该角色眼力敏锐而动作更甚。获得部分上[回合|Concept.Turn]未花费的[行动点数|Concept.ActionPoints]。");
		this.m.Icon = "ui/perks/perk_rf_vigilant.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return this.m.CurrBonus == 0;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.CurrBonus, {
				AddSign = true
			}) + "点[行动点数|Concept.ActionPoints]")
		});
		return ret;
	}

	function onTurnEnd()
	{
		this.m.CurrBonus = this.getContainer().getActor().getActionPoints() / 2;
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints += this.m.CurrBonus;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.CurrBonus = 0;
	}

});
