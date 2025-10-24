this.witchhut_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.witchhut_enter";
		this.m.Title = "当你接近时……";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_115.png[/img]{你在林间空地处驻足。眼前的小屋老旧而简单，毫不起眼的样子让你疑惑它如何存续至今——或许这种彻底的平庸与低调本身就是某种保护。但久经世故的你知道该相信直觉，而此刻直觉要求你耐心等待。\n\n不多时，木门吱呀开启，一位老妪蹒跚而出。她当即朝你的方向挥手。%SPEECH_ON%你过来，一个人过来。%SPEECH_OFF%你困惑地质问为何独邀一人入屋，更重要的是，她有何理由值得信任？老妪微笑道：%SPEECH_ON%因为我知道伪王的梦境。%SPEECH_OFF%你身边的佣兵骚动起来，询问她的话是什么意思。你抬手制止，让他们原地待命，独自走向那位神秘的老妪。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "呆在这里注意防御。",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_115.png[/img]{你持剑进门，只见那老妪将一碗炖汤推至你面前。她声称汤里只有兔肉与马铃薯，且肉多薯少。你收剑入鞘，接过炖汤在她对面入座。几支蜡烛在旁摇曳，墙壁用白色颜料绘满符文，天花板上垂着图案相似的捕梦网。老妪将手肘支上桌案，发丝间缀着鸟骨发夹与羽毛饰物。她面容沧桑，双眸却如少女般明亮，宛若沼泽深处发光的珍珠。%SPEECH_ON%我知道你会进来的，一个幽灵般的朋友，像飞蛾扑火一般，寻找无法被驾驭的真相。%SPEECH_OFF%你将碗推回桌心，问其是否是女巫。她郑重地点头，凝视片刻后又微微颔首。%SPEECH_ON%很好，你还没有杀了我，说明你仍在思考。我确实是所谓的女巫，但我孤身一人，还被其他女巫追杀。她们可以说是我的“姐妹”，但这些人和我一样都知道你的身份，她们渴求你的鲜血。他们能闻到你的气息，所以我想和你谈谈。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "你想要什么？",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_115.png[/img]{一位女子取出一件长长的东西，用桌布裹起来，然后将其放在桌子上。她掀开布来，露出一把用皮革绑结的锯齿形黑曜石刀片。%SPEECH_ON%切开你的肉，让血染上黑色。巫婆及其卑微的手艺都将前来，然后你将杀死他们。之后，我们可以谈论。佣兵与女巫，女巫与佣兵。%SPEECH_OFF%你问她对你有什么好处。巫婆咯咯地笑了起来。%SPEECH_ON%哦，佣兵，你不是在效忠谁，而是在追求金钱。一个聪明的做法就能让朋友变成敌人。但我能给你更多。一份看不见的真相，一份为虚假王者而设的真相。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们已经付出了这么多。",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_115.png[/img]{黑色的刀锋放在你的手中，你的倒影被拉伸到每个凹陷和边缘的石头凹槽中，显得扭曲不堪。这是一块简单的石头。一把简单的匕首。仅此而已。虽然不重，但你可以感受到它的分量，就像往坟墓上撒下的尘土，沙子中的重量不仅仅在于沙子本身。这把刀锋可能是胜利或是失败，只有一种方法让你知道结果。女巫点头示意，你也点头并在自己的上臂上划了一道口子。鲜血汇聚到石头上，你的倒影被鲜红的液体覆盖。女巫兴奋地凑近你，恶狠狠地压住刀锋，嘴里咆哮着%SPEECH_ON%再来。再来，佣兵。再来！%SPEECH_OFF%你再次挥刀，并用力收紧肌肉，血液喷溅到石头上。她接过刀子，在伤口上贴上一块干净的布%SPEECH_ON%不错，卖剑客。回去准备吧。%SPEECH_OFF%你站起来看着女人，问道%SPEECH_ON%一旦我杀死你的敌人，我们再谈？%SPEECH_OFF%她微笑着%SPEECH_ON%一语成谶，没错。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "那么我将会这么做。",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_115.png[/img]{当你走出去告诉战团有敌人来袭时，不久，这些疲惫不堪的女人被发现正在森林的树林之间行走，她们长长的指甲划破了树皮，口水直流的双唇嘶哑着咯咯傻笑。第一个穿过来的女巫有一个狭长的头，形状像一只独木舟。一个婴儿的头骨挂在她的项链上，皮革袋在她的臀部晃动，两只兔脚从袋子里伸出来。她盯着小屋，嗅着空气，然后把目光转向你。%SPEECH_ON%啊，你和那个婊子达成了协定？%SPEECH_OFF%你点点头。%SPEECH_ON%协定已经达成了，没错，最后你会死在这柄剑的下面。我相信她更喜欢被称作女巫。%SPEECH_OFF%另一位女巫走了出来。%SPEECH_ON%我们更喜欢叫她贱货。杀了那些雇佣兵。把队长活捉，但要拿掉他的眼睛和那张贱嘴。%SPEECH_OFF%一片女巫汇聚而来，有些已经变成了风骚的少女，而其他人则在进行着仪式的转动。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "战斗！",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
						}

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
