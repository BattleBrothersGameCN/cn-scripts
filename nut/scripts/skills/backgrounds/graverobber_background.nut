this.graverobber_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.graverobber";
		this.m.Name = "盗墓贼";
		this.m.Icon = "ui/backgrounds/background_25.png";
		this.m.BackgroundDescription = "盗墓贼胆子不小。";
		this.m.GoodEnding = "像%name%这样的盗墓贼并不受欢迎，但你只是想让他当个好佣兵，他也没有辜负你的期望。你离开后得知，这位盗墓贼长期留在了战团里，他现在是战团的培训师，帮助新兵跟上进度。";
		this.m.BadEnding = "像盗墓贼%name%这样的人加入战团，无非是为了摆脱过去所犯下的错误，那些最不能为法律道德容忍的错误。收钱把人送进坟里适合他不过了。不幸的是，%companyname%逐渐瓦解。你得知%name%最终离开了战团，加入了一家类似的竞争对手。你不确定他现在何处，也不确定该生他背叛的气，还是理解他的难处。毕竟生意就只是生意。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.night_blind",
			"trait.cocky",
			"trait.craven",
			"trait.fainthearted",
			"trait.loyal",
			"trait.optimist",
			"trait.superstitious",
			"trait.determined",
			"trait.deathwish"
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
		return "{是什么迫使一个人去打扰逝者的安宁？ | 随着死者复活的传闻再次传开，四处挖开坟墓也许只是一种前瞻性的思考。 | 作为道德标准和人情世故的敌人，那些把铁锹带到新坟墓里的人可谓失道寡助。 | 懦夫攻击失意的人，盗墓贼攻击失去意识的人。 | 人被死亡带走，东西被盗墓贼带走。 | 说到死亡，虫子带走血肉，时间带走骨头，盗墓贼带走珠宝。}{在母亲的虐待中长大，%name%发现死者比生者更好相处。 | 离群索居度过了一个个孤独的夜晚，%name%开始与死者共舞。 | %name%在星空下浪漫，但苍白和寒冷描述的不仅仅是夜空。 | 为了在乏味的生活中找到娱乐，%name%以参观朦胧的墓地而闻名。 | 在上了一个卖货郎的当后，%name%不得不靠挖坟墓赚钱。反正听说是这样。 | 曾经优秀的珠宝商%name%在痴呆症作用下创造出一种与众不同的装饰风格。当他阐释自己的设计理念时，他串满牙齿的项链咔咔作响。}{这人可能离谱起来没边儿，不过他尚且温暖的身躯还能派上用场。 | 他脑子有点问题，但说不定用剑没问题呢。大概。 | 尽管他挺愁人，但绝望的时代需要绝望的新兵。 | 他戴着一条朴素的白色项链，白到用“骨头”来形容最合适不过了。 | 在一群疯狂的暴民的驱赶下，%name%成为众多被放逐者中的一员，冒险进入雇佣兵的世界。 | 这个人很安静，但一到墓地附近就说个没完。 | 希望他喜欢把冰冷的尸体埋进坟墓，就像他喜欢把他们挖出来一样。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				8,
				5
			],
			Stamina = [
				5,
				5
			],
			MeleeSkill = [
				3,
				0
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				0,
				1
			],
			RangedDefense = [
				0,
				1
			],
			Initiative = [
				0,
				4
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/ancient/broken_ancient_sword"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/ancient/ancient_household_helmet"));
		}
	}

});
