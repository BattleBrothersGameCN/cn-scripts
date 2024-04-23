this.paymaster_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.paymaster";
		this.m.Name = "出纳员";
		this.m.Description = "出纳员负责所有日常财务和组织方面的事务, 如支付工资。";
		this.m.Image = "ui/campfire/paymaster_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"每人每日工资减少15%",
			"减少50%的逃兵几率",
			"阻止你的人要求更高报酬的事件出现"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function isVisible()
	{
		return this.World.Assets.getBrothersMax() >= 16;
	}

	function onUpdate()
	{
		this.World.Assets.m.DailyWageMult *= 0.850000;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "有" + this.Math.min(16, this.World.getPlayerRoster().getSize()) + "/16名队员登记在册";

		if (this.World.getPlayerRoster().getSize() >= 16)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
