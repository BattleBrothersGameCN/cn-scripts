this.mason_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.mason";
		this.m.Name = "石匠";
		this.m.Icon = "ui/backgrounds/background_17.png";
		this.m.BackgroundDescription = "一个优秀的石匠习惯于体力劳动和研究学习以提高他的手艺。";
		this.m.GoodEnding = "砌石工艺有着独特的魅力，尤以精确切割的石块和高耸入云目之不及的高塔最有代表性。石匠%name%回到了他的老本行，并利用他在%companyname%赚来的钱创办了一家享有声誉的企业，以构建冬暖夏凉的石质房间而闻名。";
		this.m.BadEnding = "%companyname%在你离开后继续遭受损失。越来越多的兄弟离开了战团，其中不少人重拾从前的手艺。石匠%name%也不例外。可悲的是，花在战斗上的时间已经摧毁了他仅存的稳重。他的手不停地颤抖，再也不能像以前那样塑造石头了。上次你听说他在做搬运石头的日结工，而不是作为石匠塑造石头。";
		this.m.HiringCost = 90;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.athletic",
			"trait.asthmatic",
			"trait.dumb",
			"trait.clumsy",
			"trait.bloodthirsty"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] 经验获取"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name%在%townname%长大，在年轻时就有认真研读建筑方面的书籍。 | 由一个商人行会养大的%name%在建筑领域的迅速崛起并不令人惊讶。 | 作为%randomtown%著名学院的学生，%name%怀着远大的期望毕业，甚至还有更远大的东西等着他去建造。 | 由于父亲是个砌砖工，%name%进入石匠行业只是迈出的微小一步。 | 惊讶于教堂和国家的宏伟建筑，%name%爱上了砖石工艺。 | 当%randomtown%急需防御墙时，%name%如顺应天时地利人和的天赋者般投身于石匠工作。}{不幸的是，他做石匠的时间很短。他建造的一座教堂倒塌了，一群凶残的暴民从废墟中爬出，伺机复仇。 | 建造了五栋楼，被毁了五栋楼。无休止的战争使这个人的职业变得难以为继。 | 在被一位同行建筑师背叛后，这名石匠将他的对手砌在了自己下一个项目的墙中。不久后，人们开始提出疑问。 | 在盖屋顶时，这个人失足跌倒了。接踵而来的伤病迫使他离开了建筑领域。 | 但当一位领主要求他建造一座可怕的地牢时，这位石匠拒绝了。现在他哪怕一块砖头都不被允许砌。 | 一张错位的蓝图让石匠错建了达库尔神殿，而不是达库利德神殿。现在他说诸神正亲自在追他。}{放下他的锤子和凿子，拿起锤子和一把称为剑的磨尖凿子，%name%现在从事雇佣兵领域的工作。 | 一天，一张佣兵的海报引起了他的注意。就像他以前的那些建筑一样，其余的都是历史。 | 多年的砖石工作使他适应了血与泥的生活。 | %name%在他经过的每栋建筑上都发现了缺陷。希望他能把那些烦人的分析调整到战场上。}";
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
				5,
				5
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

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.MasonTitles[this.Math.rand(0, this.Const.Strings.MasonTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.new("scripts/items/armor/linen_tunic"));
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.XPGainMult *= 1.05;
	}

});
