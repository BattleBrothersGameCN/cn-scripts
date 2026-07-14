this.perk_rf_skirmisher <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.rf_skirmisher";
		this.m.Name = ::Const.Strings.PerkName.RF_Skirmisher;
		this.m.Description = "该角色比大多数人动作都快。";
		this.m.Icon = "ui/perks/perk_rf_skirmisher.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local initBonus = this.getInitiativeBonus();

		if (initBonus > 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+" + initBonus) + "[主动值|Concept.Initiative]")
			});
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("累积[疲劳|Concept.Fatigue]带来的[主动值|Concept.Initiative]损失降低" + ::MSU.Text.colorPositive("50%"))
		});
		return ret;
	}

	function getInitiativeBonus()
	{
		return ::Math.floor(this.getContainer().getActor().getItems().getStaminaModifier([
			::Const.ItemSlot.Body,
			::Const.ItemSlot.Head
		]) * -1 * 0.3);
	}

	function onUpdate( _properties )
	{
		_properties.FatigueToInitiativeRate *= 0.5;
		_properties.Initiative += this.getInitiativeBonus();
	}

});
