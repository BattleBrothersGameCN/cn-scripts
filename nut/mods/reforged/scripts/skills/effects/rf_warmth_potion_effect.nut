this.rf_warmth_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		ActionPointsAdd = 1
	},
	function create()
	{
		this.m.ID = "effects.rf_warmth_potion";
		this.m.Name = "沸血补剂";
		this.m.Description = "拜其服下的辛辣合剂所赐，能量正从该角色的体内迸发而出。";
		this.m.Icon = "skills/rf_warmth_potion_effect.png";
		this.m.IconMini = "rf_warmth_potion_effect_mini";
		this.m.Overlay = "rf_warmth_potion_effect";
		this.m.Type = ::Const.SkillType.StatusEffect | ::Const.SkillType.DrugEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.ActionPointsAdd != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.ActionPointsAdd, {
					AddSign = true
				}) + "[行动点数|Concept.ActionPoints]")
			});
		}

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("免疫自然或非自然的寒冷效果，如[$ $|Skill+chilled_effect]和[$ $|Skill+rf_numbness_effect]")
		});
		ret.push({
			id = 7,
			type = "hint",
			icon = "ui/icons/action_points.png",
			text = "会在1场战斗后消退"
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints += this.m.ActionPointsAdd;
	}

});
