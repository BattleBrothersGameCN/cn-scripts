this.alchemist_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.alchemist";
		this.m.Name = "炼金术士";
		this.m.Description = "炼金术士拥有丰富的知识，可以使用特殊材料制造各种神秘的装置和药剂，只要他有使用制作工具的权限，并且更节省材料。";
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
		this.m.Requirements[0].Text = "在剥制屋里制造 " + this.Math.min(15, this.World.Statistics.getFlags().getAsInt("ItemsCrafted")) + "/15 件物品";

		if (this.World.Statistics.getFlags().getAsInt("ItemsCrafted") >= 15)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
