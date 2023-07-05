this.kraken_cult_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.kraken_cult_destroyed";
		this.m.Title = "战斗之后";
		this.m.Cooldown = 999999.000000 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_105.png[/img]{触须在沼泽地上纠缠成一团，如此腐化，以至于你不仅杀死了海怪，而且还毁灭了它所称之为家的地方。每个虫子般的残留物都长满了沼泽苔藓，一个盈利的农田，孵化出了你一遍又一遍见到那个女人吃的蘑菇。你蹲在一堆尚未收获的蘑菇旁边，戳着它们的帽子，就像猫戳着没有翅膀的飞蛾一样。蘑菇在触摸时变软了。%randombrother%看着它们。%SPEECH_ON%真菌学家可能知道是什么。%SPEECH_OFF%你点了点头。是的。可能。你继续前行，踩着蘑菇，在沼泽中穿行，浮在沼泽上的肢体和染血的外套以及触手无面的头部，它们的叶状嘴巴相互折叠，它们的舌头像鞭子一样垂下。你找到了那个女人藏在一堆葛藤后面，你像一个寻找财富的人一样拨开藤蔓。她冲你笑了一下。%SPEECH_ON%你听到了吗？你听到它的美吗？%SPEECH_OFF%你叹了口气，告诉她，蘑菇侵占了她的思想，蘑菇可能有它的原因，而且海怪在它升起之前就把她控制住了，用她来带领每个人来到这里。她越来越开心地笑，只是再次问你是否听到了它的美。你告诉她，你听到了它的死亡。她的眉头皱起。%SPEECH_ON%死亡的叫声？这是你的想法吗？哦，亲爱的，不。陌生人，那是求救的叫声。你不明白吗？这意味着还有更多的存在！更多！也许有数百个！现在他们醒来了！全都醒来了！%SPEECH_OFF%你向后退了一步，关上了葛藤的帘幕。%randombrother%告诉你，战团发现了一些东西。你想拯救这个女人，但你知道这是不可能的。你知道她所处的困境，所以任由她。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "好吧，让我们看看能发现什么。",
					function getResult( _event )
					{
						if (this.World.Flags.get("IsWaterWheelVisited"))
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_105.png[/img]{那怪物几乎太大了，不能合适地倒在地上，反而向前倾斜，恶心的嘴巴裂开，像是打穿一个倾斜的城墙一样。一名雇佣兵盘腿坐在鱿鱼巨兽的头状圆顶上，仿佛深入研究的僧人。另一名雇佣兵正在用手戳怪物的眼睛，直到一只眼睛破裂，眼窝的角落发出泡泡声混合着液体。你问雇佣军发现了什么重要的东西，其中一人招手让你走到怪物的嘴边。现在，酥胃的牙齿松垂向下，如同恐怖塔楼的边缘，排列着被衣物和肉体覆盖的利刃，如此之大，以至于整个肢体都被卡在它们之间。也有一把刀子。\n\n你伸手进入口腔，拔出刀子，用布擦拭干净，翻转刀片，你发现在中空线上有字形和对应数字，这暗示着永恒锻造，特定于某个时空。这块钢铁是如此活力四射，似乎是由于星光的本身塑造而成的。不幸的是，它没有柄。这柄刀的华丽装饰表明它不是任何普通柄的容纳。将刀片放入库存，你告诉这些人从“残酷的凶兽”那里收集他们所能够得到的，准备离开这个可怕的地方。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们赢了。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/legendary_sword_blade_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_105.png[/img]{这个生物几乎太大了，无法在其侧面上适当地死去，而是向前倾斜，可怕的嘴巴敞开着，就像被炸掉的倾斜堡垒上的一个洞。一名雇佣兵盘腿坐在这个海怪的背上，像一位深入研究的僧侣。另一个人在戳着这个怪物的眼睛，直到其中一个眼球被戳破，眼眶的角落发出泡沫般的咕咕声。你问这些雇佣兵发现了什么东西，其中一个人向你招手，示意你走到这个生物的嘴边。牙齿松动地垂直下垂着，无力的壕沟变成了一座恐怖的城墙，锋利的刃缝中粘着衣物和肉块，如此之大，以至于整支肢体都被卡在了里面。而在其中的就是这把剑。\n\n你伸手进入口中，拔出这把剑，用一块布擦拭干净。翻转着这把剑，你看到富勒上的字母和旁边的数字，暗示着永恒锻造的用途和目的，特定于某个时空。这把钢剑是如此光彩夺目，好像是星星的光辉所铸造的。不幸的是，它没有手柄，你立即计算了一下：一把无与伦比的剑，没有手柄，一个陌生老人在一个幽闭的车舱里还有一个没有剑柄的手柄。你想你知道该去哪儿。你把它放进清单里，命令战团掠夺其他值得带走的东西，包括所谓的“巨兽”身上的东西。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们赢了。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/legendary_sword_blade_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		this.World.Flags.set("IsKrakenDefeated", true);
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
