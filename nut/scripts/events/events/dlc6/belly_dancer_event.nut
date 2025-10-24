this.belly_dancer_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.belly_dancer";
		this.m.Title = "%townname%里";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{一位肚皮舞者如磁石般吸引着%townname%中心广场的人群。单是那律动身姿就足以让乞丐心甘情愿献出克朗，而拥有整个广场作为舞台的她，更是引来了围观人群与成堆的金币。翠绿薄纱若隐若现地掩着面容，轻盈丝绸裹身却裸露出腰肢，这位舞者无疑是此道高手。她翩然旋转时，髋部如催眠般摆动，双肘微曲，纤手叩击着小钹，足尖点地旋出紧密的圆——仿佛有位无形的神明在半空托举着她，令这场炫目表演永不停歇。\n\n有人凌空抛来苹果，舞者旋身甩出小匕首精准贯穿果核，果实应声落地。又一颗苹果飞来，这次她抽出长军刀凌空削断果梗，顺手接住剩余果肉咬了一口。众人为此鼓掌致敬。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "干得漂亮，给你一克朗。",
					function getResult( _event )
					{
						return "B";
					}

				},
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
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_163.png[/img]{你取出一枚克朗抛向舞者。她目光精准地捕捉到钱币的闪光，但舞步未曾中断。只见她放下武器，伴着清脆的钹声扭动腰肢翩跹而来——双膝微屈，步履如凌波踏雾，竟似带着几分玄妙。待她靠近，你才看清那张瘦削的面容却配着宽阔的下颌，太阳穴深陷。她咧嘴一笑。竟是个男子。她是个男子。他对着你的脸啪地敲响铜钹，随即旋身用臀尖轻蹭过你的胯部，又扭动着回到广场中央。最后用脚趾拈起那枚克朗向上一挑，钱币稳稳落进陶罐，引得人群爆发出热烈的喝彩。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "或许他可以为我们所用？",
					function getResult( _event )
					{
						return "C";
					}

				},
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
				this.World.Assets.addMoney(-1);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "你花了[color=" + this.Const.UI.Color.NegativeEventValue + "]1[/color] 克朗"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_163.png[/img]{待到那位男儿身的肚皮舞者收下你的克朗后，你一直等到表演结束。在他收拾行装时，你上前搭话。他带着揶揄的笑容看向你。%SPEECH_ON%啊，看来是位仰慕者。抱歉，今晚只演这一场，好心的陌生人。%SPEECH_OFF%你摇头问他是否知道怎么战斗。他点头。%SPEECH_ON%我当然知道。 镀金者确实眷顾世人，但并非时时刻刻。有时候我们总得在黑暗中自寻出路。看你这身装束，是个赚克朗的佣兵吧？整天把刀剑往该捅不该捅的地方送。%SPEECH_OFF%他突然盘腿坐下，数着钱袋里的克朗。%SPEECH_ON%不清楚你有没有看透我浪荡子的本性。或许你察觉到了连我自己都未曾意识到的职业倦怠——不过要想让我为几个赏钱去卖命，你还得再加把劲才行。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "你的刀法堪称一绝。",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "E" : "D";
					}

				},
				{
					Text = "我现在就给你500克朗，只要你愿意加入我们。",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"belly_dancer_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name%在" + _event.m.Town.getName() + "加入了你的队伍，他以绿绸遮面，凭借充满韵律的舞姿吸引着人群，更以令人惊叹的精准刀法斩落飞来的水果。后一项技能对任何佣兵团而言都是宝贵的财富，于是你毫不犹豫地招募了他。";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/dexterous_trait");
				_event.m.Dude.getSkills().add(trait);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_163.png[/img]{你试图通过称赞他是你见过的最好的刀客来奉承他。舞者的双手仍在沙地上游走，手指灵巧地翻起一枚枚硬币投入陶罐。当你的视线被他刻意伸向左侧的左手吸引时，他的右手已从沙砾中抽出完全埋藏的短刀，刀尖直指你的胯下。%SPEECH_ON%我使刀确实致命，就像你那根刺肯定也所向披靡。我很清楚你不过是在说些让我飘飘然的好话，像猎人驯狮般撩拨我的骄傲——但必须承认：这招奏效了。我愿意为你而战，逐币者队长%SPEECH_OFF%你点头示意他放下短刀。但见他在掌中转了个刀花利落归鞘。他站起身，脱下衣服直到全裸。%SPEECH_ON%我要彻底告别这种生活，全心全意投身于逐币者的生活中。%SPEECH_OFF%你与他握手。有个路人瞥见这幕，困惑地挠头。%SPEECH_ON%等一下，你下面有条蛇！ 我以为你是个舞女，啊这……%SPEECH_OFF%他抹了抹额头，压低嗓音。%SPEECH_ON%这样反而更带劲了。%SPEECH_OFF%舞者朝你放声大笑。%SPEECH_ON%我们的行业有着各种各样的危险，逐币者，我很期待见识你们要应对的危险。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "欢迎加入战团！",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_163.png[/img]{你对舞者说他算得上是你见过刀使得最好的人了。他闻言大笑。%SPEECH_ON%你差点就说动我了，逐币者，你是想让我加入你们吧。 但是你知道的，无论说什么做什么，都不可能让我离开现在的生活。没错，刀确实适合我，但在人群里跳跳舞，不见血就能赢得喝彩，这同样适合我。你尽管去沙场上拼杀赚钱，逐币者，而我自有我的生财之道。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "总得试试。",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_163.png[/img]{你向舞者开出了五百克朗的价码。他依旧捡着钱币——一枚接一枚——投入陶罐。空旷陶瓮回荡着硬币坠落的脆响，几乎成了此刻唯一的韵律。他抬眼瞥你，又垂首继续，最后再投进一枚克朗才缓缓起身。他利落地褪去舞衣，向你伸出手。%SPEECH_ON%镀金者必定同时眷顾着你我——祂赐你积累这般财富，又指引你带着钱囊来到我面前。%SPEECH_OFF%你点头与他握手。有个路人瞥见这幕，困惑地挠头。%SPEECH_ON%等一下，你下面有条蛇！ 我以为你是个舞女，啊这……%SPEECH_OFF%他抹了抹额头，压低嗓音。%SPEECH_ON%这样反而更带劲了。%SPEECH_OFF%舞者叹了口气，请求查看你的装备库存。%SPEECH_ON%就我这身段，什么装备都能驾驭——里里外外，我自有办法。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "欢迎加入战团！",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "你花了[color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color]克朗"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 750)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer())
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Dude = null;
	}

});
