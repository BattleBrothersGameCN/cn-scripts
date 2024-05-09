this.icy_cave_enter_event <- this.inherit("scripts/events/event", {
	m = {
		Champion = null
	},
	function create()
	{
		this.m.ID = "event.location.icy_cave_enter";
		this.m.Title = "当你接近时……";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A1",
			Text = "[img]gfx/ui/events/event_144.png[/img]{你在冰层中发现了一座洞穴，其深邃的入口被厚实冰柱构成的大门所遮掩。透过冰柱间的缝隙窥视，你看到洞穴急剧向下倾斜，似乎通往一个早已冰封的地下河岸。有个人影蜷缩在旁，不断地用镐头敲击着冰面。风在洞穴的冰齿间呼啸，发出尖锐的摩擦声。你向那个蜷缩的人喊话，但没有任何回应。\n\n要砍穿这厚实冰柱进入洞穴，需要耗费不少时间。幸运的是，一名佣兵报告说可能存在一个后门。虽然同样被堵塞，但一个足够强壮的人或许能够挤过去，直面洞内的任何危险。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "当你接近时……";
				local raw_roster = this.World.getPlayerRoster().getAll();
				local roster = [];

				foreach( bro in raw_roster )
				{
					if (bro.getPlaceInFormation() <= 17)
					{
						roster.push(bro);
					}
				}

				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "前头探路，" + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B";
						}

					});
					  // [057]  OP_CLOSE          0      6    0    0
				}

				$[stack offset 0].Options.push({
					Text = "我们应该离开这个地方。",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_144.png[/img]{你追踪那位神秘信使的足迹来到了冰洞。由厚实冰柱构成的大门牢牢守护着你的入口，显然这里近期未曾有人踏足。在洞口的一侧，老人面朝下躺在雪地里，已然离世，他的一只手臂伸出，指向洞穴深处。\n\n透过冰柱间的缝隙窥视，你看到洞穴急剧向下倾斜，似乎通往一个早已冰封的地下河岸。有个人影蜷缩在旁，不断地用镐头敲击着冰面。风在洞穴的冰齿间呼啸，发出尖锐的摩擦声。你向那个蜷缩的人喊话，但没有任何回应。\n\n要砍穿这厚实冰柱进入洞穴，需要耗费不少时间。幸运的是，一名佣兵报告说可能存在一个后门。虽然同样被堵塞，但一个足够强壮的人或许能够挤过去，直面洞内的任何危险。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "当你接近时……";
				local roster = this.World.getPlayerRoster().getAll();
				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "前头探路，" + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B";
						}

					});
					  // [041]  OP_CLOSE          0      5    0    0
				}

				$[stack offset 0].Options.push({
					Text = "我们应该离开这个地方。",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_144.png[/img]{%chosen%先行侦察，你和其他人则专注于洞穴正面的清理工作。你敲掉几根厚实冰柱，以便更清晰地观察洞穴内部。就在这时，%chosen%从旁边的斜坡翻滚而下，正好落在洞穴中央，滑过冰封的河面，顺势滑上河岸。他迅速站起，带着孩子般的微笑拍打身上的灰尘。\n\n刹那间，那个蜷缩的人以惊人的力量用镐头猛击冰面，冰屑四散，从河岸一侧飞溅至另一侧。金属与碎冰的铿锵声回荡不绝，宛若雷霆万钧。现在，你终于看清那个陌生人了：他是一名野蛮人，身披破碎盔甲，随他移动，叮当作响。冰墙映照着他的步伐，身影在洞穴中忽隐忽现，化作片片瞬息即逝的光泽。颤抖且突兀，尽管他步伐前进，却似乎在后退，仿佛影子才是真我，而肉体是幻象。身处洞穴，他响亮的声音却没有丝毫回响。%SPEECH_ON%有不速之客自迷雾现身，我绝不错过。%SPEECH_OFF%他缓缓接近%chosen%，如同暗门中展开的冷血蜘蛛。你看到他的脸半边已经冻僵，而还能称作肉体的另一半上，挤出了一丝扭曲的微笑。%SPEECH_ON%亲爱的战士，我渴望摆脱这具躯壳。你能助我飞升吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BeastsTracks;
						properties.Entities = [];
						properties.Entities.push({
							ID = this.Const.EntityType.BarbarianMadman,
							Variant = 0,
							Row = 0,
							Script = "scripts/entity/tactical/humans/barbarian_madman",
							Faction = this.Const.Faction.Enemy
						});
						properties.Players.push(_event.m.Champion);
						properties.IsUsingSetPlayers = true;
						properties.IsFleeingProhibited = true;
						properties.IsAttackingLocation = true;
						properties.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();

							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = this.Math.min(1, tile.Level);
								}
							}
						};
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(properties, false, false, false);
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "当你接近时……";
				this.Options[0].Text = "%chosen%，拿下他！";
				this.Characters.push(_event.m.Champion.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_144.png[/img]{%chosen% 砍倒了这个疯子。 他的胸甲碎裂，飞离了他的身体，大块的钢板在空中旋转和鸣叫，但却被一些奇怪的蓝色卷须绑在一起。\n\n 你的人终于击碎了冰柱进入山洞，从斜坡滑了下去。%chosen% 没有受伤，他得意得点了点头，把武器收了起来。%SPEECH_ON%只是个疯狂的混蛋，队长。%SPEECH_OFF%你蹲在尸体旁。 冰将他冻得体无完肤，没有冻伤的部分被一些闪闪发光的冰霜覆盖着，十分奇怪。 尽管他死的时候身体状况很差，但是他的脸上仍然带着笑容。 他的眼睛是蓝色的，很明亮，你甚至能在他的凝视中看到自己一个模糊的身影。 过了一会，暗淡了下来，不像之前的那般明亮，就像有人关上窗帘，将所有的亮光都锁在里面。 尸体仍然诡异得对着你笑着，但是你无法相信看到的这一切。\n\n 一个佣兵捡起疯子的盔甲并一直拿着它。%SPEECH_ON%你觉得这是什么形状？%SPEECH_OFF%这些碎金属被一些奇怪的蓝色黏液黏在一起，金属上有着一些气泡模样的图案，这些蓝色的圆圈看起来像是某个东方工匠的作品。 你用手指推了它一下，这些金属让你感到寒冷。 你从来没有见过类似的东西，但这副盔甲又没办法穿上。 你将黏液和盔甲放进了仓库，在洞穴里找有没有其他一些有用的东西。 你离开洞穴的时候，最后看了一眼尸体。 你觉得你看到尸体又移动了位置，但你坚信这是寒冷的北方在捉弄你。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%chosen%，干得好。",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "战斗之后……";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(true);
				}

				this.Characters.push(_event.m.Champion.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/broken_ritual_armor_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_144.png[/img]{隔着冰柱，你看见这个疯子砍倒了 %chosen%。即使他已经倒地死亡，这个疯子仍然不停地对着他的尸体进行挥砍，每一次的挥砍产生的闷响都回荡在山洞里。 现在你要怎么做？}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "战斗之后……";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}

				local roster = this.World.getPlayerRoster().getAll();
				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "我需要你进去，" + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B";
						}

					});
					  // [057]  OP_CLOSE          0      5    0    0
				}

				$[stack offset 0].Options.push({
					Text = "这不值得。 我们应该离开这儿。",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_144.png[/img]{当你离开山洞时，一个穿着熊皮的北方人站在了战团的面前。 他看了看你，又看了一眼洞口。他问。%SPEECH_ON%你会讲南方话或者这里的语言吗？%SPEECH_OFF%你保持着警惕，确定了他的身份。他点头。%SPEECH_ON%你在洞穴里看什么？ 你看到它了？%SPEECH_OFF%你告诉他你除了一个疯子外什么都没看到。这个陌生人笑了起来。%SPEECH_ON%一个疯子，一个疯子，这是你以为你看到的东西。 我们所有人的内心在谈论不自然的事物时都会变得小心翼翼，而不是在自然让步的时候去了解他们。 恐怖说起来容易，要看清楚却很难。 那不是普通人，傻瓜，他是伊吉罗克，是从一个身体转移到另外一个身体的短暂灵魂。 没有人真正知道它的模样，但可能整个世界都是它的面具，它很乐意从一个面具转移到另一个，它一般是以动物的形态出现，偶尔会是个虚弱的人类 它是一个邪恶的存在。 它不能被杀死，不对，应该说它把自己的死亡看做是一种娱乐。 它会记得谁逃离了它，而谁又希望跟它一起玩耍。 祝你有一张值得忘记的脸。%SPEECH_OFF%你把你的手放在剑柄上，跟那个陌生人说，无论这是神秘学还是神话传说你都可以离开。 你在山洞里看到的疯子，他就是那个样子，一个普通的人类。 陌生人又点了点头并向后退去。%SPEECH_ON%好吧，祝你旅途愉快。%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "祝你好运。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "战斗之后……";
				this.World.Flags.set("IjirokStage", 4);
				local locations = this.World.EntityManager.getLocations();

				foreach( v in locations )
				{
					if (v.getTypeID() == "location.tundra_elk_location")
					{
						v.setVisibilityMult(0.8);
						v.onUpdate();
						break;
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"chosen",
			this.m.Champion != null ? this.m.Champion.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.World.Flags.get("IjirokStage") == 3)
		{
			return "A2";
		}
		else
		{
			return "A1";
		}
	}

	function onClear()
	{
		this.m.Champion = null;
	}

});
