this.adopt_wardog_event <- this.inherit("scripts/events/event", {
	m = {
		Bro = null,
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.adopt_wardog";
		this.m.Title = "在途中……";
		this.m.Cooldown = 120.000000 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_27.png[/img]你发现几英里前看到的那条图狗仍然鬼鬼祟祟地跟在后面，在你的视线范围内时隐时现。\n\n像它这样的杂种狗，不会无缘无故地跟着一群危险的佣兵－也许有人在指挥它？",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "把那杂种狗赶走！",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "最好现在就放倒它，以免它以后来偷我们的补给。",
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
					Text = "战团需要一只吉祥物，带上它。",
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
						Text = "%houndmaster%，你受过驯养狗的训练，对吗？",
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
			Text = "[img]gfx/ui/events/event_75.png[/img]这里可不是养狗的地方。 当你又看到了那条狗，便拿起事先准备好的石头狠狠的砸中了它的脑门。 狗吃痛大叫，不由得退却。 呆立在原地，似乎在想自己做错了什么，但你并不给它喘息的机会，又拿起一块石头砸中了它。 狗离开了，再也没有出现过。",
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
			Text = "[img]gfx/ui/events/event_75.png[/img]你取弓搭箭。几个兄弟也看着你瞄准。虽然射空了，但狗识趣地跑开了。",
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
			Text = "[img]gfx/ui/events/event_27.png[/img]你取弓搭箭。几个兄弟也看着你瞄准。风时起时息，你耐心地等待着机会，然后拉弦，闭上一只眼睛瞄准那只狗。而那只狗则大口喘息，坐着那边盯着你。\n\n你松开弓弦，羽箭呼啸而去。只见那狗惨叫一声，后腿一晃，摔倒在地上。它挣扎着用腿在地上踢来踢去，直到失去了生命。你收好弓箭，让战团继续赶路。",
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
			Text = "[img]gfx/ui/events/event_27.png[/img]你决定拿起一块肉并走向那条狗。它一开始有点不安，在你靠近的时候后退，但是你手上的香气的确很诱人。 杂种狗走一步停一步地缓缓挪到你的身旁，眼神闪烁着寻找周围潜藏的陷阱。\n\n你能看到狗身上嶙峋的肋骨，在路上的许多天让这只狗变得憔悴不堪。它的耳朵有缝合的伤口，尾巴上挂满了战斗的痕迹。这只动物知道如何战斗，而从现在起它将为你所用。",
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
				item.m.Name = "战斗兄弟(Battle Brother)";
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
			Text = "[img]gfx/ui/events/event_37.png[/img]像他这样粗犷的狗会成为一个伟大的吉祥物。 这只小杂种肯定能鼓舞士气。 你让 %bro% 喂狗，希望它能跟随。 他拿了一点剩菜剩饭，蹲下来喂给狗吃。%SPEECH_ON%好狗狗。%SPEECH_OFF%杂种狗嗅了嗅食物，然后大口大口地吃下去－雇佣兵的手也被咬了下来。 这哥们向后一跳，把胳膊搂在胸口，好像他会失去它一样。 另一方面，狗吞下碎块然后跑掉了。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "该死，他的适应力真强。",
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
			Text = "[img]gfx/ui/events/event_27.png[/img]你问%houndmaster%训犬师能否试着和狗“交流”。他点头朝它走去。这只野生杂种狗的耳朵尖尖的直了起来。训犬师慢慢地蹲着向这只动物挪去。他伸出手，把一块肉放在手心里。饥饿战胜了谨慎，狗嗅着鼻子逐渐接近了驯兽师的手。狗用舌头舔出那块肉，狼吞虎咽地吃了下去。训犬师又喂了一块肉。他抓着它的颈头，找到了它耳后的舒适点。%houndmaster%回头望去，点了点头。%SPEECH_ON%是的，这是一头讨人喜欢的野兽，很容易被驯服。%SPEECH_OFF%这太好了。你问它能否参加战斗。训犬师抿着嘴。%SPEECH_ON%狗就像人一样。只要能呼吸，就能战斗。%SPEECH_OFF%",
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
				item.m.Name = "战斗兄弟(Battle Brother)";
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
