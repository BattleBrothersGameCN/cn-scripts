this.geist_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.geist_potion";
		this.m.Name = "应激动能分泌";
		this.m.Icon = "skills/status_effect_137.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_137";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "这个角色能够分泌一种在刺激时能够快速振动的物质。当应用于武器时，这会产生强大的动能力量，有助于穿透护甲。";
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
				icon = "ui/icons/direct_damage.png",
				text = "额外的[color=" + this.Const.UI.Color.PositiveValue + "]5%[/color] 的伤害在使用近战武器时无视护甲"
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
		_properties.DamageDirectMeleeAdd += 0.050000;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isGeistPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGeistPotionAcquired", false);
	}

});
