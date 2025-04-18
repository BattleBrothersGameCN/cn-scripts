this.greater_flesh_golem_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.greater_flesh_golem_potion";
		this.m.Name = "变异腺体";
		this.m.Icon = "skills/status_effect_156.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_156";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "这个角色的身体已经发生了不可逆转的突变，过度分泌的腺体使其化学平衡陷入混乱。然而，奇迹般地，它似乎以一种有益的方式稳定了下来。";
	}

	function onUpdate( _properties )
	{
	}

	function onDeath()
	{
		this.World.Statistics.getFlags().set("isGreaterFleshGolemPotionAcquired", false);
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGreaterFleshGolemPotionAcquired", false);
	}

});
