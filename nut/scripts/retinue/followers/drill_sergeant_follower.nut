this.drill_sergeant_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.drill_sergeant";
		this.m.Name = "教官";
		this.m.Description = "这位教官曾经也是一名雇佣兵，直到伤病提早结束了他的职业生涯。现在，他会把纪律灌输给你的人，吼叫着确保所有人都能从错误中吸取教训。";
		this.m.Image = "ui/campfire/drill_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"使你的人获得更多的经验，1级时为20%，每提高一级就减少2%",
			"使预备队中的角色不会因不能参战而降低心情"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "退役一位身负永久创伤的非负债者队员"
			}
		];
	}

	function onUpdate()
	{
		this.World.Assets.m.IsDisciplined = true;
	}

	function onEvaluate()
	{
		if (this.World.Statistics.getFlags().getAsInt("BrosWithPermanentInjuryDismissed") > 0)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
