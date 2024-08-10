this.apprentice_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.apprentice";
		this.m.Name = "学徒";
		this.m.Icon = "ui/backgrounds/background_40.png";
		this.m.BackgroundDescription = "学徒往往求知欲强，学得比别人快。";
		this.m.GoodEnding = "学徒%name%是%companyname%里学得最快的人，说不定也是你见过最聪明的人之一。他攒够了钱，从战斗中退役，把自己的才华带到了商界。据说他已经在多个行业取得了成功。如果有儿子的话，你会把儿子送到他那儿当学徒。";
		this.m.BadEnding = "学徒%name%是%companyname%里学得最快的人，毫不意外，他也是最先意识到战团衰落，趁早离开的人之一。如果活在另一个时代，他一定能大有作为。但是战争频发、异族入侵、疫病丛生，许多像%name%这样人空有才华而无处发挥。";
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
			"学艺者",
			"捷思",
			"学徒",
			"徒工",
			"能手",
			"学生",
			"年轻人",
			"神童",
			"聪明人"
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
		return "{人生在世总想做到最好， | 精通一门技艺，收获一片名声， | 人人都想做到最好，}{但没人能一蹴而就。 | 那何不直接向成功人士请教。 | 大家心照不宣，向大师寻求指点。}{怀有这样的想法，%name%以学徒身份来到了%townname%。 | 对此深信不疑，%name%在%townname%做了学徒。 | 当%randomtown%的学院招收学徒时，%name%是第一个报名的。 | 在父母的催促下，%name%开始了他的学徒生涯，提高自己的技艺水平。 | 为了不输给优秀的弟弟，%name%开始拜师求学。}{不幸的是，他选错了师父：一个疯狂的木匠，爱砍脖子胜过砍树。为了逃避眼前的厄运，%name%选择与佣兵为伍。 | %name%竭尽所能地学习，创造了可能是水下编篮领域里有史以来最伟大的艺术作品。可是，他的师傅嫉妒心很强，为了不被弟子超越，把作品化成了一阵烟雾和火光。%name%明白了：他学得很快，但也许应该换个更好的师父。 | 石工、木工、打铁、做爱，想学的东西他都已经学会。现在他把目光转向了武艺。虽然他还算不上什么战士，好在%name%学得很快。}";
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
		_properties.XPGainMult *= 1.1;
	}

});
