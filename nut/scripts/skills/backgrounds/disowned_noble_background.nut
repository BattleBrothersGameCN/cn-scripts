this.disowned_noble_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.disowned_noble";
		this.m.Name = "被断绝关系的贵族";
		this.m.Icon = "ui/backgrounds/background_08.png";
		this.m.BackgroundDescription = "被断绝关系的贵族通常会从宫廷里的近身格斗训练中受益颇多。";
		this.m.GoodEnding = "%name%是个有贵族情怀的人，虽被断绝关系还是回到了家族。传言他踹开了门并要求一个皇室的座位。一位篡位者向他发起了武斗挑战，然而，%name%在与%companyname%的日子里学到了很多，而现在他坐在一把非常、非常舒适的王座上。";
		this.m.BadEnding = "%name%是个有贵族情怀的人，虽被断绝关系还是回到了家族。有传言称，一个篡位者将他在城门口捕获，他的头目前镶嵌在一根长枪上，乌鸦是他的皇冠。";
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
			"遭贬谪者(the Disgraced)"
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
		return "{让一个有妄想症的父亲一直失望 | 一个涉及毒药与蛋糕的宫廷阴谋受害者 | 在公开宣布放弃自己的那份遗产后 | 在他和妹妹的乱伦关系曝光后 | 在一场推翻他哥哥的政变失败后 | 在骄傲和狂妄导致他带领父亲的军队彻底失败之后 | 因为在一次狩猎中意外杀死了作为王位继承人的长兄 | 作为在继承权战争中选错盟友的代价 | 因为他试图把抓获的偷猎者卖作奴隶 | 被逮到和一个男贵族同床 | 被发现是一个震惊农民的偷孩子阴谋的头目 | 因为背弃神明引起了平信徒的骚乱 | 被发现手臂下夹着邪教徒的达库尔之书}，%name%{被断绝关系，离开家族领地，再也没有回去过。 | 被剥夺了头衔并被驱逐出境。 | 被强行赶出他的土地并被告知永远不要回来。 | 在刽子手斧头的威胁下发现自己不再属于宫廷了。 | 看到了刽子手的绞索，耍了个聪明花招才逃脱。 | 被烙上耻辱的印记，被赶出他的土地。 | 被认为参与了太多的阴谋，并被赶出了这片土地。 | 被认为过于有野心，在贵族中这是是一种危险的特质。}{%name%如今试图挽回自己的名誉，不辜负家族的荣誉。对于一个雇佣兵组织来说，这有点自私，但还算是高尚的。 | 由于丑闻缠身，%name%的姿态低落，对困难的抵抗力减弱了。 | 他也许是个老练的拳击手，但除了%name%他自己，他很少谈论别人。 | 尽管用剑很快，但是你还是会觉得像%name%这样的人被断绝关系是有原因的。 | 由于运气不好几乎破产，%name%开始在佣兵的行当里冒险。 | 没有了头衔和土地，%name%寻求加入他曾经统治过的那些人中。 | 这位前贵族也许装备精良，但你确实注意到%name%最常用的装备是他的靴子。}";
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
