this.agent_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.agent";
		this.m.Name = "事务官";
		this.m.Description = "事务官眼观六路，耳听八方，精通时事，既能用于利用各地事件，也更方便接到高薪合同。";
		this.m.Image = "ui/campfire/agent_01";
		this.m.Cost = 4000;
		this.m.Effects = [
			"在定居点提示栏中显示可用合同和定居点形势，无论你是否在该定居点附近"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "与贵族家族或城邦达到盟友关系"
			}
		];
	}

	function onUpdate()
	{
	}

	function onEvaluate()
	{
		local allied = false;
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

		foreach( n in nobles )
		{
			if (n.getPlayerRelation() >= 90.0)
			{
				this.m.Requirements[0].IsSatisfied = true;
				return;
			}
		}

		local citystates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

		foreach( c in citystates )
		{
			if (c.getPlayerRelation() >= 90.0)
			{
				this.m.Requirements[0].IsSatisfied = true;
				return;
			}
		}
	}

});
