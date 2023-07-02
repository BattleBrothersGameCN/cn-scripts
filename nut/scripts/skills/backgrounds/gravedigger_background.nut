this.gravedigger_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gravedigger";
		this.m.Name = "掘墓人";
		this.m.Icon = "ui/backgrounds/background_28.png";
		this.m.BackgroundDescription = "掘墓人习惯于体力劳动和处理尸体。";
		this.m.GoodEnding = "随着%companyname%取得的巨大成功，掘墓人%name%得以持续练习他的技术。随着克朗的不断积累，他最终离开了战团并回到了墓地。上次你听到的消息是，他已经退休，重新开始挖洞，幸福地抚养着一个由教堂司事组成的家庭。";
		this.m.BadEnding = "你听到的消息是，掘墓人%name%是最后离开%companyname%的人之一。他几近身无分文，沉迷于酗酒，最后你听说他的尸体在一个泥泞的沟渠里被发现了。";
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
		return "{%name%的掘墓人生涯是从埋葬他的小弟弟开始的。 | 把一把剑插进他喝醉了的父亲的脖子里，%name%开始从事掘墓工作的经历很不愉快。他首先埋下了这起罪行，然后又埋葬了前来问话的执法者。 | 在恶疾席卷%townname%后，%name%是最后一个活下来的人。他不得不放弃自己的生意，从事唯一剩下的工作：掘墓。}他们说，死人会有一种眼神。但那些看过死人的人也有一种眼神。%name%现在已经花费了半辈子的时间{盯着尸体看 | 把尸体埋入地下 | 挖大大小小的坟墓}。对掘墓人来说，{死亡现在只是一门科学 | 死人是比生者更好的伴侣 | 通过埋葬死者赚取金币并不是什么新鲜事}。{%townname%曾被一列车队雇佣，去旅行并挖掘这片土地。但有一天，他的埋葬成果突然被取消了。并非因为秃鹰或老鼠，而是死者本身。看到这样的景象并且不得不两次埋葬同一个人，无疑迫使%townname%迅速改变了他的生涯。 | 每个掘墓人都会遭遇怀疑的眼光。没过多久他的赞助人就成了控告他的人，而关于不死激情的可怕罪行的观念驱使他放弃了他的工作。这些指控非常荒谬，但是你不能从他苍白的脸上读出什么。就像与月亮打牌一样。 | 现在看来，这个人看起来好像需要换个工作环境。只是别让他埋葬伤亡者。}";
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
