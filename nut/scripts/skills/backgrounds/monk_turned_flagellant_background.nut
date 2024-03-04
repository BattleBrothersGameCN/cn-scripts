this.monk_turned_flagellant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.monk_turned_flagellant";
		this.m.Name = "从僧侣转变为的自笞者";
		this.m.Icon = "ui/backgrounds/background_26.png";
		this.m.HiringCost = 60;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.clubfooted",
			"trait.tough",
			"trait.strong",
			"trait.disloyal",
			"trait.insecure",
			"trait.cocky",
			"trait.fat",
			"trait.fainthearted",
			"trait.bright",
			"trait.craven",
			"trait.greedy",
			"trait.gluttonous"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.IsOffendedByViolence = true;
	}

	function onBuildDescription()
	{
		return "这个世界太过黑暗，让%name%的修行之路无以为继。一位自笞者通过谈话向他展示了旧神对人们期望通过温和手段追求正义的不满。现在，这位曾经的僧侣开始鞭打自己，一次又一次将血淋淋的正义洒向这个世界。";
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();

			if (actor.getTitle() == "")
			{
				actor.setTitle(this.Const.Strings.PilgrimTitles[this.Math.rand(0, this.Const.Strings.PilgrimTitles.len() - 1)]);
			}
		}
	}

	function onAddEquipment()
	{
	}

});
