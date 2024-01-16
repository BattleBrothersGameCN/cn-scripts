this.lorekeeper_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false,
		LastFrameUsed = 0
	},
	function isSpent()
	{
		return this.m.IsSpent;
	}

	function getLastFrameUsed()
	{
		return this.m.LastFrameUsed;
	}

	function create()
	{
		this.m.ID = "effects.lorekeeper_potion";
		this.m.Name = "博学者的肋骨";
		this.m.Icon = "skills/status_effect_151.png";
		this.m.IconMini = "status_effect_151_mini";
		this.m.Overlay = "status_effect_151";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "这个角色的身体里整合进了博学者的部分骨骼，结果是具备了在遭受看似致命的伤口时快速恢复的能力。如果他们能别在夜里尖叫就更好了……";
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
				text = "每场战斗只能触发一次，在遭受致命伤害时抵抗该次伤害并恢复所有生命值"
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

	function setSpent( _f )
	{
		this.m.IsSpent = _f;
		this.m.LastFrameUsed = this.Time.getFrame();
	}

	function onCombatStarted()
	{
		this.m.IsSpent = false;
		this.m.LastFrameUsed = 0;
	}

	function onCombatFinished()
	{
		this.m.IsSpent = false;
		this.m.LastFrameUsed = 0;
		this.skill.onCombatFinished();
	}

	function onUpdate( _properties )
	{
		if (this.m.IsSpent && this.m.LastFrameUsed == this.Time.getFrame())
		{
			this.getContainer().removeByType(this.Const.SkillType.DamageOverTime);
		}
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isLorekeeperPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isLorekeeperPotionAcquired", false);
	}

});
