this.poacher_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.poacher";
		this.m.Name = "偷猎者";
		this.m.Icon = "ui/backgrounds/background_21.png";
		this.m.BackgroundDescription = "偷猎者在使用弓箭猎杀兔子等动物方面往往有一定的技巧。";
		this.m.GoodEnding = "前偷猎者%name%最终攒够了足够的钱离开了%companyname%。你得知他找到了一块山地，为当地贵族工作。讽刺的是，他的工作是狩猎偷猎者。";
		this.m.BadEnding = "不想再为这点儿克朗冒生命危险，前盗猎者%name%放弃了佣兵的生活，回到树林里非法猎鹿。曾经有位贵族向你提供了一大包克朗，专门让你去追捕这个人。你拒绝了这个提议，但是无可避免地：他的生命已经进入倒计时。";
		this.m.HiringCost = 65;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.hate_undead",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.loyal",
			"trait.fat",
			"trait.fearless",
			"trait.brave",
			"trait.bright"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
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
		return "{对狩猎的刺激感兴趣， | 为了养家糊口， | 带着咕咕叫的肚子， | 漫长而艰难的冬天耗光了他的食物储备，}%name%{出发到树林里去捕鹿 | 寻猎那些从他的紧张看来他无权处置的野生动物 | 能吃下各种各样的林中生物，肩上背着一把用得很好的弓，那正是他吃饭的家伙 | 带着弓和矛去树林里打猎}。%name%来自%townname%，他{是一个偷猎者，既是猎手也是猎物 | 需要养活家里的妻子和孩子 | 寻求养活自己、自己的皮囊、和他那不断长大的肚子 | 一直偷猎，这是一种违背秩序的行为，也是一种填饱肚子的手段}。{由于担心自己的事业会引来赏金猎人或执法者，他决定安定下来，当一名受雇的弓箭手。 | 他厌倦了为有食物上桌而拼命工作，用佣兵的工资买顿吃食在他看来似乎容易多了。 | 在一次导致他在领主的地牢里关了很长时间的糟糕的狩猎之后，他现在宁愿冒险当一名雇佣兵，也不想作为偷猎者被绞死。 | 多年孤独的狩猎折磨着这个人。虽然佣兵的生活极其危险，但他宁愿死的时候有个伴。 | 他的妻子一直恳求他改弦易辙，以免全家为他的罪行付出代价。他现在站在这里，证明了是谁赢得了这场争论。}";
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
				5
			],
			Stamina = [
				3,
				0
			],
			MeleeSkill = [
				2,
				0
			],
			RangedSkill = [
				15,
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
				0,
				4
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Wildmen)
		{
			r = this.Math.rand(1, 100);

			if (r <= 50)
			{
				items.equip(this.new("scripts/items/weapons/short_bow"));
				items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			}
			else if (r <= 80)
			{
				items.equip(this.new("scripts/items/weapons/staff_sling"));
			}
			else
			{
				items.equip(this.new("scripts/items/weapons/wonky_bow"));
				items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			}
		}
		else
		{
			if (this.Math.rand(1, 100) <= 75)
			{
				items.equip(this.new("scripts/items/weapons/short_bow"));
			}
			else
			{
				items.equip(this.new("scripts/items/weapons/wonky_bow"));
			}

			items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.addToBag(this.new("scripts/items/weapons/militia_spear"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});
