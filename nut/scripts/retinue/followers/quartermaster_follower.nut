this.quartermaster_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.quartermaster";
		this.m.Name = "军需官";
		this.m.Description = "凭借多年的商队旅行经验，军需官能够将任何装备、行李或盔甲挤压和旋转到最佳位置，尽可能有效地利用空间。";
		this.m.Image = "ui/campfire/quartermaster_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"增加你可以携带的弹药量100",
			"增加你可以携带的医疗用品和工具数量各50个"
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
		this.World.Assets.m.AmmoMaxAdditional = 100;
		this.World.Assets.m.MedicineMaxAdditional = 50;
		this.World.Assets.m.ArmorPartsMaxAdditional = 50;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "完成护送商队合同" + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("EscortCaravanContractsDone")) + "/5次";

		if (this.World.Statistics.getFlags().getAsInt("EscortCaravanContractsDone") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});
