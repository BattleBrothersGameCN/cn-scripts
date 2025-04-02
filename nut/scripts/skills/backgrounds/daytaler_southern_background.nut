this.daytaler_southern_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
	m = {},
	function create()
	{
		this.daytaler_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.Ethnicity = 1;
		this.m.BeardChance = 90;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.fear_undead",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{四处打零工 | 没有固定工作 | 时有时无地干活 | 做些零碎活儿 | 没学过什么手艺}的%name%，被人们称为临时工，每当需要额外人手时，总会有人想到他。{最近工作机会稀少，所以 | 过去几周几乎没什么活儿可干，所以 | %name%想尝试些以前没做过的事，所以 | 尽管没有战斗经验，但醉眼朦胧中他误以为自己能行，所以 | %name%认为如今战斗职业永远不会失业，所以 | %name%失去了心爱之人，如同许多人的遭遇，他崩溃了。借酒消愁几周后，}加入一支流动的雇佣兵队伍似乎是个不错的选择{暂时安顿下来 | 赚点钱 | 看看外面的世界 | 清醒一下头脑 | 既能前往下一个村庄，又能充实口袋}。";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else
		{
			local item = this.new("scripts/items/armor/oriental/cloth_sash");
			items.equip(item);
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});
