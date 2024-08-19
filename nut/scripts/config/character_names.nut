local gt = this.getroottable();

if (!("Strings" in gt.Const))
{
	gt.Const.Strings <- {};
}

gt.Const.Strings.CharacterNames <- [
	"西古德",
	"齐格弗里德",
	"希尔马",
	"哈拉尔德",
	"西格博德",
	"西格瓦尔德",
	"乌弗尔特",
	"卡勒",
	"伊斯本",
	"哈根",
	"埃瓦尔德",
	"维泽尔",
	"温纳尔",
	"巩特尔",
	"伊瓦尔",
	"嘉诺德",
	"博泰尔",
	"伊戈尔夫",
	"维迪坎德",
	"伊贡",
	"卡齐米尔",
	"海德利奇",
	"弗里德利奇",
	"温道尔",
	"哈索",
	"威尔瑞奇",
	"汉斯",
	"托尔海姆",
	"弗里茨",
	"玛提斯",
	"比尔克",
	"艾诺德",
	"克努特",
	"阿德尔",
	"尼尔斯",
	"艾莫尔",
	"乌弗尔特",
	"杰斯特",
	"托斯提格",
	"波特拉姆",
	"艾博尔奇特",
	"孔诺尔德",
	"巴拉德摩尔",
	"迪尔特玛",
	"登博特",
	"埃尔文",
	"卡斯帕尔",
	"埃诺恩",
	"艾德穆德",
	"库尼尔波特",
	"阿诺尔夫",
	"艾多德",
	"梅因诺夫",
	"奥斯卡尔",
	"吉塞尔赫尔",
	"雷马尔",
	"韦恩哈德",
	"文德尔",
	"伍尼尔",
	"维嘉拉德",
	"维尔埃博拉德",
	"比亚内",
	"亨瑞克",
	"卢瑟德",
	"阿历克",
	"休伯特",
	"厄恩斯特",
	"鲁道夫",
	"哈特伯特",
	"艾思格",
	"霍里克",
	"康拉德",
	"格哈德",
	"汉克",
	"圭多",
	"提尔",
	"杰洛特",
	"哈特维格",
	"托尔本",
	"吉斯贝特",
	"布鲁诺",
	"威格马",
	"特弗里德",
	"哈康",
	"高斯温",
	"冈特伯特",
	"埃克伯特",
	"罗杰",
	"格伯哈德",
	"拉尔夫",
	"伯弗里德",
	"冈特拉姆",
	"费迪南德",
	"莱昂哈德",
	"格拉赫",
	"海尔默",
	"古斯塔夫",
	"杰罗尔德",
	"杰罗",
	"格拉尔夫",
	"埃梅里希",
	"卡尔",
	"德克",
	"法尔克",
	"安塞尔姆",
	"迪特黑尔姆",
	"阿尔瓦",
	"布雷希特",
	"威廉",
	"希尔德",
	"埃里克",
	"托伊多巴尔德",
	"哈瓦德",
	"哈康",
	"沃尔夫冈",
	"埃尔林",
	"科里",
	"兰道夫",
	"罗洛",
	"莱夫",
	"拉尔斯",
	"托尔斯",
	"英格玛",
	"阿斯布约恩",
	"斯泰纳尔",
	"雷恩哈特",
	"巴尔杜尔",
	"奥拉夫",
	"埃吉尔",
	"马格努斯",
	"冈纳",
	"斯韦恩",
	"卡斯腾",
	"欧根",
	"安东",
	"托瓦尔",
	"伯恩哈德",
	"埃纳",
	"莱贝雷希特",
	"朗纳",
	"奥特玛",
	"奥特温",
	"巴隆",
	"埃伯罗德",
	"博特温",
	"奥斯瓦尔德",
	"拉贝",
	"雷蒙德",
	"沃尔夫",
	"埃伯哈德",
	"格里姆沃德",
	"雨果",
	"哈尔斯坦",
	"赫弗里奇",
	"哈里伯特",
	"巴尔杜",
	"瓦尔德马尔",
	"恩格尔伯特",
	"托比约恩",
	"埃兰",
	"托克尔",
	"霍斯特",
	"托里斯蒙德",
	"托莱夫",
	"埃哈德",
	"乌尔夫",
	"奥托",
	"赫尔曼",
	"海因里希",
	"霍尔斯",
	"提尔蒙德",
	"阿尔弗盖尔",
	"索雷尔",
	"哈特穆特",
	"洛塔尔",
	"曼弗雷德",
	"赖因霍尔德",
	"艾尔弗雷德",
	"迪特里希",
	"鲁伯特",
	"海姆拉德",
	"西格马尔",
	"弗里索",
	"兰德里奇",
	"莱恩哈德",
	"西格蒙德",
	"莱因哈特",
	"库尔特",
	"博多",
	"沃尔马",
	"利布文",
	"迪特尔",
	"乌尔里希",
	"艾克",
	"瓦拉姆",
	"马尔特",
	"格里马尔德",
	"伯托德",
	"阿尔伯里希",
	"拉邦",
	"鲁莫尔德",
	"维托尔德",
	"沃尔克",
	"伏尔喀特",
	"贝尔托夫",
	"沃尔特",
	"奥尔蒙",
	"亨伯特",
	"阿德尔马",
	"康拉德",
	"赫尔诺特",
	"拉都夫",
	"卢多尔夫",
	"吉塞尔赫",
	"阿德尔伯特",
	"耶尔马",
	"赖纳",
	"布卡德",
	"温里奇",
	"维尔德里希",
	"威尔弗里德",
	"罗伯特",
	"沃尔夫拉姆",
	"雷蒙德",
	"蒂尔曼",
	"诺尔曼",
	"卢德格尔",
	"阿尔文",
	"马克沃德",
	"马科尔夫",
	"哈德布兰德",
	"罗德里克",
	"兰伯特",
	"迈因拉德"
];
gt.Const.Strings.CharacterNamesFemale <- [
	"英格丽",
	"赫尔加",
	"厄尔马",
	"阿德拉",
	"比伊特",
	"伯莎",
	"博格希尔",
	"布伦希尔德",
	"弗里达",
	"古德兰",
	"希尔达",
	"西格里德",
	"玛蒂尔达",
	"杰希尔德"
];
gt.Const.Strings.BarbarianNames <- [
	"斯穆德",
	"赫古尔德",
	"布劳姆",
	"格里姆内",
	"哈里夫",
	"斯卡德拉格",
	"许勒",
	"格鲁德",
	"阿斯贝克",
	"伊德",
	"布兰德",
	"奥布伦",
	"约尔马",
	"约尔图尔",
	"乔特纳",
	"胡格尔",
	"埃里克",
	"哈夫古法",
	"瓦埃蒂尔",
	"弗鲁克",
	"洛基",
	"兰格瓦尔德",
	"赫尔海默",
	"布罗库尔",
	"洛克",
	"胡里克",
	"斯卡布兰德",
	"西格巴尔"
];
gt.Const.Strings.BarbarianTitles <- [
	"·杀手",
	"·毁灭者",
	"·掠袭者",
	"掠夺者",
	"征服者",
	"·杀手",
	"玷污者",
	"·掠夺者",
	"·恫吓",
	"·猎头者",
	"·掠袭者",
	"碎颅者",
	"碎骨者",
	"屠宰者",
	"·神选者",
	"战裔",
	"铁汉",
	"·染血者",
	"·猛兽",
	"猛兽",
	"·狼爪",
	"·野蛮人",
	"·血书",
	"·粉碎者",
	"·永生者"
];
gt.Const.Strings.SouthernNames <- [
	"哲米勒",
	"乌斯曼",
	"赛义德",
	"拉德万",
	"叶齐德",
	"萨希尔",
	"瓦希卜",
	"阿米拉",
	"阿斯拉姆",
	"阿提克",
	"萨丹",
	"艾曼",
	"哈坎",
	"哈法斯",
	"萨瓦尔",
	"舒亚卜",
	"哈桑",
	"哈姆敦",
	"艾舒恩",
	"贾比尔",
	"祖赫里",
	"吉弗里",
	"加利卜",
	"塔米姆",
	"贾库巴",
	"扎瓦希尔",
	"舒里德",
	"瓦利德",
	"穆萨",
	"阿拜德",
	"哈拉德",
	"塔里克",
	"瓦西",
	"法里斯",
	"阿巴尼",
	"穆塔",
	"乌斯曼",
	"塔米姆",
	"塔维德",
	"扎希里",
	"米拉德",
	"努哈",
	"阿卜达里",
	"朱奈德",
	"马利克",
	"纳赛尔",
	"贾哈夫",
	"亚齐尔",
	"塔尔哈",
	"萨卜提",
	"哈伦",
	"菲里",
	"拉希德",
	"哈姆丁",
	"拉西勒",
	"哈扬",
	"阿斯卡里",
	"巴尔库德",
	"胡斯尼",
	"奥马尔"
];
gt.Const.Strings.SouthernNamesLast <- [
	"伊本·塞赫尔",
	"阿尔·达尼",
	"伊本·塔伊卜",
	"阿尔·萨赫尔",
	"伊本·哈扎姆",
	"伊本·贾拉夫",
	"伊本·阿巴德",
	"阿尔·塔希尔",
	"阿尔·巴贾尼",
	"伊本·努萨",
	"阿尔·法里斯",
	"阿尔·瓦希里",
	"伊本·努哈",
	"阿尔·卡西姆",
	"伊本·侯赛因",
	"伊本·凯马勒",
	"阿尔·法德",
	"阿尔·巴吉",
	"阿尔·阿班",
	"阿尔·萨拉玛",
	"阿尔·哈达德",
	"阿尔·阿凡",
	"阿尔·巴克尔",
	"伊本·塔素福",
	"阿尔·法拉迪",
	"伊本·塔伊卜",
	"伊本·阿齐德",
	"伊本·瓦西阿",
	"阿尔·阿巴斯",
	"伊本·哈姆迪",
	"阿尔·巴赫里",
	"阿尔·扎希尔",
	"伊本·萨拉尔",
	"阿尔·萨维德",
	"伊本·哈姆丁",
	"伊本·安迪",
	"伊本·阿西里",
	"阿尔·塔巴尔",
	"阿尔·伦迪",
	"阿尔·西迪克",
	"伊本·萨卜提",
	"阿尔·法特",
	"伊本·曼苏尔",
	"阿尔·萨巴格",
	"阿尔·贝纳利",
	"阿尔·阿齐兹",
	"伊本·贾西卜"
];
gt.Const.Strings.SouthernOfficerTitles <- [
	"阿尔·贾瓦勒",
	"阿尔·塔拉曼齐",
	"阿尔·穆迪尔",
	"阿尔·贾苏尔·伊本·塔瓦德",
	"阿尔·贾塔米",
	"阿尔·哈伦",
	"阿尔·巴迪尔",
	"阿尔·马图里迪",
	"阿尔·穆哈里卜",
	"阿尔·塔拉布卢西·伊本·阿斯巴特",
	"阿尔·塔素芬·伊本·哈比卜",
	"伊本·扎义德",
	"伊本·阿斯马利",
	"伊本·易卜拉欣",
	"伊本·苏哈利"
];
gt.Const.Strings.GladiatorTitles <- [
	"斗士",
	"·竞技场之王",
	"无情的",
	"·猎头者",
	"·无双",
	"未尝一败",
	"·残暴者",
	"·黑马",
	"奴隶",
	"·雄狮",
	"·鬣狗",
	"·胜利者",
	"志愿者",
	"·屠夫",
	"·冠军勇士",
	"·角斗士",
	"种马",
	"·猛兽",
	"·奇迹",
	"·疯牛",
	"·雷鸣",
	"铁锤",
	"·毁灭者",
	"·穿刺者"
];
gt.Const.Strings.NomadChampionTitles <- [
	"·毒蝎",
	"·沙灵",
	"·大蛇",
	"·疫病",
	"·银棍",
	"·沙漠王子",
	"·莫测",
	"·暗影",
	"·抢掠者",
	"·强盗",
	"游牧国王",
	"·沙贼",
	"·商人之祸",
	"·沙漠之鼠",
	"黑牙",
	"蛇",
	"·沙漠掠袭者",
	"·天灾",
	"·诅咒",
	"·乌鸦",
	"游牧民",
	"·猩红",
	"·镀金者之选",
	"·沙蝰蛇",
	"朝圣者",
	"流放者",
	"·秃鹫",
	"·活蜃景",
	"·自由王子",
	"·沙之王子",
	"·尘埃舞者",
	"·金雕"
];
gt.Const.Strings.NomadChampionStandalone <- [
	"毒蝎",
	"沙之幽灵",
	"大蛇",
	"疫病",
	"银棍",
	"沙漠王子",
	"行踪莫测",
	"暗影",
	"抢掠者",
	"强盗",
	"游牧国王",
	"沙贼",
	"商人之祸",
	"沙漠之鼠",
	"黑牙",
	"蛇",
	"沙漠掠袭者",
	"天灾",
	"被诅咒的人",
	"乌鸦",
	"游牧民",
	"红色",
	"流放者",
	"秃鹫",
	"活蜃景",
	"自由王子",
	"沙之王子",
	"尘埃舞者",
	"金雕"
];
gt.Const.Strings.DesertDevilChampionTitles <- [
	"毒蝎",
	"沙之幽灵",
	"毒蛇%randomsouthernname%",
	"剑圣%randomsouthernname%",
	"沙漠恶魔%randomsouthernname%",
	"善变者%randomsouthernname%",
	"暗影%randomsouthernname%",
	"%randomsouthernname%·蛇",
	"旋风",
	"沙魔",
	"蝮蛇%randomsouthernname%",
	"流放者%randomsouthernname%",
	"剑舞者%randomsouthernname%",
	"迅捷者%randomsouthernname%",
	"不败者%randomsouthernname%",
	"尘舞者%randomsouthernname%",
	"闪烁之刃%randomsouthernname%",
	"血刃%randomsouthernname%",
	"飞刃%randomsouthernname%",
	"尘魔%randomsouthernname%",
	"劲风",
	"黑鹰"
];
gt.Const.Strings.ExecutionerChampionTitles <- [
	"刽子手",
	"银棍",
	"抢掠者",
	"商人之祸",
	"天灾",
	"被诅咒的人",
	"沙巨人",
	"镀金者之选",
	"大山",
	"弯刀",
	"金镀者%randomsouthernname%",
	"狂暴游牧者",
	"不朽者%randomsouthernname%",
	"头骨收集者",
	"巨人",
	"巨石",
	"沙尘暴",
	"碎头机",
	"伊夫利特",
	"雄狮%randomsouthernname%"
];
gt.Const.Strings.DesertStalkerChampionTitles <- [
	"·毒蝎",
	"·沙之追猎者",
	"沙漠追猎者",
	"·老鹰",
	"·乌鸦",
	"·鹰",
	"死亡追踪者",
	"·射手大师",
	"·猎人",
	"·猎头者",
	"·沙蝰蛇",
	"·光线",
	"·镀金者之手",
	"隼目",
	"·秃鹫",
	"·大蛇",
	"·毒刺",
	"·猎心者"
];
gt.Const.Strings.NobleTitles <- [
	"伯爵",
	"伯爵",
	"男爵",
	"男爵",
	"公爵"
];
gt.Const.Strings.VizierTitles <- [
	"战争维齐尔",
	"财政维齐尔",
	"贸易维齐尔",
	"大维齐尔",
	"主占星师",
	"大祭司"
];
gt.Const.Strings.SellswordTitles <- [
	"·屠夫",
	"·狂战士",
	"狗",
	"猎犬",
	"·血腥",
	"·狼",
	"·刀锋",
	"·穿刺者",
	"年轻的",
	"年长者",
	"无情的",
	"·猩红",
	"·黑皮",
	"兽人杀手",
	"·骑士杀手",
	"猎鹰"
];
gt.Const.Strings.SwordmasterTitles <- [
	"·传奇",
	"·大师",
	"·击剑手",
	"·神速",
	"快刀",
	"·大蛇",
	"·迅捷",
	"刀锋舞者",
	"未尝一败",
	"不败",
	"·冠军勇士",
	"·王国之主",
	"·长者",
	"·无双",
	"巧手",
	"·飞刃",
	"·翻飞刃"
];
gt.Const.Strings.HedgeKnightTitles <- [
	"独狼",
	"恶狼",
	"猎犬",
	"执钢者",
	"杀手",
	"巨人",
	"大山",
	"玷污者",
	"骑士杀手",
	"雇佣骑士",
	"天灾",
	"堕落骑士",
	"冲撞者",
	"流放者",
	"战嚎",
	"猎头者",
	"剁肉者"
];
gt.Const.Strings.MasterArcherNames <- [
	"神射手%randomname%",
	"泰然之箭",
	"射手大师%randomname%",
	"猎人%randomname%",
	"狙击手%randomname%",
	"百步穿杨",
	"速射手%randomname%",
	"猎头者%randomname%",
	"死神之眼",
	"神射手%randomname%",
	"射手%randomname%",
	"%randomname%·羽绘",
	"%randomname%·破空之死",
	"戳刺者%randomname%",
	"鹰眼",
	"%randomname%·结实一击",
	"%randomname%·结实一射"
];
gt.Const.Strings.OathbringerNames <- [
	"守誓者",
	"守誓者%randomname%",
	"安瑟姆之锤",
	"安瑟姆之盾",
	"安瑟姆之剑",
	"冒牌安瑟姆",
	"缚誓者%randomname%",
	"十字军%randomname%",
	"狂信者%randomname%",
	"虔诚者%randomname%",
	"忠诚的%randomname%",
	"圣骑士%randomname%",
	"正义者%randomname%"
];
gt.Const.Strings.MasonTitles <- [
	"奠基者",
	"泥瓦匠",
	"建筑师",
	"匠人"
];
gt.Const.Strings.MilitiaTitles <- [
	"征召兵",
	"民兵",
	"步兵"
];
gt.Const.Strings.BrawlerTitles <- [
	"大拳头",
	"拳击手",
	"岩石",
	"种马",
	"铁颌",
	"打手"
];
gt.Const.Strings.PeddlerTitles <- [
	"蛇",
	"黄鼠狼",
	"银舌",
	"随军小贩",
	"小贩",
	"商人"
];
gt.Const.Strings.WitchhunterTitles <- [
	"夜猎者",
	"女巫猎人",
	"驱魔师",
	"折磨者"
];
gt.Const.Strings.GravediggerTitles <- [
	"掘墓人",
	"铲工",
	"寻墓者",
	"怪人"
];
gt.Const.Strings.RatcatcherTitles <- [
	"长鼻",
	"鼠",
	"捕鼠者",
	"冷落者"
];
gt.Const.Strings.BastardTitles <- [
	"私生子",
	"过错",
	"绿帽子",
	"隐子",
	"野种",
	"污点"
];
gt.Const.Strings.PilgrimTitles <- [
	"信徒",
	"探求者",
	"奇术士",
	"纯净",
	"苦修者",
	"朝圣者"
];
gt.Const.Strings.KnightNames <- [
	"罗德里克爵士",
	"埃吉迪乌斯爵士",
	"亨利克爵士",
	"丹克沃特爵士",
	"艾森豪兹爵士",
	"杰弗拉姆爵士",
	"巴拉诺爵士",
	"威廉爵士",
	"希尔德布兰德爵士",
	"希尔马爵士",
	"塞维林爵士",
	"斯塔克沃特爵士",
	"埃尔加斯特爵士",
	"马格纳斯爵士",
	"伯克哈德爵士",
	"西尔万爵士",
	"兰伯特爵士",
	"库诺爵士",
	"文策尔爵士",
	"多纳特爵士",
	"阿尔布雷希特爵士",
	"希尔德里奇爵士",
	"西格蒙德爵士",
	"斯坦哈特爵士",
	"赫尔曼爵士",
	"埃克哈特爵士",
	"吉多巴德爵士",
	"西奥爵士",
	"埃斯维格爵士",
	"瓦拉姆爵士",
	"卡西米尔爵士",
	"马格纳斯爵士",
	"怀特爵士",
	"奥托爵士",
	"西格蒙德爵士",
	"厄兰爵士",
	"埃尔肯布兰德爵士",
	"西奥德里奇爵士",
	"洛塔尔爵士",
	"沃尔夫哈特爵士",
	"巴伦爵士",
	"瓦尔德玛爵士",
	"吉塞尔赫尔爵士",
	"恩格尔伯特爵士",
	"兰塞尔爵士",
	"亨伯特爵士",
	"埃梅里希爵士",
	"格林爵士",
	"唐伯特爵士",
	"罗伯特爵士",
	"沃尔夫冈爵士",
	"提莫爵士",
	"康拉德爵士",
	"鲁伯特爵士",
	"哈拉尔德爵士",
	"罗兰爵士",
	"拉贝爵士",
	"齐格弗里德爵士",
	"库尼伯特爵士",
	"丹克拉德爵士",
	"莱贝雷希特爵士"
];
gt.Const.Strings.OrcWarlordNames <- [
	"伊尔斯卡古尔",
	"斯卡布斯卡",
	"乌罗斯",
	"库什特鲁姆",
	"哥斯纳里",
	"奥布罗克",
	"布洛克萨帕特",
	"哥拉什",
	"莫格图",
	"索克塔",
	"戈尔加什古尔",
	"马鲁克",
	"瓦拉克纳波拉什",
	"乌尔加特",
	"德加什",
	"斯卡尔克尔夫塔",
	"马尔加什波拉什",
	"博格什",
	"戈鲁克萨帕特",
	"卡洛什乌尔加特",
	"霍加斯古尔",
	"纳古克",
	"沙多克",
	"巴赫洛布",
	"科尔盖特",
	"乌鲁木克古尔",
	"马格纳达尔",
	"弗拉斯乌斯塔",
	"布鲁克佐格塔",
	"萨帕特布洛克",
	"摩西沙基",
	"加吉特布科尔",
	"印迹卡库克",
	"塔拉克塔伦",
	"德罗喀赞",
	"奥克斯哈克",
	"乌丹诺格",
	"特洛克奥博尔",
	"博尔瓦格什鲁布",
	"厄煞塔普",
	"煞特罗托革",
	"博鲁克斯卡格",
	"伊尔斯卡萨帕特",
	"格鲁扎尔图姆",
	"格罗姆克",
	"奥格鲁",
	"舒拉纳克"
];
gt.Const.Strings.BanditLeaderNames <- [
	"屠夫",
	"尖刀%randomname%",
	"屠戮者%randomname%",
	"国王%randomname%",
	"壮牛%randomname%",
	"恶狼",
	"掳掠者%randomname%",
	"毒蛇%randomname%",
	"四指%randomname%",
	"硫磺石巴拉巴斯",
	"鸦黑罗托尔",
	"黑乌鸦巴尔塔扎",
	"%randomtown%的悍牛",
	"%randomname%·血髯",
	"蜜酒罐%randomname%",
	"%randomname%·淋血",
	"可怕的%randomname%",
	"猪猡",
	"心狠手辣%randomname%",
	"流放者%randomname%",
	"强盗男爵",
	"红蝰蛇",
	"强盗%randomname%",
	"天灾%randomname%",
	"掠夺之王",
	"猎奴者",
	"大个儿%randomname%",
	"野蛮人%randomname%",
	"恶名遍地%randomname%",
	"%randomtown%之害",
	"猩红的%randomname%",
	"咧嘴巩特尔",
	"鬣狗%randomname%",
	"秃鹰%randomname%",
	"疯子%randomname%",
	"残忍者%randomname%",
	"掠夺者%randomname%",
	"疯子拉尔斯",
	"逍遥法外%randomname%",
	"黑眼艾因哈特",
	"怪人奥斯瓦尔",
	"布罗喀·疯眼",
	"灰烬王子%randomname%",
	"%randomtown%的灾祸",
	"%randomname%·凄荒",
	"阴寒刀锋英格拉姆",
	"扒手%randomname%",
	"铁石心肠米克尔",
	"卡斯珀·掏包儿",
	"奥泰尔·暗心",
	"克朗掳手乔斯特",
	"无齿的巴尔塔萨",
	"蜘蛛沃尔特",
	"掘墓人奥古斯都",
	"市井豪徒"
];
gt.Const.Strings.KrakenNames <- [
	"大噬者奥格·萨托斯",
	"毁灭者卡·阿斯鲁",
	"不朽者沙加鲁斯",
	"无尽之喉喀欧斯",
	"千臂乱舞者古·绍革",
	"万物吞食者赫坦·纳希提",
	"世界吞噬者扎·舒塔尔",
	"万物终结托霍乔斯",
	"永恒者纳克拉斯",
	"无所不在哈珀克瑟鲁"
];
gt.Const.Strings.AncientDeadNames <- [
	"布拉索斯",
	"古迪拉",
	"奥斯特拉孔",
	"达达诺斯",
	"杜拉斯",
	"穆卡特拉",
	"科特拉斯",
	"阿扎鲁",
	"德卡洛斯",
	"阿卡玛斯",
	"卡瓦罗斯",
	"科摩西乌斯",
	"莫斯孔",
	"罗洛斯",
	"塔尔布斯",
	"阿普隆",
	"纳普孔",
	"巴尔索比斯",
	"塞卢斯",
	"马尔尼斯",
	"布罗斯",
	"特勒甫斯",
	"特雷沃斯",
	"达玛斯特斯",
	"梅格拉斯",
	"伊阿诺顿",
	"库里诺斯",
	"哈加农",
	"涅里托斯",
	"塞琉古斯",
	"诺米翁",
	"巴克诺尔",
	"卡斯特翁",
	"厄尔皮达斯",
	"阿里斯提斯",
	"莫尔西穆斯",
	"阿铁纳迭斯",
	"巴丘斯"
];
gt.Const.Strings.AncientDeadTitles <- [
	"·死而复生",
	"·回魂者",
	"·古人",
	"·毁灭者",
	"·守护者",
	"·猎人",
	"二世",
	"·使者",
	"·破土",
	"·被遗忘者",
	"·捍卫者",
	"·荣耀",
	"·护卫者",
	"·朔来",
	"·荣耀",
	"·受宠者"
];
gt.Const.Strings.GoblinNames <- [
	"诺克斯",
	"格鲁布",
	"沙拉克斯",
	"祖古特",
	"格里斯尼克",
	"扎塔克",
	"芬克斯",
	"祖塔克尔",
	"维洛克",
	"扎托克斯",
	"纳克尼克斯",
	"维利希克斯",
	"斯纳夫",
	"拉托克斯",
	"斯克罗克",
	"乌鲁扎克",
	"德罗祖布",
	"佐格罗克",
	"库尔齐克",
	"沙托克斯",
	"维库兹",
	"卡拉克斯",
	"德鲁克祖格",
	"塞戈克斯",
	"斯鲁兹",
	"德鲁特诺",
	"诺扎克",
	"雷克",
	"扎图什",
	"克莱克卢克斯"
];
gt.Const.Strings.GoblinTitles <- [
	"·戳刺者",
	"·伏击者",
	"割喉者",
	"舐刃者",
	"·剥皮者",
	"·猎头者",
	"剜眼者",
	"烂肠",
	"长鼻",
	"·剖腹者",
	"啮鼻者",
	"·迅刺",
	"·莫测",
	"·追猎者",
	"·暗影行者",
	"·雾行者",
	"·狡猾",
	"·背刺者",
	"钩刃",
	"腹刺",
	"割耳者",
	"扭颈者",
	"·耍刀者"
];
gt.Const.Strings.FallenHeroTitles <- [
	"·腐朽",
	"·槁葬",
	"·烂人",
	"·污秽者",
	"·死而复生",
	"·不死者",
	"·诅咒",
	"·腐败者",
	"·不破者",
	"·破誓者",
	"·被遗忘者",
	"·迷失者",
	"·堕落英雄",
	"毒手",
	"·死而复生",
	"·堕落王子",
	"·空魂",
	"·幽灵",
	"·失魂",
	"·空壳"
];
gt.Const.Strings.NecromancerNames <- [
	"虫王",
	"不死者%randomname%",
	"%randomname%·黑皮",
	"死灵法师%randomname%",
	"傀儡师",
	"瘟疫使者",
	"黑暗大师",
	"复活者",
	"疯子%randomname%",
	"着魔者%randomname%",
	"苍白公爵",
	"亡灵之主",
	"叛教者%randomname%",
	"博学者%randomname%",
	"%randomname%·虫咬",
	"亵渎者%randomname%",
	"疯子%randomname%",
	"先知%randomname%"
];
