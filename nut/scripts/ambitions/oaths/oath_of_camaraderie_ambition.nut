this.oath_of_camaraderie_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {
		DisableEffect = false
	},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_camaraderie";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "没有任何一位宣誓者能够独自面对世界上的所有邪恶。\n让我们立下友谊誓言，以免失去真正的盟友！";
		this.m.TooltipText = "小安瑟姆认为，在特定情况下，即便会带来指挥上的问题，也应该将尽量多的人投入战斗。的确，“每个人都享有与兄弟并肩的权力”。";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{人多力量大，同袍见真情。虽然增派人手会让指挥变得困难，但在一次次的战斗中，%companyname%很快意识到，只要与身旁的战友并肩作战，彼此信任、各司其职，就能克服战场上的混乱。这一经历让战团在战争中得到了淬炼。\n\n如今，这支队伍已经明白，只要彼此信任，就能直面敌人——它已准备好，立下另一道誓言！}";
		this.m.SuccessButtonText = "{为了小安瑟姆！ | 执誓者万岁！ | 给渡誓者以死亡！}";
		this.m.OathName = "友谊誓言";
		this.m.OathBoonText = "你能将最多[color=" + this.Const.UI.Color.PositiveValue + "]14[/color]人带入战斗。";
		this.m.OathBurdenText = "战斗开始时，你的人总会随机处于动摇或崩溃士气。";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "额外名望：队员在战斗中达到自信士气(" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersBrosConfident");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 150;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 100;
		}
		else
		{
			return 50;
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

		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() < 10)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5) + (this.m.IsDone ? 0 : 10) + this.m.TimesSkipped * 2;
	}

	function onUpdateEffect()
	{
		if (!this.m.DisableEffect)
		{
			this.World.Assets.m.BrothersMaxInCombat = 14;
		}
	}

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_camaraderie_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersBrosConfident", 0);
		this.World.Assets.resetToDefaults();
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_camaraderie");
		}

		this.World.Statistics.getFlags().set("OathtakersBrosConfident", 0);
		this.m.DisableEffect = true;
		this.World.Assets.resetToDefaults();
		this.World.Assets.updateFormation(true);
	}

});
