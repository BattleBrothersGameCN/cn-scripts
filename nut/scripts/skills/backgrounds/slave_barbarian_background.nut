this.slave_barbarian_background <- this.inherit("scripts/skills/backgrounds/slave_background", {
	m = {},
	function create()
	{
		this.slave_background.create();
		this.m.GoodEnding = null;
		this.m.BadEnding = null;
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.WildExtended;
		this.m.Bodies = this.Const.Bodies.AllMale;
		this.m.Names = this.Const.Strings.BarbarianNames;
		this.m.Titles = [
			"野蛮人(the Barbarian)",
			"北人(the Northman)",
			"苍白者(the Pale)",
			"囚犯(the Prisoner)",
			"坏运气(the Unlucky)",
			"受奴役者(the Enslaved)",
			"掠夺者(the Raider)",
			"俘虏(the Captive)",
			"不自由者(the Unfree)",
			"桀骜不驯者(the Unruly)",
			"被压制者(The Restrained)",
			"被束缚者(the Shackled)",
			"被束缚者(the Bound)"
		];
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-10,
				-5
			],
			Stamina = [
				5,
				5
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				-2,
				-1
			],
			RangedDefense = [
				-2,
				-1
			],
			Initiative = [
				-5,
				-5
			]
		};
		return c;
	}

});
