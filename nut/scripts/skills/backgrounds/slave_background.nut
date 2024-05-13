this.slave_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.slave";
		this.m.Name = "负债者";
		this.m.Icon = "ui/backgrounds/background_60.png";
		this.m.BackgroundDescription = "负债者是城邦国家中实际上的奴隶阶层，因此他们不是被雇佣，而是被购买，并且无需支付日薪。";
		this.m.GoodEnding = "负债者%name%曾经过着艰难的生活，你们两个都有责任，也都用某种方式缓解了他的困境。你在南方找到他时，他还是个奴隶，远离家人和家园。你基本上是免费“雇佣”了他，并将他作为奴隶佣兵驱使。在你离开%companyname%之后，他的名字已经从债务簿上删除了，实际上已经成为了自由人。他留在了战团里，且从那以后他的职位一直在上升。你和这个人之间的关系很奇怪，他从来没有感谢过你，也没有表现过任何不满。";
		this.m.BadEnding = "随着你从不成功的%companyname%退休，来自北方的负债者%name%继续在战团里呆了一段时间。后来你听说这支佣兵团遇到了财务问题，正在出售“人和材料”以维持生计。似乎%name%就是在那时结束了与战团的时光，又重新开始了身为奴隶的日子。";
		this.m.HiringCost = this.Math.rand(19, 22) * 10;
		this.m.DailyCost = 0;
		this.m.Titles = [
			"受奴役者(the Enslaved)",
			"北方人(the Northerner)",
			"俘虏(the Captive)",
			"苍白者(the Pale)",
			"囚犯(the Prisoner)",
			"被劫持者(the Kidnapped)",
			"倒霉蛋(the Unlucky)",
			"负债者(the Indebted)",
			"负债者(the Indebted)",
			"不自由者(the Unfree)",
			"受监者",
			"受铐者(the Shackled)",
			"被缚者(the Bound)"
		];
		this.m.Excluded = [
			"trait.survivor",
			"trait.iron_jaw",
			"trait.tough",
			"trait.strong",
			"trait.spartan",
			"trait.gluttonous",
			"trait.lucky",
			"trait.loyal",
			"trait.cocky",
			"trait.fat",
			"trait.fearless",
			"trait.brave",
			"trait.drunkard",
			"trait.determined",
			"trait.greedy",
			"trait.athletic",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Bravery
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
		local ret = [
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
		ret.push({
			id = 19,
			type = "text",
			icon = "ui/icons/special.png",
			text = "非负债者盟友死亡时不会触发士气检查"
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/special.png",
			text = "总是满足于充当后备"
		});
		return ret;
	}

	function onBuildDescription()
	{
		return "{你从外表就可以看出%name%是个北方人。他在南方沦为奴隶是因为对异端旧神的信仰触犯了镀金者。 | %name%有着北方人的面容，很容易吸引男男女女的目光。这也引起了一位祭司的注意，后者声称这位北方人欠下了对镀金者的债务，于是把这位闯入者卖成了奴隶。 | 作为一个北方人，%name%曾是一名被派往南方巡逻的士兵。他们一队人在沙漠中失去了方向，逐渐减员，直到他成为了唯一的幸存者。猎奴者抓住了他，将他从死亡边缘拉了回来，当然，一旦他的身体恢复了价值，就将他卖作了奴隶。 | 尽管%name%是个显眼的北方人，他还是不明智地走上了犯罪道路，他在从一个维齐尔的花园里偷石榴时被抓住了。他幸运地保住了性命，但现在成了猎奴者市场上的一种劳力商品。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-10
			],
			Bravery = [
				-5,
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
				-5,
				-5
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;

		if (this.Math.rand(1, 100) <= 66)
		{
			local body = actor.getSprite("body");
			local tattoo_body = actor.getSprite("tattoo_body");
			tattoo_body.setBrush("scar_01_" + body.getBrush().Name);
			tattoo_body.Color = body.Color;
			tattoo_body.Saturation = body.Saturation;
			tattoo_body.Visible = true;
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.IsContentWithBeingInReserve = true;

		if (("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.manhunters")
		{
			_properties.XPGainMult *= 1.1;
			_properties.SurviveWithInjuryChanceMult = 0.0;
		}
	}

});
