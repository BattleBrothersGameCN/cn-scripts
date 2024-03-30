this.belly_dancer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.belly_dancer";
		this.m.Name = "肚皮舞者";
		this.m.Icon = "ui/backgrounds/background_64.png";
		this.m.BackgroundDescription = "";
		this.m.GoodEnding = "南方肚皮舞者%name%在适当的时候离开了战团。虽然他的……特殊技能让他成为了一名出色的士兵，但这并不是他生活的动力所在。通过节奏感强、性感迷人的动作来娱乐观众，才是他的人生追求。你最近听说，他不仅在维齐尔的宫廷中表演，还凭借在%companyname%的经历，提供起了军事参谋服务。";
		this.m.BadEnding = "战团不像你想象的那么成功，许多人离开了这支队伍。来自南方肚皮舞者%name%也加入了他们的行列。不幸的是，他想在北方做生意，借此传播他的文化。没多久，当地人就指控他使用“突破身体限制的巫术”，把他送上了火刑柱。";
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
