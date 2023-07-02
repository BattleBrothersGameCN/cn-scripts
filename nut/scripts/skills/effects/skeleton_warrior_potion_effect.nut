this.skeleton_warrior_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.skeleton_warrior_potion";
		this.m.Name = "四肢硬化";
		this.m.Icon = "skills/status_effect_131.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_131";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "这个角色的身体经过基因突变，使他们能够将肢体锁定在某些位置上，几乎可以无限期地保持，这使他们能够轻松抵御攻击。";
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
				text = "减少“盾墙”技能疲劳值消耗[color=" + this.Const.UI.Color.PositiveValue + "]" + 100 * (1 - this.Const.Combat.WeaponSpecFatigueMult) + "%[/color]"
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
		_properties.IsProficientWithShieldWall = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isSkeletonWarriorPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isSkeletonWarriorPotionAcquired", false);
	}

});
