this.militia_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.militia";
		this.m.Name = "民兵";
		this.m.Icon = "ui/backgrounds/background_35.png";
		this.m.BackgroundDescription = "任何参加过民兵组织的人都至少接受过一些基本的战斗训练。";
		this.m.GoodEnding = "像%name%这样的前民兵最终离开了%companyname%。他游历各地，拜访村庄并帮助他们建立可靠的民兵组织以保卫自己。在这个越来越危险的世界中取得了成功后，%name%最终成为一个知名人物，被称作某种“修补师”专门去确保那些村子们的安全。你最后听到的消息是，他已经购买了一块土地，并远离了世界的纷乱，组建了家庭。";
		this.m.BadEnding = "%name%离开了崩溃中的战团并回到了他的村庄。回到民兵队伍后，不久就开始遭受{绿皮 | 掠夺者}的攻击，他被召唤出战。据说他挺身而出，在击杀无数敌人后鼓舞了防线，直到伤重不支。当你访问那个村庄时，你发现孩子们在一个以民兵形象为样本的雕像下打闹。";
		this.m.HiringCost = 100;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.hate_undead",
			"trait.clubfooted",
			"trait.fat",
			"trait.insecure",
			"trait.dastard",
			"trait.craven",
			"trait.asthmatic"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = this.Math.rand(1, 2);
		this.m.IsCombatBackground = true;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{像%name%这样的民兵只有在需要的时候才会被培养出来。 | 身无分文，没有工作，%name%加入了当地的民兵组织。 | %name%偷苹果被抓住了，作为惩罚，他被迫加入民兵组织。 | 虽然%name%是农民，但他一直愿意加入民兵组织，保护自己的家园。 | 战争是一头饥饿的野兽 —— 像%name%这样的义务民兵就是它的食量。}{虽然他得到了适当的训练，但这些“二流士兵”几乎没有得到足够的食物。 | 尽管他和专业人士一样努力奋斗，但他发现自己的工作无法获得任何尊重。 | 作为最底层的士兵，他很快意识到这意味着他的生命是可以牺牲的。 | 他的武器生锈了，盔甲也不存在了。不幸的是，敌人的装备并不那么差劲。}{身着劣质的装备四处游荡了一年之后，他决定寻找一种更适合自己的职业：佣兵。 | 当一个领主将他的整个民兵部队派去执行几乎注定要失败的任务时，%name%意识到如果他想活下去，他最好寻求一些更好的出路。他把自己的些许技能带到了佣兵的领域。 | 在不能依赖身边战友的部队中度过的多年岁月驱使着%name%开始寻求更好的选择。他并不是你见过的最好的士兵，但他很真诚。 | 当他所在的民兵队解散后，他回到家乡，发现整个城镇已经被烧成了废墟。他已经丧失了安身立命的地方，于是顺理成章地加入了在土地上四处游荡的众多雇佣兵团之一。 | %name%朴素的军事装束掩盖了他经历过相当多训练和战斗的事实。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				3,
				5
			],
			Stamina = [
				3,
				5
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				6,
				5
			],
			MeleeDefense = [
				2,
				2
			],
			RangedDefense = [
				2,
				2
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

		if (this.Math.rand(0, 4) == 4)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.MilitiaTitles[this.Math.rand(0, this.Const.Strings.MilitiaTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		local weapons = [
			"weapons/hooked_blade",
			"weapons/bludgeon",
			"weapons/hand_axe",
			"weapons/militia_spear",
			"weapons/shortsword"
		];

		if (this.Const.DLC.Wildmen)
		{
			weapons.extend([
				"weapons/warfork"
			]);
		}

		items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));

		if (items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null && this.Math.rand(1, 100) <= 50)
		{
			items.equip(this.new("scripts/items/shields/buckler_shield"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 6);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/full_leather_cap"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});
