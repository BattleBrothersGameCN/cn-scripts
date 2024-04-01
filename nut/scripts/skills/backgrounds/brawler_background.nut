this.brawler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.brawler";
		this.m.Name = "格斗家";
		this.m.Icon = "ui/backgrounds/background_27.png";
		this.m.BackgroundDescription = "格斗家在徒手格斗中无可匹敌，体育锻炼给了他们良好的状态。";
		this.m.GoodEnding = "像%name%这样的格斗家，只用拳头就很有威胁，而他也成功证明自己，用起武器也毫不逊色。在你离开%companyname%之前，你就要不要留在战团的问题找他谈过。他说他不想重返拳击比赛，并和你握手，感谢你给了他这个机会。最近你听说，战团和其他同行就赔偿问题起了争执，协议通过单挑比拳胜者决定，战团派他上场。而他在第一轮就奠定了胜局。";
		this.m.BadEnding = "鉴于留下只有死路一条，%name%退出了行将解体的战团。他回到了拳击赛场，并在接下来的几年里，苦苦挣扎于周赛之中。随着年龄的增长，他失去了他的下巴，也失去了速度和力量。他只能打假赛，故意倒下，或是因为没倒成被暴打。最终，没有人愿意和他比赛了。一个贵族给出了高价佣金，让他和一只熊搏斗，绝望的%name%接受了这个挑战。贵族喝得酩酊大醉，在他们的欢呼叫好声中，这场“战斗”结束了，面目全非的格斗家毫无生气地躺在泥水中，任由凶猛的野兽拖来拖去。";
		this.m.HiringCost = 125;
		this.m.DailyCost = 13;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.ailing",
			"trait.clubfooted",
			"trait.irrational",
			"trait.asthmatic",
			"trait.clumsy",
			"trait.fat",
			"trait.craven",
			"trait.insecure",
			"trait.dastard",
			"trait.fainthearted",
			"trait.bright",
			"trait.bleeder",
			"trait.fragile",
			"trait.tiny"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.IsCombatBackground = true;
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
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+100%[/color] 徒手伤害"
			}
		];
	}

	function onBuildDescription()
	{
		return "{身材魁梧，拳似沙包，过去的一年里，%name%一直在与他的同伴磨练拳技。 | 从那张扭曲成指关节形状的脸就能看出，%name%是个职业斗士。 | %name%喜欢喝酒，就像他喜欢打架一样，真是个强有力的组合。 | 父亲和兄弟们的艰苦教育把%name%磨练成了一个喜怒无常的斗士。 | 年少时期受到的霸凌把%name%锤炼成了一个信奉先下手为强的男子汉。 | %name%只有一项称得上才能的东西：用拳头把别人揍得鼻血直流，自己则无论如何也不倒下。 | 在成长过程中，%name%会和家庭农场里的公牛搏斗。不巧的是，他也会抽时间去城里冒险。}{在过去的一年中，他一直受雇于当地的一位领主，四处巡游，与王室的冠军们搏击。 | 作为酒吧斗殴的爱好者，这名男子显然已经被许多酒馆禁止进入。 | 在%randomtown%中成为出名的斗士意味着他必须与每一个自负、自夸和醉酒的人战斗。 | 尽管他成为了一名不败的职业斗士，但他挣的钱只够勉强维持生计。 | 他脾气火暴，总是乐意开打。当地的格斗组织说他的左钩拳非常狠。}{听说有更大的架能打，%name%放下了拳套，从事更赚钱的佣兵职业。 | 只有一个人能击败%name%：他的妻子。被骂成是胸无大志的丢人现眼之徒，他决定从事更“有尊严”的佣兵工作。 | 多年的战斗基本摧毁了他的记忆。有人说他是把雇佣兵营地看成了购物清单上的项目。 | 赚钱太少，手坏得张都张不开，连抱儿子都抱不了，更别说打拳了，%name%决定找一项新工作。 | 虽然他对真正的战争知之甚少，但在经历了多年的艰苦之后，佣兵的固定报酬实在是诱人。 | 这个人能杀死一块石头，打伤一块巨岩 —— 凡是打架的队伍里都能用上他。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				5,
				10
			],
			Bravery = [
				7,
				5
			],
			Stamina = [
				10,
				5
			],
			MeleeSkill = [
				5,
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
				5,
				0
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
			actor.setTitle(this.Const.Strings.BrawlerTitles[this.Math.rand(0, this.Const.Strings.BrawlerTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.getID() == "actives.hand_to_hand")
		{
			_properties.DamageTotalMult *= 2.000000;
		}
	}

});
