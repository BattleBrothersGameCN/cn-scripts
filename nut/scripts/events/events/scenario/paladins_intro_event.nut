this.paladins_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.paladins_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{你曾经深谙这套游戏规则，但正如所有好游戏最终都会令人厌倦——你受够了那些规则和规则制定者。 这儿一个誓约，那儿一个誓言。 你只知道自己从未能亲手捧起小安塞尔姆的头骨，最后见到的场景竟是某个渡誓者偷走了那孩子的下颌骨。 离开执誓者真是你这辈子最正确的决定，哪怕只是为了保住仅存的一丝理智。\n\n不幸的是，那些忠实信徒对叛教者的气息格外敏感。 今早推开门时，你就像是看到了顽童恶作剧留下的两堆秽物：%oathtaker1% 和 %oathtaker2%，可惜他们是活的。 前者是个始终未能摆脱信仰枷锁的老者，后者则是让你看到自己昔日影子的天才侍从。 毫无疑问，更善言辞的年轻人率先开口：执誓者需要一个熟悉这片土地的人来协助他们完成使命与誓约。 你刚要关门，却发现老者的脚卡在门缝里堵着。 他举起一袋金币，你的鼻子想必翕动了一下——因为两人顿时眼睛发亮。\n\n如今你勉强同意同行，不过是因为时局艰难，况且即便是披着宗教外衣的雇佣兵工作也能带来丰厚的报酬。 既然有人愿意资助这等美差，何乐而不为。 只有一个条件：必须立下统帅之誓，这意味着所有厮杀与艰苦跋涉都将由他人代劳。执誓者们毫不犹豫地同意了，随后向你展示了小安塞尔姆的头骨。虽已与组织断绝联系，但看见那孩子愚钝的颅骨仍在心中激起涟漪。%oathtaker2% 点头道。%SPEECH_ON%让我们涤荡这片土地寻觅荣光，恪尽职守，定要从那些粉碎他的鼠辈渡誓者手中，让小安塞尔姆重获完整！%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "为了财富、荣誉、和小安塞尔姆！",
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
		this.m.Title = "执誓者";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"oathtaker1",
			brothers[0].getName()
		]);
		_vars.push([
			"oathtaker2",
			brothers[1].getName()
		]);
	}

	function onClear()
	{
	}

});
