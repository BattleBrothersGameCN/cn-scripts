this.kraken_cult_enter_event <- this.inherit("scripts/events/event", {
	m = {
		Replies = [],
		Results = [],
		Texts = [],
		Hides = 0,
		Dust = 0,
		IsPaid = false
	},
	function create()
	{
		this.m.ID = "event.location.kraken_cult_enter";
		this.m.Title = "当你接近时……";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Texts.resize(4);
		this.m.Texts[0] = "那么，你是谁？";
		this.m.Texts[1] = "因此你到底知道些什么？";
		this.m.Texts[2] = "你是个十足的疯子。";
		this.m.Texts[3] = "所以, 我怎么能帮上忙？";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_120.png[/img]{你在沼泽中偶然发现一个女人，她独自一人背着背包和长腰篮，上面裹着卷轴，上她的左臀悬挂着一把匕首，右边则放着锅碗瓢盆。附近有一个尚未熄灭的篝火和一堆书套在天鹅绒袜里。她和她所有的东西都被泥地中的绿色植物包围着。她站在那里看着你，你也盯着她看。在沼泽中，一个女人独自在外是不寻常的。她神情怪异地微笑着。%SPEECH_ON%你好。%SPEECH_OFF%你手握剑柄，盯着周围寻找潜伏者。你问她在这条路上做什么，她说你不会相信。你已经看了足够多的东西，相信即使是她所回答的疯狂的话语的痕迹。女人点了点头。%SPEECH_ON%好吧，那么过来吧，我给你看看。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们看一眼。",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "我们很好。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsKrakenCultVisited", true);
				this.World.Flags.set("KrakenCultStage", 0);

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_120.png[/img]{你警告战团要小心湿地中隐藏的无赖，但他们只是笑着说如果你不行，应该去妓院停留。无视他们，你朝这位女子走去。你发现她坐在一根原木上，手里扭着一个蘑菇盖，她讲话相当诚实。%SPEECH_ON%我在寻找一只怪物，无论是真实还是虚幻，对我来说都是个怪物。明白吗？%SPEECH_OFF%从某种程度上来说，你理解了。并不是所有的怪物都是真实存在的，像这样的沼泽女郎可能会疯掉。你问她这个所谓的野兽是什么。她吃了蘑菇，然后拿起一本书，朝你扔了过来。上面插着一片树叶，你打开它。上面画着一只看起来像船只大小的章鱼。它正在与整个海军战斗，似乎甚至能赢。这位女子向前倾身，她的青色瘦弱的手像葛藤一样挂在膝盖之间。%SPEECH_ON%我正在寻找的怪物就是海妖克拉肯。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B0",
			Text = "[img]gfx/ui/events/event_120.png[/img]{女人向后倾斜身体。她吃了另一个蘑菇，转头用匕首刺向正爬过木头的虫子。在不停地嚼动虫壳的同时，她毫不犹豫地从匕首上把虫子吃了，一边吃一边说道。%SPEECH_ON%通常，我会说出更多的详情并且已经将这把匕首指向你的“那玩意儿”，但我觉得你很愿意帮助我，我从你的眼神中看到了这点。你是个杀手、凶手、色狼、爱钱之人和一个疯子。%SPEECH_OFF%女人吞掉了昆虫的残渣，像向日葵籽壳一样吐出它的残骸。她点了点头。%SPEECH_ON%我是一位富有贵族的女儿，但我现在显然已经远离了那种生活。%SPEECH_OFF%确实如此。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[0] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_120.png[/img]{她转向书本，盯着它们，仿佛那是坟墓一般。%SPEECH_ON%我父亲拥有这片土地上最大的图书馆之一，在那里我发现了这个沼泽的故事。来自无意中重复着同样故事的作者的著作。十年前。一百年前。一千年前。同样的故事。一个关于人们到这里来，然后消失的故事。没有得到解决，答案具有歧义。强盗。疾病。一个学者只是说那些人被这个沼泽美景所吸引，然后决定留下来。你相信吗？沼泽的美景？%SPEECH_OFF%你冷笑着说你正在看着一个。她笑了起来。%SPEECH_ON%我已经好几个月没有看到过自己，但我说真的，陌生人。我已经搜索过这些地方，但我什么都没找到。%SPEECH_OFF%她伸手指着四周的书本。%SPEECH_ON%一共有二十多个失踪事件，涉及到三百多名全副武装的人，还有马匹、商队和贵族，但我在这里四处看了，什么都没有发现。%SPEECH_OFF%你怀疑如果你在沼泽地里死掉了，也没有人会在乎你，但那么多的故事还是有点可疑的。}}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[1] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_120.png[/img]{她耸了耸肩。%SPEECH_ON%也许是吧，但至少我没有雇佣一个充满混蛋的战团。%SPEECH_OFF%你回头看了一眼那些名叫%companyname%的人，在营地的一侧正在打架，在中间有人把沼泽蛇塞进了一个睡觉的佣兵的裤子里，而在较近的一侧，有几个人正指着你们两个，一边捂着自己的下体，一边对着空气做着挺动。你转过头告诉她，他们还不错。就在这时，一个雇佣兵在沼泽上尖叫着奔过来。%SPEECH_ON%告诉她，有一次我们所有人都死了，所以我们让你当队长，因为没有其他人了！女士们喜欢英雄故事！%SPEECH_OFF%你微笑着重复了一遍。%SPEECH_ON%老实说，他们还算不错。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[2] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_120.png[/img]{那个女人在她的背包里翻找，拿出了一枚你从未见过的印章。她像是在翻转一枚赝品硬币一样扔给了你。%SPEECH_ON%我还有一堆这样的东西，不过不在这。我可不想你得到抢劫和掠夺的念头。但如果你帮我做点事，我就会送你一箱子这样的东西。%SPEECH_OFF%你揣进了印章，问她需要做什么。她回答道。%SPEECH_ON%我也不是完全确定。水手们说海怪和鲸鱼是天敌，但是，你看，这附近没有鲸鱼了——我们毕竟是在陆地上。不过有些东西很接近。是沼泽中的巨兽。我猜想海怪经过了漫长的岁月，向内陆迁移，并吞食了它所能找到的食物，就像在海中一样，在这里也找到了一个敌人。给我%hides%个巨兽皮，我或许能引诱这个野兽苏醒。%SPEECH_OFF%苏醒？它会在哪里睡觉呢？你耸了耸肩，想着如果她愿意摆脱这样华美的珠宝，你会非常乐意帮她个忙。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我会把兽皮带给你的。",
					function getResult( _event )
					{
						this.World.Flags.set("KrakenCultStage", 1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}

				if (!_event.m.IsPaid)
				{
					_event.m.IsPaid = true;
					local item = this.new("scripts/items/loot/signet_ring_item");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_120.png[/img]{你把雇主要求的野怪兽皮交给了她，结果你却看到有更多的人聚集了过来。几个男人和女人到处闲逛、在沼泽里乱翻，吃野菌。他们问你是否来协助找海怪。你严肃警告他们是否也来寻求报酬，因为你肯定不会与他们分享战利品。然后那位女性叫住了你，向你跑来。她转过头，满头泥水，像一件肮脏的抹布一样甩出去。%SPEECH_ON% 就是那个，没错！%SPEECH_OFF%她响了响手指，几个帮手拿走了兽皮。你问这些人是谁。她耸耸肩。%SPEECH_ON%他们刚刚开始到这里来，我猜。他们说他们在这里是天命，我也没理由去挑战这点。不，我也不会向他们支付我欠你的那份报酬。他们只是为了留在这里，远离其他地方，远离一切。%SPEECH_OFF%你皱了皱眉头。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "那么交易完成了？",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local items = this.World.Assets.getStash().getItems();
				local num = 0;

				foreach( i, item in items )
				{
					if (item == null)
					{
						continue;
					}

					if (item.getID() == "misc.unhold_hide")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "你失去了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
						});
						items[i] = null;
						num = ++num;

						if (num >= _event.m.Hides)
						{
							break;
						}
					}
				}

				_event.m.IsPaid = false;
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_120.png[/img]{皮革已经交付，你请求应得的报酬。她像对待乞丐一样地给了你另一个印章，然后向她的书本挥手。当你走过去时，你看见帮手们正在割裂着不死族的皮革。他们似乎正在制作披风。女人讲话了。%SPEECH_ON%我认为我们离觉醒更近了。这里的帮手们说他们看到了星星，但我认为他们真正看到的是萤火虫。我自己有时也看到它们。在黑暗中发光的小虫子。我试过捕捉一些，但它们总是一闪而逝。%SPEECH_OFF%好的。你再次要求支付报酬。她回答时重新打开了那本古书，并看着图片上被海怪攻击的水手的描绘。%SPEECH_ON%有这么多的帮手，我有更多的时间深入研究书籍，在那段时间里我注意到了一些东西。你在这张图片中看到了什么？现在仔细看看。%SPEECH_OFF%你盯着图片，但耸了耸肩。她用手指在图画的具体部位拖了拖，就像她的叙述正在当时刻画它一样。%SPEECH_ON%月光。这场战斗发生在夜间。这里飞翔的是什么？海鸥吗？不，是蝙蝠。这些蝙蝠在大海中心到底在干什么呢？再看这个人，船舵的方位，他有着长长的耳朵和一件黑色的斗篷。有趣的人物，不是吗？另外还有这个，翻到下面几页，一段记录：引用：“一个流浪汉从他的斗篷里扔出蝙蝠以掩盖他的逃跑”。相当具体，是吗？我认为它们被称为死灵学者，古老的。我认为它们不是被海怪袭击的，它们在猎杀海怪。%SPEECH_OFF%叹了口气，你问她需要什么。女人拍上那本书。%SPEECH_ON%这要看它们存不存在，因为我亲眼所见还没有见过，但在我的日子里，我见过巫医和魔法师的奇怪闪闪发亮的灰烬。也许是诡计，也许不是。给我带来%remains%这些夜行人的灰烬堆，我们可能会得到我们的海怪。%SPEECH_OFF%女人兴奋地吃着更多的蘑菇。她停下来，露出黑色的牙齿微笑。%SPEECH_ON%然后你也会有你的金币，当然。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "找来找去都是垃圾。",
					function getResult( _event )
					{
						this.World.Flags.set("KrakenCultStage", 2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}

				if (!_event.m.IsPaid)
				{
					_event.m.IsPaid = true;
					local item = this.new("scripts/items/loot/signet_ring_item");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_120.png[/img]{你已经在这里待了很长一段时间，本以为这个地方越来越熟悉，但沼泽突然感觉陌生而陌生，就像走进一间老卧室却发现有东西被移动了一样。\n\n你发现那个女人站在远处，她的助手们在她身后排成队伍。他们都穿着用未知鬼皮制成的斗篷，蹲在绿色灯泡面前，把它们握在手中，你可以在每个翠绿色的光泽中看到微笑的裂缝，唇瓣在消失的理智中轻声嘶嘶。女人的书籍、卷轴和文件散落在周围。一股雾气萦绕着，带来了可怕的气味。你问你的钱在哪里。女人露出了笑容，她的眼睛发黄，嘴唇干燥而开裂，蘑菇碎片散落在她的脸颊上。%SPEECH_ON%雇佣兵想要他的钱！这里什么也没有，只有逃生！从任何地方逃出去！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "这是怎么回事？",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "我要求立即付款。",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_103.png[/img]{你看着其中一名助手突然飘起，绿光中你看到光滑的触手将他向后拖，仿佛大地裂开，千根湿漉漉的树枝和枝条嘎吱作响，滴水作响，一排排的尖牙竞相簇拥，互相撞击，而助手被扔进它的口中，在牙齿和齿龈的扭曲中，他被褪去衣服，去肉，去肢体，最后身亡。那名女子又咬了一口蘑菇，然后她的手抚摸着绿色的球茎，你可以看到每个下面都蠕动着触手。%SPEECH_ON%加入我们，佣兵！让“魔兽之兽”享受它的盛宴！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "列队！",
					function getResult( _event )
					{
						this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Events.showCombatDialog(true, true, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function addReplies( _to )
	{
		local n = 0;

		for( local i = 0; i < 3; i = ++i )
		{
			if (!this.m.Replies[i])
			{
				local result = this.m.Results[i];
				_to.push({
					Text = this.m.Texts[i],
					function getResult( _event )
					{
						return result;
					}

				});
				  // [028]  OP_CLOSE          0      4    0    0
			}
		}

		if (n == 0)
		{
			_to.push({
				Text = $[stack offset 0].m.Texts[3],
				function getResult( _event )
				{
					return "C";
				}

			});
		}
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		this.m.Replies = [];
		this.m.Replies.resize(3, false);
		this.m.Results = [];
		this.m.Results.resize(3, "");

		for( local i = 0; i < 3; i = ++i )
		{
			this.m.Results[i] = "B" + i;
		}

		if (this.m.Hides == 0)
		{
			local stash = this.World.Assets.getStash().getItems();
			local hides = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.unhold_hide")
				{
					hides = ++hides;
				}
			}

			this.m.Hides = hides + 3;
		}
		else if (this.m.Dust == 0)
		{
			local stash = this.World.Assets.getStash().getItems();
			local dust = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.vampire_dust")
				{
					dust = ++dust;
				}
			}

			this.m.Dust = dust + 3;
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hides",
			this.m.Hides
		]);
		_vars.push([
			"remains",
			this.m.Dust
		]);
	}

	function onDetermineStartScreen()
	{
		if (!this.World.Flags.get("IsKrakenCultVisited"))
		{
			return "A";
		}
		else if (this.World.Flags.get("KrakenCultStage") == 0)
		{
			return "B";
		}
		else if (this.World.Flags.get("KrakenCultStage") == 1)
		{
			local stash = this.World.Assets.getStash().getItems();
			local hides = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.unhold_hide")
				{
					hides = ++hides;
				}
			}

			if (hides >= this.m.Hides)
			{
				return "D";
			}
			else
			{
				return "C";
			}
		}
		else if (this.World.Flags.get("KrakenCultStage") == 2)
		{
			local stash = this.World.Assets.getStash().getItems();
			local dust = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.vampire_dust")
				{
					dust = ++dust;
				}
			}

			if (dust >= this.m.Dust)
			{
				return "F";
			}
			else
			{
				return "E";
			}
		}
	}

	function onClear()
	{
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU8(this.m.Hides);
		_out.writeU8(this.m.Dust);
		_out.writeBool(this.m.IsPaid);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 43)
		{
			this.m.Hides = _in.readU8();
			this.m.Dust = _in.readU8();
			this.m.IsPaid = _in.readBool();
		}
	}

});
