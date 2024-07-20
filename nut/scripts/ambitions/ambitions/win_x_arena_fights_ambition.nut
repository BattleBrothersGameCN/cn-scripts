this.win_x_arena_fights_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		ArenaMatchesToWin = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_x_arena_fights";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "让人们高呼着我们的名字，给我们带来名声\n和财富。我们要在南方的竞技场上挥洒鲜血！";
		this.m.UIText = "赢得竞技场战斗";
		this.m.TooltipText = "进入南方城邦的竞技场，赢得5场战斗。";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]杀死了各种有两条腿或更多条腿，或者可能根本没腿的生物之后，你已经靠你的角斗能力赢得了相当多的声望。南方人说起你的名字，就像它会带来好消息一样，他们间接地享受着你的胜利，并希望看到你赢得更多比赛。真是命运无常 —— 大多数人来竞技场是为了看角斗士尽可能惨烈的死去。让大众为你欢呼的想法，通过一种奇怪的方式实现了，这你刚刚才意识到的，虽然你一出场便会座无虚席，但观众不光是奔着你，也是奔着看出丑来的，不过出丑的不是你，而是你的对手。说实话，只要钱给得够多，满足满足观众的嗜血欲也没什么不可以。";
		this.m.SuccessButtonText = "他们还在高喊着我们的名字！";
	}

	function getUIText()
	{
		local d = 5 - (this.m.ArenaMatchesToWin - this.World.Statistics.getFlags().getAsInt("ArenaFightsWon"));
		return this.m.UIText + " (" + this.Math.min(5, d) + "/5)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1 && this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") > 10)
		{
			return;
		}

		this.m.ArenaMatchesToWin = this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") + 5;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= this.m.ArenaMatchesToWin)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.ArenaMatchesToWin);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 55)
		{
			this.m.ArenaMatchesToWin = _in.readU16();
		}
	}

});
