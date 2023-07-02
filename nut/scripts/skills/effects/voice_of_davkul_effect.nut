this.voice_of_davkul_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.voice_of_davkul";
		this.m.Name = "达库尔的声音";
		this.m.Description = "这个角色通过他的血肉信道真实的听到了达库尔的声音。 他已经准备好超越他身体的极限去听从神的命令。";
		this.m.Icon = "skills/status_effect_112.png";
		this.m.IconMini = "status_effect_112_mini";
		this.m.Overlay = "status_effect_112";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		actor.setFatigue(this.Math.max(0, actor.getFatigue() - 10));
		this.spawnIcon(this.m.Overlay, actor.getTile());
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

});
