this.apprentice_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.apprentice";
		this.m.Name = "学徒";
		this.m.Icon = "ui/backgrounds/background_40.png";
		this.m.BackgroundDescription = "学徒往往求知欲强，学得比别人快。";
		this.m.GoodEnding = "学徒%name%也许是你所见过的最聪明的人之一，他是%companyname%中学东西最快的。有了足够的财富积累，他从战斗中退役，将自己的才华带到了商界。最后你听说他在多个行业非常成功。如果你有儿子，他就是你会送儿子去当学徒的对象。";
		this.m.BadEnding = "%name%这位学徒是%companyname%中学习速度最快的人，毫无疑问，他也是最快意识到战团不可避免地会垮台并及早离开的人之一。如果他生在另一个时代，他本来可以做出伟大的成就。但是很多战争、入侵和瘟疫这片土地上蔓延，最终导致%name%和许多其他才华横溢的人彻底被浪费。";
		this.m.HiringCost = 90;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.dumb",
			"trait.clumsy",
			"trait.asthmatic",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"学徒(the Learner)",
			"捷思(Quickmind)",
			"学徒(the Apprentice)",
			"替补(the Understudy)",
			"能手(Goodhand)",
			"学生(the Student)",
			"年轻人(the Young)",
			"孩子(the Kid)",
			"明日之星(the Bright)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.YoungMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
				id = 13,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] 经验获取"
			}
		];
	}

	function onBuildDescription()
	{
		return "{一个人来到世上总是想尽自己所能去做到最好， | 精通一门艺术是值得尊敬的， | 每个人总想做到最好，}{但没人能一蹴而就。 | 那么有什么方法能比向他人学习更好呢？ | 大多数人都向大师寻求指点，这已经不是秘密了。}{%name%也有这样的想法，以学徒的身份呆在%townname%。 | 相信着这一点的%name%在%townname%做了学徒。 | 当%randomtown%的学院招收学徒时，%name%是第一个报名的。 | 在父母的要求提高其手艺的催促下，%name%开始了他的学徒生涯。 | 为了不被他优秀的兄弟超越，%name%开始了他的学徒生涯。}{不幸的是，他选错了师傅：一个疯狂的木匠，喜欢砍脖子而不是树枝。为了逃避即将到来的厄运，%name%最终加入了佣兵团。 | %name%竭尽所能地学习，创造了水下编织篮子的领域中可能是有史以来最伟大的艺术作品。可是，他的师傅是个嫉妒心很强的人。为了不被弟子超越，他把这个作品烧成了灰烬和令人咳嗽的烟雾。%name%明白了：他学得很快，但也许有更好的师傅可以学习。 | 他已经把所有要学的东西都学完了：石工、木工、打铁、做爱。现在他把目光转向了武艺。虽然他还不是一个真正的战士，但%name%学得很快。}";
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
				0
			],
			Stamina = [
				0,
				0
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
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/apron"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.XPGainMult *= 1.100000;
	}

});
