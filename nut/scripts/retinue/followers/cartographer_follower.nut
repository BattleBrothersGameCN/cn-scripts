this.cartographer_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.cartographer";
		this.m.Name = "制图师";
		this.m.Description = "制图师是个有知识的文化人，但他也明白，与一群装备精良的佣兵一起旅行才是安全探索前人未曾涉足之地的最佳方式。";
		this.m.Image = "ui/campfire/cartographer_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"为每个自主发现的地点支付100到400克朗。离文明越远，你得到的报酬就越多。传奇地点报酬翻倍。"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "发现一个传奇地点"
			}
		];
	}

	function onUpdate()
	{
	}

	function onEvaluate()
	{
		if (this.World.Flags.getAsInt("LegendaryLocationsDiscovered") >= 1)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

	function onLocationDiscovered( _location )
	{
		local settlements = this.World.EntityManager.getSettlements();
		local dist = 9999;

		foreach( s in settlements )
		{
			local d = s.getTile().getDistanceTo(_location.getTile());

			if (d < dist)
			{
				dist = d;
			}
		}

		local reward = this.Math.min(400, this.Math.max(100, 10 * dist));

		if (_location.isLocationType(this.Const.World.LocationType.Unique))
		{
			reward = reward * 2;
		}

		this.World.Assets.addMoney(reward);
	}

});
