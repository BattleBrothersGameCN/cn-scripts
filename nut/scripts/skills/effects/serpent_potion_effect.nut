this.serpent_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.serpent_potion";
		this.m.Name = "趁火打劫";
		this.m.Icon = "skills/status_effect_142.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_142";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "这个角色的眼睛发生了突变，更容易发现目标的防御漏洞。它们似乎还会发出非常微弱的嘶嘶声。";
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
				text = "攻击目标周围每有一名盟友，近战命中率提升 [color=" + this.Const.UI.Color.PositiveValue + "]+3%[/color]"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "下次喝下突变药剂会导致更长时间的疾病"
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.SurroundedBonus += 3;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isSerpentPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isSerpentPotionAcquired", false);
	}

});
