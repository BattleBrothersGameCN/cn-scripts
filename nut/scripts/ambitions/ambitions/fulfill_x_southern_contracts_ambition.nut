this.fulfill_x_southern_contracts_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		ContractsToFulfill = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.fulfill_x_southern_contracts";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "南方的城邦拥有很多的克朗。\n我们会在炽热的沙漠阳光下发财！";
		this.m.UIText = "履行城邦的合同";
		this.m.TooltipText = "向南旅行，访问南方的城邦并在那里找到工作。接受并完成上层统治者的合同。";
		this.m.SuccessText = "[img]gfx/ui/events/event_150.png[/img]南方人对知识和礼仪的追求，并不影响他们理解你雇佣兵的身份。北方的人们说你带武力而去，这里的人们说你逐克朗而来。你对这两种归因都不太在意，只认识到一个残酷的现实，就算他们鄙视你，他们还是会找你替他们干活，嘉奖你的才能，在危难关头想到你的买卖。\n\n这就是北方和南方共同的基石：克朗的力量。语言，宗教，民族，都见鬼去吧。一点金子不需要翻译，不需要调解，也不需要仲裁。你对克朗的追求表明你对南方人是可靠的，你的名声也像他们的口袋一样深。";
		this.m.SuccessButtonText = "金子就是金子。";
	}

	function getUIText()
	{
		local d = 5 - (this.m.ContractsToFulfill - this.World.Statistics.getFlags().getAsInt("CityStateContractsDone"));
		return this.m.UIText + " (" + this.Math.min(5, d) + "/5)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("CityStateContractsDone") > 15)
		{
			return;
		}

		this.m.ContractsToFulfill = this.World.Statistics.getFlags().getAsInt("CityStateContractsDone") + 5;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("CityStateContractsDone") >= this.m.ContractsToFulfill)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.ContractsToFulfill);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.ContractsToFulfill = _in.readU16();
	}

});
