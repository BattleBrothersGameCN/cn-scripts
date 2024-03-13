this.hunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hunter";
		this.m.Name = "猎人";
		this.m.Icon = "ui/backgrounds/background_22.png";
		this.m.BackgroundDescription = "猎人们惯于独自一人穿越树林，凭借高超的射箭技巧猎杀动物。";
		this.m.GoodEnding = "尽管%companyname%持续取得巨大成功，猎人%name%还是决定把这一切都抛在身后。他回到树林和田野，狩猎鹿和小型动物。他很少展现出狩猎人类的残酷真相，你只能往好了想，他已经不再那么做了。 据你所知，他现在生活还不错。他买了一块地，并帮忙指导贵族进行昂贵的狩猎之旅。";
		this.m.BadEnding = "%companyname%的衰落显而易见，猎人%name%离开了战团，重返捕猎。不幸的是，与一位贵族的狩猎旅行出了差错，贵族被一只野猪顶穿了双颊。猎人意识到他会被责备，在贵族和侍卫的追射下，独自穿过森林逃跑了。那之后再也没人见过他。";
		this.m.HiringCost = 120;
		this.m.DailyCost = 20;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.short_sighted",
			"trait.fat",
			"trait.clumsy",
			"trait.gluttonous",
			"trait.asthmatic",
			"trait.craven",
			"trait.dastard",
			"trait.drunkard"
		];
		this.m.Titles = [
			"猎鹿人(the Deerhunter)",
			"林间行者(Woodstalker)",
			"林中人(the Woodsman)",
			"猎人(the Hunter)",
			"箭发直中(True-Shot)",
			"一击中的(Ond Shot)",
			"鹰眼(Eagle Eye)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 2);
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

	function onBuildDescription()
	{
		return "{父亲不在身边，%name%的母亲教会他怎么射箭养家。 | 出生在%randomtown%的穷乡僻壤，%name%大部分时间都在树林里追踪野兽。 | %name%打赌他能射下猪头上的苹果，他射歪了。肚子里塞满猪肉，他决心再也不射歪了，能得到更多猪肉的情况除外。 | 早年间，%name%喜欢在树林里闲逛。疯狐狸的袭击让他学会了拉弓，凶老鹰的利爪让他学会了射箭。} {当地贵族雇佣%name%参加一场野猪狩猎，这场糟糕的狩猎以男爵受伤告终，所有的指责和鲜血都落在了%name%手上。 | 他早就有这个想法了，但他藏得很深：狩猎终极猎物——人类会是什么样子。 | 可惜一场俄罗斯农民轮盘赌迫使他换个法子谋生。 | 可惜他烹鹿的水平远不及猎鹿的，一顿夹生肉大餐害死了他全家。难怪他想重新开始。 | 为了到城里卖猎来的皮和肉，他历尽艰辛。这一定是佣兵生活在召唤他。 | 战争把猎物赶出了树林，也就把%name%赶出了打猎的营生。现在他得找点别的活计干了。 | 他的妻子病了，打来的肉又不能治病。为了赚够治病钱，他的剑就是你的剑，或者弓也行。} {任何团体都需要一个这样的神射手。 | 虽然称不上完美，但%name%是个不折不扣的专业弓箭手。 | %name%霎时间露了一手：朝天射一箭，再用另一支箭把它击落。妙。 | 如果%name%想要证明自己，让他到靶场去。他刚拿剑的时候，剑柄都抓错了。没错，就是那头儿。 | 这位猎人可谓人弓合一，射起箭来就像和尚念经。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				0,
				5
			],
			Stamina = [
				7,
				5
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				20,
				17
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				3
			],
			Initiative = [
				0,
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/hunting_bow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else
		{
			items.equip(this.new("scripts/items/helmets/hunters_hat"));
		}
	}

});
