this.paladin_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.paladin";
		this.m.Name = "执誓者";
		this.m.Icon = "ui/backgrounds/background_69.png";
		this.m.BackgroundDescription = "执誓者是勇敢的战士，他们宣誓恪守信条，对战斗也并不陌生。";
		this.m.GoodEnding = "执誓者%name%留在了%companyname%，手持小安瑟姆的头骨，向世界传播骑士的美德。大多数人认为他有些烦人，但一个完全相信荣誉、自豪和善行的人也有些迷人之处。据你所知，他独自一人从一伙街头小偷手中拯救了一位领主的公主。为了庆祝，他娶了这位少女，不过有传言称她在床上并不开心，声称那执誓者坚持让小安瑟姆的头骨在角落里观看。无论发生了什么，你很高兴这个人仍然全力以赴地做着他的事情。";
		this.m.BadEnding = "%name%曾经是名忠诚的执誓者，但最终对他的同伴失望透顶。有一天晚上他梦到他们自己，实际上，才是真正的异端。于是，他杀死了身边所有的执誓者并逃离，最终加入了守誓者。据最后一次听到的消息，他夺回了小安瑟姆的头骨，并用锤子将其粉碎。愤怒之下，他的新守誓者兄弟们立即将他杀死。%name%的尸体上发现了一百多处刺伤，头骨的碎片覆满了鲜血淋漓、狂笑着的面容。";
		this.m.HiringCost = 150;
		this.m.DailyCost = 22;
		this.m.Titles = [
			"圣战士(the Crusader)",
			"狂信者(the Zealot)",
			"尽责者(the Pious)",
			"虔诚者(the Devoted)",
			"圣武士(the Paladin)",
			"正义者(the Righteous)",
			"誓缚者(the Oathbound)",
			"誓言守护者(the Oathsworn)",
			"高尚者(the Virtuous)"
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
		return "{守誓者。守誓者。守誓者。守誓者。守誓者。守誓者。守誓者。守誓者。守誓者。守誓者。守誓者。守誓者！\n\n守誓者 守誓者 守誓者 守誓者 守誓者 守誓者！！！\n\n**守誓者**守誓者**守誓者**！！！ | %name%是著名的执誓者创始人小安瑟姆的忠实追随者。他认为自己很幸运能与志同道合的人们在一起，这些人虽然不是没有过错，但会努力在世上做正确的事。 | 有人说%name%生来便是执誓者。不过，最常说这句话的也是此人自己，这让一些人猜测他极有可能过去是个可怕的堕落者，现在只是在弥补其恐怖的过去。 | 当你想到一名执誓者时，%name%几乎整洁得无可挑剔。他保持他的制服和盔甲干净整齐。他尊重他的上级，但从不矫揉造作。而且他在引导剑锋穿过守誓者的面孔时绝对出色。如果有人能成为出色的执誓者，那一定是他。 | %name%生活在遥远的国度，追求荣誉，并给守誓者带来死亡，在听说%companyname%的辉煌过去后，他不得不找到并加入其中。他是一个有着难以置信的决心的人，最重要的是，他不与守誓者打交道。 | 小安瑟姆的精神把%name%带到了%companyname%。至少他是这么说的。不管令他加入的是什么，他无疑是一个有才华的战士，能堪大用。 | 小安瑟姆的的精神威严不容忽视。至少%name%是这么认为的。他声称自己代表已故的执誓者而战。小安瑟姆一定是个勇猛的伙计，因为这个人用啥武器都是个超凡的天才。 | 像许多执誓者一样，%name%知道三种神圣的元素：珍视小安瑟姆的精神、认真对待誓言以及所有守誓者都必须死。此外，赚点钱也不错，这就是为什么他将\"第四\"元素定义为替%companyname%这样的组织而战。 | 对执誓者而言通过战斗赚取佣金是有点奇怪，但是%name%说这并不违反小安瑟姆的教诲。相反，信守誓言是每个执誓者的个人责任，他能以%companyname%的名义扫除敌人来轻易做到这一点。 | %name%带着本只记录一种东西的账簿：他杀死了多少个守誓者。他甚至列出了时间地点，当然还有方式。“方式”的条目甚至有些额外的投入，一行一行地精心描述他如何击败他可憎的敌人。坦白说，你喜欢这人的热情。 | %name%，一个执誓者，思想如此单纯，以至于让你几乎担心他没有了小安瑟姆的指示会做出什么。说到这一点，你内心的一部分很好奇他如果致力于另一门手艺会如何。凭借他的决心和动力，他或许能编织出一个令人难以置信的篮子，甚至可能像那些博学的专家一样在水下完成。 | %name%是高尚者的完美典范，聪明、健壮，而且武艺相当出色。他对誓言的承诺仅与他毁灭那些阻碍他道路的敌人的能力相匹配。他非常适合%companyname%，确实。 | 随着%companyname%声名鹊起，它正在成为这片土地上更加著名的组织之一。自然，像%name%这样才华横溢，充满荣誉感的人会寻求加入，尽管需要花费一些代价。他为小安瑟姆的事业提供服务，这意味着他的注意力无疑是分散的，但即使被正义所驱使，他仍然是一位不知疲倦的战士，值得被雇佣为%companyname%的一员。}";
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
