this.flagellant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.flagellant";
		this.m.Name = "自笞者";
		this.m.Icon = "ui/backgrounds/background_26.png";
		this.m.BackgroundDescription = "自笞者在他们所做的事情上有着坚定的决心，并且对疼痛有很高的容忍度，但他们的工作经常会让他们的身体留下终身的伤痕。";
		this.m.GoodEnding = "作为团队里最不安分的人之一，自笞者%name%至少能够在挥刀向敌人时，不挥鞭向自己。在他的过度勤奋之余，虽然他是个有能力的佣兵，他的习惯早晚会毁了他。在整整一晚地自我折磨后，这个人又一次失去知觉，几近失血而亡。兄弟们带着拯救%name%的想法，把他扔在了一个修道院里，他最终在痛苦中迷惑地醒来。一位慈祥的僧侣护理他恢复健康，并教他和平的宗教之道。直到今天，%name%还走在修道院的回廊里，给年轻人做一些温和的演讲，让他们远离野蛮崇拜。";
		this.m.BadEnding = "随着战团迅速衰落，许多佣兵孤注一掷。自笞者%name%就是其中之一。由于混乱和困惑，一些人开始相信%name%可以引导他们获得荣誉和救赎。少数幸存者脱离了%companyname%，疯狂地加入了他野蛮的精神崇拜之中。在其旗手%name%的嚎叫声中，皈依者们无目的地漫步，半曲着身子行走在大地上，背上覆盖着生皮。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.weasel",
			"trait.clubfooted",
			"trait.tough",
			"trait.strong",
			"trait.disloyal",
			"trait.insecure",
			"trait.cocky",
			"trait.fat",
			"trait.fainthearted",
			"trait.bright",
			"trait.craven",
			"trait.greedy",
			"trait.gluttonous"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
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
			}
		];
	}

	function onBuildDescription()
	{
		return "{众神怜悯人类，这促使许多人，如%name%一样，去寻求祂们的青睐。 | 目不识丁，出身贫寒，%name%在诸神的传说中找到了慰藉。 | %name%一向嗜书如命，自然也读到了诸神的典籍。 | 有人说神灵会跟我们对话，如果是真的，那祂们肯定跟%name%说过话。 | 随着新的邪教在荒野中涌现，%name%重拾对众神的亲近。 | 早年间，在他狂热父亲的教育下，%name%一直在治愈那些结实鞭打带来的伤口。众神会认同这样的行为的。}{当战争降临在这片土地上，众神告诉他为了更大的正义而参战。 | 正如老鼠传播瘟疫，异教徒们传播歪理邪说，%name%决定拿起武器与异端战斗。 | 他违背信仰，在%randomtown%犯下了一桩可怕的罪行 —— 一个男人有了暧昧关系。现在他每晚责打自己，从中寻求救赎。 | 哪怕只是个关于圣地的传闻，就能让朝圣者就带上行装，前去寻找。 | 战争又回到了这片土地上，这位神明们的信徒希望通过祈祷和肉体手段找出原因。 | 在山洞里的一夜让这位信徒开悟 —— 诸神需要鲜血。%name%不是会拒绝祂们召唤的人。 | 掠袭者洗劫了他教堂的金库，%name%的任务是把他再干净不过的钱袋重新填满。}{这是一场消磨世界的战争，连宇宙法则都能折服，有个像%name%这样的奇术士才能叫有备无患。 | 他拿着一根夹杂玻璃碴的皮鞭。不是用来杀敌的，他说，是用来净化心灵。有趣。 | 他自称憎恨邪恶，但只要花几个克朗，你就能替%name%定义“邪恶”。 | 这个人寻求劫难，佣兵团正适合他。 | 如果%name%神力傍身，他肯定会净化整个世界。谢天谢地，他只是个普通人。 | 讲起诸神的事，%name%总是喋喋不休，他炽热的激情适合释放在战场上。 | 朝圣者相当迷恋神的世界，难怪人世在他们眼里尽是敌人。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-5
			],
			Bravery = [
				12,
				12
			],
			Stamina = [
				5,
				10
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
				0
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		this.updateAppearance();
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local body = actor.getSprite("body");
		local tattoo_body = actor.getSprite("tattoo_body");
		tattoo_body.setBrush("scar_01_" + body.getBrush().Name);
		tattoo_body.Color = body.Color;
		tattoo_body.Saturation = body.Saturation;
		tattoo_body.Visible = true;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.PilgrimTitles[this.Math.rand(0, this.Const.Strings.PilgrimTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_flail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/reinforced_wooden_flail"));
		}

		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}

		if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/monk_robe"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});
