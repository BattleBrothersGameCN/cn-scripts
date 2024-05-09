this.blacksmith_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.blacksmith";
		this.m.Name = "铁匠";
		this.m.Description = "雇佣军很擅长破坏武器和盔甲，但并不擅长维护它们。铁匠能够快速高效地完成这项繁琐的任务，甚至可以修复其他被认为已经损坏的装备。";
		this.m.Image = "ui/campfire/blacksmith_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"修理你手下所有的盔甲、头盔、武器和盾牌，即使它们因为你手下的死亡而破损或丢失",
			"修复速度提高33%"
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
		this.World.Assets.m.RepairSpeedMult *= 1.33;
		this.World.Assets.m.IsBlacksmithed = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "在城镇的铁匠处修复" + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("ItemsRepaired")) + "/5件物品。";

		if (this.World.Statistics.getFlags().getAsInt("ItemsRepaired") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
