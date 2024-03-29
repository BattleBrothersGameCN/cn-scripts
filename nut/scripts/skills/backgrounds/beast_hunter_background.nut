this.beast_hunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.beast_slayer";
		this.m.Name = "野兽杀手";
		this.m.Icon = "ui/backgrounds/background_57.png";
		this.m.BackgroundDescription = "野兽杀手一向猎杀各种尺寸的骇人野兽。";
		this.m.GoodEnding = "%name%从战团退休，买下了一座废弃城堡。在那里，他带领着一群野兽杀手，穿行于大地，保护它免受怪物的侵害。上次你上门找他时，见到了他的一位黑发女性朋友，她不太欢迎你和同行们。他一定过得很幸福。";
		this.m.BadEnding = "在离开%companyname%之后，%name%彻底放弃了猎杀野兽的工作，你最后听说他成为了一个白化病女儿的父亲。不幸的是，关于这个女孩有超自然能力的谣言很快就传开了，她的母亲被火刑处死。父亲和孩子则没有被抓住，从此杳无音信。";
		this.m.HiringCost = 150;
		this.m.DailyCost = 15;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.weasel",
			"trait.fear_beasts",
			"trait.ailing",
			"trait.bleeder",
			"trait.dumb",
			"trait.fragile",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.short_sighted",
			"trait.fat",
			"trait.clumsy",
			"trait.gluttonous",
			"trait.asthmatic",
			"trait.craven",
			"trait.dastard"
		];
		this.m.Titles = [
			"兽猎者(the Beasthunter)",
			"森林潜行者(Woodstalker)",
			"野兽杀手(the Beastslayer)",
			"追踪者(the Tracker)",
			"战利品猎人(the Trophyhunter)",
			"猎人(the Hunter)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 3);
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
			}
		];
	}

	function onBuildDescription()
	{
		return "{{%name%的过去并不奢华。 | %name%在这些地方旅行已经有一段时间了，但他并不总是从事他现在的职业。 | 尽管%name%从事着可怕的工作，但他并非出身不凡。 | 一长串被打败野兽的名单和证明用的毛皮误导了人们对%name%背景的认识。}{这位野兽杀手曾经只是一名普通的狩猎者，凭借弓箭和智慧武装自己。但是，当他在一个陷阱中发现一只巨型冰原狼时，他开始对狩猎更危险的猎物产生了兴趣。 | 当他的村庄反复遭到蛛魔的攻击时，这个人开始尽可能学习如何狩猎野兽，并且取得了很大的成功。 | 据说他是一个村庄的磨坊主，直到梦魇折磨起整个小镇。他自己也不怎么睡觉，他整夜都在学习关于怪物的知识，直到他打败了它们。 | 他曾专职为当地领主的寻找猎物。但一次狩猎时，情况失控，不幸受到了一只巨魔的袭击，此后这个人便转而研究野兽以及如何杀死它们。 | 一个普通的伐木工人，在他的同伴们被一只树人 —— 一颗活生生的树杀害后开始成为真正的野兽杀手。他为他的朋友们报了仇，并发誓要尽可能了解所有的怪物。 | 他曾是一名僧侣，在食尸鬼蹂躏了他的修道院后，他开始研究野兽和剑。}{然而时代在变化，即使是这位熟练的怪物猎人也无法独自应对。他寻求加入一个战团并消灭尽可能多的野兽。 | 白天短得异乎寻常，晚上月亮格外明亮。这位杀手感觉到了空气中的变化，如果他打算面对即将到来的挑战，他需要的不仅仅是他自己。 | 虽然不喜欢与人为伴，但如果这位野兽杀手希望尽可能多地杀死野兽，他就一定要找一些优秀的伙伴。 | 在一个变得越来越危险和绝望的世界中，这位野兽杀手既寻求财富，也寻求伙伴。 | 像这样的专业人士对一个雇佣兵战团大有用处，你毫不怀疑他杀敌的勤奋度。 | 不幸的是，这个人的羽翼下曾收过一个学徒，结果孩子却被冰原狼杀死了。这位心碎的野兽杀手现在寻求更加坚实的陪伴。}}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				3
			],
			Bravery = [
				13,
				10
			],
			Stamina = [
				5,
				7
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				11,
				7
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
				7,
				5
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 75)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 75)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hunting_bow"));
			items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/spetum"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/javelin"));
		}

		if (this.Math.rand(1, 100) <= 50 && items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
		{
			items.equip(this.new("scripts/items/tools/throwing_net"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hunters_hat"));
		}
	}

});
