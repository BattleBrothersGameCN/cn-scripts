this.orc_young_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.orc_young_potion";
		this.m.Name = "动能打击";
		this.m.Icon = "skills/status_effect_127.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_127";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "这个角色的手腕发生了变异，以至于可以减轻对抗外力的初始冲击。更实际的说，当攻击敌人时，可以削弱其保护装备的质量。此外，它们还可以做出一些非常奇特的影子木偶。";
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
				icon = "ui/icons/armor_damage.png",
				text = "攻击增加[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color]护甲有效性"
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
		_properties.DamageArmorMult += 0.100000;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isOrcYoungPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isOrcYoungPotionAcquired", false);
	}

});
