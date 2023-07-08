local gt = this.getroottable();

if (!("Strings" in gt.Const))
{
	gt.Const.Strings <- {};
}

gt.Const.Strings.ShieldNames <- [
	"盾",
	"堡垒",
	"保护者",
	"护板",
	"盾墙",
	"覆盖",
	"卫士",
	"守护者",
	"防卫者",
	"监狱",
	"障壁",
	"阻截者",
	"巨盾",
	"堡垒",
	"堡垒",
	"警卫",
	"壁垒",
	"拦截者",
	"守望者",
	"甲壳"
];
gt.Const.Strings.SwordNames <- [
	"切裂者",
	"切片者",
	"刀",
	"切割者",
	"切肉刀",
	"剑",
	"死亡使者",
	"宽恕",
	"杀手",
	"利刃",
	"战刃",
	"长刀",
	"饮血者",
	"誓约守护者",
	"晨光",
	"审判",
	"复仇者",
	"血河",
	"毒刺",
	"闪电",
	"打击者",
	"剃刀",
	"利刃",
	"风刃",
	"迅刃"
];
gt.Const.Strings.SabreNames <- [
	"弯刃刀",
	"马刀",
	"斩首者",
	"弧形刃",
	"新月",
	"残月",
	"南境之星",
	"狮尾弯刀",
	"短弯刀"
];
gt.Const.Strings.CleaverNames <- [
	"斩劈者",
	"开膛者",
	"切裂者",
	"切片者",
	"切割者",
	"切肉刀",
	"斩首者",
	"掠袭者",
	"饮血者",
	"渴血者",
	"暴行",
	"血肉雕刻者",
	"军用砍刀",
	"断肠者",
	"血肉切割者",
	"屠夫切肉刀",
	"绞肉机",
	"劈砍者",
	"撕裂者",
	"碾压者",
	"砍杀者",
	"毁坏者",
	"残害者",
	"摧残者",
	"残杀者"
];
gt.Const.Strings.WhipNames <- [
	"鞭子",
	"长舌",
	"蛇",
	"闪电",
	"绞杀者",
	"伸缩鞭",
	"苦痛制造者",
	"惩罚者",
	"鞭笞者"
];
gt.Const.Strings.AxeNames <- [
	"分尸者",
	"斩劈者",
	"斧头",
	"屠杀者",
	"狂怒",
	"清算者",
	"杀手",
	"掠夺者",
	"死亡宣告",
	"掠袭者",
	"裂颅者",
	"征服者",
	"死亡使者",
	"寡妇制造者",
	"毁灭者",
	"破盾者",
	"新月"
];
gt.Const.Strings.LongaxeNames <- [
	"长斧",
	"狂怒",
	"清算者",
	"掠夺者",
	"死亡宣告",
	"掠袭者",
	"裂颅者",
	"死亡使者",
	"寡妇制造者",
	"破盾者",
	"开山斧",
	"长柄刀刃",
	"长柄战斧",
	"斩首者",
	"开膛者",
	"分裂者",
	"切肉刀",
	"唤雷者",
	"破坏者",
	"灭顶之灾"
];
gt.Const.Strings.ThrowingAxeNames <- [
	"投斧",
	"刀锋",
	"分尸者",
	"轮转死神",
	"开膛者",
	"碎肉机",
	"狂怒",
	"掠袭者",
	"死亡宣告",
	"寡妇制造者",
	"激浪",
	"新月",
	"虐杀者",
	"突围者",
	"利刃",
	"杀手"
];
gt.Const.Strings.SpearNames <- [
	"尖刺",
	"穿刺者",
	"矛",
	"背刺者",
	"把柄",
	"唾刺者",
	"刺钎",
	"尖桩",
	"棘刺",
	"倒钩",
	"翎羽",
	"长矛",
	"迅捷尖刺",
	"乱舞刃锋",
	"防卫者",
	"毒刺",
	"别针"
];
gt.Const.Strings.PikeNames <- [
	"投枪",
	"极",
	"责杖",
	"尖桩",
	"穿刺者",
	"战矛",
	"矛",
	"疾射",
	"龙卷",
	"毒刺",
	"脊刺",
	"长峰矛",
	"穿心矛",
	"剜眼枪",
	"尖旋",
	"白银之枪",
	"针鞘"
];
gt.Const.Strings.BillNames <- [
	"打谷者",
	"镰",
	"钩镰",
	"长柄刀刃",
	"杆枪",
	"月牙斧",
	"钩镰枪",
	"伸缩鞭",
	"摧心者",
	"饮血者",
	"劈砍者",
	"斩劈者",
	"破敌者",
	"肢解者",
	"割草机",
	"碾压者",
	"砍杀者"
];
gt.Const.Strings.GreatswordNames <- [
	"大剑",
	"双手剑士",
	"刀",
	"长刀",
	"杀手",
	"征伐者",
	"斩首者",
	"刽子手",
	"防卫者",
	"兽人杀手",
	"荣誉",
	"阔剑",
	"暴徒之末日",
	"长柄剑",
	"分尸者",
	"军用大剑",
	"护手大剑",
	"双手重剑"
];
gt.Const.Strings.WarbrandNames <- [
	"布兰德战刃",
	"寻战者",
	"护手刀",
	"刀",
	"长刀",
	"杀手",
	"征伐者",
	"斩首者",
	"祸乱之源",
	"凋零之刃",
	"战刃",
	"斩风者",
	"水手弯刀",
	"利刃",
	"快刀",
	"打击者",
	"撕肉者",
	"绞肉者"
];
gt.Const.Strings.DaggerNames <- [
	"分裂者",
	"棘刺",
	"楔子",
	"凿子",
	"钻子",
	"毒针",
	"德克",
	"锥子",
	"短刀",
	"匕首",
	"放血者",
	"背誓者",
	"毒牙",
	"狡黠之刃",
	"复仇者",
	"背刺者",
	"掏心者",
	"小剑",
	"胫刃",
	"毒刃",
	"线针",
	"剔骨刀"
];
gt.Const.Strings.CrossbowNames <- [
	"爆矢弩",
	"穿刺者",
	"吐痰器",
	"钉刺者",
	"投手",
	"射手",
	"弹射",
	"弩弓",
	"弩",
	"破局者",
	"摧破者",
	"背叛者",
	"掷矛者",
	"天火",
	"信使",
	"手炮",
	"巨人杀手",
	"强弩",
	"伸缩鞭",
	"密使"
];
gt.Const.Strings.BowNames <- [
	"伸缩鞭",
	"弯弓",
	"大弓",
	"长弓",
	"战弓",
	"穿杨",
	"稳固者",
	"天擎",
	"反曲弓",
	"风语者",
	"出云",
	"战歌",
	"轰炮",
	"穿心者",
	"复仇者",
	"疾风",
	"射手",
	"透心者",
	"毒刺",
	"灾星(Comet)",
	"天陨",
	"风暴使者",
	"唤雨者",
	"雹暴",
	"穿云",
	"绒线",
	"刚力",
	"肌腱"
];
gt.Const.Strings.FlailNames <- [
	"链枷",
	"猛击者",
	"响吻",
	"鞭子",
	"裁决",
	"净化者",
	"怨毒",
	"收割者",
	"挽歌",
	"憎恶",
	"审判",
	"盲目的正义",
	"救赎",
	"打谷机",
	"鞭挞者",
	"惩击者",
	"决胜",
	"死神",
	"谴责",
	"惩罚者",
	"流星",
	"突袭者",
	"捶打者"
];
gt.Const.Strings.MaceNames <- [
	"猛击者",
	"碎裂者",
	"粉碎者",
	"俱乐部",
	"锤",
	"棍棒",
	"谋害者",
	"碎颅者",
	"撞槌",
	"撞槌手",
	"主宰",
	"荒凉",
	"战棒",
	"警棍",
	"节杖",
	"皇家战棒",
	"响炮",
	"痛击者",
	"敲打者"
];
gt.Const.Strings.HammerNames <- [
	"锤子",
	"大锤",
	"重锤",
	"粉碎者",
	"破甲者",
	"铁喙",
	"撞槌手",
	"大灾变",
	"战锤",
	"骑士杀手",
	"击锤",
	"食铁者",
	"镰",
	"钻孔者",
	"碎金锤",
	"蹂躏者",
	"分离者"
];
gt.Const.Strings.JavelinNames <- [
	"棘刺",
	"尖刺",
	"针",
	"标枪",
	"投矛",
	"尖桩",
	"飞镖",
	"倒钩",
	"脊刺",
	"钉刺",
	"投枪",
	"鱼叉"
];
gt.Const.Strings.FencingSwordNames <- [
	"毒刺",
	"冷锋",
	"棘刺",
	"钢钳",
	"利刃",
	"打击者",
	"刀",
	"掏心者",
	"饮血者",
	"封喉剑",
	"荣光",
	"迅刃"
];
gt.Const.Strings.PolehammerNames <- [
	"碎裂者",
	"粉碎者",
	"震击锤",
	"撼地者",
	"噬金锤",
	"铁喙",
	"锤子",
	"分离者",
	"破门者",
	"战锤",
	"雷霆"
];
gt.Const.Strings.ThreeHeadedFlailNames <- [
	"抽头者",
	"九尾猫",
	"凌迟者",
	"唱诗班",
	"冰雹",
	"瀑布",
	"惊怖",
	"激流",
	"残虐者",
	"战团"
];
gt.Const.Strings.SpetumNames <- [
	"尖刺",
	"三叉戟",
	"刺钎",
	"密集阵",
	"脊刺",
	"长峰矛",
	"穿心矛",
	"剜眼枪",
	"尖旋",
	"白银之枪",
	"针鞘"
];
gt.Const.Strings.TwoHandedFlailNames <- [
	"爆头者",
	"碎盾者",
	"粉碎者",
	"开颅者",
	"碎骨者",
	"残害者",
	"链枷",
	"惩罚者",
	"猛击者",
	"鞭子",
	"收割者"
];
gt.Const.Strings.TwoHandedMaceNames <- [
	"颅骨扭曲者",
	"粉碎者",
	"践踏者",
	"棍棒",
	"大棒",
	"擎天",
	"割草机",
	"战棒",
	"巨人之棒",
	"大地之拳",
	"击槌",
	"撼地者"
];
gt.Const.Strings.WarscytheNames <- [
	"军用镰刀",
	"死神",
	"镰刀",
	"刀",
	"利刃",
	"长柄镰刀",
	"收割者",
	"新月"
];
gt.Const.Strings.HandgonneNames <- [
	"加农炮",
	"龙息少年",
	"火药柱",
	"咆哮",
	"雷鸣",
	"火棒",
	"龙舌",
	"戈恩",
	"雷霆棒",
	"喷火器"
];
gt.Const.Strings.SwordlanceNames <- [
	"利刃法杖",
	"刀刃长矛"
];
this.Const.Strings.SwordlanceNames.extend(this.Const.Strings.WarscytheNames);
gt.Const.Strings.OldWeaponPrefix <- [
	"古老的",
	"先祖的",
	"遗产·",
	"悠久的",
	"上古的",
	"太古的",
	"死亡领主的",
	"失落的",
	"被遗忘的",
	"陈旧的",
	"冷锻的",
	"唯一的",
	"古老的",
	"恐怖的",
	"阴寒的",
	"庄严的",
	"古代的",
	"圣物·",
	"被埋葬的",
	"先驱的",
	"先行者的",
	"历经百战的",
	"古董",
	"圣遗·",
	"纪念·",
	"帝国的",
	"军团的",
	"古老的"
];
gt.Const.Strings.BarbarianPrefix <- [
	"先祖的",
	"征服者的",
	"酋长的",
	"军阀的",
	"冠军勇士的",
	"祖先的",
	"唤火者的",
	"剥夺者的",
	"血淋淋的",
	"掠夺者的",
	"冰冻的",
	"冰寒的",
	"部落的",
	"野蛮人",
	"染血的",
	"天选的"
];
gt.Const.Strings.BarbarianSuffix <- [
	"·北方",
	"·陈旧",
	"·愤怒",
	"·杀戮",
	"·大屠杀",
	"·诸神",
	"·反抗",
	"·英雄"
];
gt.Const.Strings.SouthernPrefix <- [
	"南方的",
	"游牧民族",
	"猎奴者的",
	"角斗士的",
	"刺客的",
	"镀金的",
	"Desert",
	"真神的",
	"唯一的",
	"致命",
	"精工锻造的",
	"杰出的",
	"均衡的",
	"历战的",
	"著名的",
	"可靠的",
	"辉煌的",
	"贪婪的",
	"苦涩的",
	"恶名的",
	"精妙的",
	"维齐尔的",
	"超大的",
	"血腥的",
	"残忍的",
	"凶残的",
	"险恶的",
	"残酷的",
	"致命的",
	"不祥的",
	"可怕的",
	"宏伟的",
	"精致的"
];
gt.Const.Strings.SouthernSuffix <- [
	"·南方",
	"·镀金",
	"·沙漠",
	"·沙地",
	"·旭日",
	"·晨光",
	"·绿洲",
	"·星辰",
	"·月亮",
	"·辉煌",
	"·华丽",
	"·净化之火",
	"·神意"
];
gt.Const.Strings.GoblinWeaponPrefix <- [
	"锋锐的",
	"锋利的",
	"尖锐的",
	"刺芒的",
	"倒钩的",
	"尖锐的",
	"狡猾的",
	"背叛的",
	"刺客的",
	"残忍的",
	"背信弃义的",
	"黏糊糊的",
	"卑鄙的",
	"恶毒的"
];
gt.Const.Strings.RandomWeaponPrefix <- [
	"唯一的",
	"致命",
	"精工锻造的",
	"杰出的",
	"均衡的",
	"历战的",
	"阴寒的",
	"佣兵的",
	"著名的",
	"可靠的",
	"冠军勇士的",
	"身经百战的",
	"北方的",
	"掠袭者的",
	"无名英雄的",
	"辉煌的",
	"贪婪的",
	"苦涩的",
	"恶名的",
	"精妙的",
	"超大的",
	"血腥的",
	"残忍的",
	"致死的",
	"凶残的",
	"险恶的",
	"野蛮的",
	"残酷的",
	"致命的",
	"不祥的",
	"恶心的",
	"可怕的",
	"宏伟的",
	"精致的"
];
gt.Const.Strings.RandomArmorPrefix <- [
	"队长的",
	"杰出的",
	"精工锻造的",
	"结实的",
	"老兵的",
	"大师打造的",
	"坚定的",
	"铁卫的",
	"著名的",
	"恶名的",
	"雇佣兵的",
	"灰狼的",
	"遗产·",
	"战痕累累的",
	"佣兵的",
	"不灭的",
	"牢固的",
	"桀骜的",
	"可靠的",
	"冠军勇士的",
	"唯一的",
	"辉煌的",
	"精妙的",
	"尊贵的",
	"卓越的",
	"威严的",
	"庄严的",
	"高贵的",
	"崇高的",
	"庄重的",
	"绝妙的",
	"不朽的",
	"闪亮的"
];
gt.Const.Strings.RandomShieldPrefix <- [
	"唯一的",
	"结实的",
	"杰出的",
	"坚定的",
	"坚不可摧的",
	"身经百战的",
	"久经沙场的",
	"坚定的",
	"著名的",
	"不可逾越的",
	"辉煌的",
	"沉重的",
	"粗野的",
	"坚硬的",
	"顽强的",
	"防爆的",
	"不可动摇的",
	"不毁的",
	"冰冷的",
	"不折的",
	"巍然屹立的"
];
gt.Const.Strings.WardogNames <- [
	"巴尔",
	"布洛克",
	"贝恩",
	"公爵",
	"尖牙",
	"海德",
	"壮壮",
	"幽灵",
	"戈隆德",
	"疾风",
	"巴拉格",
	"布拉森",
	"布雷泽",
	"小骨头",
	"布兰特",
	"阿咆",
	"德雷克",
	"芬奇",
	"贼鸥",
	"咬咬",
	"塔尔",
	"伯爵",
	"浮士德",
	"饭桶",
	"跑跑",
	"抹布",
	"奥诺夫",
	"银灰",
	"国王",
	"狼",
	"猎犬",
	"笨狗",
	"棘刺",
	"利特尔",
	"维格",
	"格斗家",
	"大人",
	"卡西欧",
	"爪爪",
	"拉什",
	"大头",
	"瘦仔",
	"尖刺",
	"灰牙",
	"精神",
	"谢弗",
	"嚎叫者",
	"神行",
	"库丘",
	"响尾",
	"哈兹",
	"阿虚",
	"枯牙",
	"奥马罗格",
	"格瑞兹",
	"长牙",
	"大嘴",
	"红牙",
	"奥格瑞姆",
	"毒刃",
	"鲷鱼",
	"捉猫犬",
	"迅爪",
	"凤尾"
];
