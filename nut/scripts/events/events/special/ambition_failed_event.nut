this.ambition_failed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ambition_failed";
		this.m.Title = "露营时……";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%randombrother%抱怨道。%SPEECH_ON%放弃可不是我们战团的作风，至少我原以为不是。%SPEECH_OFF%今天士兵们一直无精打采，要么为些鸡毛蒜皮的事破口大骂，要么对着酒杯喃喃自语。他们对战团未能实现既定的共同目标感到不满。%SPEECH_ON%我们大可以满世界追寻自己定下的目标——整天像扑蝴蝶一样乱跑，但既然事不可为，不如把这份霉运抛在脑后，回归我们最擅长的事：打仗、喝酒、挥霍辛苦挣来的血汗钱！%SPEECH_OFF%%highestexperience_brother%这样鼓舞着他的战友们。这番话稍稍平息了众人的情绪，你也庆幸避免了一场哗变。 | 正当你巡视营地帐篷时，%randombrother%前来抱怨。%SPEECH_ON%我明明记得自己加入的是支铁血无畏的战团，应该破除一切实现目标的阻碍。可现在%companyname%感觉更像群疲惫的孩子，而不是所向披靡的部队。%SPEECH_OFF%他顿了顿，咬住嘴唇。%SPEECH_ON%是吧，长官。%SPEECH_OFF%你点头示意后继续巡视。显然，此人对战团未能实现你不久前宣布的目标感到失望。 | 尽管竭尽全力，你还是未能在战团的崛起之路上实现最近的抱负。更糟的是，士兵们都清楚地意识到了这点，而且似乎比你更受挫败感困扰。脚步拖沓，垂头丧气，怨声载道不绝于耳。\n\n不过太阳照常升起，沉湎于失败无异于浪费本可把握新机遇的时光。你深知%companyname%的战士终将渡过这次挫折，向着更辉煌的胜利进军——要么就在尝试中壮烈牺牲。  | 历经诸多拼搏与努力，你最终不得不放弃为%companyname%选定的目标。佣兵战团的荣耀之路必然布满荆棘，但此次半途而废尤其令团员们感到苦闷。眼下最明智之举，要么是接下一笔丰厚合约，要么是找些其他事由——比如迫在眉睫的生命威胁——来转移他们对失利现状的不满。 | 当你宣布战团无法完成当初豪言壮语立下的目标时，众人的表情顿时变得阴郁沮丧。他们像闹别扭的孩子般在你靠近时扭头不理，又趁你转身时低声抱怨。要是%SPEECH_ON%总半途而废，我们怎么名扬四海？我想到哪儿都有人认得我们，连酒馆都会提前备好我们的酒！%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{世事很难尽如人意。 | 罢了。 | 兄弟们会理解的。 | %companyname%的脚步不会因此停下。 | 重要的是我们仍在前进。 | 新的挑战在等着我们。}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(this.Const.MoodChange.AmbitionFailed, "怀疑你的领导能力");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local lowest_hiretime = 100000000.0;
		local lowest_hiretime_bro;
		local highest_hiretime = -9999.0;
		local highest_hiretime_bro;
		local highest_bravery = 0;
		local highest_bravery_bro;
		local lowest_hitpoints = 9999;
		local lowest_hitpoints_bro;

		foreach( bro in brothers )
		{
			if (bro.getHireTime() < lowest_hiretime)
			{
				lowest_hiretime = bro.getHireTime();
				lowest_hiretime_bro = bro;
			}

			if (bro.getHireTime() > highest_hiretime)
			{
				highest_hiretime = bro.getHireTime();
				highest_hiretime_bro = bro;
			}

			if (bro.getCurrentProperties().getBravery() > highest_bravery)
			{
				highest_bravery = bro.getCurrentProperties().getBravery();
				highest_bravery_bro = bro;
			}

			if (bro.getHitpoints() < lowest_hitpoints)
			{
				lowest_hitpoints = bro.getHireTime();
				lowest_hitpoints_bro = bro;
			}
		}

		_vars.push([
			"highestexperience_brother",
			lowest_hiretime_bro.getName()
		]);
		_vars.push([
			"strongest_brother",
			lowest_hiretime_bro.getName()
		]);
		_vars.push([
			"lowestexperience_brother",
			highest_hiretime_bro.getName()
		]);
		_vars.push([
			"bravest_brother",
			highest_bravery_bro.getName()
		]);
		_vars.push([
			"lowesthp_brother",
			lowest_hitpoints_bro.getName()
		]);
		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearest_town_distance = 999999;
		local nearest_town;

		foreach( t in towns )
		{
			local d = t.getTile().getDistanceTo(playerTile);

			if (d < nearest_town_distance)
			{
				nearest_town_distance = d;
				nearest_town = t;
			}
		}

		_vars.push([
			"currenttown",
			nearest_town.getName()
		]);
		_vars.push([
			"nearesttown",
			nearest_town.getName()
		]);
	}

	function onClear()
	{
	}

});
