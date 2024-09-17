this.monolith_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.monolith_enter";
		this.m.Title = "当你接近时……";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_101.png[/img]{从远处看，黑色巨石就像一座倾斜立于地面的黑塔。上方的天空毫无瑕疵，仿佛云和鸟儿绕过了某座看不见的山峰。一片麻木笼罩着它的腹地，土地既不死亡也不生长，一片残酷的寂静使得这种无精打采的生命感比死亡更糟。冒险家们走向它，却没有回来。他们死亡的故事叠起来足以盖住整根石柱，给它裹上了一层恐惧和威胁，没有人敢靠近。\n\n但现在，%companyname%站在这座方尖碑前，就像蚂蚁站在一柄利剑之前。在这里，你可以看到这个结构根本不是建在地上的：这个石柱坐落在一个废弃采石场的坑里。道路和小径蜿蜒而下，就像某个巨大而中空的地穴。吊着桶的绳索跨越着每个缺口，无数的泥桶像节日之夜没有点亮的灯笼一样悬挂着。更多的绳索固定着桥梁的框架，曾经的人行道板早已垮塌，还有更多的环绕着石柱，仿佛有一大群人曾试图将其拉倒或甚至将其拉正。在这个废坑的底部是石柱的基座，但对你来说这只是一个猜测。它看起来似乎永远在沉向地下和下面的一切。铲子和镐还散落在黑曜石壁上，金属上仍有泥土粘连。%randombrother%对着这景象点了点头。%SPEECH_ON%看起来挖掘的人被打断了。%SPEECH_OFF%这个人的话在采石场里远远回荡，直到你几乎看到它们消失。回头看，你发现寂静本身已经跟随着你，但即使在这个悬崖边上，寂静也是深思熟虑的，并且容易被打破。进入采石场的决定沉重地压在你的肩上。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "进去。",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "撤退。",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

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
			Text = "[img]gfx/ui/events/event_101.png[/img]{在进入采石场并绕过一个长弯道时，你注意到墙下挖出了一系列走廊。你举起一只拳头。队伍不再前进，彼此碰撞着停了下来。%randombrother%问出了什么事。你把手指放在了嘴唇上。\n\n你迈着最轻盈的步子走近了一根连接这一层和坑底之间的绳子。一只装满土壤的桶仿佛随着你的出现而晃动。用来上下拉动的滑轮早已生锈。你拔出剑，将绳子割断。绑绳像一条鞭子一样向后弹回，木桶直坠。它在岩石上左右碰撞，直到撞到地面，发出金属的撞击声和一片尘土之云。就那样，寂静被打破了。\n\n脸色苍白的人从下面的走廊里涌出，一群恶意的矿工和挖沟者的人流，身穿褴褛的裤子、靴子和用碎衬衫做成的斗篷，步履蹒跚地走了出来，好像回到了一些长期未完成的工作中。你试图数出他们的人数，但当一群全副武装的士兵从暴徒后面走出来时，你的注意力被分散了，这些士兵携带着长柄武器、盾牌和长矛，最危险的是，他们有一种凝聚力。\n\n逃出采石场毫无意义，这片土地上没有可以逃去的地方。当你回头看那些男人时，他们已经开始拔出武器。%randombrother%点了点头。%SPEECH_ON%跟你跟到底，队长。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "战至最后一刻！",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
							this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						}

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

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
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
