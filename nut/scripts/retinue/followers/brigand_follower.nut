this.brigand_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.brigand";
		this.m.Name = "强盗";
		this.m.Description = "这位强盗或许已经年迈力衰，却也曾在这片土地上威震一时。为了一顿热饭，他很愿意与你分享他从联系人那里得来的商队情报。";
		this.m.Image = "ui/campfire/brigand_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"使你能随时看到一些商队的位置，即便它们在你的视野范围之外"
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
		this.World.Assets.m.IsBrigand = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "袭击" + this.Math.min(4, this.World.Statistics.getFlags().getAsInt("CaravansRaided")) + "/4队车队";

		if (this.World.Statistics.getFlags().getAsInt("CaravansRaided") >= 4)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
