this.oath_of_fortification_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_fortification";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "邪恶之徒躲藏在公理与正义的高墙之外。\n让我们立下壁垒誓言，把这堵高墙拍在他们脸上！";
		this.m.TooltipText = "“信任你的盾牌，就像你相信旧神一样，因为树木和土地的贡献不应被浪费在懦夫的神经紧张上。” - 年轻的安瑟姆";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{古帝国文献中所记载的军事阵型十分紧凑，动起来宛如移动的堡垒：数百面盾牌紧紧相连，如同蛇鳞或龟甲。%companyname%竭尽全力去复现这些理论，但要将各个要素整合起来毕竟需要时间，你从没有指望这次演练能有多成功。古人能建立帝国自有其原因，而你们只是一群不合群的执誓者。但依你的判断 ——战团是否还活着 —— 这次誓约可谓大获成功。\n\n现在是时候放下盾牌和对古代帝国的狂热，立下新的誓言了！}";
		this.m.SuccessButtonText = "{为了小安瑟姆！ | 执誓者万岁！ | 给渡誓者以死亡！}";
		this.m.OathName = "壁垒誓言";
		this.m.OathBoonText = "你的所有战团成员中使用盾牌技能时减少 [color=" + this.Const.UI.Color.NegativeValue + "25%疲劳值积累。”盾墙“技能提供额外 [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] 近战防御和 [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] 远程防御。“击退”技能在成功命中时会对目标施加踉跄效果。";
		this.m.OathBurdenText = "你的所有战团成员在战斗的第一个回合无法移动。";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() <= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "如果你在誓言期间从未损失过战团成员，你将获得额外的名望 (" + this.getBonusObjectiveProgress() + "已死亡)";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersBrosDead");
	}

	function getBonusObjectiveGoal()
	{
		return 0;
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5) + (this.m.IsDone ? 0 : 10) + this.m.TimesSkipped * 2;
	}

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_fortification_trait"));
			bro.getSkills().add(this.new("scripts/skills/special/oath_of_fortification_warning"));
		}

		this.World.Statistics.getFlags().set("OathtakersBrosDead", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_fortification");
			bro.getSkills().removeByID("special.oath_of_fortification_warning");
		}

		this.World.Statistics.getFlags().set("OathtakersBrosDead", 0);
	}

});
