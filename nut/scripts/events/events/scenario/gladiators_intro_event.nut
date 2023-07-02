this.gladiators_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.gladiators_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_147.png[/img]{杀死一个人本是小事一桩，然而陌生能使肉体坚韧：凶手们在街上被捉住，扼紧喉咙，拉住臂膀，钳住双手，嚷嚷着为什么他们的受害者没有死。 母亲的遗产被毁了，一遍又一遍的用火钩击打她的丈夫，而他在火星熄灭后仍长叹连连。 一个无聊的维齐尔不知道为什么他的施虐者们要和一个罪犯搏斗，而那个疯狂的人嘲笑他们被阉割了最重要的附属物。\n\n但是对于角斗士来说，一个人不仅仅是一个人，他还是一个武器的使用者。 剑，斧，矛，三叉戟等等。 当你略过这些显而易见的辩护，他仅仅是最熟悉不过的肉体，驱使他的不是斗争而是为了娱乐。娱乐！ 和比赛里各色肤色的人们竞争，以及人群的狂欢。 这些都是你喜爱的事物。 让哲学家们继续谈论事物生死存亡的本质吧。 当你把剑猛插进一些蠢货的脖子中时，不仅有鲜血喷涌到了你的锋刃之上，亦有人群喷涌出对你的成就的欢呼赞美之声！ 这是世界上最美妙的声音！ 追随而来的女人们，如此热辣令人苦恼，她们甚至不等你清理干净内脏就要开干？荣耀啊。\n\n但是事情也渐渐变得枯燥。 已经发生多少场战斗？ 你数不清了。有过多少挑战？ 你甚至连一次都说不出。 一次都没有！%g1%，%g2%，和 %g3% 都同意，是你太优秀了。 要说实话的话他们也同样很棒。 不过你们四个都同意：你们应该离开竞技场在整个世界塑造冠军之魂。\n\n角斗士们有一些奢侈的癖好，特别是香薰浴和刻有他们名字的珠宝首饰，所以当你为他们在舒适的城邦之外的奢华生活方式提供资金时，请准备好为他们支付一笔可观的费用。 事实也会如此。 你的三个坚实有力但不总是伟大的战斗伙伴将展现他们的武力，而你也将面临一项新的挑战：学习如何管理战士（和你们不是一个水平的）和他们的需求。}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "应该很容易。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "角斗士";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"g1",
			brothers[0].getName()
		]);
		_vars.push([
			"g2",
			brothers[1].getName()
		]);
		_vars.push([
			"g3",
			brothers[2].getName()
		]);
	}

	function onClear()
	{
	}

});
