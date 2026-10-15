this.rf_rattled_effect <- ::inherit("scripts/skills/skill", {
	m = {
		ReachModifier = -3
	},
	function create()
	{
		this.m.ID = "effects.rf_rattled";
		this.m.Name = "颤栗";
		this.m.Description = "该角色连骨头都在打颤，降低了其战斗效率。";
		this.m.Icon = "ui/perks/perk_rf_rattle.png";
		this.m.IconMini = "rf_rattled_effect_mini";
		this.m.Overlay = "rf_rattled_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/rf_reach.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.ReachModifier, {
				AddSign = true
			}) + "[触及距离|Concept.Reach]")
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.Reach += this.m.ReachModifier;
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

});
