this.surgeon_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.surgeon";
		this.m.Name = "外科医生";
		this.m.Description = "这位外科医生是解剖学知识的行家。雇佣兵战团似乎是一个完美的地方，既可以将这些知识应用于治疗，也可以更多地了解人类的内部构造。";
		this.m.Image = "ui/campfire/surgeon_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"使每一个没有永久性损伤的人都能在致命的打击中幸存下来",
			"使每一个损伤的治愈时间都减少一天"
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
		this.m.Requirements[0].Text = "处理完成了 (Treated)" + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("InjuriesTreatedAtTemple")) + "/5 名男子在寺庙受伤";

		if (this.World.Statistics.getFlags().getAsInt("InjuriesTreatedAtTemple") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
