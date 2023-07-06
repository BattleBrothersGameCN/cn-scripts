this.scout_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.scout";
		this.m.Name = "侦察员";
		this.m.Description = "侦察兵是在寻找山口、穿越险恶沼泽和引导任何人安全通过最黑暗的森林方面的专家。";
		this.m.Image = "ui/campfire/scout_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"使战团在任何地形上的旅行速度提高15%",
			"阻止因地形引起的疾病和意外遭遇"
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
		for( local i = 0; i < this.World.Assets.m.TerrainTypeSpeedMult.len(); i = ++i )
		{
			this.World.Assets.m.TerrainTypeSpeedMult[i] *= 1.150000;
		}
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "赢得了" + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("BeastsDefeated")) + "/5场野兽战斗";

		if (this.World.Statistics.getFlags().getAsInt("BeastsDefeated") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
