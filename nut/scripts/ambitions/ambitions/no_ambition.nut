this.no_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.none";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "战团做得很好，我们只需要保持下去！\n（没有野心）";
		this.m.RewardTooltip = null;
	}

	function getButtonTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "header",
				text = "没有野心"
			},
			{
				id = 2,
				type = "text",
				text = "暂不选择野心。三天后，你会再次被要求选择。"
			}
		];
		return ret;
	}

});
