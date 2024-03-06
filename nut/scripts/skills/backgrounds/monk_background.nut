this.monk_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.monk";
		this.m.Name = "僧侣";
		this.m.Icon = "ui/backgrounds/background_13.png";
		this.m.BackgroundDescription = "僧侣们往往对他们所做的事情有很高的决心，但不习惯繁重的体力劳动或战争事宜。";
		this.m.GoodEnding = "僧侣%name%从战团退役，回归平静的精神生活。他现身处一所山中修道院，一边回想战团时光，一边享受宁静。其他僧侣都因他战斗与杀戮的过往憎恶于他，而他正在写一本和平与暴力之间的平衡的书，一本改变世界的巨著。";
		this.m.BadEnding = "在经历了一次精神崩溃后，%name%退役并在一座修道院中找到了归所。他的所有兄弟和修道院长都因为他参与了这样的暴力冒险而排斥他。有传言说他在偷祭品时被教堂司事抓到，最终被流放。";
		this.m.HiringCost = 60;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_beasts",
			"trait.swift",
			"trait.impatient",
			"trait.clubfooted",
			"trait.brute",
			"trait.gluttonous",
			"trait.disloyal",
			"trait.cocky",
			"trait.quick",
			"trait.dumb",
			"trait.superstitious",
			"trait.iron_lungs",
			"trait.craven",
			"trait.greedy",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"虔诚者 (the Pious)",
			"僧侣(the Monk)",
			"学者(the Scholar)",
			"传教士(the Preacher)",
			"虔诚者(the Devoted)",
			"无声者(the Quiet)",
			"沉稳者(the Calm)",
			"忠诚者(the Faithful)"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.Monk;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Monk;
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
		return "{由于家人被掠袭者杀害，%name%退身于宗教中寻求慰藉，在附近的一个修道院出家为僧。 | 多年来，%name%经常离开教堂和其他僧侣，向偏远村庄的农民传教。 | %name%，一个安静的僧侣，花了数不清的日子在%townname%的修道院里朝拜旧神。 | 作为众多僧侣中的一员，%name%曾经在%randomtown%的尖顶神殿中漫游。 | %name%年幼时被遗弃在修道院的台阶上，在僧侣的陪伴下长大，很快就适应了他们的生活方式。 | 为了在一片废墟中寻求安宁，%name%成了一名僧侣。 | %name%一直是个不听话的孩子，他的父母把他交给了当地的修道院，在那里，他很快成为了一个安静的僧侣。}{不幸的是，他的院长对青春肉体的喜好导致了一场可怕的丑闻。%name%为了保全他的小命和信仰逃离了那里。 | 男人被阉割、女人被强奸、孩子被串成串，掠袭者的恶毒袭击使他的信仰受到了不可逆转的伤害。 | 尽管他信仰旧神们，但他无法忍受他的顶头祭司长以神的名义犯下的暴行。这位僧侣最终离开了，以自己的方式寻求灵性。 | 随着世界的苦难不断增加，%name%所在修道院的院长请求他出去医治大地上的人们 —— 或者消灭那些执迷不悟的人。 | 崇拜死亡的邪教、噩梦般的野兽、还有残忍的人们。%name%离开寺庙的厅堂去净化这一切。 | 但当一个孩子问及他一个动摇信仰的问题时，%name%放弃了他的信仰，通过其他方式寻求灵性。 | 不幸的是，祈祷并没有使他的兄弟们免遭屠杀。%name%意识到，与其对什么所谓的神灵嘀咕，不如把自己的信念投在自己身上。 | %name%一直是个脾气暴躁的人，他离开了安全的修道院，去“纠正”世界。 | 作为这一带少数的几个文化人之一，%name%放弃了苦行僧的生活，去更多地了解这个世界，并希望能治愈这个世界的弊病。 | 但有一天晚上，一个女人跟他上了床。他醒来时，发现自己的信仰在周围皱巴巴的被单上支离破碎。他感到羞愧，再也没有回到修道院。 | 但他利用自己被信任的地位谋取不义之财，从神殿的宝库中偷窃。没过多久，丑闻就把他赶了出去。 | 不幸的是，一个孩子指责他的行为不符合僧侣的身份。没有人知道故事背后的真相，但%name%在教堂没呆上多久。 | 一天晚上，他在一本古书中发现了一个可怕的真相。不久之后，%name%草草离开了教堂，也没说他发现了什么。}{这个人对战斗一窍不通，但他有着如同抵御风暴的高山般坚毅的精神。 | 多年的孤独和祈祷使%name%身材走样，但最可贵的是他坚韧不拔的精神。 | 也许是对他当前的生活感到不满，很难说清为什么像%name%这样的人会加入一群佣兵。 | 也许这个世界上有太多的恶魔，或者他内心有太多的恶魔，但你不会质疑为什么%name%想要加入一帮佣兵。 | 信仰劈不开绿皮，但能让%name%这样的人不从绿皮身边逃跑。 | 根除无信者是%name%的愿望，这份决心是可怕的。 | 虽然%name%的灵性值得称赞，但他老是对旧神不断嘀咕，够烦人的。 | 也许比起执剑，%name%的手更适合祈祷，但很少有佣兵拥有像他一样坚定的决心。 | 圣书不离手，%name%寻找佣兵作伴。 | 他随身携带的圣书厚得足以作为盾牌，但当你大声说出这些话时，%name%的样子绝对吓坏了。 | 也许是抱着一种浪漫的观点，认为佣兵需要一种良好的精神净化，%name%寻求与佣兵相伴。 | 读到过神职者战士们的故事的%name%现在希望效仿那些勇敢而坚定的战士。 | 你能感觉到%name%想要在这个罪恶的世界中寻求解脱之法。如果这是真的，那么他来对地方了。}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				11,
				11
			],
			Stamina = [
				-10,
				0
			],
			MeleeSkill = [
				-5,
				-5
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
		items.equip(this.new("scripts/items/armor/monk_robe"));
	}

});
