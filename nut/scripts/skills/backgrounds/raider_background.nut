this.raider_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.raider";
		this.m.Name = "掠袭者";
		this.m.Icon = "ui/backgrounds/background_49.png";
		this.m.BackgroundDescription = "任何一个存活至今的掠袭者都会有一些战斗方面的专长。";
		this.m.GoodEnding = "作为一个前掠袭者，%name%很好地适应了%companyname%并证明了自己是一名出色的战士。他在攒了一大笔克朗后便退出了战团并回到了他的家乡。他最后一次被人看见时正驾着一条内河船驶向一个小村庄。";
		this.m.BadEnding = "随着%companyname%的快速衰落，掠袭者%name%离开了战团继续走自己的路。他重回掠袭行列，带着贪婪和暴力袭击沿岸的河边村庄。你不确定这是否属实，但有消息称他被一个年轻马夫用草叉戳了个透心凉。据说镇上的人把他的残躯挂在外墙上作为对未来掠袭者的警告。";
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
			"掠袭者(the Raider)",
			"掳掠者(the Marauder)",
			"可怖者(the Terrible)",
			"强盗(the Bandit)",
			"四指(Fourfingers)",
			"乌鸦黑(Ravensblack)",
			"乌鸦(The Crow)",
			"反抗者(the Defiant)",
			"劫掠者(the Pillager)",
			"威胁者(the Menace)"
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
		return "{住在海边，%name%的生活中充满了海上掠袭者的刺激。成年后，他加入了他们进行掠袭行动。 | %name%的全家被屠杀，而刚出生的他自己则被始作俑者带走。 | 出生在一个遥远的地方，%name%来到这片土地寻找可以劫掠的城镇。 | %name%是一个来自偏远地区的壮汉，他的出现对当地居民来说非常可怕。 | %name%是有着一只强壮如桨的臂膀和另一只更壮如斧的臂膀的掠袭者，是让孩子们晚上老实待床上的民间传说的一份子。 | 既是战士，亦是罪犯，%name%作为一名掠袭者过得很好。 | %name%许多年前就决定用武力从弱者那里夺走他想要的任何东西，从那时起，他就通过袭击商队和村庄展示了自己的存在。 | %name%作为一个贫穷饥饿的孩子长大，在绝望中加入了强盗和割喉者的行列。这是他有生以来第一回每晚都不感到饥饿，所以他继续用武力从别人那里夺取他所需要的东西。他学会了毫无悔意地战斗和杀戮，没过多久，他就变成了一个人中怪物。 | 穿着领主的靴子，用女王的破衣服当披肩，%name%的装束很好地反映了他多年来的掠袭经历。 | 让领主在梦中惊醒，害家庭主妇躲到床下，%name%是一个极具威胁的掠袭者。 | 弱肉强食 —— 那便是%name%赖以生存的准则。}{他和他的战友们劫掠了商队，掳掠了偏远的农场，却在某一天自己成了抢夺战利品的攻击目标。一小队兽人发现了%name%的营地，并像自然的力量一样摧毁了它，幸存者四散逃亡。%name%逃走了，头也不回。 | 他多年来一直赚取着不义之财，但一次对孤儿院的掠袭以失控的火灾和内部人员的死亡告终，这使他放弃了这种生活。 | 他是古老传统的忠实信徒，渴望像一个光荣的战士那样战死，以此立于众神之林。然而，像屠宰牲畜一样屠杀村民并不能引起众神的注意，因此他现在在寻找更大的挑战。 | 但在强奸和掠夺的过程中，%name%被注意到对丈夫的偏爱更甚于妻子。他的品味使他与其他战友格格不入。 | 这一切始于对一支商队的成功掠袭。几名护卫很快被击败，逃跑的商人跑得不够快 —— 他背上的标枪证明了这一点。战利品很丰厚，但不久之后，他们开始激烈争论如何分享这些财物。到了傍晚，大部分掠袭者都死于相互残杀。%name%勉强逃脱，一天下来战利品只有自己的一条跛腿。 | 但他对女性始终有着一份怜悯之心，而同伴们持续的强奸和谋杀行为将这名掠袭者推离了这种原本的生活方式。 | 在被一个领主的卫兵抓住后，这个掠袭者勉强逃脱，他站在在山顶上看着他的战友们被处决。 | 但是有一个村庄在一次掠袭中伏击了他的队伍，在他从马厩偷到马并逃脱厄运的同时，其他人都被砍倒了。 | 在森林里监视时，掠袭队遭到了凶猛野兽的袭击。他为了保全自己的性命，把自己的同志喂给了那些可恶的东西。 | 但随着战争撕裂世界，这个掠袭者意识到真正可以掠袭的东西越来越少了。 | 但随着冲突愈演愈烈，他遇到的每个村庄要么穷得一无所有，要么已经武装起来准备好面对世界上的其他恶魔。}{现在，%name%只想要一个新的开始，即使是在阴暗的佣兵领域。 | %name%作为一个佣兵不能完全被信任，但至少他与强盗和掠袭者的搭伙经历使他适合这项工作。 | 这个人一点也不像兄弟，但他拿武器就像拿着自己丢失的一根手指一样。 | 虽然%name%的过去给每个人留下了不好的印象，但还有更糟糕的。 | %name%擅长杀戮和掠夺，只是要确保这些技能是针对你的敌人的。 | 虽然%name%是一名优秀的战士，但他首先忠诚于掠夺。 | %name%是来杀戮和抢掠的。 对你来说，这是件好事。 | %name%脖子上戴着一串耳朵，另一条项链上则装饰着那些耳朵的耳环。很是花哨。 | %name%是一个强大的斗士，但他很有可能成为你们整个团队中最不受欢迎的人。 | 乡村是块诱人的绿色帆布，可以在上面建立自己的生活。也许这个掠袭者只是想安定下来。 | 穿着沾有前主人血迹的衣服，%name%看起来已经准备好履行职责了。 | 你会觉得%name%穿的衣服可能是某个被谋杀的人的。}";
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
