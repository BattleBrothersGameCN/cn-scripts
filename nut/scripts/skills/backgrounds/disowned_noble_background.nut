this.disowned_noble_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.disowned_noble";
		this.m.Name = "废嗣贵族";
		this.m.Icon = "ui/backgrounds/background_08.png";
		this.m.BackgroundDescription = "废嗣贵族从宫廷格斗训练中受益良多。";
		this.m.GoodEnding = "即便被断绝关系，%name%还是遵循内心的贵族情怀，回到了家族。相传他踢门而入，要夺回一席之地。篡位者向他发起了挑战，不过，%name%在%companyname%学到了很多，现在他坐在一把非常、非常舒适的王座上。";
		this.m.BadEnding = "即便被断绝关系，%name%还是遵循内心的贵族情怀，回到了家族。有传言称，篡位者在城门口抓住了他。头插在长矛上，乌鸦是他的王冠。";
		this.m.HiringCost = 135;
		this.m.DailyCost = 17;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.clumsy",
			"trait.fragile",
			"trait.spartan",
			"trait.clubfooted"
		];
		this.m.Titles = [
			"被断绝关系者(the Disowned)",
			"流放者(the Exiled)",
			"受辱者"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
		this.m.Level = this.Math.rand(1, 3);
		this.m.IsCombatBackground = true;
		this.m.IsNoble = true;
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
		return "{总是让他有妄想症的父亲失望 | 毒药、蛋糕、宫廷阴谋的受害者 | 公开宣布放弃自己的遗产之后 | 和妹妹的不伦关系曝光后 | 推翻哥哥的政变失败后 | 在他的狂妄自大把父亲的军队带向失败后 | 在一场狩猎中意外杀死了作为王位继承人的长兄 | 作为继承战争中站错队的代价 | 试图把抓来的偷猎者当奴隶售卖 | 被人撞见和男贵族同床 | 一场骇人听闻的儿童人口贩卖的头目 | 背弃众神引发了平信徒暴乱 | 被人看到夹着达库尔邪教书籍}，%name%{被断绝关系，逐出家族领地，再也不许回来。 | 被剥夺了头衔驱逐出境。 | 被赶出了土地，再也不许回来。 | 在刽子手斧头的威胁下，意识到自己再也不是宫廷的一分子了。 | 被带到了绞索跟前，耍了个花招逃走了。 | 被烙上耻辱的印记，赶出了他的土地。 | 被认为参与了太多的阴谋，赶出了这片土地。 | 被认为野心太大，会威胁到所有贵族的利益。} {%name%现在试图挽回名誉，不负家族的名声。对一个佣兵来说有点自私，但也说得上是高尚。 | 由于丑闻缠身，%name%的地位一落再落，变得难以正视困难了。 | 也许%name%是个熟练的战士，但他很少提起自己以外的人。 | %name%用剑轻快，你觉得他肯定不是无故被废。 | 时运不济，近乎破产，%name%决定把自己投资进佣兵领域。 | 失去了头衔和土地，%name%寻求加入曾经受他统治的那些人的机会。 | 这位贵族称得上装备精良，但你也确实注意到了，%name%最常用的装备是他的靴子。}";
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
				-2
			],
			Stamina = [
				-10,
				-5
			],
			MeleeSkill = [
				8,
				10
			],
			RangedSkill = [
				3,
				6
			],
			MeleeDefense = [
				0,
				3
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
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/militia_spear"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/shields/buckler_shield"));
		}

		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/mail_shirt"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}

		r = this.Math.rand(0, 8);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/padded_nasal_helmet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});
