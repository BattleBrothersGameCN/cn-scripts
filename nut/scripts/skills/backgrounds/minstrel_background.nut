this.minstrel_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.minstrel";
		this.m.Name = "吟游诗人";
		this.m.Icon = "ui/backgrounds/background_42.png";
		this.m.BackgroundDescription = "一个好的吟游诗人会唱传奇故事来鼓舞人、吹笛子来安抚人、或是围着营火写诗来娱乐人。然而，琵琶不是武器，吟游诗人通常不习惯体力劳动或流血。";
		this.m.GoodEnding = "啊，%name%。他对于%companyname%来说真是一次了不起的添砖加瓦！这个吟游诗人不仅成为了一个出色的战士，还在最艰难的时刻起到了保持士气的关键作用。作为一个有诗歌天赋和表演才能的人，他最终退出了战团，并创办了一个剧团。他目前为贵族和普通人表演戏剧。尽管他本人还未察觉，但这位吟游诗人的幽默机智和尖锐评论正在慢慢将不同阶层的人们联系在一起。";
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
			"歌鸟(Songbird)",
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
		return "“{我可以挥剑劈斧， | 有人可能会对我提出一个任务， | 神灵在上，而酒瓶在手，}{我会说，‘你质疑一个不戴面具的男人？’。 | 所以我必须迅速行动，但也并不是太快。}{盯着我做过的玩具熊， | 穿上我的破裤子， | 沿着泥泞的道路，我的靴子打着滑，}{很多东西我都摆脱了。 | 真相！我可耻的天赋是 —— 凶猛地！ —— 编织。}{所以带我一起去冒险吧， | 带上我，与那些吵吵嚷嚷的人们一起， | 递给我你的盾牌和那个形似我鸡儿的东西，}{让我们去告别恐惧，让它成为一个难忘的告别！ | 让我们 —— 哦，噢！我被一根刺扎到了手！ | 愿我们，所有人，来年冬天都健康！}”。{那男人在胡言乱语。 | 它很押韵！}";
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
