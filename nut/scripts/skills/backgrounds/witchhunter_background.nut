this.witchhunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.witchhunter";
		this.m.Name = "女巫猎人";
		this.m.Icon = "ui/backgrounds/background_23.png";
		this.m.BackgroundDescription = "女巫猎人往往有一些战斗经验，而且即便是面对难以形容的恐怖时，他们的决心往往也不会动摇。";
		this.m.GoodEnding = "猎巫人%name%最终听说了邪恶在北方村庄间扩散的消息。他离开了%companyname%，从那以后一直在把那些可怕的女巫烧死在火刑柱上。";
		this.m.BadEnding = "邪恶在北方蔓延的消息促使女巫猎人%name%离开了战团。他带着木桩、小瓶奇怪的液体和许多引火的东西出发。一个月后，一个农民发现他在北方的荒地上游荡，眼睛被挖出、嘴巴被缝起。他胸前烙着一个奇怪的标志，农民一碰，两个人都爆炸了。";
		this.m.HiringCost = 100;
		this.m.DailyCost = 13;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.insecure",
			"trait.hesitant",
			"trait.craven",
			"trait.fainthearted",
			"trait.dumb",
			"trait.superstitious",
			"trait.drunkard"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 3);
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
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] 决心（仅在恐惧、恐慌或精神控制士气检查中生效）"
			}
		];
	}

	function onBuildDescription()
	{
		return "{某天，%name%来到了%townname%，有人说他是{地方议会派来的 | 当地牧师请来的}。 | %name%以伴灵异事件而来，夜最漆黑时行动而闻名。 | 作为一个安静而冷酷的人，%name%往往会让周围的人感到不舒服甚至害怕。 | %name%在很许多村子里都很出名，因为他走遍了最需要他才能的地方。}{他自称是女巫猎人。他利用手头各种奇特的工具和自己老道的经验，让人们在酷刑的痛苦中坦白他们与恶魔或魔鬼的罪恶往来。 | 但只有迷信的傻瓜才会相信这一点，陷入他荒谬的故事。 | 他自称是女巫猎人，并声称自己曾见过来自外域的恐惧，足以让不够格者陷入疯狂。 | 关于他在正在寻找恶魔崇拜者和夜间生物的谣言和他一起到达了%townname%，但没有人知道他此行的真正目的是什么。 | 在%townname%，他因杀死一位老妇人并被扔进地牢。结果，这个女人被证实绑架并杀害了三个婴儿，所以他又被释放了。 | 一连几个晚上，他都坐在%townname%的酒馆里，像一只在上空盘旋的猛禽一样，默默地研究着每一位顾客，而他的弩就放在手边。居民们对此并不满意，但他们也不敢接近他。}{到目前为止，大多数当地人都希望%name%早日离开，并乐于看到他加入一个旅行佣兵团。 | 看来不管他的任务是什么，现在已经完成了，所以%name%以佣兵的身份提供服务。 | 考虑到%name%胆子不小，也有用弩的经验。他会找上招人的佣兵团完全是在意料之内。 | 现在，一个佣兵战团将是他实现个人追求所需要的工具 —— 对抗来自世界之外的邪恶。 | 大多数人都很乐意让他赶紧离开。}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 25)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				12,
				10
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				15,
				8
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

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.WitchhunterTitles[this.Math.rand(0, this.Const.Strings.WitchhunterTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/light_crossbow"));
		}
		else
		{
			items.equip(this.new("scripts/items/weapons/crossbow"));
		}

		items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/witchhunter_hat"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.MoraleCheckBravery[1] += 20;
	}

});
