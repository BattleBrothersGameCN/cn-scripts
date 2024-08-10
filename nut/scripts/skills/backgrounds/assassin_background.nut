this.assassin_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.assassin";
		this.m.Name = "刺客";
		this.m.Icon = "ui/backgrounds/background_53.png";
		this.m.BackgroundDescription = "";
		this.m.GoodEnding = "%name%加入了战团，接替了他原本要杀死的贵族私生子。这样的协议有些荒诞，以至于你关注了这名刺客很久。但他就是单纯地为%companyname%而战，还表现得非常出色。最近你听到，这名刺客已经离开了战团，从此断绝了音讯。你亲自去看那私生子本人，想知道刺客是否完成了任务，却发现他还活得好好的。真是一次独特的邂逅。";
		this.m.BadEnding = "%name%加入了战团，接替了他原本要杀死的贵族私生子。这样的协议有些荒诞，以至于你关注了这名刺客很久。但他就是单纯地为%companyname%而战，还表现得非常出色。最近你听说，刺客在你草草退休后很快就离开了战团。你决定亲自看看作为他目标的贵族私生子，却只得知，他死于一名来去无踪的刺客之手。看来%name%最终还是完成了任务。";
		this.m.HiringCost = 800;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.huge",
			"trait.weasel",
			"trait.teamplayer",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.dumb",
			"trait.loyal",
			"trait.clumsy",
			"trait.fat",
			"trait.strong",
			"trait.hesitant",
			"trait.insecure",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.brute",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
			this.Const.Attributes.RangedDefense,
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"刺客"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = 4;
		this.m.IsCombatBackground = true;
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
				10,
				10
			],
			Stamina = [
				-5,
				-5
			],
			MeleeSkill = [
				12,
				10
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				20,
				15
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
		actor.setTitle("刺客");
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/rondel_dagger"));
		items.equip(this.new("scripts/items/armor/thick_dark_tunic"));
		items.equip(this.new("scripts/items/helmets/hood"));
	}

});
