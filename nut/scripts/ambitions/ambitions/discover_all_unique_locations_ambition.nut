this.discover_all_unique_locations_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.discover_all_unique_locations";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "世界各地的传说地点，隐藏着奇妙的秘密。\n在我们不找到它们的每一个前绝不罢休！";
		this.m.UIText = "发现世界上所有传奇地点";
		this.m.TooltipText = "通过自己探索荒野，发现世界上所有传奇宝藏。 出发前一定要储备好食物！";
		this.m.SuccessText = "[img]gfx/ui/events/event_45.png[/img]你地图的边缘已磨损，折痕磨损得尤其厉害，连你的手指头都知道。 这张纸比它看起来要重要得多，它指引你免受雨雪侵袭，它垫起了你的稻草床铺，它在危急时刻差点被用作引火物。 但它也比它看起来要轻，因为风已经直接从你的手指上偷走了它好几次了，你一直在田野里追逐它，像一只要失去猎物的豺狼一样大喊大叫，在它扭来扭去逃跑时，还骂它是婊子干的活。\n\n根据最初制图师的作品，你的战团不会离开道路或城镇。 他曾写过诸如“厄运且只有厄运”和“这里有强盗和他们干不了正经营生的妈”之类的警告。 你忽略了其中的许多内容，把你自己的探索地界用蜿蜒的线条画在了上面。 这些地方不是迷信传说，而是 %companyname% 想去也确实去过的地方。鉴于你在这张发软地图上刻下的线条，对于这些与世隔绝的地方，你已经算得上是个臭名昭著的准探险家了。 说不定除了这里，更远的地方也许还有些什么？";
		this.m.SuccessButtonText = "我们绘制自己的地图。";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.discover_unique_locations").isDone())
		{
			return;
		}

		if (!this.World.Flags.has("LegendaryLocationsDiscovered"))
		{
			this.World.Flags.set("LegendaryLocationsDiscovered", 0);
		}

		if (this.World.Flags.get("LegendaryLocationsDiscovered") >= 11)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		return this.World.Flags.get("LegendaryLocationsDiscovered") >= 11;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});
