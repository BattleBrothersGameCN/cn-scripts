this.wildman_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		Tattoo = 0
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.wildman";
		this.m.Name = "野人";
		this.m.Icon = "ui/backgrounds/background_31.png";
		this.m.BackgroundDescription = "野人习惯了只有强壮才能胜出的野外艰苦生活。他们不太适应城市生活，那是精明和狡诈的人的领地。";
		this.m.GoodEnding = "在%companyname%前往某城镇休整时，一位当地公主对野人%name%产生了好感。这位女贵族以一大笔金子“购买”了他。最近你去拜访了这个人。晚宴时，他坐在一张国王般的桌子前，傻笑着，尽其所能地模仿周围的贵族们。他那莫名其妙的新婚妻子爱他，他也爱她。当你告别时，他从自己的头上拿下一顶沉重的金冠赠送与你。冠上承载着悠久的传统和古老的历史。你说他最好留着它。野人耸了耸肩，转身走开，用手指旋转着冠环。";
		this.m.BadEnding = "野人%name%在行将瓦解的%companyname%待了一段时间，然后就默默离开了。战团去森林中寻找他，最终发现了一些粗粝的记号：在一大堆沉甸甸的克朗旁边，有一幅%companyname%及其成员的泥画，所有人都被一个带着傻笑的、字面意义上的火柴人拥抱着。还有一只已经死去并被吃掉一半的兔子作为供品。";
		this.m.HiringCost = 100;
		this.m.DailyCost = 12;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_beasts",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.night_blind",
			"trait.ailing",
			"trait.clubfooted",
			"trait.fat",
			"trait.tiny",
			"trait.gluttonous",
			"trait.pessimist",
			"trait.optimist",
			"trait.short_sighted",
			"trait.dexterous",
			"trait.insecure",
			"trait.hesitant",
			"trait.asthmatic",
			"trait.greedy",
			"trait.fragile",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.bright",
			"trait.cocky",
			"trait.dastard",
			"trait.drunkard"
		];
		this.m.Titles = [
			"蒙昧者(the Savage)",
			"被驱逐者(the Outcast)",
			"野人(the Wildman)",
			"蛮族(the Feral)",
			"野蛮者(the Wild)",
			"野蛮人(the Barbarian)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Wild;
		this.m.BeardChance = 100;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 2);
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
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] 经验获取"
			}
		];
	}

	function onBuildDescription()
	{
		return "{对一些人来说，荒野才是避难所。 | 据说人天生内心就有着野性，背弃它是反而是一种错误行为。 | 文明是一道污点，是为了更好地与终极敌人 —— 大自然母亲本身进行抗争而对每一代人进行的长期武装。 | 在战争时期，很多人再次到野外寻求庇护并不奇怪。 | 有些人从一个城镇逃到另一个城镇。另一些则在中途停下，消失在宁静的森林里。}{%name%曾经在树林中找到了一个安全的居住地，但好景不长。 | 曾经猎人们眼中的神秘角色 —— 著名的“妈呀那是啥” —— %name%如今出于未知原因回到了文明社会。 | %name%的手像铁匠一样强壮，但卫生状况像猪圈一样差。 | 也许是被爱抛弃，也许只是因为战争，%name%在过去的十年里一直远离人类。 | %name%在树林中生活了不知多少年，他也许只是一个在狩猎地定居的盗猎者。 | %name%穿着巧妙缝合的衣服，他的返祖形象也许掩盖了他作为裁缝或鞣制工人的过去。}{这个野人有着明显的语言障碍，但出于某种原因，他似乎非常愿意战斗。我们希望他新发现的“使命”背后没有更阴暗的目的。 | 缤纷而永恒的仪式痕迹围绕包裹着他的身体。当问及他为什么想加入一支佣兵团时，他大喊一声，用弯曲的手指在天空中复制了他的肉体艺术之一。 | 新旧伤口点缀着他斑驳的身体。而且伤口并不浅 —— 这个人曾在野外与凶猛的东西搏斗过。 | 人们不禁要问，那些把他赶到森林里的灾难，是不是又把他赶出来了。 | 他狂野的呼噜声令人怀疑他来这里是不是为了重新融入文明社会。 | 多年的隐居生活并没有让他忘记一些克朗能给人带来什么。 问题是，他为什么回来？ | 他有和野猪搏斗的力气 —— 而他身上的许多伤疤让你怀疑他是不是真的那么做过。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				12,
				10
			],
			Bravery = [
				12,
				10
			],
			Stamina = [
				18,
				23
			],
			MeleeSkill = [
				6,
				0
			],
			RangedSkill = [
				-5,
				0
			],
			MeleeDefense = [
				-5,
				0
			],
			RangedDefense = [
				-5,
				-5
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
		this.m.Tattoo = this.Math.rand(0, 1);
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		local body = actor.getSprite("body");
		tattoo_body.setBrush((this.m.Tattoo == 0 ? "warpaint_01_" : "scar_02_") + body.getBrush().Name);
		tattoo_body.Visible = true;
		tattoo_head.setBrush(this.m.Tattoo == 0 ? "warpaint_01_head" : "scar_02_head");
		tattoo_head.Visible = true;
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush((this.m.Tattoo == 0 ? "warpaint_01_" : "scar_02_") + body.getBrush().Name);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 7);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/hatchet"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wooden_stick"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_metal_club"));
			}
			else if (r == 3)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_wooden_club"));
			}
			else if (r == 4)
			{
				items.equip(this.new("scripts/items/weapons/boar_spear"));
			}
			else if (r == 5)
			{
				items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
			}
			else if (r == 6)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_wooden_hammer"));
			}
			else if (r == 7)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_wooden_flail"));
			}
		}
		else
		{
			r = this.Math.rand(0, 6);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/hatchet"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wooden_stick"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_metal_club"));
			}
			else if (r == 3)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_wooden_club"));
			}
			else if (r == 4)
			{
				items.equip(this.new("scripts/items/weapons/boar_spear"));
			}
			else if (r == 5)
			{
				items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
			}
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.XPGainMult *= 0.850000;
	}

	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeU8(this.m.Tattoo);
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
		this.m.Tattoo = _in.readU8();
	}

});
