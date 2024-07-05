this.beast_hunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.beast_slayer";
		this.m.Name = "野兽杀手";
		this.m.Icon = "ui/backgrounds/background_57.png";
		this.m.BackgroundDescription = "野兽杀手惯于猎杀形态各异的骇人野兽。";
		this.m.GoodEnding = "%name%从战团退休，买下了一座废弃城堡。在那里，他带领着一群野兽杀手，穿行于大地，保护它免受怪物的侵害。上次你上门找他时，见到了他的一位黑发女性朋友，她不太欢迎你和同行们。他一定过得很幸福。";
		this.m.BadEnding = "离开%companyname%之后，%name%彻底放弃了猎杀野兽的工作，据说他生了个有白化病的女儿。可惜好景不长，人们怀疑这女孩天生异象，必有蹊跷，流言不胫而走，她的母亲被处以火刑。父亲和孩子没被抓住，但也从此杳无音信。";
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
		return "{{%name%的过去和奢华不沾边。 | %name%在这片土地上四处游历，干过的活也不尽相同。 | %name%从事的工作可谓残酷，但他并非出身不凡。 | %name%带着一份长长的名单，记载着他猎杀过的野兽。他还准备了毛皮作为佐证，这反而加深对他背景的误解。}{他曾经只是一名普通的猎人，凭借弓箭和智慧武装自己。直到一头巨型恐狼出现在他的陷阱里，激起了他对危险猎物的兴趣。 | 蛛魔的袭击长期困扰着他居住的村庄，于是他竭尽所能，学习狩猎野兽，最终取得了成功。 | 据说，梦魇折磨起整个小镇之前，他在村里经营磨坊。本来他也不爱睡觉，便用晚上的时间，学习起了怪物的知识，并最终打败了它们。 | 他曾专职为当地领主寻找猎物。但一次狩猎中，一头巨魔发起了袭击，夺走了猎物，此后这个人便转而研究野兽以及杀死它们的方法。 | 树人杀死了他的同伴，让他从伐木工人变成了野兽杀手。他为他的朋友们报了仇，并发誓要尽可能了解所有的怪物。 | 修道院毁于食尸鬼之手，是这位僧侣研究野兽和剑术的契机。}{不过，时代在变化，即使是这位熟练的怪物猎人也无法独自应对。他希望通过加入战团来消灭尽多的野兽。 | 白天短得异乎寻常，晚上月亮格外明亮。这位猎手感觉到了空气中的变化，如果要面对即将到来的挑战，仅凭他自己是不够的。 | 虽然不喜欢与人为伴，但如果有尽多地杀死野兽，一些优秀的伙伴是不可或缺的。 | 随着世界变得危险而绝望，这位野兽杀手既寻求财富，也寻求伙伴。 | 这样的专业人士对战团大有裨益，他的职业精神值得信赖。 | 这人曾经收过学徒，却让冰原狼把他从羽翼下夺走。这位心碎的野兽杀手想要找到更坚实的同伴。}}";
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
