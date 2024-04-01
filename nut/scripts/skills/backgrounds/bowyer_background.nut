this.bowyer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.bowyer";
		this.m.Name = "弓匠";
		this.m.Icon = "ui/backgrounds/background_29.png";
		this.m.BackgroundDescription = "弓匠制作过许多远程武器，对其使用也略知一二。";
		this.m.GoodEnding = "在一次比武中，一个年轻男孩手里的弓引起了你的注意，这支弓形状虽怪。但显然做工精良。他瞄准时有些哆嗦，但射出的箭却十分稳定。在他赢得比赛后，你询问这个男孩从哪里得到了这么了不起的弓。他说是一位名叫%name%的弓匠造的。显然，他已经做出了最棒的弓，并以此闻名各地！";
		this.m.BadEnding = "你离开%companyname%后，曾寄信询问弓匠%name%的近况。你听说，他发现了一种方法，能做出最棒的弓，他没有把这个方法告诉战团，而是离开战团去开创自己的事业。可他只走出了第一步：他的毕生所学都和他一起死在了{北 | 南 | 西 | 东}边的一条泥路上，身上扎着整整一打的箭。真是讽刺。";
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
		return "{有着一双结茧的妙手，一对观弦的慧眼， | 明明生在铁匠家庭，但奇怪的是， | 继承了祖先的远见卓识和优良手艺，}%name%以制弓造箭为生。{不料一根弓弦绷断，割断了一位被寄予厚望的皇室继承人的手指，也断送了他的职业生涯。 | 可恨战争把他获取良材的森林摧毁。 | 不幸的是，他把弓卖给了小孩，引发了一场可怕的涉箭事故。一番争辩过后，镇里人不再欢迎他。 | 多年来，他始终为别人制作武器，如今他想知道，木头和弦以外的生活样貌。}{%name%决定开辟一条新路。不再把弓卖给别人，而是把箭射向敌人。 | 如今%name%加入了战团，和他的老主顾成了同行。 | 他对制弓失去了兴趣，希望他的箭术没有随之荒废。}";
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
