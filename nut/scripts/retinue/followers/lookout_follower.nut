this.lookout_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.lookout";
		this.m.Name = "观察员";
		this.m.Description = "拥有一名行动迅速目光敏锐的观察员在战团前面探路，在其他人察觉到战团之前意识到危险，包括利益地点的发现都是极有用的。";
		this.m.Image = "ui/campfire/lookout_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"增加你的视野25%",
			"显示有关足迹的扩展信息"
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
		this.World.Assets.m.VisionRadiusMult = 1.250000;
		this.World.Assets.m.IsShowingExtendedFootprints = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "发现" + this.Math.min(10, this.World.Statistics.getFlags().getAsInt("LocationsDiscovered")) + "/10个地点（独自完成）";

		if (this.World.Statistics.getFlags().getAsInt("LocationsDiscovered") >= 10)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
