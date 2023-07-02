this.goblin_shaman_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.goblin_shaman_potion";
		this.m.Name = "多汗症(Hyperactive Sweat Glands)";
		this.m.Icon = "skills/status_effect_125.png";
		this.m.IconMini = "status_effect_125_mini";
		this.m.Overlay = "status_effect_125";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "当处于高压情境时，该角色的变异身体会产生一种黏滑、粘稠的物质，并开始过度出汗。在这种状态下，他们逃脱任何网或陷阱都会更加容易。记得带一条毛巾。";
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
				text = "始终能够成功摆脱困住效果，例如来自网或根的效果。"
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

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isGoblinShamanPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGoblinShamanPotionAcquired", false);
	}

});
