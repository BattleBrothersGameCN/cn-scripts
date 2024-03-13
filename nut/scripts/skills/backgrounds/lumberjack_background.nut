this.lumberjack_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.lumberjack";
		this.m.Name = "伐木工";
		this.m.Icon = "ui/backgrounds/background_04.png";
		this.m.BackgroundDescription = "伐木工习惯于体力劳动。还有斧子。";
		this.m.GoodEnding = "魁梧的伐木工%name%最终离开战团，回到了森林。他把伐木干成了一门生意，全年无休地经营。贵族们最近迷上了小木屋，愿意为此付一大笔钱，他真是赶上了个好时候。";
		this.m.BadEnding = "伐木工%name%受够了佣兵生活，决定回去砍树。最后你听说，他被倒下的树砸成了肉饼，连骨头都碎了。";
		this.m.HiringCost = 100;
		this.m.DailyCost = 13;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.ailing",
			"trait.clubfooted",
			"trait.asthmatic",
			"trait.clumsy",
			"trait.fat",
			"trait.craven",
			"trait.fainthearted",
			"trait.bright",
			"trait.bleeder",
			"trait.fragile",
			"trait.tiny"
		];
		this.m.Titles = [
			"结实者(the Sturdy)",
			"砍斧(the Axe)",
			"林中人(the Woodsman)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "作为一个伐木工，%fullname%{大部分时间在树林里砍树 | 靠砍树劈柴为生 | 肩上要么扛着斧头，要么扛着木头 | 一向是个文静的人，比起与人为伍，更喜欢林中的宁静 | 因其身材魁梧、双手有力而吸引了许多年轻女性的目光 | 总是幻想自己是一名骑士，挥舞着斧头砍的不是树，而是兽人和巨魔}。{他是个高大强壮的人，在户外干活十分轻松 | 他喜欢他的斧子收藏，给每把斧子起了个女性熟人的名字 | 尽管是项卖力气的工作，但他每天都兢兢业业 | 独自待在树林里时，他会和树木交谈，让它们告诉他哪棵树的木材最好 | 他把斧子用得炉火纯青，想让树往哪儿倒就往哪儿倒 | 高大而结实的体格让他能够背起足以压垮其他人的重物}。{像大多数人一样，他子承父业。但年复一年，他逐渐意识到，他想看看这个世界，而不是每天待在同一片树林里。经过长时间的深思熟虑，他决定 | 随着妻子死于难产，他被生活压垮了。失去了一切，他变得越来越离群索居，即使是树林也不能再给他带来安宁，他只想离开这个伤心地。他决定 | 一天，他从树林里回来，远远地就看到了烟。他的村庄被烧毁，人们被屠杀或绑架，他的家没了。他怒气冲冲地出发，决定 | 久而久之，树林里出现了奇怪的生物。村民一个个地消失，有一些人搬走了。考虑了整整一个晚上，他觉得他也该走了。无以为生，他迫切希望 | 令所有村民感到奇怪的是，随着时间的推移，%name%似乎对森林失去了兴趣，经常会谈起离开这里。称得上是命运的转折点的一天，他提议 | 仿佛是命运的安排，他砍倒的一棵树砸死了一只鹿。%name%不想浪费它，于是把它带回家，却被指控盗猎。在宣判之前，他匆忙决定离开村庄，试图}加入一个旅行中的佣兵战团。";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				10
			],
			Bravery = [
				0,
				5
			],
			Stamina = [
				10,
				15
			],
			MeleeSkill = [
				5,
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
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(6);
			items.equip(item);
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});
