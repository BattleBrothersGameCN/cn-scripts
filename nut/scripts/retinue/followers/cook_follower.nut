this.cook_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.cook";
		this.m.Name = "厨师";
		this.m.Description = "一顿热腾腾的饭菜对于恢复身心健康有很大帮助。厨师会确保粮食不被浪费，并用良好的膳食使你的人焕发精神。";
		this.m.Image = "ui/campfire/cook_01";
		this.m.Cost = 2000;
		this.m.Effects = [
			"使所有食物能多保存3天",
			"每小时生命值恢复增加1点。"
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
		this.World.Assets.m.AdditionalHitpointsPerHour += 1;
	}

	function onEvaluate()
	{
		local uniqueProvisions = this.getAmountOfUniqueProvisions();
		this.m.Requirements[0].Text = "有" + this.Math.min(8, uniqueProvisions) + "/8种不同类型的口粮";

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
