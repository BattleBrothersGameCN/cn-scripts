this.historian_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.historian";
		this.m.Name = "历史学家";
		this.m.Icon = "ui/backgrounds/background_47.png";
		this.m.BackgroundDescription = "历史学家是勤奋好学的人，拥有大量的知识，但这些知识在战场上毫无用处。";
		this.m.GoodEnding = "你没想过历史学家%name%会永远留在战团里。他最终离开了，据说带走了一大批卷轴。正如结果所展示的那样，他正在编制一份%companyname%的成就清单。他创建了一本记录了所有佣兵业绩的文献，将所有佣兵的名字载入史册，供后人查阅。你希望他们能从你们的所作所为中学到些什么。";
		this.m.BadEnding = "%companyname%持续走下坡路，许多非战斗人员如历史学家%name%视其为离开的好时机。你试着跟这些人保持联系，但历史学家特别好找：他留下了书面记录。你寻找这个人，询问抄写员们是否听说过他。他们说他只是一个小人物，正在写一本关于佣兵的生活是多么黑暗、暴力和毫无意义的巨著。";
		this.m.HiringCost = 100;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_beasts",
			"trait.paranoid",
			"trait.impatient",
			"trait.iron_jaw",
			"trait.dumb",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty",
			"trait.iron_lungs",
			"trait.irrational",
			"trait.cocky",
			"trait.dexterous",
			"trait.sure_footing",
			"trait.strong",
			"trait.tough",
			"trait.superstitious",
			"trait.spartan"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue
		];
		this.m.Titles = [
			"猫头鹰(the Owl)",
			"好学者(the Studious)",
			"历史学家(the Historian)"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
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
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] 经验获取"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name%一直是个如饥似渴的读者，在他的早年时光里他总在%randomcity%的图书馆里度过漫漫长夜。 | 年幼的%name%在更强壮的同龄人的霸凌下退回了书的世界里。 | 为了寻找人类真正的过去，%name%阅读书籍，研究人性。 | 世界上有这么多的变化，%name%决定帮助记录下它们。 | %name%是一个快速学习者，对好书有着特别的喜好，他尝试用纸笔把自己对这个世界的展望传达给别人。 | 作为一位来自%randomcity%的小学院的学者，%name%为后人记录世界的历史。 | 被世上的黑暗事件所震惊，%name%停止了对植物的研究，开始记录人类的历史。}{一个合格的历史学家会寻找他能得到的最接近的资料，这就把他带进了雇佣兵的战团。 | 在强盗们毁了他的著作后，这个人穿上了靴子开始开展新的研究 —— 亲自。 | 当他的教授说他的研究是垃圾时，这位历史学家到社会上去证明他的错误。 | 由于被指控剽窃，这位历史学家被赶出了学术界。他在他所研究的世界：战争中寻求救赎。 | 这个历史学家利用他在学术界的地位去睡女人，最终的丑闻和争议迫使他离开这个领域，让他身无分文，准备接受任何工作。 | 这位历史学家厌倦了读有关冒险者的书，他决定自己整装好，近距离观察一下真货。 | 由于许多雇佣兵团散布在周围，这位历史学家试图参加其中一支，进行一些现实生活的研究。}{%name%和真正的士兵没有什么共同之处，但他富有想象力的头脑仍然幻想着一场精彩的战斗。 | %name%毕生都在写作，从来没有花时间打斗过。直到如今。 | %name%渴望记录下你们团队的旅程。他可以出力拿上一把剑、穿戴好自己。 | %name%的肩上扛着一袋书。你建议用连枷代替。很相似，但更尖更刺。 | %name%经常被发现在笔记上奋笔疾书，因为他仍然用研究人员的眼光看待世界。 | %name%带着一口袋羽毛笔来。羽毛可以用来做很好的箭。 | 你可以相信%name%对研究的真诚，但也许不太相信他挥舞剑的能力。 | %name%跟着团队的任务是发展一个理论，但他能在实验中幸存下来吗？ | 你向%name%保证，如果他死了，你会想办法记录下他的生活。他对你表示感谢，把他的遗嘱递给你。遗嘱是用一种对你来说陌生的语言写成的，你一个字也看不懂。总之，你还是回以微笑。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-2,
				-5
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				-5,
				-5
			],
			MeleeSkill = [
				-5,
				-5
			],
			RangedSkill = [
				-3,
				-2
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
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.XPGainMult *= 1.150000;
	}

});
