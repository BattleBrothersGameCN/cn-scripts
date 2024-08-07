this.broken_knee_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.broken_knee";
		this.m.Name = "膝盖骨折";
		this.m.Description = "这个角色的膝盖受到了创伤，无法完全康复。前进或躲闪都十分痛苦，动作也显得别扭。";
		this.m.Icon = "ui/injury/injury_permanent_icon_11.png";
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
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] 近战防御"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] 远程防御"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color]主动值"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "总是满足于充当后备"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefenseMult *= 0.6;
		_properties.RangedDefenseMult *= 0.6;
		_properties.InitiativeMult *= 0.6;
		_properties.IsContentWithBeingInReserve = true;
	}

	function onApplyAppearance()
	{
	}

});
