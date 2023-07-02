this.cultist_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.cultist";
		this.m.Name = "邪教徒";
		this.m.Icon = "ui/backgrounds/background_34.png";
		this.m.BackgroundDescription = "邪教徒有决心进一步传播他们鲜为人知的邪教。";
		this.m.GoodEnding = "邪教徒，%name%，带着一伙披着斗篷的皈依者离开了战团。你不知道他后来怎么样了，但你偶尔会梦见他。他常常独自站在一处巨大的虚空中，黑暗之外总是有一个人或者某种东西徘徊。这个画面每天晚上都会变得越来越清晰，而每个晚上你都发现自己熬得越来越晚，只是为了避免做梦。";
		this.m.BadEnding = "你听说%name%，那个邪教徒，在某个时刻离开了战团，出去传播他的信仰。没人知道他后来怎么样了，但最近有一场针对邪恶信仰的宗教审判，数百名“披着黑斗篷，意图则更黑暗的人”在各地被处以火刑。";
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
			"疯子(the Mad)",
			"信徒(the Believer)",
			"神秘学者(the Occultist)",
			"疯狂者(the Insane)",
			"追随者(The Follower)",
			"迷失者(the Lost)",
			"怪人(the Odd)",
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
		return "{这个男人站在那里，脖子上挂着一块牌子。 | 这个男人的脸上满是刺青。他带着一张纸条。 | 这个男人把脸藏在一件很深的斗篷里，一个孤立的鼻尖就是你在黑暗中看到的一切。他脖子上挂着一块牌子。 | 奇怪的是，这人衣衫褴褛却热时不出汗、冷时不发抖。他紧紧抓着一个卷轴，仿佛它能保护他免受恶劣天气的侵袭。 | 他的手臂上以疤痕的形式书写着经文，疯狂的终曲。 | 这个陌生人在泥土上写字，就像一个已经写过一千遍的人一样快。他的意思显而易见。 | 那个人站着，弯曲的手臂后面夹着一本大书，他把书递向你。打开它，皮革的手感与你以前接触过的不同。里面只有一个段落，反复书写着。}它的内容是：“在永恒的宅邸拉莱耶中，长眠的达库尔在此静候。他是所有，他是开端。分享所在拯救世人于阴暗。”嗯……有点古怪。";
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
