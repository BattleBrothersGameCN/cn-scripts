this.have_z_crowns_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_z_crowns";
		this.m.Duration = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "克朗意味着权力和影响力，有多少我们都不嫌多。让\n我们攒起50000克朗，在国王和贵族们间争得一席之地！";
		this.m.UIText = "拥有至少50000克朗。";
		this.m.TooltipText = "拥有至少50000克朗，跻身富人行列。你可以通过完成合同、掠夺废墟或营地、进行贸易等方式赚钱。";
		this.m.SuccessText = "[img]gfx/ui/events/event_04.png[/img]抢，抢，没错，继续抢！战团积累的财富足以媲美巨龙的财宝。只要一开口，最好的盔甲和武器都是你的。租一艘船或一支舰队，打个响指就行了。当你在城里的时候，各路小摊贩摆出他们最好的商品，他们最渴望帮助你找到新的方式来消费你的黄金。\n\n由于你的财富与贵族不相上下，你也就不用听命于他们了。你可以购买自己的贵族头衔和土地，或者从事商业银行家的职业，只要你厌倦了在这群顽固、喜怒无常的笨蛋面前充当保姆的话。";
		this.m.SuccessButtonText = "好极了。";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 25)
		{
			return;
		}

		if (this.World.Assets.getMoney() >= 45000)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 10000 && !this.World.Ambitions.getAmbition("ambition.have_y_crowns").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 50000)
		{
			return true;
		}

		return false;
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
