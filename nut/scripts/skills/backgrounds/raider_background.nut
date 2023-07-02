this.raider_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.raider";
		this.m.Name = "掠夺者(Raider)";
		this.m.Icon = "ui/backgrounds/background_49.png";
		this.m.BackgroundDescription = "任何一个幸存下来的掠夺者都会在战斗方面的十分专业。";
		this.m.GoodEnding = "一个前掠夺者，%name% 很好地适应了 %companyname%并证明了自己是一名出色的战士。他攒了一大笔克朗后，便退出了战团并回到了他的家乡。最后一次见他是他驾驶一条游艇驶向一个小村庄。";
		this.m.BadEnding = "随着%companyname%的快速衰落，队长%name% 离开了战团继续走自己的路。他重回抢劫行列，带着贪婪和暴力袭击沿岸的河边村庄。你不确定这是否属实，但消息称他被一个马厩男孩用草叉刺死了。城镇据说将他的尸体残肢高悬城墙，以警示未来的袭击者。";
		this.m.HiringCost = 160;
		this.m.DailyCost = 28;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.Titles = [
			"掠夺者(the Raider)",
			"掳掠者(the Marauder)",
			"可怖者(the Terrible)",
			"强盗(the Bandit)",
			"四指(Fourfingers)",
			"乌鸦黑(Ravensblack)",
			"乌鸦(The Crow)",
			"反抗者(the Defiant)",
			"掠夺者",
			"威胁者"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 4);
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
		return "{住在海边，%name%的生活充满了海洋掠夺者的味道。 成年后，他加入了掠夺行动。 | 当他的家人被屠杀的时候，新生的 %name% 被做了这一切掠夺者带走了。 | 出生在一个遥远的地方，%name% 来到这片土地寻找城镇抢劫。 | 一个来自偏远地区的壮汉，%name%的存在对当地居民来说非常可怕。 | 有着一只强壮如桨的臂膀和另一只更壮如斧的臂膀的掠夺者，%name% 是让孩子们晚上躺在床上的民间传说中的一部分。 | 既是战士，亦是罪犯，%name% 作为一名掠夺者过得很好。 | %name% 多年前，他决定用虚弱的力量从村庄和弱旅中夺走他想要的东西，从那之后到如今他已经通过掠夺商队和村庄让他的存在广为知晓。 | 一个贫穷挨饿的小男孩长大，出于绝望，%name% 加入了强盗和杀手的行列。 这是他有生以来第一次每晚都不感到饥饿，所以他继续强行从别人那里夺走他所需要的东西。 他学会了无怨无悔地战斗和杀戮，不久，他就成了一个怪物。 | 穿着领主的靴子和女王的破烂衣服披肩，%name%的着装很好地反映了他多年来的掠夺。 | 让领主在梦中惊醒，害家庭主妇躲到床下，%name% 是一个极具威胁的掠夺者。 | 弱肉强食，这是 %name% 赖以生存的准则。} {他和他的战友们掠夺商队，欺凌边远的农场，结果有一天他们发现自己遭到了掠夺袭击。 一小群兽人发现了 %name%的营地，如同自然之力般将营地洗劫，少数幸存者跑向各个方向。%name% 逃走了，头也不回的。 | 多年来一直赚取不义之财，这名男子在一次对孤儿院的突袭中，一场失控的大火导致孤儿院内人员死亡，他放弃这种掠夺的日子。 | 一个虔诚的老信徒，%name% 渴望死像一个光荣的战士那样战死，以此获得在神身边的一席之地。 但是像屠宰牛一样屠宰村民不会引起神的注意，所以他现在寻找一个更大的挑战。 | 但是在强奸和抢劫的时候，%name% 被注意到对丈夫比妻子更偏爱。 他的性癖使他与其他兵团相形见绌。 | 一开始是对一个商队的突袭。 几个卫兵很快就被砍倒了，逃跑的商人跑得不够快－他背上的标枪证明了这一点。 战利品很丰富，但不久就有了关于如何分赃的激烈争论。 到了晚上，大多数掠夺者都互相残杀了。%name% 只是勉强逃过一劫，除了腿变得一瘸一拐，他一天什么都没有。 | 但他总是对女人有好感，战友们不断的强奸和谋杀，使这个掠夺者远离了这种生活方式。 | 被一个领主的卫兵抓住，掠夺者差点没没逃脱，他站在在山顶上看着他的战友们被处决。 | 但是有一个村庄在一次突袭中伏击了他的队伍，在他偷了马厩的马并逃脱了厄运时，除了他自己，其他人都被砍倒了。 | 在森林里巡逻时，突击队遭到了凶猛野兽的袭击。 他为了救自己的命，把自己的战友喂给了那些肮脏的东西。 | 但是当战争把世界撕成碎片时，掠夺者意识到真正能抢劫的东西越来越少了。 | 但随着冲突的加剧，他所遇到的每一个村庄要么一贫如洗，要么已经准备了武器面对世界上的其他恶魔。} {现在，%name% 只是想要一个新的开始，即使是在阴暗的佣兵领域。 | %name% 作为一个佣兵不能完全被信任，但至少他与强盗和掠夺者有过联盟，这至少使他适合这项工作。 | 这个人一点也不兄弟，但他可以挥舞武器，就像武器是他遗失的一根手指一样。 | 虽然 %name%的过去给任何人留下了不好的印象，但还有更糟糕的。 | %name% 擅长杀戮和掠夺，只要确保这些技能是针对你的敌人的。 | 虽然 %name% 是一名优秀的战士，但他首先忠诚于掠夺。 | %name% 是来杀戮和掠夺的。 对你来说，这是件好事。 | %name% 脖子上戴着一条耳朵项链，另一条项链上还戴着那对耳朵的耳环。很是花哨。 | %name% 是一个强大的斗士，但他很有可能成为你们整个团队中最不受欢迎的人。 | 乡村是一块诱人的绿色帆布，可以在上面建立生活。 也许掠夺者只是想安定下来。 | 穿着沾有前主人血迹的衣服，%name% 看起来已经准备好了。 | 你觉得 %name% 穿的衣服可能是被谋杀的那位的。}";
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

		if (this.Math.rand(1, 100) <= 40)
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
				0,
				0
			],
			Bravery = [
				0,
				-3
			],
			Stamina = [
				2,
				0
			],
			MeleeSkill = [
				12,
				10
			],
			RangedSkill = [
				5,
				0
			],
			MeleeDefense = [
				6,
				5
			],
			RangedDefense = [
				6,
				5
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
		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/flail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/morning_star"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/military_pick"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}

		r = this.Math.rand(0, 0);

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
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/dented_nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet_with_rusty_mail"));
		}
	}

});
