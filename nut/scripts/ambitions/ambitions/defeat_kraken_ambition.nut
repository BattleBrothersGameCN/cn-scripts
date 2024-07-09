this.defeat_kraken_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_kraken";
		this.m.Duration = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "有传言说，沼泽地里潜伏着一只巨大的野兽。\n如果我们能找到它，杀死它，那我们就能名垂青史！";
		this.m.UIText = "击败克拉肯";
		this.m.TooltipText = "在战斗中击败克拉肯。你能在野外的某个地方找到它。";
		this.m.SuccessText = "[img]gfx/ui/events/event_89.png[/img]它还住在你的梦里，长着湿滑的球状脑袋，装点着睡莲叶子和精致的葛藤，一呼气就像大锅里冒泡的肉汤，气泡破裂掀开了烂泥。它的触须在光影之间中扭动，像是影子的影子。它就在这里，在遥远的黑暗中，在一个虚空中，它已经此地下留了烙印，漫无目的传播着恐怖。不是它出现在了你的梦里，而是你走向了它。你走向黑暗，伸出手来，但也就是这样了。你永远不会真正接近它。有时候你会梦到别的，但你知道那野兽就在某个地方，你只需要打开一扇门或走下几级台阶，你就会再次找到它和它的领地。你无需与你的人交谈，就可以知道他们也做着这样的梦。\n\n全世界都知道你杀戮了克拉肯，但他们认为这是道听途说，是母亲哄孩子睡觉的故事，是父亲通过讲述人类战胜恐怖的壮举来给族人壮胆。但是他们没有亲眼看到。他们接触到的是传言，而不是怪物本身，他们将%companyname%视为活着的传奇。就和所有人们口耳相传的故事一样，战团里的人从中消失，由‘真正’的英雄取代，世界的每一个角落，都在塑造着一个战胜了这个生物的‘真正的勇者’。一个普通的佣兵怎么会有战胜这种野兽的勇气！是东方的骑士！北方的王卫！妆点过的传奇取代了你们的位置。但是与你并肩作战的兄弟们知道真相，即使是垂死的真相也足以激励着你们。\n\n它就这么在黑暗里住下，你也经常去拜访它。";
		this.m.SuccessButtonText = "还有哪位猎人能做出这样的壮举？";
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
