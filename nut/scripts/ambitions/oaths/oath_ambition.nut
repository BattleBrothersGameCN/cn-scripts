this.oath_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		OathDuration = 10,
		OathName = "",
		OathBoonText = "",
		OathBurdenText = ""
	},
	function getOathName()
	{
		return this.m.OathName;
	}

	function create()
	{
		this.ambition.create();
		this.m.IsCancelable = false;
		this.m.IsRepeatable = true;
	}

	function getButtonTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.m.OathName
			},
			{
				id = 2,
				type = "text",
				text = this.getTooltipText() + "\n\n"
			}
		];
		ret.push({
			id = 4,
			type = "header",
			text = "誓言恩赐"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/ambition_tooltip.png",
			text = this.m.OathBoonText
		});
		local reward_tooltip = this.getRewardTooltip();

		if (this.isGrantingRenown())
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/ambition_tooltip.png",
				text = "你的名望会提高，这意味着合同报酬的增长和新合同类型的可能。" + (reward_tooltip == "" ? "\n\n" : "")
			});
		}

		if (reward_tooltip != "")
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/ambition_tooltip.png",
				text = reward_tooltip + "\n\n"
			});
		}

		ret.push({
			id = 7,
			type = "header",
			text = "誓言之担"
		});
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/ambition_tooltip.png",
			text = this.m.OathBurdenText
		});
		return ret;
	}

	function getUIText()
	{
		local timeRemaining = this.m.OathDuration - this.Math.floor((this.Time.getVirtualTimeF() - this.m.StartTime) / this.World.getTime().SecondsPerDay);
		return "当前立下 " + this.m.OathName + "为期尚余" + (timeRemaining > 1 ? "共" + timeRemaining + "天" : " 1天");
	}

	function getRenownOnSuccess()
	{
		return this.Const.World.Assets.ReputationOnOathAmbition;
	}

	function onCheckSuccess()
	{
		if ((this.Time.getVirtualTimeF() - this.m.StartTime) / this.World.getTime().SecondsPerDay >= this.m.OathDuration)
		{
			return true;
		}

		return false;
	}

});
