this.bowyer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.bowyer";
		this.m.Name = "弓匠";
		this.m.Icon = "ui/backgrounds/background_29.png";
		this.m.BackgroundDescription = "弓匠通常对如何使用他们以前制造的远程武器有一定的了解。";
		this.m.GoodEnding = "在一次比武上，一个年轻男孩使用了一支形状奇特但制作完美的弓。他瞄准时手有些颤抖，但射出的箭却没有晃动。在他赢得比赛后，你询问这个男孩从哪里得到了这么了不起的弓。他说是一位名叫%name%的弓匠造的。显然，他以制作世界上最好的弓而闻名！";
		this.m.BadEnding = "你离开%companyname%后，曾寄信询问弓匠%name%的近况。你得到消息称，他发现了一种制作最好弓的方法，并没有将这个秘密告诉战团，而是离开去开创自己的事业。他没走多远：他所学到的一切都随着他一起死在了{北 | 南 | 西 | 东}边的一条泥泞的路上，讽刺的是，他的身体上扎着据说一打的箭。";
		this.m.HiringCost = 80;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.iron_jaw",
			"trait.athletic",
			"trait.clumsy",
			"trait.short_sighted",
			"trait.fearless",
			"trait.brave",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.dumb",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.MeleeSkill
		];
		this.m.Titles = [
			"弓匠(the Bowyer)",
			"制箭师(the Fletcher)",
			"制箭者(the Arrowmaker)",
			"耐心者(the Patient)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
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
		return "{手上长满老茧，对弦有着敏锐的洞察力， | 出生在一个铁匠家庭，确实有点奇怪的是 | 继承了远见卓识的祖先的优良手艺，}%name%是一名造箭者和弓匠。{他的职业生涯在与皇室做交易时终结，因为一根断弦割断了一个有前途的继承人的手指。 | 不幸的是，战争摧毁了他用于获取最好木材的森林。 | 不幸的是，他把弓卖给了一个小男孩，这导致了一场可怕的与箭有关的事故。经过一番辩论，他再也不受镇里人的欢迎。 | 但在为别人制造武器这么多年之后，他开始想知道除了木头和弦之外，生活中还有什么。}{现在，%name%寻求一条不同的道路。如果他不能卖弓，也许他可以使用它们。 | 如今%name%与他曾经的供应对象一起休息了。 | 随着他对弓箭的兴趣消失，这位前弓匠射箭能像他造弓那样好吗？}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				0
			],
			Stamina = [
				-5,
				0
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				10,
				10
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

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/hunting_bow"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/short_bow"));
		}

		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/apron"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});
