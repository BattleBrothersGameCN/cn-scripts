this.minstrel_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.minstrel";
		this.m.Name = "吟游诗人";
		this.m.Icon = "ui/backgrounds/background_42.png";
		this.m.BackgroundDescription = "一个好的吟游诗人会唱传奇故事来鼓舞人、吹笛子来安抚人、或是围着营火写诗来娱乐人。然而，琵琶不是武器，吟游诗人通常不习惯体力劳动或流血。";
		this.m.GoodEnding = "啊，%name%。%companyname%有他真好！这位吟游诗人不仅成为了一个出色的战士，还在最艰难的时刻起到了保持士气的关键作用。作为一个有诗歌天赋和表演才能的人，他最终退出了战团，并创办了一个剧团。他目前为贵族和普通人表演戏剧。尽管他本人还未察觉，但这位吟游诗人的幽默机智和尖锐评论正在慢慢将不同阶层的人们联系在一起。";
		this.m.BadEnding = "心中从未有过战斗之意的吟游诗人%name%很快就离开了日渐衰落的%companyname%。他和一群音乐家和滑稽演员在晚上为醉醺醺的贵族们表演。你有幸亲眼目睹了其中一场演出。%name%大部分时间都在受醉醺贵族们的责骂，他们还朝他扔吃了一半的鸡骨头。其中一个贵族甚至认为放一只狗去追一个丑角会很有趣。你可以从吟游诗人的眼中看出他的梦想正在死去，但演出仍在继续。";
		this.m.HiringCost = 65;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.iron_jaw",
			"trait.athletic",
			"trait.craven",
			"trait.dumb",
			"trait.strong",
			"trait.tough",
			"trait.dumb",
			"trait.brute",
			"trait.clubfooted",
			"trait.dastard",
			"trait.insecure",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"吟游诗人(the Minstrel)",
			"说书人(the Skjald)",
			"诗人(the Poet)",
			"百灵鸟",
			"巡回演者(the Troubadour)",
			"歌者(the Chorine)",
			"情人(the Lover)",
			"讽刺手(the Bard)"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
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
		return "“{能挥剑来能劈斧， | 有人找我做任务， | 敬神嗜酒长生术，}{不戴面具很靠谱。 | 快快走来慢慢赴。}{毛绒小熊着眼目， | 穿上我的破秋裤， | 脚上泥路滑不住，}{三十六业半途黜。 | 织布才是我天赋。}{带我加入你冒险， | 又是砸来又是砍， | 盾牌硬来鞭不软，}{送走恐惧留大胆。 | 啊嗷！木刺扎手现了眼！ | 争取明年别入殓！}”。{这人净说傻话。 | 押韵了！}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-3
			],
			Bravery = [
				5,
				10
			],
			Stamina = [
				-10,
				-10
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
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local armor = this.new("scripts/items/armor/linen_tunic");
		armor.setVariant(this.Math.rand(3, 4));
		items.equip(armor);
		local r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}

		if (this.Math.rand(1, 100) <= 60)
		{
			items.equip(this.new("scripts/items/weapons/lute"));
		}
	}

});
