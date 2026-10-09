this.rf_random_trio_scenario_intro_event <- ::inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.rf_random_trio_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Title = "三人行";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_80.png[/img]风呼啸过路边一家无名旅店的废墟，昨夜营火的余烬还在火堆里微微发亮。你们三人坐在清晨的寒风里，休养着身躯的酸痛和心灵的疲惫。就在不久前，你们还形同陌路 ―― 被命运，环境，或许还有点儿霉运纠葛在了一起。\n\n几天前，道路还算安全，至少你当时是这么想的。但强盗，野兽或是更可怕的东西，还是降临在了你的头上。也许是商队被伏击，领主的背叛，农庄被焚毁，或者原来的战团分崩离析。现在你孤身一人，走投无路，只有一点点小聪明和捡来的铁家伙可以依靠。\n\n生存的必要，而非信任，让你们站在了一起。当一切尘埃落定，你们都还活着，这肯定不是没原因的。\n\n%bro1%长出了一口气，打破了沉默。%SPEECH_ON%光是盯着火堆看可不能让路变短。%SPEECH_OFF%说着，他拉紧了盔甲上的最后一根带子。%bro2%一边磨着刀一边嗤笑道%SPEECH_ON%本来也算不上什么路，只是一堆土和肯定比上个镇子好的空头承诺罢了。%SPEECH_OFF%%bro3%，更老或者更累的那一个，指着旅店的废墟说道。%SPEECH_ON%哼，这足以证明这承诺有多扯了吧。但钱可不会骗人，我们懂得怎么打架，总会有人为了这个付给我们钱的。%SPEECH_OFF%多么简单的事实。没有要回的家，也没有要侍奉的主子。就你们三个，一些武器，和开阔的道路。如果真的有未来的话，那它一定要用刀剑雕刻，用鲜血铸就。必须要做个决断了。%SPEECH_ON%那就这么定了。我们为金钱而战，为彼此而战，从这乱世里打出个名堂。%SPEECH_OFF%没有仪式，没有豪言壮语，只有三个被命运捆绑的灵魂，迈上了战斗之路。你们的过去已经不再重要。从今天开始，你们是佣兵，是战场上过命的兄弟。你们的名字会被全世界铭记。",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "为了金钱与荣耀！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		foreach( i, bro in ::World.getPlayerRoster().getAll() )
		{
			_vars.push([
				"bro" + (i + 1),
				bro.getNameOnly()
			]);
		}
	}

});
