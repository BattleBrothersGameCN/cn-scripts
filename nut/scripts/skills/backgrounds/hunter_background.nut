this.hunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hunter";
		this.m.Name = "猎人";
		this.m.Icon = "ui/backgrounds/background_22.png";
		this.m.BackgroundDescription = "猎人们习惯于熟练地用弓箭猎杀动物和独自一人穿越树林。";
		this.m.GoodEnding = "当%companyname%持续取得巨大成功时，猎人%name%最终还是决定把这一切都抛在身后。他回到树林和田野，狩猎鹿和小型动物。他很少展现出狩猎人类的残酷现实，但你可以想象他只是宁愿不再这么做。 据你所知，他现在生活还不错。他买了一块地，并帮助指导贵族进行昂贵的狩猎之旅。";
		this.m.BadEnding = "由于%companyname%的衰落显而易见，猎人%name%离开了战团，重返捕猎。不幸的是，与一位贵族的狩猎旅行出了差错，贵族被一只野猪顶穿了双颊。猎人意识到他会被责备，遭到了贵族和他的侍卫的追射，最终独自穿过森林逃跑了。从那以后就再也没有人见过他。";
		this.m.HiringCost = 120;
		this.m.DailyCost = 20;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.short_sighted",
			"trait.fat",
			"trait.clumsy",
			"trait.gluttonous",
			"trait.asthmatic",
			"trait.craven",
			"trait.dastard",
			"trait.drunkard"
		];
		this.m.Titles = [
			"猎鹿人(the Deerhunter)",
			"森林潜行者(Woodstalker)",
			"伐木工(the Woodsman)",
			"猎人(the Hunter)",
			"真射手(True-Shot)",
			"一枪(Ond Shot)",
			"鹰眼(Eagle Eye)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 2);
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
		return "{没有父亲在身边，%name%的母亲教他如何射箭，以及如何养活他的家人。 | 出生在%randomtown%的腹地里，%name%一生中大部分时间都在树林里跟踪野兽。 | %name%曾经打赌要从猪头上射下一个苹果。他失手了。肚子里塞满了培根，他下定决心再也不失手了 —— 当然，如果这意味着能得到更多的培根就另当别论。 | %name%小时候喜欢在森林里闲逛。当一只患狂犬病的狐狸袭击他时，他学会了拉弓。当一只凶猛的老鹰抓他的脸时，他学会了射击。}{曾经被当地皇室雇佣，一次灾难性的野猪狩猎以一个男爵被刺伤告终，而所有的指责 —— 和鲜血 —— 都落在了%name%的手上。 | 猎人把这个想法藏得很好，但很长一段时间他都在想，猎杀终极猎物：人类会是什么样子。 | 不幸的是，一场糟糕的农民轮盘赌迫使这位鹿猎手寻求其他收入来源。 | 不幸的是，他烹调鹿的技巧远不如射杀鹿的技巧好。一顿由未煮熟的肉组成的晚餐毒害了他的全家。他对新生活的渴望是可以理解的。 | 在一次艰难的进城卖肉和皮革的经历后，他接受了雇佣兵生涯的召唤。 | 战争把猎物赶出了森林，把狩猎赶出了%name%的生活。现在他在寻找另一份工作。 | 当他的妻子生病时，他无法用猎获的肉来医治她。由于需要赚取克朗来支付治疗费用，他开始出卖自己的武艺 —— 或者说出卖自己的弓艺。}{任何组织都需要一个他这样的神射手。 | %name%并非完全没有缺点，但他仍然是一名专业的弓箭手。 | 他提供了一个快速展示：%name%将一支箭射向天空，然后用另一支箭将其击飞。令人印象深刻。 | %name%看起来有点想证明什么，只要确保和他保持距离就行。第一次拿到剑时，他抓住了错误的那一端。没错，就是那一端。 | 这位猎人执弓如同自己另一只手臂般娴熟，射箭犹如传教士说教一般流畅。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				0,
				5
			],
			Stamina = [
				7,
				5
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				20,
				17
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				3
			],
			Initiative = [
				0,
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/hunting_bow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
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
		else
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else
		{
			items.equip(this.new("scripts/items/helmets/hunters_hat"));
		}
	}

});
