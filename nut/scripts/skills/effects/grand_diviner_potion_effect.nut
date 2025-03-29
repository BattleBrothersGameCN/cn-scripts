this.grand_diviner_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.grand_diviner_potion";
		this.m.Name = "Cursed Sight";
		this.m.Icon = "skills/status_effect_152.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_152";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "This character has seen things not meant to be seen and draws upon an experience that is not their own. You can glimpse the unfettered terror on their face in those rare moments you catch them alone. Or maybe that\'s just the pressures of mercenary life finally getting to them.";
	}

	function onDeath()
	{
		this.World.Statistics.getFlags().set("isGrandDivinerPotionAcquired", false);
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGrandDivinerPotionAcquired", false);
	}

});
