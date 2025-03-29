this.lesser_flesh_golem_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.lesser_flesh_golem_potion";
		this.m.Name = "Bizarre Steroid";
		this.m.Icon = "skills/status_effect_155.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_155";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "This character\'s body has changed, arguably for the better, due to the application of an unnatural steroid.";
	}

	function onUpdate( _properties )
	{
	}

	function onDeath()
	{
		this.World.Statistics.getFlags().set("isLesserFleshGolemPotionAcquired", false);
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isLesserFleshGolemPotionAcquired", false);
	}

});
