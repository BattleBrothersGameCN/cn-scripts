this.blacksmith_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.blacksmith";
		this.m.Name = "铁匠";
		this.m.Description = "佣兵擅长破坏武器摧毁铠甲，论起维修保养却是外行。铁匠可以高效快速地完成这些繁琐工作，甚至能修复一些本要报废的装备。";
		this.m.Image = "ui/campfire/blacksmith_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"即使因死亡导致装备损坏或遗失，也能回收你手下所有穿戴的装备。",
			"提升20%的修理速度。",
			"工具消耗减少20%"
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
		this.World.Assets.m.RepairSpeedMult *= 1.2;
		this.World.Assets.m.ArmorPartsPerArmor *= 0.8;
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
