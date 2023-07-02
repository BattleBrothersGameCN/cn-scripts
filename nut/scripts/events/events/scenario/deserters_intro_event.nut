this.deserters_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.deserters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_88.png[/img]{穿着破旧的老靴子远征。 天降大雪？战斗。倾盆大雨？战斗。 被重骑兵冲锋？ 拿上你的长矛。 战斗。战斗。一直在战斗。 但是最简单的机械也会受到侵蚀。 申请一双袜子，却被告知要去偷农民的。 申请要一份更好的餐食，被问到你全心全意的完成你的使命了吗。\n\n 作为一个兵丁本身并不困扰你。 杀人也不会困扰你，死亡的威胁也不会困扰你。 贵族们的不尊重，那些“勇敢地”把你扔进绞肉机的副官们的不负责任，这些都削弱了你的意志。 还有无聊。 无尽的日复一日的无聊。\n\n 讽刺的是当你逃离营地的那一天有三个和你一样的逃兵也做了同样的事情。 每个人都被分发了一顿大餐。 他们称之为对胜利的庆祝。 你的盘子里面装满了食物。 这些本应该属于那天死在战场上的人的。 但是你吃了那些食物。 你吃光了那些食物。 然后你拿起你的包，去守夜，然后就溜了。 为了策划出逃，其他三个逃兵选择听从你的命令。\n\n 之后你会开辟一条佣兵之路，至少得到的报酬会和你的痛苦相称。 但首先，你必须到别的地方去，因为如果你在这里呆久了，绞架肯定是你的人生归宿。}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们的命运掌握在自己手中。",
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
		this.m.Title = "逃兵";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});
