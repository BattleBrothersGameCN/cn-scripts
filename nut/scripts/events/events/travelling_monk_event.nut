this.travelling_monk_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.travelling_monk";
		this.m.Title = "在路上……";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A1",
			Text = "[img]gfx/ui/events/event_40.png[/img]你在路上遇到了一个僧侣，和他在一起的是一辆驴拉的车，这可怜的驮畜无精打采地低着头。刚割完的金雀花杆和碧绿的苔藓挂在车的一侧，两者都在在吹干它们的风中急切地扭动着，一些锅碗瓢盆像乡村的风铃一样发出咔哒声，随着这辆简陋的货车慢悠悠地停下来。一个桶子在车板的边缘摇摇晃晃，一对蜜蜂摇摇摆摆地想跟上来，因极大的好奇心在桶的裂缝里戳来戳去。\n\n那僧侣把一顶羊毛帽从他的脸上抬起，但帽檐又垂落到他的眼睛上。他马上完全摘下帽子，然后用袖子擦了擦他的眉毛。带着惬意的微笑，似乎一点也不为眼前真正的人形军械库所困扰。%SPEECH_ON%晚上好先生们。我猜你们不是那种会在领主的旗帜下行军的人。对我来说你们看起来像是雇佣兵。%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "你带着什么？",
					function getResult( _event )
					{
						return "A2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_40.png[/img]%SPEECH_ON%啊，我正想着你们会问。这位是贝西，给驴屁股起的奶牛名字。别担心，她不会踢你的。她已经疲惫不堪了，你看吧？她驮着的，好吧，是啤酒。给远方的人们喝，好叫他们为天上的人干杯。如果你们不介意，或者如果不介意我的事，我想继续上路了。%SPEECH_OFF%僧侣握紧了他的母驴的缰绳，他已经准备好要出发了。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "要来一轮啤酒得花多少钱？",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "D";
					}

				},
				{
					Text = "我们保护道路安全，这些是我们应得的 —— 拿走啤酒，兄弟们！",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_40.png[/img]你举起你的手，在僧侣再次上路之前拦下了他。他叹了口气，慢慢地放下了手中的缰绳。你感觉到他好像会错了你的意，因此你马上问他有没有些啤酒能够分给你的人。你很乐意付钱。僧侣回头看了看他的存货，然后转过身来。%SPEECH_ON%行。我给你的人一小口一克朗，或者两克朗。别在意绕着顶上转悠的蜜蜂，你来的时候它们很快就会跑了，但是如果当它们跑了的时候你跑了，它们就会快速地追着你跑。奇怪的小家伙。%SPEECH_OFF%你问他他想要多少。%SPEECH_ON%我敢打赌一人十克朗就够了。虽然我不是商人，但我可能在自己身上占便宜了。%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "给整个战团都来一轮！",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "你要的太多了。",
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
			Text = "[img]gfx/ui/events/event_40.png[/img]你同意付他所要的钱，他张开手臂表示邀请。你的人打开桶盖，把杯子浸进去。他们坐到了树荫下，抿着小酒杯，交换着啤酒。僧侣向你告别，你的人们高声地举起杯子给他喝彩，声音越来越含糊不清。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "干杯！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-10 * this.World.getPlayerRoster().getSize());
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "你花费了 [color=" + this.Const.UI.Color.NegativeEventValue + "]" + 10 * this.World.getPlayerRoster().getSize() + "[/color] 克朗"
					}
				];
				this.List.extend(_event.giveTraits(90));
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_40.png[/img]你举起了你的手，在僧侣再次上路之前拦下了他。 他叹了口气，慢慢地放下了手中的缰绳。 你感觉到他好像会错了你的意，因此你马上问他有没有些啤酒能够分给你的人。 你很乐意付钱。 僧侣回头看了看他的存货，然后转了过来。%SPEECH_ON%是啊。如果上帝不高兴我拿你的钱，那就去他的吧。 如果你打了一场好仗，那么我请你免费喝一些，但肯定不是全部。%SPEECH_OFF%你谢过了僧侣的慷慨，并且命令你的人喝的时候都诚实一点。 当几个兄弟围在桶边的时候，僧侣举起了他的手。%SPEECH_ON%别在意绕着顶上转悠的蜜蜂，你来的时候它们很快就会跑了，但是如果当它们跑了的时候你跑了，它们就会快速地追着你跑。奇怪的小家伙。%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "干杯！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveTraits(90);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_40.png[/img]当马车摇晃经过时，你抓住剑柄，猛力敲击酒桶，盖子被弹开，让一群蜜蜂陷入疯狂。那个僧侣放开缰绳，回头看着你。%SPEECH_ON%我就在担心你会这么做。%SPEECH_OFF%这个人被你一拳击倒，他的身体扭曲着倒在地上。几个兄弟冲上去朝他踢了几脚，其他人拿起酒桶把它们移到阴凉处。你将一个杯子伸入酒桶，拿起来喝了一口，然后把它举到那个在地上扭动的僧侣面前。%SPEECH_ON%干杯伙计们，别忘了感谢我们那位慷慨的朋友！%SPEECH_OFF%那僧侣翻过身，眼睛急速眨动，他用一只手抓住背部，用另一只手慢慢地站起来。弯着腰，拉住驴的缰绳，开始向前走。他试图把帽子戴回去，但它掉了下来，他也没去捡。那个人在远处变得越来越小，被地平线和酒精弄得模糊不清，然后消失了。\n\n男人们都举起酒杯，向你欢呼，声音越来越含糊不清。",
			Image = "",
			List = [],
			Options = [
				{
					Text = "干杯！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				this.List = _event.giveTraits(66);
			}

		});
	}

	function giveTraits( _chance )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local result = [];

		foreach( bro in brothers )
		{
			if (this.Math.rand(1, 100) <= _chance)
			{
				bro.improveMood(1.0, "与战团一起庆祝了");

				if (bro.getMoodState() >= this.Const.MoodState.Neutral)
				{
					result.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bro.getMoodState()],
						text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
					});
				}
			}
		}

		return result;
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getMoney() <= 10 * this.World.getPlayerRoster().getSize() + 250)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = 8;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A1";
	}

	function onClear()
	{
	}

});
