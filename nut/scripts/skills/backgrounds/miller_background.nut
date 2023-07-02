this.miller_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.miller";
		this.m.Name = "磨坊工人";
		this.m.Icon = "ui/backgrounds/background_05.png";
		this.m.BackgroundDescription = "磨坊工人习惯于体力劳动。";
		this.m.GoodEnding = "%name%这个曾经的磨坊工人在%companyname%待了一段时间，攒够了克朗开了自己的面包店。你最后听到的消息是他的剑形甜点在贵族中很受欢迎，他卖甜点赚的钱比他在战团赚的钱还多。";
		this.m.BadEnding = "随着%companyname%陷入困境，磨坊工人%name%觉得赶紧走人是个不错的主意。他帮助一位贵族测试了一种利用骡子和水车联动磨粮的新方法。不幸的是，“帮忙”的结果是他掉进了装置里，被残酷地压死了。";
		this.m.HiringCost = 65;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.bright",
			"trait.cocky",
			"trait.quick",
			"trait.fragile",
			"trait.greedy",
			"trait.sure_footing",
			"trait.deathwish",
			"trait.dexterous",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"磨坊工人(the Miller)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
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
			}
		];
	}

	function onBuildDescription()
	{
		return "{当磨坊工人的日子对%name%来说总是缺少一些东西，然而繁重的工作使他无法制定任何伟大的计划。 | 延续家族传统，%name%从父亲那里学到了碾磨的手艺。 | 虽然只是一个普通的磨坊工人，%name%却总是梦想着走出去，到外面的世界去，带着故事和装满克朗的口袋回家。 | 作为一个单纯的人，%name%不介意每天在磨坊里辛苦工作。 | %name%总是比别人更有野心。虽然他的兄弟满足于经营家族的磨坊，但他无法摆脱他注定投身更大事业的感觉。}{一天晚上他被一声响雷惊醒。冲到屋外，%name%意识到他的磨坊被雷击点燃了。 | 当他抓到他的未婚妻和另一个男人上床时，他勃然大怒，狠狠地揍了他们两个。他的拳头擦伤了，人们在对他大喊大叫，但他唯一感受到的是曾经心脏所在处的空虚。就像在梦中一样，他迅速收拾行李并出发，再也不回来。 | 当他年轻可爱的妻子被发现死在树林里，被野兽撕碎时，他没有说一句话。他默默地收拾好自己的东西，向这个世界出发，去遥远的地方开始新的生活。 | 在%townname%的酒馆里听了一个雇佣骑士的荒诞故事后，他的想象力变得狂野起来，世界上所有的可能性都在等着他。 | 干旱意味着他的生意进展缓慢。当%name%无力偿还债务时，他的生命受到了无情讨债人的威胁。他必须消失。}{想起他的堂兄，%randomname%，在佣兵生意中过着体面的生活，%name%决定也这样做。 | 在寻找机会时，他遇到了一个唯利是图的佣兵招募者，他向他许诺名声和财富。 | 虽然%name%对战斗一无所知，但他被冒险的承诺深深吸引，渴望加入一支佣兵战团。 | 不知是因为别无选择还是出于自愿，%name%现在站在你们面前，准备宣誓效忠。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				3,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				8,
				5
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

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}
	}

});
