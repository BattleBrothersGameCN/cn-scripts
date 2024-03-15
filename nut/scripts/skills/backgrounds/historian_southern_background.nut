this.historian_southern_background <- this.inherit("scripts/skills/backgrounds/historian_background", {
	m = {},
	function create()
	{
		this.historian_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.BeardChance = 90;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{%name%读起书来如饥似渴，早年间他总在%randomcitystate%的诸多图书馆里度过漫漫长夜。 | 年幼的%name%在更强壮的同龄人的霸凌下退回了书的世界。 | 为了寻找人类真正的过去，%name%阅读书籍，研究人性。 | 世界上有这么多的变化，%name%决定帮助记录下它们。 | %name%学得很快，又喜好读书，他尝试用纸笔把自己对这个世界的展望传达给别人。 | 来自%randomcitystate%的一座学院，学者%name%为后人记录世界的历史。 | 被世上的黑暗事件震惊，%name%放下了对植物的研究，开始记录人类的历史。}{一个合格的历史学家总会寻找第一手资料，这把他带进了佣兵战团。 | 著作被沙漠掠袭者毁了，他只得鼓起勇气，身体力行，开展新的研究。 | 他的教授说他的研究是垃圾，这位历史学家决定到社会上证明孰是孰非。 | 剽窃嫌疑将这位历史学家赶出了学术界。他在他所研究的世界：战争中寻求救赎。 | 有关他利用学术地位睡女人的丑闻和争议迫使这位历史学家离开研究领域，身无分文的他准备接受任何工作。 | 这位历史学家厌倦了读有关冒险者的书，他决定自己整装好，近距离观察一下真货。 | 佣兵团多如牛毛，这位历史学家试图加入其中一支，进行一些实地研究。}{%name%和真正的士兵没什么共同之处，但他富有想象力的头脑仍然幻想着一场精彩的战斗。 | %name%毕生都在写作，从来参与过战斗。直到今天。 | %name%渴望记录下你们团队的旅程。他愿意执剑披甲作为交换。 | %name%的肩上扛着一袋书。你建议用连枷代替。差不太多，但更尖更刺。 | %name%经常在笔记上奋笔疾书，他仍然用研究人员的眼光看待世界。 | %name%带着一口袋羽毛笔。拿来做箭应该不错。 | 你相信%name%对研究的热诚，但不太相信他挥剑的能力。 | %name%加入团队的最终目标是完成理论，但他得先活着完成实验。 | 你向%name%保证，如果他死了，你会想办法记录下他的一生。他对你表示感谢，把他的遗嘱递给你。遗嘱是用一种你不认识的语言写成的，你一个字也看不懂。但你还是回以微笑。}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});
