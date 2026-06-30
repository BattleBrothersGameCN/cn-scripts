this.oath_of_distinction_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_distinction";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "能够遵循安瑟姆教诲的人才称得上是杰出。\n让我们立下超群誓言，证明我们有资格走他的路！";
		this.m.TooltipText = "即便是在战场上，小安瑟姆也时常寻求独处。“所谓证明自己，就是取得上至旧神都不会觉得看走眼了的荣耀。”";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{许多剑术大师都行独处之道。他们在战斗时并不直接着眼于结果对手，而是争夺对中间空间的控制。或许你并不理解剑术大师和佣兵挥剑时的个中差别，但是其中的核心理念不言自明。宣誓者，固然追求荣誉，勤勤恳恳，却执于蛮勇，刚愎自用。超群誓言是剑术大师技艺的灵魂，所有宣誓者都应当铭记于心。对任何人都是一样，只有独立证明过自己，面对别人的称赞才能问心无愧。以后要是碰巧有普通信徒看到我们，只要他没有什么偏见，他就绝对不能否认，%companyname%是一支身手不凡的队伍。\n\n但还是让什么超群见鬼去吧。我们不能因为过去的荣耀就洋洋得意！让我们立下新的誓言！}";
		this.m.SuccessButtonText = "{为了小安瑟姆！ | 执誓者万岁！ | 给渡誓者以死亡！}";
		this.m.OathName = "超群誓言";
		this.m.OathBoonText = "所有战团成员 [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] 决心，[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] 每回合疲劳值恢复量，且若相邻格没有队友时，造成的伤害 [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color]。";
		this.m.OathBurdenText = "你的人不会从队友的击杀中获得经验。";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "额外名望：让你的一位战团成员升级" + this.getBonusObjectiveGoal() + " 次(" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		brothers.sort(function ( _a, _b )
		{
			if (_a.getFlags().getAsInt("OathtakersDistinctionLevelUps") > _b.getFlags().getAsInt("OathtakersDistinctionLevelUps"))
			{
				return -1;
			}
			else if (_a.getFlags().getAsInt("OathtakersDistinctionLevelUps") < _b.getFlags().getAsInt("OathtakersDistinctionLevelUps"))
			{
				return 1;
			}

			return 0;
		});
		return brothers[0].getFlags().getAsInt("OathtakersDistinctionLevelUps");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 3;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 2;
		}
		else
		{
			return 2;
		}
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

		if (this.World.Ambitions.getDone() < 1)
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_distinction_trait"));
			bro.getFlags().set("OathtakersDistinctionLevelUps", 0);
		}
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_distinction");
			bro.getFlags().set("OathtakersDistinctionLevelUps", 0);
		}
	}

});
