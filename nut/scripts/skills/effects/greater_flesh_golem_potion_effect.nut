this.greater_flesh_golem_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.greater_flesh_golem_potion";
		this.m.Name = "突变腺体";
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
		return "该角色的身体发生了不可逆转的突变，过度分泌的腺体使化学平衡陷入了混乱。可以说是奇迹吧，这最终稳定在了一种对身体有益的状态。";
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isGreaterFleshGolemPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGreaterFleshGolemPotionAcquired", false);
	}

});
