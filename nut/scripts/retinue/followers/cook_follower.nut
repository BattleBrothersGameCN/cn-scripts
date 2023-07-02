this.cook_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.cook";
		this.m.Name = "厨师";
		this.m.Description = "一顿热腾腾的饭菜对于恢复身心健康有很大帮助。 队长会确保没有粮食浪费，并为士兵们提供有力的补给。";
		this.m.Image = "ui/campfire/cook_01";
		this.m.Cost = 2000;
		this.m.Effects = [
			"使所有的食物能多维持3天",
			"增加33%的生命值治愈速度"
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
		this.World.Assets.m.FoodAdditionalDays = 3;
		this.World.Assets.m.HitpointsPerHourMult = 1.330000;
	}

	function onEvaluate()
	{
		local uniqueProvisions = this.getAmountOfUniqueProvisions();
		this.m.Requirements[0].Text = "有" + this.Math.min(8, uniqueProvisions) + "/8 种不同类型的口粮";

		if (uniqueProvisions >= 8)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

	function getAmountOfUniqueProvisions()
	{
		local provisions = [];
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (provisions.find(item.getID()) == null)
				{
					provisions.push(item.getID());
				}
			}
		}

		return provisions.len();
	}

});
