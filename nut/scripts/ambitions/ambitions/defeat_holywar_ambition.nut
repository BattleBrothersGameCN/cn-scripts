this.defeat_holywar_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_holywar";
		this.m.Duration = 99999.000000 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "宗教动乱之火威胁着要吞噬这片土地。 \n让我们的战团在热火中锻炼得比以往任何时候都强大，并通过赢得战争来赚取财富！";
		this.m.UIText = "结束南北战争";
		this.m.TooltipText = "选择北方贵族家族或南方城邦，与他们合作，赢得他们的圣战。 每摧毁一支军队，每履行一分合同，都将加速战争的结束。";
		this.m.SuccessButtonText = "不管他们是喜欢我们还是憎恨我们，但现在每个人都知道%companyname%！";
	}

	function getUIText()
	{
		local f = this.World.FactionManager.getGreaterEvil().Strength / this.Const.Factions.GreaterEvilStartStrength;
		local text;

		if (f >= 0.950000)
		{
			text = "战争初始";
		}
		else if (f >= 0.500000)
		{
			text = "战况激烈";
		}
		else if (f >= 0.250000)
		{
			text = "陷入胶着";
		}
		else
		{
			text = "接近尾声";
		}

		return this.m.UIText + " (" + text + ")";
	}

	function getSuccessText()
	{
		local north = 0;
		local south = 0;
		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0)
				{
					if (this.World.FactionManager.getFaction(v.getFaction()).getType() == this.Const.FactionType.NobleHouse)
					{
						north = ++north;
					}
					else
					{
						south = ++south;
					}
				}
			}
		}

		if (north >= south)
		{
			return "[img]gfx/ui/events/event_92.png[/img]{你呼吸的空气，你脚下的地面，都感觉不到丝毫不同。 然而在你的周围却有北方人群的欢乐，仿佛每个灵魂都得偿所愿。 你已经得到消息，南方人已经让步，派出鸽派谈判者，结束了北方占优的圣战。 相对的，北方将占领圣地，并允许南方人进入，只要他们承认他们的“镀金者”只是古代众神神殿中的一个。 一个年轻女孩带着一朵花向你走来。%SPEECH_ON%他们说的是骑士和英雄，但我亲眼见过你。 你朝这里去，好消息来了，你又朝那里去，更多的好消息来了。 就好像你是上天派来的，是古代诸神的右手。%SPEECH_OFF%你感谢那个女孩，她转身跑开了。%randombrother% 撅着嘴走向你。%SPEECH_ON%他们对上天派来的使者的尊敬就只值得一朵破花吗？%SPEECH_OFF%}";
		}
		else
		{
			return "[img]gfx/ui/events/event_171.png[/img]{你看到伟大的镀金者的追随者成群结队地涌向圣地，整个大地都摆脱了宗教战争的枷锁，圣战最终以南方占据上风而告终。 据你所知，维齐尔强制执行了一条规定，北方人可以访问圣地，但必须向监管这些领土的总督纳税。 这是一个吝啬的结果，尽管不是一个特别暴力和报复性的结果。\n\n当你盘点你的库存时，十几位老人沿路走来，在你面前停了下来。 他们自称是记录圣战伟大回忆的文士和历史学家。 显然有人把你指给他们了，但他们不完全确定你是谁。 你解释说维齐尔雇你来－%SPEECH_ON%你说是雇佣的？难道说，你是逐币者？%SPEECH_OFF%其中一个老人打断了你，他的羽毛笔突然停了下来。 他摇了摇头。%SPEECH_ON%不不不，我们是在记录那些让神圣之地回归镀金者之光的人的成功。 你是一个畏首畏尾的机会主义者，毫无疑问还是阴险的逐币者。 祝你过得愉快。%SPEECH_OFF%他们在你还没来得及反驳之前就离开了，尽管你怀疑，如果你真的想要说道说道，你可能已经拿出铁家伙来对付他们了。%randombrother% 走上前来，问你他们是谁。你耸耸肩。%SPEECH_ON%籍籍无名之辈罢了。%SPEECH_OFF%}";
		}
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1500)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.FactionManager.getGreaterEvil().Type == 0 && this.World.FactionManager.getGreaterEvil().LastType == 4)
		{
			return true;
		}

		this.World.Ambitions.updateUI();
		return false;
	}

	function onPrepareVariables( _vars )
	{
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
