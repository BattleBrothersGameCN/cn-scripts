this.regent_in_absentia_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.regent_in_absentia";
		this.m.Name = "缺席的统治者";
		this.m.Icon = "ui/backgrounds/background_06.png";
		this.m.HiringCost = 135;
		this.m.DailyCost = 17;
		this.m.Excluded = [
			"trait.clumsy",
			"trait.fragile",
			"trait.spartan",
			"trait.clubfooted"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
		this.m.IsCombatBackground = true;
		this.m.IsNoble = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name%不再被皇室断绝关系，但他现在效忠于%companyname%。尽管他没有回到自己的家族，但你知道在他内心深处，回归了血脉使他更加勇敢。}";
	}

	function onAddEquipment()
	{
	}

});
