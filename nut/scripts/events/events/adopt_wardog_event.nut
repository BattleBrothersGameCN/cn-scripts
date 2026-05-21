this.adopt_wardog_event <- this.inherit("scripts/events/event", {
	m = {
		Bro = null,
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.adopt_wardog";
		this.m.Title = "在途中……";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_27.png[/img]之前你就看到了这条狗，一连走了几里地，它还跟在后边晃来晃去。\n\n这样的杂种狗不会无缘无故地跟着一群危险人物——它是不是被人养过？",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "赶走它！",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "趁补给没被偷走，赶快放倒它。",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 60)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "战团需要只吉祥物，带上它。",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 75)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Houndmaster != null)
				{
					this.Options.push({
						Text = "%houndmaster%，你是对付狗的行家，没错吧？",
						function getResult( _event )
						{
							return "G";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_75.png[/img]你们可没地方养狗。当那条狗再次出现时，你一块石头精准命中它的眉心。狗哀嚎着逃开，接着停下脚步，似乎以为这是个误会，但你立刻用另一块石头纠正了它的想法。那条狗离开后再未出现。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "滚远点！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_75.png[/img]你取弓搭箭。几个兄弟看着你瞄准。虽然射空了，但狗识趣地跑开了。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我是想吓跑它。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_27.png[/img]你取弓搭箭。几个兄弟看着你瞄准。风时起时息，你耐心地等待着机会，然后拉弦，闭上一只眼睛瞄准那只狗。而那只狗则大口喘息，坐着那边盯着你。\n\n你松开弓弦，羽箭呼啸而去。只见那狗惨叫一声，后腿一晃，摔倒在地上。它挣扎着用腿在地上踢来踢去，直到失去了生命。你收好弓箭，让战团继续赶路。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "可怜的家伙。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_27.png[/img]你决定拿起一块肉并走向那条狗。它起初有些胆怯，在你接近时向后退缩，但你手中食物的香气确实令人难以抗拒。这条杂种狗走一步停一步地缓缓挪到你的身旁，眼睛警惕地扫视四周，提防着可能的陷阱。\n\n你能看到狗身上嶙峋的肋骨——连日奔波让这只狗身形瘦削。它的耳朵有伤口缝合的痕迹，尾巴上挂满了战斗的痕迹。这只动物知道如何战斗，而从现在起它将为你而战。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "欢迎加入战团。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "战犬兄弟";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_37.png[/img]它这样结实的狗能当个不错的吉祥物。这小家伙肯定能提振士气。你命令%bro%喂它些食物，希望它能跟着队伍。他拿着一块剩肉走出去，蹲下身来。%SPEECH_ON%乖狗狗。%SPEECH_OFF%这杂种狗先嗅了嗅食物，随即猛地一口咬下——佣兵的手也被一齐咬下。兄弟急忙后跳，将手臂紧紧蜷在胸前，仿佛稍慢片刻就会连前臂一起失去。而那条狗则吞下碎肉，转身跑远了。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "该死，他本该能合得来的。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro.getImagePath());
				local injury = _event.m.Bro.addInjury(this.Const.Injury.FeedDog);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Bro.getName() + " 遭受 " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_27.png[/img]你问驯犬师%houndmaster%能否试着和狗“交流”。他点头朝它走去。这只野狗的耳朵尖尖的竖了起来。驯犬师蹲着，慢慢地向这只动物挪去。他伸出手，把一块肉放在手心里。饥饿战胜了谨慎，狗嗅着鼻子逐渐接近了驯犬师的手。狗用舌头舔出那块肉，狼吞虎咽地吃了下去。驯犬师又喂了一块肉。他抓着它的颈头，找到了它耳后的舒适点。%houndmaster%回头望去，点了点头。%SPEECH_ON%嗯，这家伙通人性，容易驯服。%SPEECH_OFF%这太好了。你问它能否参加战斗。驯犬师抿着嘴。%SPEECH_ON%狗就像人一样。只要还有一口气，就能战斗。%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "很好。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "战犬兄弟";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Forest || currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.LeaveForest || currentTile.Type == this.Const.World.TerrainType.Mountains)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.houndmaster")
			{
				candidates.push(bro);
			}
		}

		this.m.Bro = brothers[this.Math.rand(0, brothers.len() - 1)];

		if (candidates.len() != 0)
		{
			this.m.Houndmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bro",
			this.m.Bro.getName()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster != null ? this.m.Houndmaster.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Bro = null;
		this.m.Houndmaster = null;
	}

});
