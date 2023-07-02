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
			Text = "[img]gfx/ui/events/event_105.png[/img]{The creature was almost too large to die properly on its side and instead tilts forward with its horrid mouth gaping like a hole blasted into a leaning bastion. One sellsword sits crosslegged atop the kraken\'s dome like a monk deep in study. Another is poking the creature in its eyes until one pops and the corners of the socket slurp the liquid in a frothy gargle. You ask the mercenaries what of import has been found and one waves you over to the creature\'s maw. With slackened gums the teeth now hang downward, limp crenellations to a tower of horror, the slew of razors coated in clothes and flesh and so large that whole limbs are wedged between them. And so is the blade.\n\n You reach into the mouth and wrench out the blade and wipe it down with a cloth. Turning the blade, you spot glyphs in the fuller with numbers beside them, a suggestion of smithing eternal yet purposed particular to a time and place. The steel is so vibrant it seems to have been fashioned by the light of the stars themselves. Unfortunately, there is no handle for it and you immediately do the math on that: a sword of unseen magnificence with no handle and one strange old man in a secluded wheelhouse with a blade-less handle. You think you know just where to take this. You put it in the inventory and order the company to plunder whatever else is worth taking, including from the so-called \'beast of beasts.\'}",
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
