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
		return "{%name%一直是个如饥似渴的读者，在他的早年时光里他总在%randomcitystate%的图书馆里度过漫漫长夜。 | 年幼的%name%在更强壮的同龄人的霸凌下退回了书的世界里。 | 为了寻找人类真正的过去，%name%阅读书籍，研究人性。 | 世界上有这么多的变化，%name%决定帮助记录下它们。 | %name%是一个快速学习者，对好书有着特别的喜好，他尝试用纸笔把自己对这个世界的展望传达给别人。 | 作为一位来自%randomcitystate%的学院的学者，%name%为后人记录世界的历史。 | 被世上的黑暗事件所震惊，%name%停止了对植物的研究，开始记录人类的历史。}{一个合格的历史学家会寻找他能得到的最接近的资料，这就把他带进了雇佣兵的战团。 | 在沙漠掠夺者们毁了他的著作后，这个人穿上了靴子开始开展新的研究 —— 亲自。 | 当他的教授说他的研究是垃圾时，这位历史学家到社会上去证明他的错误。 | 由于被指控剽窃，这位历史学家被赶出了学术界。他在他所研究的世界：战争中寻求救赎。 | 这个历史学家利用他在学术界的地位去睡女人，最终的丑闻和争议迫使他离开这个领域，让他身无分文，准备接受任何工作。 | 这位历史学家厌倦了读有关冒险者的书，他决定自己整装好，近距离观察一下真货。 | 由于许多雇佣兵团散布在周围，这位历史学家试图参加其中一支，进行一些现实生活的研究。}{%name%和真正的士兵没有什么共同之处，但他富有想象力的头脑仍然幻想着一场精彩的战斗。 | %name%毕生都在写作，从来没有花时间打斗过。直到如今。 | %name%渴望记录下你们团队的旅程。他可以出力拿上一把剑、穿戴好自己。 | %name%的肩上扛着一袋书。你建议用连枷代替。很相似，但更尖更刺。 | %name%经常被发现在笔记上奋笔疾书，因为他仍然用研究人员的眼光看待世界。 | %name%带着一口袋羽毛笔来。羽毛可以用来做很好的箭。 | 你可以相信%name%对研究的真诚，但也许不太相信他挥舞剑的能力。 | %name%跟着团队的任务是发展一个理论，但他能在实验中幸存下来吗？ | 你向%name%保证，如果他死了，你会想办法记录下他的生活。他对你表示感谢，把他的遗嘱递给你。遗嘱是用一种对你来说陌生的语言写成的，你一个字也看不懂。总之，你还是回以微笑。}";
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
