this.gravedigger_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gravedigger";
		this.m.Name = "掘墓人";
		this.m.Icon = "ui/backgrounds/background_28.png";
		this.m.BackgroundDescription = "掘墓人习惯于体力劳动和处理尸体。";
		this.m.GoodEnding = "随着%companyname%取得巨大成功，掘墓人%name%得以继续践行他的老本行。钱越攒越多，他最终离开了战团，回到了墓园。上次你听说，他已经退休，重新开始挖洞，幸福地抚养着一个司事家庭。";
		this.m.BadEnding = "据说，掘墓人%name%是最后离开%companyname%的人之一。他身无分文，沉迷饮酒，你最后听到的消息是，人们在泥水沟里发现了他的尸体。";
		this.m.HiringCost = 50;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.night_blind",
			"trait.swift",
			"trait.cocky",
			"trait.craven",
			"trait.fainthearted",
			"trait.dexterous",
			"trait.quick",
			"trait.iron_lungs",
			"trait.optimist"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
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
		return "{%name%的掘墓生涯从埋葬自己年幼的弟弟开始。 | 趁父亲喝醉的当口，%name%把他抹了脖子。先是掩埋了罪证，然后是前来问话的治安官。他掘墓的开始可谓不光彩。 | 疫病席卷了%townname%，只有%name%活了下来。他被迫放弃自己的生意，从事仅存的工作：掘墓。} 人们都说，将死之人的面相会变化，但和死人打过交道的人也是如此。%name%已经{盯着尸体看了 | 埋尸体埋了 | 挖坑挖了}半辈子了。对掘墓人来说，{死亡不过是一门科学 | 死人比活人更好相处 | 埋死人赚钱并不新鲜}。{在车队的雇佣下，%name%走遍挖遍了世界的每个角落。但有一天，葬礼突然被打断了，并非是秃鹰老鼠，而是被死者自己。目睹了这样的场景，埋了同一个人两次，难怪他急着换个职业。 | 每个掘墓人都曾被投以怀疑的眼光。没多久他的雇主就变成了诉主，指控他犯下染指死灵法术的骇人罪行，这迫使他放弃了工作。这可谓无稽之谈，但他苍白的脸上你也看不出什么。好一个板着脸的月亮。 | 看来这人需要换个工作环境，别让他埋死人就行。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				4
			],
			Bravery = [
				7,
				5
			],
			Stamina = [
				5,
				7
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
				-5,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});
