this.graverobber_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.graverobber";
		this.m.Name = "盗墓贼";
		this.m.Icon = "ui/backgrounds/background_25.png";
		this.m.BackgroundDescription = "盗墓贼胆子不小。";
		this.m.GoodEnding = "像%name%这样的盗墓贼在这个世界上并不是最受欢迎的人，但你只需要他成为一个优秀的雇佣兵，而他挥舞着铲子完全做到了。在你离开这个行业后，你得知这位盗墓贼继续在战团里活动。据你所知，他现在是战团的培训师，帮助新兵跟上进度。";
		this.m.BadEnding = "一个像盗墓贼%name%这样的人来到战团是为了帮助自己摆脱最不合法、最不道德的错误，还有什么比为了钱杀人更好的方法吗？不幸的是，%companyname%逐渐开始瓦解。你得知%name%最终离开了战团，并加入了一家类似的竞争对手。你不确定他现在在哪里，也不确定是否应该为他的背叛感到受辱或理解其背后的原因。毕竟，生意只是生意。";
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
		return "{是什么迫使一个人去打扰那些已经逝去的人？ | 随着死者再次复活的传闻再次传播，四处挖开坟墓也许只是一种前瞻性的思考。 | 作为道德标准和人情世故的敌人，那些把铁锹带到新坟墓里的人几乎找不到盟友。 | 懦夫在一个人失意的时候攻击他，盗墓贼在一个人真正失意的时候攻击他。 | 一个已被死亡带走的人可以通过单纯的盗墓得到，微不足道。 | 说到死亡，虫子带走血肉，时间带走骨头，而盗墓贼得到了珠宝。}{被虐待他的母亲带大，%name%发现与死者相处比与生者相处更愉快。 | 在修道院度过了许多孤独的夜晚后，据说%name%开始与死者共舞。 | %name%在星空下浪漫，但苍白和寒冷描述的不仅仅是夜空。 | 为了在乏味的生活中找到娱乐，%name%以参观朦胧的墓地而闻名。 | 在上了一个卖货郎的当后，%name%不得不靠挖坟墓赚钱。总之，故事就是这样。 | %name%曾经是一个优秀的珠宝商，但是痴呆症令其转而创造出一种非常不同风格的服装。当他解释时，一条串满牙齿的项链发着咔咔声。}{这样一个人的离经叛道也许是没有界限的，但他那尚且温暖的身躯是有用的。 | 他头脑不太正常，但或许在持剑时会表现得不错。也许吧。 | 尽管他可能令人不安，但绝望的时代需要绝望的新兵。 | 他戴着一条朴素的白色项链，白到用“骨头”来形容最合适不过了。 | 在一群疯狂的暴民的驱赶下，%name%成为众多被放逐者中的一员，冒险进入雇佣兵的世界。 | 这个人很安静，但你没法让他在墓地附近闭嘴。 | 希望他喜欢把冰冷的尸体埋进坟墓，就像他喜欢把他们挖出来一样。}";
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
