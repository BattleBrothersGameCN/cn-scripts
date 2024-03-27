this.cripple_southern_background <- this.inherit("scripts/skills/backgrounds/cripple_background", {
	m = {},
	function create()
	{
		this.cripple_background.create();
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
	}

	function onBuildDescription()
	{
		return "%name%{一瘸一拐的朝你走来，像一条落魄的狗 | 用缺指的手朝你打招呼 | 把他没牙的嘴挤出个微笑 | 身姿低垂，好似背部受了伤 | 在两条僵硬的疑似木腿上摇摇晃晃 | 拄着拐杖朝你走来 | 起初是爬着来的，后来站起身来，犹像一个教堂台阶上的醉汉 | 每走一步，骨头都咯吱作响 | 吊着一条胳膊，靠拐杖撑着一条腿 | 是个塌鼻梁，乌眼青 | 看起来好像有人想要剥下他的头皮把他活埋 | 的肉闻着快要熟了，每朝你走一步，他就眯一下眼睛 | 没了一对耳朵，用耳朵眼听声 | 散发出屎尿的臭味 | 少了一只眼，剩下的一只也游移不定 | 两只眼睛无精打采，笑容扭曲空无一物 }。他解释道，{他曾经是名石匠，但因为复制自己的作品而被疯子袭击了 | 他曾以骑士的身份披甲上阵，但残酷的命运带走了他的一切 | 他曾经是个维齐尔，但他贫乏的词汇表明，他在说谎 | 他曾经是个小贩，但一场狼脊骨的推销让他落在了愤怒的镇民手里 | 他曾经涉及邪教，想要退出时却被他们惩罚 | 他曾经参与拳赛，取悦奢靡的商人，但某次他被其他斗士击倒在地，残废了 | 他曾经在竞技场里战斗，直到一场糟糕的比赛以他伤重残废告终 | 他过去盗过墓，有次教区居民把他逮到，打断的骨头比他从骨架子上见过的还多 | 他涉足{奥术 | 死灵法术}，但他垂死的状态表明，这次试验草草收场 | 他曾经是个成功的赌徒，结果显示，不还债对生意和骨头都不好 | 他曾经捕鼠为生，但显然一只巨鼠在夜间为报仇找上了他 | 他曾经服侍%randomcitystate%的一位维齐尔，一盘摔在地上的食物让他锒铛入狱，被忘在那里好几年 | 诚然，他杀过人，理应得到报应，但不是不可逆转的酷刑 | 他曾经是个女巫猎人，直到残忍女士给他灌下了脆骨合剂 | 他从军队里逃了出来，显然，他被抓住了 | 他曾经为富人表演杂耍，直到他在特技表演中摔下台阶。看来台阶比他的骨头硬多了 | 他生下来就患有严重畸形 | 他的父亲因为他没有活成他期待的样子而残暴地殴打了他 | 他母亲无休止的折磨给他留下了伤疤 | 他的兄弟姐妹折磨了他一辈子}。{这人虚弱极了，他的皮囊随风摆动。 | 雇了他他也就完了。你真是个大好人！ | 你不想让人觉得自己什么人都招，但这人算不上个人，那么也就算不上什么人都招？ | 他比死人还像死人。 | 这人是会走路的狗食。 | 好消息是，如果他死而复生，你可以轻易放倒他第二次。 | 梦游撞墙都比他危险。 | 说实话，你宁愿雇个小孩，但人们的白眼让你找了这人作为替代。 | 你觉得%randombrother%已经够难闻了。 | 雇个这样的人，道德指南针恐怕要转得冒火星。 | 喂，好好看看他！%companyname%有这么需要热乎的尸体吗？ | 雇佣这样的人是不对的。嗯，好吧。 | 一副拐杖都比这人有价值。 | 这人的状况糟透了，他能站着装死。}";
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
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			local item = this.new("scripts/items/helmets/oriental/nomad_head_wrap");
			item.setVariant(16);
			items.equip(item);
		}
	}

});
