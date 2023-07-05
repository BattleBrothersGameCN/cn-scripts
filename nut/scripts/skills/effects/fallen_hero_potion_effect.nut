this.fallen_hero_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.fallen_hero_potion";
		this.m.Name = "反应性肌肉组织";
		this.m.Icon = "skills/status_effect_136.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_136";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "这个角色的身体面对物理创伤会反应式的分泌一种含钙物质，会使被冲击处的肌肉反射式的收缩以最小化肌肉损伤。";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "该角色不会因敌人的攻击（无论是否命中）而积累疲劳值。"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "下次喝下突变药剂时会导致更长时间的疾病"
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.FatigueLossOnAnyAttackMult = 0.000000;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isFallenHeroPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isFallenHeroPotionAcquired", false);
	}

});
