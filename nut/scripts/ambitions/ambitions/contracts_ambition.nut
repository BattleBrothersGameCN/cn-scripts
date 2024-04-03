this.contracts_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		ContractsToComplete = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.contracts";
		this.m.Duration = 21.000000 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们需要把自己打造成可信赖的雇佣兵团。\n让我们一次又一次地接受考验，毫无疑问地证明这一点！";
		this.m.UIText = "完成更多合同";
		this.m.TooltipText = "完成8份任何形式的合同，证明自己的可靠毋庸置疑。";
		this.m.SuccessText = "[img]gfx/ui/events/event_62.png[/img]出发的时候，全世界都看到了你的本来面目：武装起来的的野心。 每个人都有一个梦想，大约一半的人梦里都有武器。 如果你回过头好好审视过去的自己，你不特别，不杰出，甚至不是多么危险。 但你做到了。 门在你面前关上了。 讨价还价的尝试让你失去了好买卖。 口水，那么多口水。 这是一个寒冷的世界，而你敢于温暖自己。你成功了。\n\n 你手头上的合同，地平线上的合同，他们都模糊在一起。 一种胜利的文化已经开始席卷%companyname%，你有充分的理由为自己的指挥感到自豪。";
		this.m.SuccessButtonText = "我们正在为自己打响名号。";
	}

	function getUIText()
	{
		local d = 8 - (this.m.ContractsToComplete - this.World.Contracts.getContractsFinished());
		return this.m.UIText + " (" + this.Math.min(8, d) + "/8)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1)
		{
			return;
		}

		if (this.World.Contracts.getContractsFinished() >= 15)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.ContractsToComplete = this.World.Contracts.getContractsFinished() + 8;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Contracts.getContractsFinished() >= this.m.ContractsToComplete)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.ContractsToComplete);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.ContractsToComplete = _in.readU16();
	}

});
