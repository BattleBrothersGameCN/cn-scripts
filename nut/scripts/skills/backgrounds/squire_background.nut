this.squire_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.squire";
		this.m.Name = "扈从";
		this.m.Icon = "ui/backgrounds/background_03.png";
		this.m.BackgroundDescription = "扈从通常接受过一些战争方面的训练，而且他们通常对他们所从事的事情有很高的决心。";
		this.m.GoodEnding = "%name%这位扈从最终离开了%companyname%。你听说过他后来被封为骑士了。毫无疑问，无论他现在身在何处，他一定过得非常幸福。";
		this.m.BadEnding = "扈从，%name%，最终离开了%companyname%。他打算回家受封为骑士，实现他的终身梦想。残酷的政治干扰了他的计划，他不仅没有被封为骑士，还被剥夺了扈从的职务。据说他在谷仓的椽子上上吊自杀了。";
		this.m.HiringCost = 160;
		this.m.DailyCost = 20;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.clubfooted",
			"trait.irrational",
			"trait.disloyal",
			"trait.fat",
			"trait.fainthearted",
			"trait.craven",
			"trait.dastard",
			"trait.fragile",
			"trait.insecure",
			"trait.asthmatic",
			"trait.clumsy",
			"trait.pessimist",
			"trait.greedy",
			"trait.bleeder"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.YoungMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "{%name%，一个年轻的扈从，尽职地陪伴他的骑士参加了许多战斗。 | 作为一个严厉骑士的扈从，%name%终日为他的主人跑腿。 | %name%虽然是一个扈从，但他的生活主要是看守战俘，这让他很懊恼。 | 虽然是一位骑士的扈从，当然，但是%name%大部分时间都在清洁厕所、喂狗，并大用特用擦鞋盒。}{一天晚上，奇怪而蹒跚的人们在月光下的地平线上显出了黑影。警报钟声与他们的呻吟声交织，一个小时后，半个%townname%成了废墟。 | 旅途中，土匪袭击了他主人的车队。剑出鞘，头颅纷飞，当一切都结束时，这个扈从失败了：他本应保护的每个人都躺在了地上，死去了。 | 然而，有一天晚上，一群凶猛、多毛的生物袭击了他主人的城堡。情急之下，%name%释放了一群囚犯，希望他们能帮助参与战斗。然而，他们却杀死了他的主人，然后跑进了黑夜。这个扈从勇敢地幸存下来，脚下是十几具魁梧的尸体，但战斗使他孤身一人，失去了目标。 | 他被发生在%townname%的一桩可怕罪行激怒，采取了自己的手段，亲自杀死了那个罪犯。一种正当的行为，也是一种不合适的行为。这位年轻的扈从因违命而被放逐。 | 当一个邪恶的红衣骑士来到%townname%要求决斗时，%name%的骑士太过病弱无法战斗。在喝下壮胆的一杯后，%name%穿上了他主人的盔甲，亲自面对红衣骑士。他挥动剑的速度如此之快，使得空气都发出了声响，%name%结果了对手。}{现在他只剩下一个任务了 —— 获得骑士身份。 | 现在这个扈从寻求好伙计的陪伴，再次证明自己配得上成为一名骑士。 | 随着战争蹂躏大地，现在有很多机会来运用他的技能。 | 尽管有些过于认真，毫无疑问，世界需要像%name%这样的人。}";
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
				12
			],
			Stamina = [
				7,
				5
			],
			MeleeSkill = [
				7,
				5
			],
			RangedSkill = [
				7,
				8
			],
			MeleeDefense = [
				1,
				3
			],
			RangedDefense = [
				1,
				3
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
		r = this.Math.rand(0, 3);

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
			items.equip(this.new("scripts/items/weapons/winged_mace"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

});
