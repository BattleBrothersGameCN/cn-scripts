this.brawler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.brawler";
		this.m.Name = "格斗家";
		this.m.Icon = "ui/backgrounds/background_27.png";
		this.m.BackgroundDescription = "格斗家在徒手格斗中是无与伦比的，体育锻炼往往能使他们保持良好的状态。";
		this.m.GoodEnding = "像%name%这样的格斗家只用拳头就很危险，并且证明了自己在使用武器时同样可怕。在你离开%companyname%之前，你和这个斗士谈过他是否要留下。他说他不想重返拳击比赛，并和你握手，感谢你给他这个机会。据你最后得知，战团选择他在一场一对一的比赛中与一支竞争的雇佣兵团队决定赔偿差异。他在第一轮就赢了。";
		this.m.BadEnding = "格斗家%name%在战团显然即将解散并有可能会让留下来的人都丧命时离开了。他回归拳击比赛，在每周残酷的比赛中挣扎了好几年。随着年龄的增长，他的下巴消失了，速度和力量也跟着消失。他只能打假赛，故意倒下，在没倒成的时候被暴打。最终，没有人再想和他比赛了。一个贵族向他提出了高价佣金，让他和一只熊搏斗，绝望的%name%接受了这个挑战。当这场“战斗”结束时，这个格斗家死掉了，面目全非，被凶猛的野兽在泥泞中拖着，而醉酒的贵族们欢呼雀跃着。";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+100%[/color] 徒手时的伤害"
			}
		];
	}

	function onBuildDescription()
	{
		return "{身材魁梧，拳头结实，%name%在过去一年的大部分时间里都在与他的同伴磨练拳技。 | 一张扭曲成别人指关节形状的脸，不难看出%name%是个职业斗士。 | %name%喜欢喝酒，就像他喜欢打架一样，这是一种有力的组合。 | 父亲和兄弟们的艰苦教育把%name%磨练成了一个喜怒无常的斗士。 | %name%在年少时期遇到的恶霸将他塑造为一个宁愿主动寻找冲突而不是等待冲突到来的男子汉。 | %name%只有一项真正的才能：用拳头把别人揍得鼻血直流，而且自己无论如何都不会倒下。 | 在成长过程中，%name%与家庭农场里的公牛搏斗。不幸的是，他也有时间到城市里去冒险。}{在过去的一年中，他一直受雇于当地的一位领主，四处巡游，与王室的冠军们搏击。 | 作为酒吧斗殴的爱好者，这名男子显然已经被许多酒馆禁止进入。 | 在%randomtown%中成为出名的斗士意味着他必须与每一个自负、自夸和醉酒的人战斗。 | 尽管他成为了一名不败的职业斗士，但他挣得的钱才勉强够维持生计。 | 他脾气暴躁，总是乐意开打。当地的格斗组织说他的左钩拳非常狠。}{听说有更大的架能打，%name%放下了拳套以从事更赚钱的佣兵职业。 | 只有一个人击败了%name%：他的妻子。在她责备他的没有野心让人尴尬之后，他决定从事更“有声望”的雇佣兵工作。 | 多年的战斗几乎毁坏了他的记忆。一些人认为他是把雇佣兵营地看成了自己购物清单上的项目。 | 赚的克朗很少、几乎无法张开受伤的手来拥抱自己的儿子，更不用说出手打拳了，所以%name%正在寻求一项新的事业。 | 在经历了多年的艰苦之后，尽管他对真正的战争知之甚少，但对他来说，雇佣兵工作固定报酬的承诺是一个诱人的提议。 | 这个人能杀死一块石头，伤害一块巨岩 —— 对任何组织都是一个很好的补充。}";
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
