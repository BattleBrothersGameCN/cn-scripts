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
		this.m.SuccessText = "[img]gfx/ui/events/event_89.png[/img]它还住在你的梦里，它有一个光滑的球状脑袋，上面装点着睡莲叶子、精致的葛藤，它的呼气就像大锅里的肉汤的呼噜声一样，把烂泥掀开。 它的触须在光影之间中扭动，像是叠起来的影子。 它就在这里，在遥远的黑暗中，在一个虚空中，它已经留在此下了烙印，并变幻为一种无意义的恐怖。 在它出现在你的梦中时，你已经与它近距离接触了。 你进入黑暗、向前，伸出手来，但也就是这样了。 你永远不会真正接近它。 有时候你会梦到别的，但你知道那野兽就在某个地方，你只需要打开一扇门或走下几级台阶，你就会再次找到它和它的领地。 你无需与你的人交谈，就可以知道他们也做着这样的梦。\n\n全世界都知道你杀戮了克拉肯，但他们认为这是道听途说，是母亲哄孩子睡觉的故事，是父亲通过讲述人类战胜恐怖的壮举来给族人壮胆。 但是他们没有亲眼看到。 他们接触到的是传言，而不是怪物本身，他们将 %companyname% 视为现实的传说。 就像任何人们口耳相传的故事一样，战团里的人从中消失，由‘真正’的英雄取代，世界的每一个角落都在塑造一个战胜了这个生物的更勇敢的胜利者。一个普通的佣兵怎么会有战胜这种野兽的勇气！ 是东方的骑士！ 北方的王卫！ 妆点过的传奇取代了你们的位置。 但是与你并肩作战的兄弟们知道真相，即使是垂死的真相也足以继续下去。\n\n 它就住在黑暗中，你也经常去拜访它。";
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
