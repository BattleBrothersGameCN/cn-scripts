this.flagellant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.flagellant";
		this.m.Name = "自笞者";
		this.m.Icon = "ui/backgrounds/background_26.png";
		this.m.BackgroundDescription = "自笞者在他们所做的事情上有着坚定的决心，并且对疼痛有很高的容忍度，但他们的工作经常会让他们的身体留下终身的伤痕。";
		this.m.GoodEnding = "作为团队里最不安分的人之一，自笞者%name%至少能够在挥刀向敌人时，不挥鞭向自己。在他的过度勤奋之余，虽然他是个有能力的佣兵，他的习惯早晚会毁了他。在整整一晚地自我折磨后，这个人又一次失去知觉，几近失血而亡。兄弟们带着拯救%name%的想法，把他扔在了一个修道院里，他最终在痛苦中迷惑地醒来。一位慈祥的僧侣护理他恢复健康，并教他和平的宗教之道。直到今天，%name%还走在修道院的回廊里，给年轻人做一些温和的演讲，让他们远离野蛮崇拜。";
		this.m.BadEnding = "随着战团迅速衰落，许多佣兵孤注一掷。自笞者%name%就是其中之一。由于混乱和困惑，一些人开始相信%name%可以引导他们获得荣誉和救赎。少数幸存者脱离了%companyname%，疯狂地加入了他野蛮的精神崇拜之中。在其旗手%name%的嚎叫声中，皈依者们无目的地漫步，半曲着身子行走在大地上，背上覆盖着生皮。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.weasel",
			"trait.clubfooted",
			"trait.tough",
			"trait.strong",
			"trait.disloyal",
			"trait.insecure",
			"trait.cocky",
			"trait.fat",
			"trait.fainthearted",
			"trait.bright",
			"trait.craven",
			"trait.greedy",
			"trait.gluttonous"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
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
		return "{The gods pity men, spurring many, not unlike %name%, to seek their favor. | Illiterate and born to poverty, %name% found refuge in tales of the gods. | Always a man to devour books, it wasn\'t long until %name% discovered texts of the gods. | Some say the gods speak to us and, if true, they definitely spoke to %name%. | With new cults springing up in the wilds, %name% returned to the familiarity of the gods. | Raised by his firebrand father, %name% spent much of his early years nursing wounds from good floggings. The gods would approve.} {When war came to the land, the gods told him to take part for greater justice. | As cultists spread their vile word like disease on a rat, %name% saw fit to take up arms and battle the heresy. | Straying from his faith, he committed a horrific crime in %randomtown% - finding company with a man. While flagellating himself nightly, he seeks redemption. | Hearing but a mere rumor of a holy place, the pilgrim took up staff and supplies to seek it out. | Now that war has returned to the land, the gods\' devotee wished to find out why, through prayer and corporeal means. | A night spent in a cave revealed to the believer that the gods demanded blood. %name% was not one to refuse their beckoning. | After raiders looted the coffers of his church, %name%\'s quest was to refill the pure purses.} {As the laws of the universe bend to a world-consuming war, a thaumaturge like %name% might be useful to have around. | He carries a whip with glass-barbed leather. This is not for your enemies, he states, but for purity. Interesting. | He professes to hate evil, but for a few crowns %name% can be persuaded to make anything \'evil\'. | This man seeks the difficult road, no doubt why he saw fit to join a mercenary band. | If %name% had the power, you believe he\'d purge the entire world. Thankfully, he is a mere man. | Talks of the gods might be a tad irksome, but %name%\'s fiery passion lends itself well to the battlefield. | So enamored with the world of the gods, it\'s not much of a surprise that the pilgrim sees the real one filled with enemies.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-5
			],
			Bravery = [
				12,
				12
			],
			Stamina = [
				5,
				10
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

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		this.updateAppearance();
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local body = actor.getSprite("body");
		local tattoo_body = actor.getSprite("tattoo_body");
		tattoo_body.setBrush("scar_01_" + body.getBrush().Name);
		tattoo_body.Color = body.Color;
		tattoo_body.Saturation = body.Saturation;
		tattoo_body.Visible = true;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.PilgrimTitles[this.Math.rand(0, this.Const.Strings.PilgrimTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_flail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/reinforced_wooden_flail"));
		}

		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}

		if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/monk_robe"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});
