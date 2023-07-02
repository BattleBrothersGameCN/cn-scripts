this.swordmaster_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.swordmaster";
		this.m.Name = "剑术大师";
		this.m.Icon = "ui/backgrounds/background_30.png";
		this.m.BackgroundDescription = "剑术大师在近身格斗上无人出其右，但是面对远程攻击较为脆弱。年龄可能对他的身体素质造成了影响，而且可能还会继续如此。";
		this.m.GoodEnding = "作为你所见过的最出色的剑客，老剑术大师%name%是%companyname%的天然补充。但一个人无法永远战斗下去。尽管战团越来越成功，但很明显剑术大师的身体状况已经无法再支撑下去。他退休后，找了一块漂亮的土地，享受属于自己的时光。或者说你曾以为是这样。你去拜访他时发现他正在秘密地训练一位贵族的女儿。你答应保守秘密。";
		this.m.BadEnding = "遗憾的是，剑术大师%name%不得不在一个日益衰败的佣兵战团中度过他的晚年。他退休时表示他身体已经无法胜任了。你觉得他只是为了不让%companyname%难堪，因为一周后他在路边轻松地击败了十名意图打劫的匪徒。据你所知，他正在训练那些不知感恩的王子们剑术。";
		this.m.HiringCost = 400;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.huge",
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.paranoid",
			"trait.impatient",
			"trait.clubfooted",
			"trait.irrational",
			"trait.athletic",
			"trait.gluttonous",
			"trait.dumb",
			"trait.bright",
			"trait.clumsy",
			"trait.tiny",
			"trait.insecure",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.hesitant",
			"trait.fragile",
			"trait.iron_lungs",
			"trait.tough",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.Titles = [
			"传奇(the Legend)",
			"老卫士(the Old Guard)",
			"大师(the Legend)"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(3, 5);
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
		return "{%name%战斗起来有如鱼练习游泳。 | %name%不仅仅是一个男人的名字，它是一个神话。它是用来替代战争、战斗和死亡这样的词语的一个称呼。 | 说上一句“你的动作像%name%一样”也许是一个人能给予一个战友的最大荣誉。 | %name%被认为是这片土地上最危险的剑客之一。}{他的大部分生活都建立在神话中：比如他如何通过向国王和他的所有卫兵挑战决斗来瓦解一个王国 —— 还是只用一只手打败的他们。 | 据说，他在自己的花园里与二十个人搏斗，用他拿来正在杀人的刀慢慢地采摘和修剪番茄。 | 有人说他被留在海上三百天，而在那里他学会了 —— 在浮木上保持平衡 —— 如何移动、如何战斗以及如何生存。 | 有故事说他的家人被谋杀了，而他不知道凶手是谁。为了在遇到那些为此负责的人时能做好准备，他自学了用剑杀死任何人的本领。 | 在独臂父亲的抚养下，他首先学会了如何与局限抗争。当他开始使用双手时，他已经能只用一只手杀死任何人了。}{不幸的是，时间和年龄已经让%name%衰老得不比从前。 | 在兽人入侵期间，%name%设法单枪匹马地杀死了十几个绿皮。可悲的是，完成一个本不可能完成的壮举并非没有代价：他的使剑手失去了三个手指，他的主导脚也被切断了跟腱。 | 不幸的是，一群醉汉袭击了他的家，每个人都希望通过杀死这位著名剑客而恶名远播。他杀死了他们，但在此之前他已经遭受了无法逆转的伤害。 | 传说称他曾与一只巨大的邪恶野兽发生争执。他用只有三根手指的手挥了挥，并眨了一下带着疤痕的眼皮否认这种说法。 | 在教皇室如何战斗的时候，一场席卷整个王国的政变让他不得不逃命。 | 受聘教导贵族后代战斗技能，不久他就卷入了一张充满阴谋与暗害的网，只得趁还能离开的时候及早离开。}{现在这位老剑客只想把他余下的战斗知识用在战场上。 | 虽然他已经失去了锐气，但这个人仍然非常危险，有人说他正在趁自己离世之前找到一名学徒。 | 他可能是个武艺大师，但他每一个动作都伴随着老骨头的咔嚓声。 | 沮丧又缺乏目标的%name%，现在在融入他曾经教过的学生时找到了意义。 | 这人让通过他的防守成为不可能，能够反击所有的进攻，但是他已经失去了反击的跳跃步伐。令人钦佩，亦令人悲伤。 | 拿到一把剑，老卫兵翩然舞动，展示出令人印象深刻的技巧。当他将剑插入地面时，他靠在剑柄上喘息片刻。这样则并不令人印象深刻。 | 这个人失去了他的运动能力，但他的知识将剑术转化为了数学。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-12,
				-12
			],
			Bravery = [
				12,
				10
			],
			Stamina = [
				-15,
				-10
			],
			MeleeSkill = [
				25,
				20
			],
			RangedSkill = [
				-5,
				-5
			],
			MeleeDefense = [
				10,
				15
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				-10,
				-10
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.SwordmasterTitles[this.Math.rand(0, this.Const.Strings.SwordmasterTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 2);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/noble_sword"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/arming_sword"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/fencing_sword"));
			}
		}
		else
		{
			r = this.Math.rand(0, 1);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/noble_sword"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/arming_sword"));
			}
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}

		if (this.Math.rand(1, 100) <= 33)
		{
			items.equip(this.new("scripts/items/helmets/greatsword_hat"));
		}
	}

});
