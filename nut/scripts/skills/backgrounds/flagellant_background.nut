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
		return "{神明怜悯世人，激励了许多人，包括%name%，去寻求他们的恩宠。| 文盲且生于贫困的%name%，在神明的传说中找到了慰藉。| 一向嗜书如命的%name%，不久便发现了关于神明的典籍。| 有人说神明向我们传达信息，若此言非虚，那么他们必定曾对%name%有所启示。| 随着荒野中新教派的兴起，%name%重归熟悉的神明怀抱。| 在激进父亲的抚养下，%name%的早年大多在鞭笞留下的伤痕中度过，神明对此会表示赞许。} {当战火蔓延至这片土地，神明指引他参与其中，以追求更崇高的正义。| 随着邪教徒如鼠疫般散布其邪恶言论，%name%认为拿起武器对抗异端乃当务之急。| 偏离信仰的他，在%randomtown%犯下了骇人罪行——与一名男子私通。每夜自我鞭笞，他寻求救赎。| 仅仅听闻一处圣地的传闻，这位朝圣者便执杖携粮，踏上寻找之旅。| 如今战火重燃，神明的虔诚信徒欲通过祈祷与实际行动探明其因。| 在山洞中度过的一夜，让这位信徒明白神明渴望鲜血。%name%自然不会拒绝他们的召唤。| 劫掠者洗劫了教堂的财库后，%name%的使命便是重新填满那纯洁的钱袋。} {随着宇宙法则在吞噬世界的战争面前扭曲，像%name%这样的奇迹制造者或许大有用武之地。| 他携带一根镶嵌玻璃刺的皮鞭。他声称，这不是用来对付敌人，而是为了净化。有趣。| 他宣称憎恶邪恶，但几枚金币就能说服%name%将任何事物定性为“邪恶”。| 此人选择艰难之路，难怪他决定加入佣兵团。| 若%name%拥有力量，你相信他会净化整个世界。庆幸的是，他不过是个凡人。| 谈论神明或许略显烦人，但%name%的热情在战场上倒是如鱼得水。| 对神明世界如此痴迷，难怪这位朝圣者视现实世界为充满敌意之地。}";
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
