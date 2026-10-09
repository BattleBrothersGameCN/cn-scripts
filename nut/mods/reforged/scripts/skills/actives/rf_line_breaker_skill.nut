this.rf_line_breaker_skill <- ::inherit("scripts/skills/actives/line_breaker", {
	m = {
		RequiresShield = true
	},
	function create()
	{
		this.line_breaker.create();
		this.m.ID = "actives.rf_line_breaker";
		this.m.Name = "破阵者";
		this.m.Description = "用一次行动击退一名目标并占据其位置，突破敌人防线。";
		this.m.Icon = "skills/rf_line_breaker_skill.png";
		this.m.IconDisabled = "skills/rf_line_breaker_skill_sw.png";
		this.m.Overlay = "rf_line_breaker_skill";
		this.m.SoundOnUse = [
			"sounds/combat/indomitable_01.wav",
			"sounds/combat/indomitable_02.wav"
		];
		this.m.IsSerialized = false;
		this.m.FatigueCost = 25;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.LineBreaker;
	}

	function isUsable()
	{
		local actor = this.getContainer().getActor();
		return this.line_breaker.isUsable() && (!this.m.RequiresShield || actor.isArmedWithShield()) && !actor.getCurrentProperties().IsRooted && !actor.getCurrentProperties().IsStunned;
	}

});
