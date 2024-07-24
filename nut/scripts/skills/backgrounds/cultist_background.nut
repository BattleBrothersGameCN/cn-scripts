this.cultist_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.cultist";
		this.m.Name = "邪教徒";
		this.m.Icon = "ui/backgrounds/background_34.png";
		this.m.BackgroundDescription = "邪教徒有决心让他们那首屈一指的邪教广为流传。";
		this.m.GoodEnding = "邪教徒%name%离开了战团，还带走了一群披着斗篷的皈依者。你不知道他后来如何，但你偶尔会梦见他，梦见他独自站在无垠的虚空中，深邃的虚空深处有什么东西在徜徉徘徊。日复一日，这个画面变得越来越清晰，为了避免做梦，你不自觉熬得越来越晚。";
		this.m.BadEnding = "你听说，邪教徒%name%在某个时刻离开了战团，出去传播他的信仰。没人知道他近况如何，但前不久的一场宗教审判中，因邪恶信仰被捕的人数以百计，审判庭指控他们“黑斗篷底下包藏黑心”，把他们处以火刑。";
		this.m.HiringCost = 50;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.night_blind",
			"trait.lucky",
			"trait.athletic",
			"trait.bright",
			"trait.drunkard",
			"trait.dastard",
			"trait.gluttonous",
			"trait.insecure",
			"trait.disloyal",
			"trait.hesitant",
			"trait.fat",
			"trait.bright",
			"trait.greedy",
			"trait.craven",
			"trait.fainthearted"
		];
		this.m.Titles = [
			"邪教徒(the Cultist)",
			"疯子",
			"信徒",
			"神秘学者(the Occultist)",
			"疯狂者(the Insane)",
			"The Follower",
			"迷失者(the Lost)",
			"怪人",
			"歧途者(the Misguided)",
			"狂热者(the Fanatic)",
			"狂信者(the Zealot)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{这人脖子上挂着块牌子。 | 这人的脸上满是刺青。他带着一张纸条。 | 这人的脸埋在深深的斗篷里，黑暗中透出一个突兀的鼻尖。他脖子上挂着一块牌子。 | 这人衣衫褴褛，但他却热不出汗、冷不发抖。仿佛是他紧攥着的卷轴保护了他。 | 疤痕在他手臂上写出经文，所谓疯狂的终曲。 | 这个陌生人在泥土上写字，快似已经写过千百遍。他的意思显而易见。 | 这人弯着手臂，手臂里夹着一本大书，他把书递向你，书皮的触感和你以往接触过的都不同，翻开它，里面却只有一个反复书写的段落。}上面写着：“在永恒的宅邸拉莱耶中，长眠的达库尔在此静候。他是所有，他是开端。分享所在拯救世人于阴暗。”嗯……有点古怪。";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				5
			],
			Bravery = [
				15,
				10
			],
			Stamina = [
				3,
				3
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
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 50)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("tattoo_01_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			tattoo_head.setBrush("tattoo_01_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("tattoo_01_" + body.getBrush().Name);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/monk_robe"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/cultist_leather_robe"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/cultist_hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/cultist_leather_hood"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});
