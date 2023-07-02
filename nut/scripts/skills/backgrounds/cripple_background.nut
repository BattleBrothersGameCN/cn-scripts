this.cripple_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.cripple";
		this.m.Name = "残废";
		this.m.Icon = "ui/backgrounds/background_51.png";
		this.m.BackgroundDescription = "对于一个残废来说，唯一迅速的是他在真正的战斗中可预见的死亡。";
		this.m.GoodEnding = "惊人的是一个像%name%这样的人居然活了下来，但是这个残废最终从%companyname%退休时拥有了相当可观的一笔财富。如今他经营着一个孤儿院，花他自己的钱来帮助世界上那些受伤和被遗弃的孩子们。不过，或许这个孤儿院只是一种廉价劳动力的掩护，毕竟如今谁也无法确定。";
		this.m.BadEnding = "当你离开%companyname%时，有一件事你几乎可以肯定：那个可怜的残废%name%不会活得太久。尽管困难重重，他还是活了下来。实际上，他活得足够久到退休，尽管离开时所拥有的财富与刚加入时没什么两样。你不知道他后来过得怎么样，但他现在肯定已经死了。确定，对吧？";
		this.m.HiringCost = 30;
		this.m.DailyCost = 3;
		this.m.Excluded = [
			"trait.huge",
			"trait.weasel",
			"trait.lucky",
			"trait.iron_jaw",
			"trait.tough",
			"trait.strong",
			"trait.cocky",
			"trait.fat",
			"trait.greedy",
			"trait.athletic",
			"trait.impatient",
			"trait.quick",
			"trait.swift",
			"trait.dexterous"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Initiative
		];
		this.m.Titles = [
			"残废(the Cripple)",
			"残废者(the Maimed)",
			"废人(the Broken)",
			"奇形怪状者(the Grotesque)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
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
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "总是满足于充当后备"
			}
		];
	}

	function onBuildDescription()
	{
		return "%name%{像只肮脏的狗一样蹒跚向你走来 | 用一只缺了数根手指的手向你向你致意 | 对你露出无牙的笑容 | 身姿低垂，好似背部了受伤 | 用两条非常僵硬的，甚至可能是木制的腿摇摇晃晃地站着 | 拄着手杖向你走来 | 一开始爬向你，但后来站起身来，姿态犹如一个教堂台阶上的醉汉 | 每走一步骨头都吱吱作响 | 一只胳膊用吊索吊着，一根手杖支撑着他的一条腿 | 鼻子被打肿、眼窝被揍青 | 看起来像是有人试图在他活着的时候割下他的头皮并将他烧死 | 的肉闻起来有半熟的味道，每朝你走一步，他的眼睛都会眯起来 | 缺了两只耳朵，虽然还能用耳洞听见 | 散发出屎尿的臭味 | 失去了一只眼睛，而且另一只眼睛的视线明显游移不定 | 有着两只懒眼和一个歪歪扭扭、缺牙的笑容}。他解释说{他曾经是一名石匠，但因为试图复制一个疯子的作品而遭受了袭击 | 他曾以骑士的身份穿上盔甲，但残酷的命运夺走了他的一切 | 他很久以前是个贵族，但他蹩脚的词汇表明这可能是一个谎言 | 他曾经是个小贩，但一次卖lobo-rail导致他被镇上一群愤怒的暴民所摆布 | 他曾涉足过邪教，但当他想脱离时他们因此惩罚了他 | 他曾经是个僧侣，但{邪教徒袭击了他的教堂 | 与其他僧侣的口角使他受到了严厉的惩罚 | 强盗们因为他把强盗同伴钉死在了十字架上而袭击了他} | 他曾经为领主们打架，但被其他拳手打倒后，他成了瘸子 | 他过去常在这片土地上游荡，参加马上骑枪比武，但一场惨烈的比赛以他严重残疾告终 | 他以前是盗墓的，但当他被抓的时候一个教区居民将他浑身打成骨折，断得比他所知道的人体骨头数量还多 | 他涉猎过{神秘学 | 亡灵术}但是，从他濒临死亡的状态可以明显看出，这个实验是短暂的 | 他曾经是一个成功的赌徒，但事实证明，不还债对生意不利 —— 对你的骨头也不利 | 他曾以吟游诗人的身份演唱，但当他唱了一半哑了嗓子后，一个领主残酷地折磨了他 | 他以前以抓老鼠为生，但显然一只巨大的老鼠在夜里报复性地拜访了他 | 他曾经侍奉过一位领主，但在把一盘食物弄洒之后，他被送进了地牢，被忘在了里面很多年 | 他确实杀过一个人，但他应该得到更好的命运，而不是受到不可逆转的折磨 | 他曾经追捕女巫，但一位残忍的女主人却让他喝下一种药剂，使他的骨骼受到了损伤 | 他曾经做过逃兵，显然，后来被抓了 | 他曾经为皇室表演杂耍，直到他在表演中不小心从台阶上摔了下来。看来，这些台阶对他的骨头来说相当尖锐 | 他生下来就有可怕的畸形 | 他父亲因他没能达到自己预期的形象而残暴地殴打了他 | 他母亲无休止的折磨使他伤痕累累 | 他的兄弟姐妹折磨了他一辈子}。{这个人看起来如此虚弱你似乎能看到他的皮囊在风中飘动。 | 雇用他几乎肯定是这个人的末日。多么仁慈！ | 你不想让别人认为你什么人都雇佣，但如果这个人是个无名小卒，那些人还算“什么人”吗？ | 你见过看起来比这家伙状态好的死人。 | 这家伙是长着两条腿的野狼午餐。 | 好消息是，如果他死而复生，他会很容易再死一次。 | 梦和无生命的物体都比这个可怜的家伙更具威胁性。 | 老实说，你宁愿雇一个孩子，但显然人们看不起这一点，所以我们不得不另想办法。 | 而且你觉得%randombrother%闻起来很糟。 | 雇佣这样的人会让任何人的道德指南针都旋转不止。 | 哦，拜托，看看他！%companyname%真的那么需要温暖的尸体吗？ | 雇用这个人是不对的。好吧，那就这样吧。 | 一副拐杖都比这个可怜的人更有价值。 | 这个人的状态如此糟糕，他能站在那儿装死。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-20,
				-10
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				-10,
				0
			],
			MeleeSkill = [
				-5,
				-5
			],
			RangedSkill = [
				-5,
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
				-25,
				-10
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

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
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			local item = this.new("scripts/items/helmets/hood");
			item.setVariant(38);
			items.equip(item);
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.IsContentWithBeingInReserve = true;
	}

});
