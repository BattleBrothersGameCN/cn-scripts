this.recruiter_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.recruiter";
		this.m.Name = "招募者";
		this.m.Description = "招募者是个令人讨厌的口吃之人，他会欺骗那些绝望的人们加入佣兵公司来脱离贫困的生活，结果只能步入死亡。对于任何经营佣兵团的人来说都是非常有用的。";
		this.m.Image = "ui/campfire/recruiter_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"让你在雇佣新人时少支付10%，测验费少50%",
			"让每个定居点可以招募的新兵额外增加2到4人"
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
		this.World.Assets.m.RosterSizeAdditionalMin += 2;
		this.World.Assets.m.RosterSizeAdditionalMax += 4;
		this.World.Assets.m.HiringCostMult *= 0.900000;
		this.World.Assets.m.TryoutPriceMult *= 0.500000;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "已招募" + this.Math.min(12, this.World.Statistics.getFlags().getAsInt("BrosHired")) + "/12名";

		if (this.World.Statistics.getFlags().getAsInt("BrosHired") >= 12)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
