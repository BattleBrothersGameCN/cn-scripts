this.belly_dancer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.belly_dancer";
		this.m.Name = "肚皮舞者";
		this.m.Icon = "ui/backgrounds/background_64.png";
		this.m.BackgroundDescription = "";
		this.m.GoodEnding = "南方肚皮舞者%name%在适当的时候离开了战团。虽然他的……特殊技能使他成为一名出色的士兵，但这并不是他的人生激情所在。通过节奏感强、性感迷人的动作来娱乐观众，这才是他想要的。据你最后听到的消息，他在一位维齐尔的宫廷中，不仅担任娱乐者，而且，多亏了他在%companyname%的时光，为武艺事务提供建议。";
		this.m.BadEnding = "由于战团未能取得你所希望的成功，许多人离开了这支队伍。南方肚皮舞者%name%加入了他们。不幸的是，他试图在北方做生意，认为他可以在那里传播他的文化。当地人很快开始指责他从事“未受约束的身体巫术”，并将其烧死在火刑柱上。";
		this.m.HiringCost = 0;
		this.m.DailyCost = 20;
		this.m.Excluded = [
			"trait.huge",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.fat",
			"trait.strong",
			"trait.hesitant",
			"trait.insecure",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.brute",
			"trait.strong",
			"trait.bloodthirsty",
			"trait.deathwish"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
			this.Const.Attributes.RangedDefense,
			this.Const.Attributes.Bravery
		];
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.SouthernYoung;
		this.m.BeardChance = 0;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.IsCombatBackground = false;
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

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				-5,
				-5
			],
			MeleeSkill = [
				10,
				10
			],
			RangedSkill = [
				5,
				5
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				10,
				10
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
		actor.setTitle("肚皮舞者(the Belly Dancer)");
	}

	function onAddEquipment()
	{
	}

});
