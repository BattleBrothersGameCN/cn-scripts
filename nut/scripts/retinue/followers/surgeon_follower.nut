this.surgeon_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.surgeon";
		this.m.Name = "外科医生";
		this.m.Description = "这位外科医生是人体解剖结构的活百科。在佣兵团里，他既能学以致用救治伤员，又能更深入地了解人体的构造，实在是再理想不过了。";
		this.m.Image = "ui/campfire/surgeon_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"使每个没有永久创伤的人都能在致命打击中幸存下来",
			"使所有创伤的治愈时间减少一天"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function onUpdate()
	{
		this.World.Assets.m.IsSurvivalGuaranteed = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "在神殿治疗伤员" + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("InjuriesTreatedAtTemple")) + "/5次";

		if (this.World.Statistics.getFlags().getAsInt("InjuriesTreatedAtTemple") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
