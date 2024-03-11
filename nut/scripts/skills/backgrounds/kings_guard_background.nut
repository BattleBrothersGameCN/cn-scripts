this.kings_guard_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.kings_guard";
		this.m.Name = "国王护卫";
		this.m.Icon = "ui/backgrounds/background_59.png";
		this.m.BackgroundDescription = "";
		this.m.GoodEnding = "当你在北方荒野中发现冻僵的%name%时，你以为他只不过是个乡下人。然而事实证明，他是个名副其实的国王护卫。他为保护自己的领主而战，而他的敌人是整个世界。所幸，那段时间里，那个“领主”恰好是你。据你最近听到的消息，他前往了南方，护卫着一个新兴的游牧民国王，试图推翻当地的维齐尔。";
		this.m.BadEnding = "你从没彻底搞清楚%name%加入%companyname%之前“护卫”的到底是哪位国王，但现在这已经不重要了。在你突然退休后，这个国王护卫动身去了南方沙漠。他曾为一位维齐尔服务，但没能保护贵族免受妃子的毒害。作为惩罚，%name%的装备被熔化成一锅铁水，倒入了他的喉咙里。";
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
