this.paladin_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.paladin";
		this.m.Name = "宣誓者";
		this.m.Icon = "ui/backgrounds/background_69.png";
		this.m.BackgroundDescription = "宣誓者是勇敢的战士，他们发誓要遵守严格的规则，擅长战斗。";
		this.m.GoodEnding = "守誓者 %name% 留在%companyname%，挥舞年轻人安瑟姆的头骨，向世界宣扬骑士美德。大多数人认为他是一种令人讨厌的存在，但相信完全尊重荣誉、自豪和行善的人也有些迷人之处。据你所知，他独自一人从一群小偷手中拯救了一位领主的公主。为了庆祝，他与少女结婚，尽管有传言称她在床上不开心，声称守誓者坚持让安瑟姆的头骨坐在角落里看着。无论发生了什么，你都很高兴这个人仍然全力以赴地做他自己的事情。";
		this.m.BadEnding = "曾经是名誓言守护者的队长%name%，他深感对教义的同情心渐渐消失。有一晚他梦见，其实是他们自己成为了真正的异端。于是，他屠杀了身边所有誓言守护者，离开了原地，最终竟然加入了誓言行者。后来听说，他夺回了年轻安瑟姆的头骨，用锤子敲成碎片。愤怒的新誓言行者兄弟们立即将他杀害。%name%的尸体被发现刺了一百多刀，头骨四分五裂并且狂笑着沾满鲜血。";
		this.m.HiringCost = 150;
		this.m.DailyCost = 22;
		this.m.Titles = [
			"十字军战士(the Crusader)",
			"狂信者(the Zealot)",
			"虔诚者 (the Pious)",
			"虔诚者(the Devoted)",
			"圣骑士(the Paladin)",
			"正义者(the Righteous)",
			"誓约教团(the Oathbound)",
			"誓言守护者(the Oathsworn)",
			"高尚的人 (the Virtuous)"
		];
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.bright",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.craven",
			"trait.dastard",
			"trait.disloyal",
			"trait.drunkard",
			"trait.fainthearted",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fragile",
			"trait.greedy",
			"trait.hesitant",
			"trait.insecure",
			"trait.paranoid",
			"trait.tiny",
			"trait.tough",
			"trait.weasel"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.RangedSkill
		];
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.BeardChance = 60;
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
			}
		];
	}

	function onBuildDescription()
	{
		return "{誓约者。誓约者。誓约者。誓约者。誓约者。誓约者。誓约者。誓约者。誓约者。誓约者。誓约者。誓约者！\n\n誓约者，誓约者，誓约者！\n\n誓约者，誓约者，誓约者！ | %name%是誓言接受者的著名创始人年轻安瑟姆的忠诚追随者，他认为自己很幸运能与志同道合的人们在一起，虽然并不完美，但会尝试为世界做正确的事情。 | 有人说%name%自出生时就是誓言接受者。最喜欢说这句话的也是此人自己，这导致人们有些猜测，他几乎肯定是可怕的堕落者，现在才在弥补可怕的过去。 | 当你想到一个誓言接受者时，%name%是一个很干净的样子。保持制服和盔甲干净整洁。尊重上级但从不装腔作势。他在指导誓言接受者的脸上绝对非常出色。如果有人能成为杰出的誓言接受者，那就是他了。 | 生活在遥远的国度，追求荣誉，并给誓约者带来死亡，%name%听说%companyname%过去曾经很有声望，他不得不找到并加入其中。他有着惊人的决心，最重要的是他不与誓约者交易。 | 年轻的安瑟姆的精神已经把%name%带到了%companyname%。他是这样说的。不管是什么把他带进了公司，他无疑是一个有才华的战士，会为装备队效力。 | 年轻的安瑟姆的精神的伟大是不能指望的。至少%name%是这么认为的。他说他是为死去的誓言接受者而战斗的。年轻的安瑟姆肯定是个有精神的家伙，因为这个人在使用任何钢铁方面都非常出色。 | 像许多誓言接受者一样，%name%知道三种神圣的元素：年轻安瑟姆的精神是应该珍惜的，誓言是必须认真对待的，所有的誓言接受者都必须死亡。外挂赚点钱也不错，因此他把为像%companyname%这样的装备队战斗作为自己的“第四”个元素。 | 一个誓言接受者通过战斗赚取佣金有点奇怪，但是%name%说这并不违反年轻安瑟姆的教导。相反，这是个人的责任，需要保持自己的誓言，他可以通过向%companyname%斩击敌人来实现。 | %name%持有专门用于记录一种清单：他杀死了多少个誓约者。他甚至列出了何时何地完成任务，当然还有如何完成任务。他收集各种任务的详细信息，描述自己如何精确地使用自己的想象力。坦白地说，你喜欢这个人的热情。 | %name%，一个誓言接受者，思想如此单纯，以至于让你几乎担心他没有了年轻安瑟姆的指示会做出什么。现在，话又说回来，你有点好奇他如果专注于另一种手艺会怎样。凭借他的决心和动力，他可能能编织出一个难以置信的篮子，甚至在水下完成，就像那些学有专长的专家一样。 | %name%是一位光荣之人，他是聪明的，身体健康的，并且非常擅长舞动一些钢铁。他对誓言的承诺仅与他毁灭那些阻碍他道路的敌人的能力相匹配。他非常适合%companyname%，确实。 | 随着%companyname%声名鹊起，它正在成为国内最有名的装备之一。自然，像%name%这样才华横溢，光荣的人会寻求加入其中，尽管需要花费一些代价。他为年轻安瑟姆的事业提供服务，这意味着他的注意力无疑是分散的，但即使被正义所消费，他仍然是一名不知疲倦的战士，值得成为%companyname%的一员。}";
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

		if (this.Math.rand(1, 100) <= 30)
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
				10,
				6
			],
			Bravery = [
				13,
				16
			],
			Stamina = [
				0,
				-4
			],
			MeleeSkill = [
				13,
				10
			],
			RangedSkill = [
				-2,
				-3
			],
			MeleeDefense = [
				4,
				5
			],
			RangedDefense = [
				-10,
				-5
			],
			Initiative = [
				13,
				12
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local weapons = [
				"weapons/arming_sword",
				"weapons/fighting_axe",
				"weapons/winged_mace",
				"weapons/military_pick",
				"weapons/warhammer",
				"weapons/billhook",
				"weapons/longaxe",
				"weapons/greataxe",
				"weapons/greatsword"
			];

			if (this.Const.DLC.Unhold)
			{
				weapons.extend([
					"weapons/longsword",
					"weapons/polehammer",
					"weapons/two_handed_flail",
					"weapons/two_handed_flanged_mace"
				]);
			}

			if (this.Const.DLC.Wildmen)
			{
				weapons.extend([
					"weapons/bardiche"
				]);
			}

			items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}

		if (items.hasEmptySlot(this.Const.ItemSlot.Offhand) && this.Math.rand(1, 100) <= 75)
		{
			local shields = [
				"shields/wooden_shield",
				"shields/wooden_shield",
				"shields/heater_shield",
				"shields/kite_shield"
			];
			items.equip(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
		}

		r = this.Math.rand(0, 5);

		if (r < 3)
		{
			items.equip(this.new("scripts/items/armor/adorned_mail_shirt"));
		}
		else if (r < 5)
		{
			items.equip(this.new("scripts/items/armor/adorned_warriors_armor"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/adorned_heavy_mail_hauberk"));
		}

		r = this.Math.rand(0, 5);

		if (r < 3)
		{
			items.equip(this.new("scripts/items/helmets/heavy_mail_coif"));
		}
		else if (r < 5)
		{
			items.equip(this.new("scripts/items/helmets/adorned_closed_flat_top_with_mail"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/adorned_full_helm"));
		}
	}

});
