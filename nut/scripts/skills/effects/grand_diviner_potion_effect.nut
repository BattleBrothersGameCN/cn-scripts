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
		return "这个角色目睹了本不该被看见的事物，汲取了不属于自己的经历。在他们独处的罕见时刻，你可以在他们脸上瞥见无拘无束的恐惧。又或许，这只是雇佣兵生活的压力终于压垮了他们。";
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
