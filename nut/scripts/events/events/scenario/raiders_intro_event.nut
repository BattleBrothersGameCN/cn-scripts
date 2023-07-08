this.raiders_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.raiders_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_94.png[/img]{在你和你的部队杀掉了一半的村民之后村民们终于投降了。 一面白色的小旗从中升起并且村民们还要求停战，你很乐意答应他们。 村民们一字排开的走向他们之前举行节日庆典的城镇广场。 村民们一个一个的把怀中的珠宝和财宝放到了你脚下被打碎的镇长的脑袋旁边。 你的先锋部队 %raider1%，%raider2%，%raider3% 和 %raider4% 小心地看着村民们就像秃鹰看着快死的动物慢慢死去一样。\n\n 队伍中最后一个人是个僧侣。 他的身上没有任何金子或者银子并且还开始对你说话，他的行为立刻让你的手下们掏出了他们的武器。 你允许了他说话，但是他却开始谈论古老的神明是怎么被天堂取代的并且如果你相信了天堂又会有怎样的财富等待着你。 你告诉他他这张灵巧的嘴只会早就自己的死亡之后。 僧侣赶紧闭上了嘴但是又慢慢说到。%SPEECH_ON%好吧，好吧如果你真的想要财富的话就放弃这种无聊愚蠢的游戏吧。 这种掠夺和抢劫根本比不上南方财富的哪怕一点点。 贵族首领们肯定不会让你加入他们的军队但是他们会很乐意雇佣一队佣兵并且他们才不会用他们宝贵的时间研究这队雇佣兵是从哪里来的。 你将会得到你梦寐以求的财富的。 去南方吧，掠夺者，去作为以队佣兵生活吧。%SPEECH_OFF%%raider3% 想要把这个僧侣的头砍下来但是你把这个处决决定先保存了下来。 相反，你听信了这个狡猾的僧侣的话。 你早就听说过了南方的财富和冒险者被雇佣来战斗的故事。 你决定去南方，并且带上了这个僧侣和你一起。%raider3% 对于这个带上僧侣这个决定是抗拒的但是你根本没听。 因为如果这个小白脸僧侣是你去往新生活的幸运护符的话，杀掉他就是对古老神明的侮辱了。 其他掠夺者们鸟兽一样散去，但是 %raider1%，%raider2% 和 %raider4% 对于跟随你的领导没有任何异议。 其他的掠夺者们返回了北方并且分掉了掠夺的财富。 留下来的村庄还需要重建和回复并且还会有新的陌生部落前来拿走他们想要的财富。}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们会向南方前进。",
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
		this.m.Title = "北方掠袭者们";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"raider1",
			brothers[0].getName()
		]);
		_vars.push([
			"raider2",
			brothers[1].getName()
		]);
		_vars.push([
			"raider3",
			this.Const.Strings.BarbarianNames[this.Math.rand(0, this.Const.Strings.BarbarianNames.len() - 1)]
		]);
		_vars.push([
			"raider4",
			brothers[2].getName()
		]);
	}

	function onClear()
	{
	}

});
