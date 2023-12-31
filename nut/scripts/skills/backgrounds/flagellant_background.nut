this.flagellant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.flagellant";
		this.m.Name = "自笞者";
		this.m.Icon = "ui/backgrounds/background_26.png";
		this.m.BackgroundDescription = "自笞者在他们所做的事情上有着坚定的决心，并且对疼痛有很高的容忍度，但他们的工作经常会让他们的身体留下终身的伤痕。";
		this.m.GoodEnding = "作为这个团队中最令人不安的人之一，自笞者%name%至少长时间放下了鞭子，拿起刀来攻击敌人。虽然他是一个有能力(如果不是令人不安的勤奋的话)的雇佣兵，但很明显他的习惯会毁了他。在经历了又一个充满自我斥责的夜晚后，战团发现这个人再次失去知觉，快要流血过多。希望能拯救%name%，他们把他扔在了一个修道院里，他最终在痛苦的迷惑中醒来。一位慈祥的僧侣护理他恢复健康，并教他和平的宗教之道。直到今天，%name%还走在修道院的回廊里，给年轻人做一些温和的演讲，让他们远离野蛮精神的概念。";
		this.m.BadEnding = "随着战团迅速衰落，许多佣兵采取了孤注一掷的措施。自笞者%name%就是其中之一。由于混乱和困惑，一些人开始相信%name%可以引导他们获得荣誉和救赎。少数幸存者脱离了%companyname%，疯狂地加入了他的野蛮精神崇拜之中。在其旗手%name%的怒吼声中，这些信徒无目的地漫步，半曲地躬身行走在大地上，背上覆盖着生皮。";
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
		return "{众神怜悯人类，这促使许多人，如%name%一样，去寻求祂们的青睐。 | 目不识丁且出身贫寒，%name%在诸神的传说中找到了慰藉。 | %name%一向是一个嗜书如命的人，没过多久他就发现了诸神的典籍。 | 有人说神灵会跟我们对话，如果是真的，那祂们肯定跟%name%说过话。 | 随着新的邪教在荒野中涌现，%name%回到了与众神熟悉的环境中。 | 在他那狂热的父亲的教育下，%name%在很多年里都在治愈那些因受到严厉鞭打而受伤的伤口。众神会认同这样的行为的。}{当战争降临这片土地时，众神告诉他为了更大的正义而参战。 | 当异教徒们像老鼠传播瘟疫一样传播他们邪恶的言论时，%name%决定拿起武器与异端进行战斗。 | 他违背了信仰，在%randomtown%犯下了一桩可怕的罪行 —— 被发现和一个男人有了暧昧关系。在每晚责打自己的同时，他寻求救赎。 | 仅仅是听到一个关于圣地的传闻，朝圣者就拿起手杖和给养去寻找。 | 现在战争又回到了这片土地上，这位神明们的信徒希望通过祈祷和肉体的手段来找出原因。 | 在山洞里度过的一夜告诉了这位信徒 —— 诸神需要鲜血。%name%不是会拒绝祂们召唤的人。 | 在掠袭者洗劫了他教堂的金库后，%name%的任务是重新填充他们纯净的钱袋。}{当宇宙法则向一场消耗世界的战争屈服时，一个像%name%这样的奇术士可能会派上用场。 | 他拿着一根夹杂玻璃碴的皮鞭。这不是为了你的敌人，他这么说，而是为了纯洁。有趣。 | 他自称憎恨邪恶，但只要花几个克朗，%name%就能被说服把任何事情都变成“邪恶”。 | 这个人寻求的是困难的道路，毫无疑问他认为加入一个佣兵团是合适的。 | 如果%name%有力量，你相信他会净化整个世界。谢天谢地，他只是个普通人。 | 谈论诸神可能会让人有点厌烦，但%name%炽热的激情却很适合战场。 | 如此热爱神的世界，不难理解朝圣者眼里真实的世界充满敌人。}";
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
