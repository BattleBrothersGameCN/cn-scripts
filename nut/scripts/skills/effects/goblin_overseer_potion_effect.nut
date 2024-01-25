this.goblin_overseer_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.goblin_overseer_potion";
		this.m.Name = "突变角膜";
		this.m.Icon = "skills/status_effect_126.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_126";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "该角色的眼睛已经永久性变异，现在能够感知风和空气的最微妙的移动。虽然这看似微不足道，但使他能够更好地预测投射攻击的轨迹，更好地攻击目标的防护薄弱部位。";
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
				text = "使用弓或弩时额外造成 [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color] 无视护甲的伤害"
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
		_properties.IsSharpshooter = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isGoblinOverseerPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGoblinOverseerPotionAcquired", false);
	}

});
