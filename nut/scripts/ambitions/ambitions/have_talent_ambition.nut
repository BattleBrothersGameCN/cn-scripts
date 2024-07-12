this.have_talent_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_talent";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们需要真正的人才来进一步加强我们的队伍。我们\n会招募我们能找到的最有才华的人，把他塑造成战神！";
		this.m.UIText = "拥有一名同时具有三个三星天赋的角色";
		this.m.TooltipText = "将一名拥有三个不同属性三星天赋的角色招入你的麾下。走遍天下，寻找精英中的精英。可以考虑雇佣非战斗追随者中的“征募员”。";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]矿工在山里挖到的钻石，会被急着送进王宫。渔夫一天里最肥的渔获，会被贵族占为己有。好士兵？成了领主手下的将军或教官。好裁缝？最好的衣服要用最好的手艺，他要为贵族服务。除了拍鼻子和喊出命令以外还有别的手艺？这样的驯犬师要为贵族军队训练战犬。这个世界抓住天才的速度，就像老鹰扑向现身的兔子。\n\n不过你已经抓到了自己的猎物：%star%。他是个真正的天才，在身体、军事技能和勇气方面都展现出了非凡的才能。即使是%companyname%的其他人，也能感觉到这个人的与众不同，毫无疑问，就像人能感觉到命运和伟大一样。%star%满足了你对雇佣兵的所有需求，如果战团里全是他这样的人，你肯定不会止步于接受合同，而是会征服整个世界！";
		this.m.SuccessButtonText = "除非，他下场战斗就被流矢射中。";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.getTime().Days <= 100)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax() - 1)
		{
			return;
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local n = 0;

			foreach( t in bro.getTalents() )
			{
				if (t == 3)
				{
					n = ++n;
				}
			}

			if (n >= 3)
			{
				return;
			}
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local n = 0;

			foreach( t in bro.getTalents() )
			{
				if (t == 3)
				{
					n = ++n;
				}
			}

			if (n >= 3)
			{
				return true;
			}
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local roster = this.World.getPlayerRoster().getAll();
		local star;

		foreach( bro in roster )
		{
			local n = 0;

			foreach( t in bro.getTalents() )
			{
				if (t == 3)
				{
					n = ++n;
				}
			}

			if (n >= 3)
			{
				star = bro;
				break;
			}
		}

		_vars.push([
			"star",
			star.getName()
		]);
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});
