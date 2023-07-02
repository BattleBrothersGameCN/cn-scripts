this.defeat_kraken_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_kraken";
		this.m.Duration = 35.000000 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "有传言说沼泽地里潜伏着一只巨大的野兽。\n如果我们找到并杀死它，无上的荣誉将属于我们！";
		this.m.UIText = "击败克拉肯";
		this.m.TooltipText = "在战斗中击败克拉肯。 你能在野外的某个地方找到它。";
		this.m.SuccessText = "[img]gfx/ui/events/event_89.png[/img]在你的想象中，它有一个光滑的球状脑袋，上面装点着睡莲叶子、精致的葛藤，它的呼气就像大锅里的肉汤的呼噜声一样，把烂泥掀开。 它的触须在半影中扭动，像一个叠加的影子。 因此，它就在这里，在遥远的黑暗中，在一个虚空中，它已经留在此下了烙印，并变幻为一种无聊的恐怖。 在它出现在你的梦中时，你已经与它近距离接触了。 你进入黑暗、向前，伸出手来，但这就是你所做的一切。 你永远不会真正靠近。 有时候你的梦会是别的，但你知道野兽就在那里的某个地方，你只需要打开一扇门或走下几级台阶，你就会再次找到它和它的领地。 你无需与你的人交谈，就可以知道他们也想这样做。\n\n 全世界都知道你杀戮了克拉肯，但他们通过小道消息注意到这一点，他们认为这是一种母亲催促孩子睡觉的口吻或父亲通过讲述人类战胜恐怖的胜利来对于亲人的鼓励。 但是他们没有看到。 他们看到的是谣言，而不是怪物，他们将 %companyname% 视为现实的传说。 就像每天的传说一样，战团里的人从中消失，由真正的英雄取代，世界的每一个角落都在塑造一个战胜了这个生物的更勇敢的胜利者。 俗话说，一把普通的宝剑决不会塑造这样勇敢的野兽！ 是东方的骑士！ 北方的卫王！ 自负取代了你的位置。 但是与你并肩作战的兄弟们知道真相，即使是垂死的真相也足以继续下去。\n\n 所以它就住在黑暗中，你也经常去拜访它。";
		this.m.SuccessButtonText = "还有哪位猎人能自信拥有这样的专长？";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().Days <= 100)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 20)
		{
			return;
		}

		if (this.World.Flags.get("IsKrakenDefeated"))
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Flags.get("IsKrakenDefeated"))
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
