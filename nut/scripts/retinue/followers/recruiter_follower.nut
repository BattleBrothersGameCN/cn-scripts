this.recruiter_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.recruiter";
		this.m.Name = "征募员";
		this.m.Description = "征募员是个花言巧语的大忽悠，他会向那些绝望的人许诺，当上雇佣兵就能脱离贫困生活，从而把他们骗进佣兵团，但通常等待他们的只有死亡。经营佣兵团的人用得上他。";
		this.m.Image = "ui/campfire/recruiter_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"使新人雇佣费减少10%，测验费减少50%",
			"每个定居点待招募的新兵增加2到4人"
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
		this.World.Assets.m.HiringCostMult *= 0.9;
		this.World.Assets.m.TryoutPriceMult *= 0.5;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "招募" + this.Math.min(12, this.World.Statistics.getFlags().getAsInt("BrosHired")) + "/12人";

		if (this.World.Statistics.getFlags().getAsInt("BrosHired") >= 12)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
