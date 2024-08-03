this.drill_sergeant_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.drill_sergeant";
		this.m.Name = "教官";
		this.m.Description = "军士长曾经是一名雇佣兵，但伤病使他的职业生涯过早结束。现在，他会训练你的士兵纪律，并大喊大叫以确保每个人都能从自己的错误中学习。";
		this.m.Image = "ui/campfire/drill_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"使你的人在1级时获得20%更多的经验，每提高一级就减少2%",
			"使预备队中的角色不会因不能参战而降低心情"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "退役一位带着永久损伤的非负债者队员"
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
