this.grand_diviner_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.grand_diviner_potion";
		this.m.Name = "诅咒之视";
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
		return "该角色目睹了本不该看见的事物，历经了本不属于他们的经历。在他们少数独处的时间里，你曾瞥见过他们脸上那不加控制的恐惧。或许只是佣兵生活终于把他们压垮了罢了。";
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
