this.visit_settlements_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.visit_settlements";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我知道你们现在闲得发慌，我们应该\n宣传咱们的战团。走遍每一处定居点！";
		this.m.UIText = "拜访每一座城镇与城堡";
		this.m.TooltipText = "拜访每一座村落、城镇、据点和城堡，了解当地的商品与服务设施，为战团做推广。";
		this.m.SuccessText = "[img]gfx/ui/events/event_16.png[/img]你很快发现斯卡德尔（注：古代北欧诗人）所唱的旅行热情并不像他们说的那样普遍。你决定让战团长长见识，但是这项决定却引起了不满，人们开始抱怨强行军和辗转夜路。不过并不是所有人都参与抱怨。%SPEECH_ON%如果一天的行军或一夜的雨水就能让你筋疲力尽，你如何面对兽人的攻击？%SPEECH_OFF%%sergeantbrother%问道，却被骂了回来。%SPEECH_ON%保持干燥，注意警戒。%SPEECH_OFF%你催促他们前进。每到一座村庄或城镇，你都会鼓励手下的人，让他们出出名，看起来他们确实听进去了，打架斗殴，在镇广场上喝得烂醉，恐吓商人，骚扰本地女孩。无论这些倒霉商人和农民怎么看待你的战团，至少他们一时半会是忘不了你了！探索了地图的边缘后，%companyname%的名字更广为人知，你对这片土地的了解也更深入了。";
		this.m.SuccessButtonText = "记好了，我们是“%companyname%”！";
	}

	function getTooltipText()
	{
		if (this.World.Ambitions.getActiveAmbition() == null)
		{
			return this.m.TooltipText;
		}
		else if (!this.onCheckSuccess())
		{
			local ret = this.m.TooltipText + "\n\n还有一些定居点要拜访。\n";
			local c = 0;
			local settlements = this.World.EntityManager.getSettlements();

			foreach( s in settlements )
			{
				if (!s.isVisited())
				{
					c = ++c;

					if (c <= 10)
					{
						ret = ret + ("\n- " + s.getName());
					}
					else
					{
						ret = ret + "\n... 以及更多!";
						break;
					}
				}
			}

			return ret;
		}
		else
		{
			local ret = this.m.TooltipText + "\n\n你已经完成了你打算做的事。\n";
			return ret;
		}
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() == 0 && (this.World.Assets.getOrigin().getID() != "scenario.deserters" || this.World.Assets.getOrigin().getID() != "scenario.raiders"))
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		local settlements = this.World.EntityManager.getSettlements();
		local notVisited = 0;

		foreach( s in settlements )
		{
			if (!s.isVisited())
			{
				notVisited = ++notVisited;
			}
		}

		if (notVisited < 4)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local notVisited = 0;

		foreach( s in settlements )
		{
			if (!s.isVisited())
			{
				notVisited = ++notVisited;
			}
		}

		if (notVisited == 0)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local bestBravery = 0;
		local bravest;

		if (brothers.len() > 1)
		{
			for( local i = 0; i < brothers.len(); i = ++i )
			{
				if (brothers[i].getSkills().hasSkill("trait.player"))
				{
					brothers.remove(i);
					break;
				}
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getCurrentProperties().getBravery() > bestBravery)
			{
				bestBravery = bro.getCurrentProperties().getBravery();
				bravest = bro;
			}
		}

		_vars.push([
			"sergeantbrother",
			bravest.getName()
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
