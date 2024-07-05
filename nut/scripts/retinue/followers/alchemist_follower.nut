this.alchemist_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.alchemist";
		this.m.Name = "炼金术士";
		this.m.Description = "炼金术士拥有丰富的，用珍奇材料制造装置和合剂的知识，只要能拿到剥制设备，他就能用更少材料做出成品。";
		this.m.Image = "ui/campfire/alchemist_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"有25%的几率不消耗你使用的原料",
			"解锁“蛇油”配方，通过制作各种低层组件来赚钱"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function isValid()
	{
		return this.Const.DLC.Unhold;
	}

	function onUpdate()
	{
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "在剥制屋里制作" + this.Math.min(15, this.World.Statistics.getFlags().getAsInt("ItemsCrafted")) + "/15件物品";

		if (this.World.Statistics.getFlags().getAsInt("ItemsCrafted") >= 15)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
