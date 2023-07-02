this.brain_damage_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.brain_damage";
		this.m.Name = "脑损伤";
		this.m.Description = "头部的受到的重击使一些东西摇晃起来，并没有完全有利于这个角色的认知能力。从好的方面来说，他现在可能太蠢了，不知道什么时候该跑了。";
		this.m.Icon = "ui/injury/injury_permanent_icon_12.png";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] 决心"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] 经验获取"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] 主动性"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 1.150000;
		_properties.XPGainMult *= 0.750000;
		_properties.InitiativeMult *= 0.750000;
	}

	function onApplyAppearance()
	{
		local sprite = this.getContainer().getActor().getSprite("permanent_injury_1");
		sprite.setBrush("permanent_injury_01");
		sprite.Visible = true;
	}

});
