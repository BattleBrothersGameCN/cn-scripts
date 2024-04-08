this.brigand_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.brigand";
		this.m.Name = "强盗";
		this.m.Description = "这个强盗现在可能已经年迈力衰，但他早年的名字曾经在这片土地上威震一时。为了一顿热饭，他愉快地与你分享他从联系人那里了解到的关于路上押运队的情报。";
		this.m.Image = "ui/campfire/brigand_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"使你能随时看到一些商队的位置，即使在你的视野之外"
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
		this.m.Requirements[0].Text = "袭击" + this.Math.min(4, this.World.Statistics.getFlags().getAsInt("CaravansRaided")) + "/4 贸易队";

		if (this.World.Statistics.getFlags().getAsInt("CaravansRaided") >= 4)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
