this.scout_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.scout";
		this.m.Name = "侦察员";
		this.m.Description = "侦察员是寻找隐蔽山口、穿越凶险沼泽和引导人们安全通过茂密森林的专家。";
		this.m.Image = "ui/campfire/scout_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"使战团在任何地形上的旅行速度提高15%",
			"防止地形引起的疾病和意外"
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
			this.World.Assets.m.TerrainTypeSpeedMult[i] *= 1.15;
		}
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "赢得" + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("BeastsDefeated")) + "/5场对抗野兽的战斗";

		if (this.World.Statistics.getFlags().getAsInt("BeastsDefeated") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
