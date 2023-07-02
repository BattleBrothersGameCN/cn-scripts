this.kings_guard_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.kings_guard";
		this.m.Name = "国王护卫";
		this.m.Icon = "ui/backgrounds/background_59.png";
		this.m.BackgroundDescription = "";
		this.m.GoodEnding = "当你在北方荒野中发现冻僵的他时，你以为%name%只是一个简单的农民。然而事实证明，他不仅在名义上是个国王护卫，而且在行动上也是如此。他像保护自己的领主免受外界侵害的男人一样战斗。庆幸的是，有段时间里，那个“领主”恰好是你。据你最后听说的消息，他前往了南方，正护卫着一个刚刚兴起的游牧民国王，试图推翻当地的维齐尔。";
		this.m.BadEnding = "你永远没有真正弄清楚%name%在加入%companyname%之前“护卫”的是哪个国王，但现在这已经不重要了。在你突然退休后，这个国王护卫自己去了南方沙漠。他曾为一位维齐尔服务了一段时间，但未能保护国王免受妃子的毒药侵害。作为惩罚，%name%的装备被熔化成一锅，倒入了他的喉咙里。";
		this.m.HiringCost = 0;
		this.m.DailyCost = 30;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
		actor.setTitle("国王护卫(the Kingsguard)");
	}

});
