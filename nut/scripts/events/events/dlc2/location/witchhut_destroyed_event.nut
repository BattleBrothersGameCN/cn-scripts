this.witchhut_destroyed_event <- this.inherit("scripts/events/event", {
	m = {
		Replies = [],
		Results = [],
		Texts = []
	},
	function create()
	{
		this.m.ID = "event.location.witchhut_destroyed";
		this.m.Title = "战斗之后";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Texts.resize(7);
		this.m.Texts[0] = "你是谁？";
		this.m.Texts[1] = "你怎么知道我是谁？";
		this.m.Texts[2] = "古人是谁？";
		this.m.Texts[3] = "什么是达库尔？";
		this.m.Texts[4] = "绿皮是人类吗？";
		this.m.Texts[5] = "你为什么要叫我伪王？";
		this.m.Texts[6] = "我的梦想是什么？";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_115.png[/img]{最后一名女巫伏诛，你命人将她们的尸身彻底毁损以绝后患。双耳、嘴唇、鼻尖、趾尖——全部切下。行囊中的物件则捣为齑粉埋入尘土，血肉与动物残骸堆成小山付之一炬。正当烈焰升腾之际，木屋里的那个女巫竟然如鬼魅般突然现身并挽住你的臂弯。队员们拔剑相向，你抬手制止，嘱咐他们继续执行打扫战场。在转身步入木屋前，你瞥见几个部下正对着余烬小解。\n\n屋内，你在原处落座。桌上一方手帕包裹的物事映入眼帘，女巫用指尖捻着手帕一角缓缓转动。她仰首前倾，掌心向上摊开双手。}",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{女巫微微一笑。%SPEECH_ON%不过是个住在林间破屋的老太婆。其他的都只是谣言。%SPEECH_OFF%你凝视她良久，明白继续追问也不会有什么结果。}",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{她凝视着那件被包裹的物品。%SPEECH_ON%我连你的名字都不知晓，佣兵，也丝毫不想关心。重要的不是你是谁，而是你是什么。%SPEECH_OFF%她双手如追随韵律般缓缓翻转。%SPEECH_ON%远古之血在你体内流淌。它存在于我们所有人之中，但你尤其……%SPEECH_OFF%她皱起鼻子轻哼一声，呼出气息时露出癫狂的笑容。%SPEECH_ON%如此鲜明。既然我能嗅到这份气息，整个世界自然也能闻到。%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{她轻叩手帕，下面的物件随之敲击桌面。她缓缓答道：%SPEECH_ON%古人存在于我们时代之前。是真正、真正久远的时代，想象一个王国，再想象一个统御众王国的国度——没错，就是帝国。现在，请想象一个主宰万千帝国的存在。当这般不可揣度的力量陨落时，必将向世界施以残酷的报复，用尽它垂死之际的所有时光来摧毁那些毁灭它的人。%SPEECH_OFF%你追问那个帝国是否已然覆灭。女巫唇角微扬。%SPEECH_ON%我怀疑并非如此，但我没有确切答案。%SPEECH_OFF%}",
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
			ID = "B3",
			Text = "[img]gfx/ui/events/event_115.png[/img]{耸耸肩，向后靠斜，女巫让你重复名字。“达库尔。”她摇了摇头。%SPEECH_ON%我没有听说过这个达夫库尔。你说他是一个所谓的神？好吧，他没有与我交谈过。%SPEECH_OFF%你盯着她，试图从她的眼中窥探到一个隐藏的真相，但她的回答似乎很真诚，你改变了话题。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[3] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B4",
			Text = "[img]gfx/ui/events/event_115.png[/img]{女巫咯咯地笑了起来。%SPEECH_ON%我倒想呢！你见过兽人裤裆里那玩意儿吗？要不是怕被撕成两半——这边糟蹋着我，那边还把另半截当手套戴——我倒是很想骑上去试试！%SPEECH_OFF%你扬起眉毛点头，好像在说“当然了”。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[4] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B5",
			Text = "[img]gfx/ui/events/event_115.png[/img]{女巫的表情第一次出现了波动。她抿紧嘴唇。%SPEECH_ON%我什么时候这么叫过你？%SPEECH_OFF%你指了指门，又指了指桌子，回答道。%SPEECH_ON%我刚进门时，你说我在追寻真相，还说你知道伪王的梦境。%SPEECH_OFF%女巫心不在焉地轻叩着手帕，抬眼看向你。%SPEECH_ON%那我向你道歉，佣兵。这些事我完全不记得了。我只是个年老体衰的妇人，比看上去还要苍老——这可没骗你。%SPEECH_OFF%你继续追问，但她只是用更坚决的沉默回应你。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[5] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "Dream",
			Text = "[img]gfx/ui/events/event_115.png[/img]{女巫倾身向前，双手捧住你的脸。皮肤粗糙的手指深陷你的脸颊。她摩挲过你的眼角，轻叩你的太阳穴。她始终带着笑意，随后缓缓收手。%SPEECH_ON%你为贵族与富人效命，他们赐你黄金，而你用血肉之躯冒险，屠戮所有目标。日复一日，你质疑自己是否仅剩这点价值。当那些高高在上者将你与你的功绩隔绝在门外，当门内传来盛宴的喧嚣——音乐、女子的欢笑、弄臣的俏皮话——你却攥着钱袋站在阴影里，袋上还沾着凝固的血迹。你走进酒馆买醉，给吟游诗人赏银点曲，在最廉价的酒窖里寻找慰藉。但始终无法摆脱脑海深处那个念头：仿佛你生来就注定陷入这种狂热，所有这些暴力与死亡并非通往某个终点的途径，其本身就是终点。这就是你的本质，是你永恒的真相。%SPEECH_OFF%她停了下来，叹了口气。%SPEECH_ON%佣兵，谎言的力量只取决于人们愿意相信的程度。你活在一个强大的谎言里，而这样的力量不会轻易消退。我恳求你，只成为你所能理解的存在。%SPEECH_OFF%此刻令她感到恐惧的，并非你本人、你的武器或你麾下的战团，而是她亲口诉说时逐渐领悟的某个事实。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我是谁？！",
					function getResult( _event )
					{
						return "WhoAmI";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "WhoAmI",
			Text = "[img]gfx/ui/events/event_115.png[/img]{你起身大声质问那女人。她反手给你一记耳光，你只觉得脸颊发麻，踉跄着后退半步。血珠顺着脸颊滑落，你下意识用袖口擦拭。女巫一把夺过手帕扔开，露出底下那柄黑曜石匕首。它比你记忆中更加锋利，刀刃上映出的面容清晰得仿佛你就在镜中世界。女巫坐回原位，将匕首推过桌面。%SPEECH_ON%别再问了，佣兵。我知道的就这么多，而你需要知道的也只有这么多。我们的交易到此为止。%SPEECH_OFF%你接过匕首问她做了什么，她却闭口不答。你又问这世上是否还有她这样的存在。她顽劣地勾起嘴角。%SPEECH_ON%我祈祷再没有第二个。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们完了，我应该离开了。",
					function getResult( _event )
					{
						return "Leave";
					}

				},
				{
					Text = "你现在没用了。受死吧，女巫！",
					function getResult( _event )
					{
						return "Kill";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/weapons/legendary/obsidian_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Leave",
			Text = "[img]gfx/ui/events/event_115.png[/img]{你向女巫道别，她未再言语。屋外，弟兄们围上来询问谈话内容，有人还嬉笑着猜测你们是否有了什么风流韵事。你感觉自己似乎在笑，却又不太确定。刚才的对话让你如陷迷雾，在这片混沌中你只能做出最熟悉的行动：下令战团继续赶路。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "该走了。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsWitchhutLeft", true);
			}

		});
		this.m.Screens.push({
			ID = "Kill",
			Text = "[img]gfx/ui/events/event_115.png[/img]{女巫交叠十指点头致意。你回以颔首，随即抓起黑曜石匕首刺入她的胸膛。她流血的样子与你熟知的凡人无异，呛咳着鲜血的模样与任何生灵别无二致。她踉跄后退时眼中迸发的惊惧，亦如你曾见过的无数将死之人。你抽出匕首抬脚猛踹，她哀嚎着向后倒去，双手胡乱抓扯下大把捕梦网与蛛网，手肘撞翻木制餐具架，器皿哗啦啦散落满屋。她用苍白的手指抓起一把黄油餐刀，目光如利箭穿透你。两声呛咳后，她扔下餐刀握拳捶打胸口，喷出一口鲜血。她抬起头来。%SPEECH_ON%我们有约定，佣兵。%SPEECH_OFF%你将匕首收回，并点点头。%SPEECH_ON%没错，你和雇佣兵有约定，你得到了你想要的。而我呢？我和这个世界达成了协议，要把你和你的同类消灭干净。说了这么多，祝你好运。%SPEECH_OFF%女巫的头低垂在地板上，身体变得无力。当你走出小屋时，战团问发生了什么事。你告诉他们焚烧小屋，准备上路。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "该走了。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsWitchhutKilled", true);
			}

		});
	}

	function addReplies( _to )
	{
		local n = 0;

		for( local i = 0; i < 6; i = ++i )
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
				n = ++n;

				if (n >= 4)
				{
					break;
				}

				  // [034]  OP_CLOSE          0      4    0    0
			}
		}

		if (n == 0)
		{
			_to.push({
				Text = $[stack offset 0].m.Texts[6],
				function getResult( _event )
				{
					return "Dream";
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
		this.m.Replies.resize(6, false);
		this.m.Results = [];
		this.m.Results.resize(6, "");

		for( local i = 0; i < 6; i = ++i )
		{
			this.m.Results[i] = "B" + i;
		}
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});
