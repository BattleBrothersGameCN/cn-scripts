local gt = this.getroottable();

if (!("Strings" in gt.Const))
{
	gt.Const.Strings <- {
		function getArticle( _object )
		{
			return this.isFirstCharacter(_object, [
				"A",
				"E",
				"I",
				"O",
				"U"
			]) ? "一个" : "一个";
		}

		function getArticleCapitalized( _object )
		{
			return this.isFirstCharacter(_object, [
				"A",
				"E",
				"I",
				"O",
				"U"
			]) ? "一个" : "一个";
		}

	};
}

if (!("Tactical" in gt.Const.Strings))
{
	gt.Const.Strings.Tactical <- {};
}

if (!("World" in gt.Const.Strings))
{
	gt.Const.Strings.World <- {};
}

gt.Const.Strings.Quantity <- [
	"第1",
	"第2",
	"第3",
	"第4",
	"第5",
	"第6",
	"第7",
	"第8",
	"第9",
	"第10",
	"第11",
	"第12",
	"第13",
	"第14",
	"第15",
	"第16",
	"第17",
	"第18",
	"第19",
	"第20"
];
gt.Const.Strings.Amount <- [
	"no",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"10",
	"11",
	"12",
	"13",
	"14",
	"15",
	"16",
	"17",
	"18",
	"19",
	"20",
	"21",
	"22",
	"23",
	"24",
	"25",
	"26",
	"27",
	"28",
	"29",
	"30"
];
gt.Const.Strings.AmountC <- [
	"No",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"10",
	"11",
	"12",
	"13",
	"14",
	"15",
	"16",
	"17",
	"18",
	"19",
	"20",
	"21",
	"22",
	"23",
	"24",
	"25",
	"26",
	"27",
	"28",
	"29",
	"30"
];
gt.Const.Strings.Difficulty <- [
	"初学者",
	"老兵",
	"专家"
];
gt.Const.Strings.EntityName <- [
	"死灵法师",
	"僵尸",
	"盔甲僵尸",
	"堕落英雄",
	"复仇之魂",
	"古代辅军",
	"古代军团",
	"古代仪仗队",
	"古代祭司",
	"征服者",
	"死灵学者",
	"幽灵",
	"食尸鬼",
	"兽人青年",
	"兽人狂战士",
	"兽人战士",
	"兽人军阀",
	"民兵",
	"民兵神射手",
	"民兵老兵",
	"民兵队长",
	"赏金猎人",
	"农民",
	"商队队员",
	"商队卫队",
	"商队运货马车",
	"步兵",
	"双手剑士",
	"钩镰兵",
	"弩手",
	"旗手",
	"军士",
	"骑士",
	"驴",
	"强盗暴徒",
	"强盗偷猎者",
	"强盗神射手",
	"强盗掠袭者",
	"强盗首领",
	"地精伏击者",
	"地精散兵",
	"地精监督者",
	"地精萨满",
	"地精狼骑",
	"狼",
	"战犬",
	"盔甲战犬",
	"雇佣兵",
	"雇佣兵",
	"剑圣",
	"雇佣骑士",
	"弓箭手大师",
	"绿皮投石机",
	"邪教徒",
	"恐狼",
	"林德蠕龙",
	"巨魔",
	"巨魔",
	"巨魔",
	"蛛魔",
	"蛛魔卵",
	"梦魇",
	"女巫",
	"树人",
	"树苗",
	"野人",
	"克拉肯",
	"伊尔利赫特",
	"堕落的背叛者",
	"恶梦",
	"野蛮人奴仆",
	"野蛮人掠夺者",
	"野蛮人神选者",
	"野蛮人鼓手",
	"野蛮兽王",
	"盔甲巨魔",
	"盔甲巨魔",
	"蛮王",
	"战獒",
	"伊吉罗克",
	"狂暴野蛮人",
	"大蛇",
	"伊夫利特",
	"鬣狗",
	"征召兵",
	"炮手",
	"军官",
	"火炮技师",
	"刺客",
	"负债者",
	"角斗士",
	"臼炮",
	"游牧割喉者",
	"游牧亡命徒",
	"游牧投石手",
	"游牧弓箭手",
	"游牧领袖",
	"沙漠追猎者",
	"游牧刽子手",
	"刀锋舞者",
	"市民",
	"博学者",
	"博学者的幻影",
	"护符",
	"失落的宝藏猎人",
	"尖叫骷髅",
	"誓约使者"
];
gt.Const.Strings.EntityNamePlural <- [
	"死灵法师",
	"僵尸",
	"盔甲僵尸",
	"堕落的英雄",
	"复仇之魂",
	"古代辅军",
	"古代军团",
	"古代仪仗队",
	"古代祭司",
	"征服者",
	"死灵学者",
	"幽灵",
	"食尸鬼",
	"兽人青年",
	"兽人狂战士",
	"兽人战士",
	"兽人军阀",
	"民兵",
	"民兵射手",
	"民兵精锐",
	"民兵队长",
	"赏金猎人",
	"农民",
	"商队队员",
	"商队卫队",
	"商队运货马车",
	"步兵",
	"双手剑士",
	"钩镰兵",
	"弩手",
	"旗手",
	"中士",
	"骑士",
	"驴",
	"强盗暴徒",
	"强盗偷猎者",
	"强盗射手",
	"强盗掠袭者",
	"强盗首领",
	"地精伏击者",
	"地精散兵",
	"地精监督者",
	"地精萨满",
	"地精狼骑兵",
	"狼队",
	"战犬",
	"盔甲战犬",
	"雇佣兵",
	"雇佣兵",
	"剑圣",
	"雇佣骑士",
	"弓箭手大师",
	"绿皮投石机",
	"邪教徒",
	"恐狼",
	"林德蠕龙",
	"巨魔",
	"巨魔",
	"巨魔",
	"蛛魔",
	"蛛魔卵",
	"梦魇",
	"女巫",
	"树人",
	"树苗",
	"Wildmen",
	"克拉肯",
	"伊尔利赫特",
	"堕落的背叛者",
	"噩梦",
	"野蛮人奴仆",
	"野蛮人掠夺者",
	"野蛮人神选者",
	"野蛮人鼓手",
	"野蛮人兽王",
	"盔甲巨魔",
	"盔甲巨魔",
	"野蛮人国王",
	"战獒",
	"冬天的野兽",
	"野蛮人狂人",
	"大蛇",
	"伊夫利特",
	"鬣狗",
	"征召兵",
	"枪手",
	"军官",
	"火炮技师",
	"刺客",
	"负债者",
	"角斗士",
	"臼炮",
	"游牧割喉者",
	"游牧亡命徒",
	"游牧投石手",
	"游牧弓箭手",
	"游牧领袖",
	"沙漠追猎者",
	"游牧刽子手",
	"刀锋舞者",
	"市民",
	"博学者",
	"博学者的幻影",
	"护命匣",
	"失落的宝藏猎人",
	"尖啸颅骨",
	"誓约使者"
];
gt.Const.Strings.Tactical.EntityName <- {
	Boulder = "巨石",
	Ruin = "废墟",
	Shrubbery = "灌木",
	Tree = "树",
	Brush = "刷子",
	Cartwheel = "旧车轮",
	RuinedPillar = "毁坏的柱子",
	Cart = "getroottable",
	Donkey = "驴",
	Plant = "植物"
};
gt.Const.Strings.Tactical.EntityDescription <- {
	Boulder = "一块大石头。阻挡移动和视线。",
	Ruin = "很久以前的废墟。",
	Shrubbery = "非常茂密的灌木丛，阻挡移动和视线。",
	Tree = "一棵树干粗壮的大树。",
	TreeSwamp = "这棵树已经腐烂，早已枯死。",
	TreeTrunk = "一棵树干，一半被脏水覆盖。",
	Brush = "非常茂密的灌木丛，阻挡移动和视线。",
	Cartwheel = "牛车的破旧车轮。",
	RuinedPillar = "TODO",
	Cart = "满载贸易商品的运货马车。",
	Donkey = "用来拉重车的驴。",
	Plant = "异域植物，阻挡移动和视线。"
};
gt.Const.Strings.FootprintsType <- [
	"",
	"北方士兵",
	"镀金者的士兵",
	"大篷车",
	"农民",
	"民兵",
	"难民",
	"强盗",
	"亡灵",
	"兽人",
	"地精",
	"野蛮人",
	"游牧民",
	"恐狼",
	"食尸鬼",
	"鬣狗",
	"大蛇",
	"蛛魔",
	"巨魔",
	"梦魇",
	"女巫",
	"树人",
	"克拉肯",
	"伊夫利特",
	"林德蠕龙",
	"雇佣兵"
];
gt.Const.Strings.ShipNames <- [
	"夏日风情号",
	"醉人薄雾号",
	"海啸号",
	"珊礁秘宝号",
	"沙湾号",
	"海之女神号",
	"明珠号",
	"布伦希尔德号",
	"玛蒂尔达号",
	"彗星号",
	"藩王号",
	"荣光之地号",
	"秋风号",
	"庞德梅克号",
	"呼啸号",
	"七星号",
	"黑暗预兆号",
	"和睦号",
	"信天翁号",
	"金马号",
	"海中仙女号",
	"一波三折号",
	"国王之赐号",
	"秃僧号",
	"金日号",
	"浮华号",
	"斗胆号",
	"虎爪号",
	"梧桐号",
	"高贵跑者号",
	"凄凉月光号",
	"族人号",
	"鲸游号",
	"竞速号",
	"墨蚊号",
	"埃纳尔·埃里克森号",
	"林德蠕龙",
	"无上号",
	"狮鹫号",
	"阿克斯福德号",
	"伯莎号",
	"海鸥号",
	"别西卜号"
];
gt.Const.Strings.MercenaryCompanyNames <- [
	"铁鸦",
	"黄金秩序",
	"南方之剑",
	"荒林狼群",
	"黑盾",
	"铁币战团",
	"闲语之剑",
	"呼啸之矢",
	"蓝猪团",
	"獠牙与钱币",
	"红色军团",
	"饿犬团",
	"猩红匕首",
	"君王之末战团",
	"黑色战团",
	"次子团",
	"瓦尔特兄弟会",
	"怨恨使者",
	"伯恩哈德之熊",
	"银爪",
	"钢铁兄弟会",
	"兽人之灾战团",
	"铁盟",
	"不灭三人众",
	"战争之犬",
	"鹰丘军团",
	"自由人",
	"战争之王",
	"北境战团",
	"归还背离者",
	"白色战团",
	"寡妇制造者",
	"冷心战团",
	"燃日战团",
	"天选团",
	"死士团",
	"铜头团",
	"略地之矛",
	"锤之卫士",
	"夺币者",
	"银域战矛",
	"钢铁之约",
	"鲜血之缚",
	"磐岩之障",
	"黎明行者",
	"冬之子",
	"溪流家族战团",
	"燃星战团",
	"大战团",
	"正义掠夺者",
	"被遗忘者旅",
	"战斗之选",
	"和平使者",
	"黑夜之盾",
	"杂种团",
	"白骨守卫",
	"失落军团"
];
gt.Const.Strings.NobleHouseNames <- [
	"格林蒙德",
	"威尔博格",
	"阿姆斯丘",
	"哥达",
	"埃森斯坦",
	"格劳沃尔",
	"拉本霍尔特",
	"萨默温",
	"温特霍尔",
	"鲁姆特",
	"阿德尔赖希",
	"佩罗温格",
	"伊格洛夫",
	"贝伦加尔",
	"冈巴尔德",
	"高斯温",
	"阿德尔海姆",
	"阿蒙德",
	"巴托林",
	"埃伯林",
	"福尔萨赫",
	"赫定",
	"霍恩",
	"尼德加德",
	"罗森文",
	"图拉",
	"卡尔滕伯恩",
	"克里格",
	"斯坦沃尔",
	"哈康",
	"奥斯滕"
];
gt.Const.Strings.CityStateNames <- [
	"达哈卜",
	"卡比拉",
	"拉斯 萨南",
	"坦维尔",
	"阿兹姆 沙布",
	"塔尔瓦",
	"哈基姆 阿尔 拉马尔",
	"卡拉坎",
	"阿尔-哈兹雷德",
	"哈齐夫",
	"夸丁",
	"希克玛",
	"埃尔哈代",
	"阿尔-安瓦尔"
];
gt.Const.Strings.CityStateTitles <- [
	"城邦·",
	"城市·",
	"藩属国·",
	"领地·",
	"大城市·",
	"自由城·",
	"圣城·"
];
gt.Const.Strings.BusinessReputation <- [
	"背信弃义",
	"难担重任",
	"庸庸碌碌",
	"籍籍无名",
	"初露锋芒",
	"言而有信",
	"能担其任",
	"行家里手",
	"声名斐然",
	"家喻户晓",
	"久负盛名",
	"丰功伟绩",
	"留名青史",
	"功高盖世",
	"彪炳千秋",
	"万古流芳"
];
gt.Const.Strings.MoralReputation <- [
	"令人畏惧",
	"狠心辣手",
	"冷酷无情",
	"声名狼藉",
	"中立",
	"中立",
	"亲切友好",
	"救困扶危",
	"骑士精神",
	"在世圣人"
];
gt.Const.Strings.Relations <- [
	"敌对",
	"威胁",
	"不友好",
	"冷淡",
	"中立",
	"中立",
	"开放",
	"友好",
	"非常友好",
	"盟友"
];
gt.Const.Strings.Tactical.TerrainName <- [
	"无",
	"泥路",
	"粘土路",
	"鹅卵石路",
	"草原",
	"泥地",
	"森林",
	"泥泞的地面",
	"草泽",
	"浑浊的水",
	"草地",
	"旱草地",
	"苔原",
	"积雪",
	"浅雪",
	"石头",
	"石头",
	"沙地",
	"浅水"
];
gt.Const.Strings.Tactical.TerrainDescription <- [
	"无",
	"源于人类和动物不断使用的土路。",
	"一条由夯实粘土组成的原始道路。",
	"用于马车和大型车辆的鹅卵石道路。",
	"平坦坚实的地面上长着短草。",
	"裸露而平坦的土地，几乎没有任何植被。",
	"森林地面覆盖着一层又厚又软的苔藓层。",
	"黑暗和泥泞的地面。",
	"大部分坚硬的地面覆盖着又高又软的草。",
	"浅而浑浊的水覆盖着柔软而泥泞的地面。",
	"平坦而坚实的地面覆盖着干枯的草。",
	"坚硬的土块被太阳和热量完全干燥。",
	"平坦而干旱的地面覆盖着粗糙的各色野草。",
	"冰冻的地面覆盖着厚厚的雪层。",
	"冰冻的地面覆盖着一层薄薄的雪。",
	"平整的石头地面提供了良好的立足点。",
	"粗糙的石头地面。",
	"炙热的沙漠沙地。",
	"清澈而浅的水。"
];
gt.Const.Strings.UI <- {
	Introduction = "你沉浸在凉爽的早晨空气中。随着太阳慢慢升起，你生活中的新篇章也开始了。经过多年为微薄的薪水而血腥杀戮，你已经攒够了足够的钱来创办自己的雇佣兵公司。和你在一起的是%allbrothers%，你曾在盾墙中并肩作战。你现在是他们的指挥官，%companyname% 的领导者。\n\n当你在这片土地上旅行时，你应该在村庄和城市雇佣新的人来填补你的队伍。许多提供服务的人以前从未拿起过真正的武器。也许他们绝望了，也许他们贪婪地快速获得战利品。他们中的大多数会死在战场上。但不要气馁。这就是佣兵的生活，下一个村庄总会有新人热切地寻找新的生活开始。\n\n现在的土地很危险。强盗和掠夺者埋伏在路边，野兽在黑暗的森林中游荡，兽人部落在东部的沼泽中躁动不安。甚至有传言说黑魔法在起作用，死者从坟墓中复活并再次行走。有很多赚钱的机会，无论是通过在全国各地的村庄、城市和要塞中找到的合同，还是通过自己冒险去探索和袭击。\n\n你的手下期待着你下达命令。他们现在为 %companyname% 生死存亡。\n\n[color=#bd9d71]早期访问免责声明：此版本仍在大量工作中，并不代表产品的最终质量。功能可能不完整或缺失，UI 尚未剥皮，会有错误，经济、资源和敌人的平衡和进展可能需要调整，有时可能太具有挑战性或太容易。抢先体验期间将添加许多额外内容，包括更多敌人、物品、合同、地形类型、独特位置、故事事件和其他功能。[/color]",
	FleeDialogueConsequences = "所谓留得青山在，不怕没柴烧，有时战术撤退或许是更好的选择。你的人会自行尝试到达地图的边缘，安全撤退。但是，他们也可能被敌人追上，已经陷入近战中的人未必能做到毫发无损，甚至没法活着离开。",
	RetreatDialogueConsequences = "敌人被击溃和打败。那些少数还活着的人向四面八方散去。你是要追踪他们夺取他们的头颅和财物，还是宣布战斗已经赢了呢？"
};
gt.Const.Strings.AlpStateName <- [
	"",
	"在梦中若隐若现",
	"在梦中若隐若现",
	"在梦中清晰可见",
	"在梦中清晰可见"
];
gt.Const.Strings.BodyPartName <- [
	"body",
	"head"
];
gt.Const.Strings.ItemSlotName <- [
	"身体",
	"头",
	"主手",
	"副手",
	"配饰",
	"背包"
];
gt.Const.Strings.World.TimeOfDay <- [
	"黎明",
	"早晨",
	"中午",
	"下午",
	"傍晚",
	"黄昏",
	"夜晚",
	"黎明"
];
gt.Const.Strings.Direction <- [
	"[color=#ffff00]北[/color]",
	"[color=#ffff00]东北[/color]",
	"[color=#ffff00]东南[/color]",
	"[color=#ffff00]南[/color]",
	"[color=#ffff00]西南[/color]",
	"[color=#ffff00]西北[/color]",
	"<未定义>"
];
gt.Const.Strings.Direction8 <- [
	"[color=#ffff00]北[/color]",
	"[color=#ffff00]东北[/color]",
	"[color=#ffff00]东[/color]",
	"[color=#ffff00]东南[/color]",
	"[color=#ffff00]南[/color]",
	"[color=#ffff00]西南[/color]",
	"[color=#ffff00]西[/color]",
	"[color=#ffff00]西北[/color]"
];
gt.Const.Strings.Terrain <- [
	"",
	"[color=#ff0000]海洋里[/color]",
	"[color=#ff0000]平原上[/color]",
	"[color=#ff0000]沼泽里[/color]",
	"[color=#ff0000]小山上[/color]",
	"[color=#ff0000]森林里[/color]",
	"[color=#ff0000]森林里[/color]",
	"[color=#ff0000]森林里[/color]",
	"[color=#ff0000]森林里[/color]",
	"[color=#ff0000]山脊间[/color]",
	"",
	"",
	"[color=#ff0000]雪地里[/color]",
	"[color=#ff0000]荒原里[/color]",
	"[color=#ff0000]苔原上[/color]",
	"[color=#ff0000]草原里[/color]",
	"[color=#ff0000]岸边[/color]",
	"[color=#ff0000]沙漠里[/color]",
	"[color=#ff0000]湿地里[/color]"
];
gt.Const.Strings.TerrainAlternative <- [
	"",
	"",
	"[color=#ff0000]平原上[/color]",
	"[color=#ff0000]沼泽里[/color]",
	"[color=#ff0000]小山上[/color]",
	"[color=#ff0000]森林里[/color]",
	"[color=#ff0000]森林里[/color]",
	"[color=#ff0000]森林里[/color]",
	"[color=#ff0000]森林里[/color]",
	"[color=#ff0000]山脊间[/color]",
	"[color=#ff0000]平原上[/color]",
	"[color=#ff0000]平原上[/color]",
	"[color=#ff0000]雪地里[/color]",
	"",
	"[color=#ff0000]苔原上[/color]",
	"[color=#ff0000]草原里[/color]",
	"",
	"[color=#ff0000]沙漠里[/color]",
	"[color=#ff0000]湿地里[/color]"
];
gt.Const.Strings.TerrainShort <- [
	"",
	"[color=#ff0000]海湾[/color]",
	"[color=#ff0000]平原[/color]",
	"[color=#ff0000]沼泽[/color]",
	"[color=#ff0000]山丘[/color]",
	"[color=#ff0000]森林[/color]",
	"[color=#ff0000]森林[/color]",
	"[color=#ff0000]森林[/color]",
	"[color=#ff0000]森林[/color]",
	"[color=#ff0000]高山[/color]",
	"",
	"",
	"[color=#ff0000]雪地[/color]",
	"[color=#ff0000]荒原[/color]",
	"[color=#ff0000]苔原[/color]",
	"[color=#ff0000]草原[/color]",
	"[color=#ff0000]水岸[/color]",
	"",
	"[color=#ff0000]沙漠[/color]",
	"[color=#ff0000]山丘[/color]",
	"[color=#ff0000]湿地[/color]"
];
gt.Const.Strings.TerrainRegionNames <- [
	[],
	[
		"暴风海",
		"克拉肯之匿",
		"白驹海",
		"千鸥海",
		"无底渊",
		"常雨洋",
		"无垠之海",
		"狂澜洋",
		"雷鸣海",
		"浩海",
		"汹涌海",
		"珍珠海",
		"呼嚎海",
		"冷厉海",
		"拱潮洋",
		"轻涛海",
		"柔波海",
		"碧绿海",
		"回潮海",
		"哀泣洋",
		"泡沫涂",
		"暗潮海",
		"无垠水光",
		"无垠碧波",
		"怒涛湾",
		"粼波渊"
	],
	[
		"行商途",
		"车前原",
		"平原郊",
		"美酒原",
		"低地",
		"风袭之地",
		"阔望原",
		"碧蓝域",
		"丰甸草",
		"边境地",
		"流云郊",
		"绝景谷",
		"快步长廊",
		"漂泊者之赐",
		"谷郊",
		"坎坷原",
		"绿褶谷",
		"山民野",
		"锥麦野",
		"浅石滩",
		"泾渭原",
		"封王磨",
		"参差垄",
		"绿谷",
		"碧褶谷",
		"温墩",
		"绿泽",
		"麋鹿角",
		"旧界",
		"新陲",
		"丽日长廊",
		"中央标地",
		"大草原",
		"覆苔谷",
		"广亩",
		"南花绽",
		"黎明之地",
		"橡木甸",
		"南风田",
		"草甸湾",
		"摆柳野",
		"广览甸",
		"夜莺谷",
		"银艾原",
		"心歌长廊"
	],
	[
		"黑沼",
		"死水塘",
		"沥青场",
		"泥炭地",
		"闷息沼",
		"诡异泽",
		"漆黑潭",
		"黏人塘",
		"可怖潭",
		"阴暗沼",
		"冒泡塘",
		"黑鬼没",
		"绞窒泽",
		"泥粪坑",
		"猎犬沼",
		"船息沼",
		"诅咒之地",
		"无情淖",
		"大芦荡",
		"蛤蟆城",
		"蜘蛛林",
		"公爵没",
		"无底坑",
		"毒息沼",
		"吮蛙林",
		"沉尸底",
		"大湿地",
		"大泽",
		"黑泥潭",
		"荒凉泽",
		"黑烟圩",
		"无边圩",
		"泥炭淖",
		"流草涂",
		"南国腹地",
		"蔚蓝沼",
		"千镜迷沼",
		"逼仄潭",
		"腐草地",
		"灰湿地",
		"野沼",
		"絮语潭",
		"避忌泊",
		"骇人泊"
	],
	[
		"累骨丘",
		"战斧丘",
		"颅息冈",
		"古丘",
		"老关山",
		"绵延丘",
		"褶丘",
		"古石冢",
		"嗡鸣冈",
		"锐岩坡",
		"雾隐丘",
		"巨石丘",
		"石砾丘",
		"万泉冈",
		"鬼丘",
		"女妖丘",
		"卵石丘",
		"望乡陵",
		"巨人石",
		"掩蛇山",
		"滚颅冈",
		"锈洞山",
		"女巫山",
		"杜松丘",
		"白羊丘",
		"裸岩",
		"远望陵",
		"耳语丘",
		"铜陵",
		"逢柳坡",
		"猩红丘",
		"巨人坡",
		"阴郁陵",
		"崩丘"
	],
	[
		"荒凉林",
		"骇然林",
		"忧郁林",
		"暮色昏林",
		"贼窝林",
		"野猪林",
		"黑窝",
		"枝条谷",
		"蜘蛛林",
		"扁虱灌木",
		"德鲁伊之林",
		"脆枝林",
		"白狼栖",
		"栖鸦林",
		"针林",
		"沙声灌",
		"松苔林",
		"鸦巢林",
		"暗林",
		"绰影林",
		"阴郁森",
		"野狼森",
		"黑树林",
		"低语丛林",
		"荆棘暗野",
		"刺猬灌",
		"雾隐迷地",
		"边谷",
		"神庙林",
		"惨号林",
		"长老森",
		"蔽目深林",
		"寒皋林",
		"女巫森"
	],
	[],
	[
		"古林",
		"巡林客之歇",
		"鹿谷",
		"老林",
		"放浪林",
		"铁橡林",
		"猎人林",
		"王狩地",
		"葱郁林",
		"兔狐林",
		"折枝林",
		"匿鹿林",
		"长老林",
		"绿木森",
		"青苔林",
		"雾隐森",
		"树海",
		"材林",
		"耳语林",
		"硕兔林",
		"栗木林",
		"隐蛇盖",
		"黑木林",
		"风暴林",
		"沙声灌",
		"邪气林",
		"灰蟾林",
		"攀猿林",
		"参差林",
		"雄鹿领",
		"橡盖林",
		"忍冬林",
		"榆树林",
		"黑鼹林",
		"溪木林",
		"常春林",
		"亘古林"
	],
	[
		"红虫林",
		"热火林",
		"阴燃林",
		"烬余林",
		"生境林",
		"狐巢森",
		"夏色林",
		"火枫林",
		"血痕丛",
		"火过林",
		"锈滴林",
		"血色林",
		"炽燃森",
		"朱红林",
		"赤红林",
		"褐红林",
		"红林",
		"隐獾林",
		"桦材林",
		"水木森",
		"篝火林",
		"红根野",
		"沼木林",
		"黄叶长廊",
		"溅血林",
		"红皮林",
		"火石林"
	],
	[
		"世界之脊",
		"眠巨人之背",
		"锯齿峰群",
		"诸神之墙",
		"却步岩",
		"岩脊",
		"错落峰",
		"银脊岭",
		"雾隐峰",
		"铁山",
		"羊角峰",
		"龙牙顶",
		"弥高仰",
		"鹰翔岭",
		"峻顶",
		"褐刺峰",
		"却步角",
		"鸦喙峰",
		"两割山",
		"磐岩之障",
		"叠山尖",
		"眉坡",
		"陨英峰",
		"垭口",
		"巨象肩",
		"突矛顶",
		"秃山冠",
		"攀云顶",
		"永雾山",
		"戮山",
		"大裂谷",
		"雷鸣峰",
		"败落顶",
		"斑斓顶",
		"无人顶",
		"大崛",
		"照月峰",
		"灰巅",
		"裸峰",
		"落影山",
		"灰岩峰",
		"硫磺峦",
		"铁峰"
	],
	[],
	[],
	[
		"白色荒原",
		"冰封原",
		"雪海",
		"白色荒野",
		"白银原",
		"嚎风废土",
		"一片银",
		"永冬之地",
		"冰封北地",
		"天涯海角",
		"冰冷尽头",
		"深冬原",
		"冰陲",
		"刺骨风原",
		"冰刃谷",
		"银沙积",
		"霜褶原",
		"冰石林",
		"冰封洞",
		"极光滩",
		"没指霜",
		"永冻原",
		"苍白漫",
		"明镜漠",
		"鬼号原",
		"寒风原",
		"琉璃谷",
		"呼风漠",
		"雪末原",
		"雪洲"
	],
	[],
	[
		"北陲",
		"秃桌原",
		"荒崎地",
		"北郊",
		"稀树裸土",
		"先祖高原",
		"通天径",
		"氏族领地",
		"崎岖原",
		"北族地",
		"至北之地",
		"荒原",
		"贫瘠之地",
		"拉格纳长廊",
		"异教荒原",
		"褶波原",
		"风袭之地",
		"环回坳",
		"悲河",
		"荒凉丘",
		"北地",
		"绿原丘",
		"咸水丘",
		"族人泊",
		"北地之刺",
		"北围",
		"大河原",
		"凄贫埆"
	],
	[
		"木棘野",
		"旱原",
		"焦原",
		"红衍",
		"火灼郊",
		"烁金谷",
		"南部草原",
		"南陲",
		"灼原",
		"白骨谷",
		"旱郊",
		"日熙原",
		"大荒原",
		"荆棘谷",
		"铜青滩",
		"恶栖",
		"燥郊",
		"小河栖",
		"刺棘丛",
		"树瘿地",
		"砾岩地",
		"丰裕原",
		"丰裕地",
		"日头原",
		"锈刃台",
		"麝香滩",
		"日头岩",
		"南望地",
		"日抚原",
		"沙削地",
		"疏林原",
		"背篓原",
		"豚鼠野",
		"新垦",
		"无主之地"
	],
	[],
	[
		"银沙",
		"死亡沙地",
		"一片金",
		"永恒沙地",
		"荧荧沙",
		"灼漠",
		"空无之地",
		"燃火砾",
		"南漠",
		"尘飞漠",
		"沙海",
		"太阳之国",
		"大沙漠",
		"无垠金沙",
		"南至地",
		"呢喃漠",
		"细语沙",
		"流沙",
		"嚎沙",
		"粼光滩",
		"灿光滩",
		"干燥废土"
	],
	[
		"失落的绿洲",
		"绿色浅滩",
		"翡翠盆地",
		"南地明珠",
		"丰美滩",
		"生命之泉",
		"上帝的礼物",
		"先知的救赎",
		"大湿地"
	]
];
gt.Const.Strings.Distance <- [
	"[color=#00ff00]较近[/color]",
	"[color=#00ff00]不远[/color]",
	"[color=#00ff00]稍远[/color]",
	"[color=#00ff00]远[/color]",
	"[color=#00ff00]很远[/color]",
	"[color=#00ff00]非常远[/color]"
];
gt.Const.Strings.PartyStrength <- [
	"弱小的",
	"虚弱的",
	"一般",
	"强的",
	"危险的",
	"致命",
	"无敌"
];
gt.Const.Strings.EngageEnemyNumbers <- [
	"几个(2-3)",
	"一些(4-6)",
	"许多(7-10)",
	"很多(11-13)",
	"大量(14以上)"
];
gt.Const.Strings.InventoryHeader <- [
	"驴",
	"马车",
	"货车",
	"大货车"
];
gt.Const.Strings.InventoryUpgradeHeader <- [
	"购置马车",
	"购置货车",
	"购置大货车"
];
gt.Const.Strings.InventoryUpgradeText <- [
	"购置马车",
	"购置货车",
	"购置大货车"
];
gt.Const.Strings.InventoryUpgradeCosts <- [
	"5,000",
	"10,000",
	"20,000"
];
gt.Const.Strings.PerkName <- {
	Bullseye = "神射",
	Ballistics = "弹道学",
	Berserk = "狂暴",
	DevastatingStrikes = "毁灭打击",
	KillingFrenzy = "杀戮",
	ShieldBash = "盾击",
	Brawny = "强壮",
	Stalwart = "坚实",
	Taunt = "嘲讽",
	Steadfast = "坚定不移",
	Colossus = "巨像",
	ShieldExpert = "盾牌专家",
	NineLives = "九命猫",
	BatteringRam = "攻城锤",
	BattleForged = "战斗锻造",
	BagsAndBelts = "包和腰带",
	Student = "学生",
	Zweihander = "双手剑士",
	Pathfinder = "探路者",
	FortifiedMind = "坚定意志",
	Captain = "getroottable",
	InspiringPresence = "鼓舞人心的存在",
	QuickHands = "快手",
	CripplingStrikes = "致残打击",
	Duelist = "决斗者",
	Nimble = "轻灵",
	Dodge = "闪避",
	HoldOut = "韧性",
	Anticipation = "预判",
	SteelBrow = "钢头",
	CoupDeGrace = "刽子手",
	Weaponmaster = "武器大师",
	FastAdaption = "快速适应",
	SunderingStrikes = "崩裂打击",
	BattleFlow = "战斗流程",
	HeadHunter = "猎头者",
	RallyTheTroops = "集结部队",
	Fearsome = "恐惧",
	Indomitable = "不屈",
	Debilitate = "衰弱",
	Footwork = "步法",
	Rotation = "换位",
	Underdog = "落单狗",
	Recover = "深呼吸",
	Gifted = "天才",
	Adrenaline = "肾上腺素",
	Backstabber = "背刺者",
	LoneWolf = "独狼",
	ReachAdvantage = "双手优势",
	Overwhelm = "压制",
	Relentless = "不懈",
	SpecBow = "弓精通",
	SpecCrossbow = "弩和火器精通",
	SpecThrowing = "投掷精通",
	SpecAxe = "斧精通",
	SpecCleaver = "砍刀精通",
	SpecDagger = "匕首精通",
	SpecSword = "剑精通",
	SpecSpear = "矛精通",
	SpecPolearm = "长柄精通",
	SpecHammer = "锤精通",
	SpecMace = "骨朵精通",
	SpecFlail = "链枷精通"
};
gt.Const.Strings.PerkDescription <- {
	Relentless = "不要慢下来! 在任何时候，你的主动值都只减少累积疲劳值的[color=" + this.Const.UI.Color.NegativeValue + "]50%[/color]，而不是全部的。此外，使用\'等待\'命令将不再使你在下一回合的主动值受到惩罚。",
	Rotation = "解锁“换位”技能，该技能允许两个角色在无视控制区域的情况下切换位置，只要两个角色都没有被击晕、定身或因其他方式失能。",
	Footwork = "解锁“步法”技能，使您可以通过熟练的步法离开控制区域而不会触发自由攻击。",
	Debilitate = "解锁 \'衰弱\' 技能，该技能可以使你的下一次攻击使目标瘫痪一回合，使其造成伤害的能力降低[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color].",
	Indomitable = "解锁 \'不屈\' 技能，该技能给予[color=" + this.Const.UI.Color.PositiveValue + "]50%[/color]的伤害减免，以及对昏迷、击退或勾拽的免疫，持续一回合。",
	RallyTheTroops = "解锁“集结”技能，可以集结逃跑的盟友，并提高附近所有盟友的士气到稳定的等级。使用技能的角色决心越高，成功的几率就越高。",
	Adrenaline = "解锁“肾上腺素”技能，让你在下一轮的回合顺序中处于首位，在你的敌人之前进行另一个回合。感受肾上腺素在你的血管中奔涌！",
	Fearsome = "让他们四散而逃! 任何对命中点造成至少1点伤害的攻击都会触发对手的士气检查，其惩罚等于[color=" + this.Const.UI.Color.NegativeValue + "]你的决心 * 20%[/color] - 10(这与无惩罚和仅在造成15点或以上伤害时进行士气检查不同)",
	HeadHunter = "攻击头部！击中目标的头部将使您在下一次攻击时也能保证击中头部。如果你的攻击命中了，这个效果会重置。",
	SunderingStrikes = "无论使用任何使用的武器，对盔甲的伤害均会增加[color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color]。",
	FastAdaption = "适应对手的动作！每次攻击未命中对手后，额外提高[color=" + this.Const.UI.Color.PositiveValue + "]10%[/color]的命中率。该增益可叠加，命中后重置。",
	Weaponmaster = "所有攻击的疲劳值消耗减少[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color]，并且武器损坏速度减半。用你的武器优雅地跳舞，让每一击都算数。",
	CoupDeGrace = "对受到创伤效果影响（例如手臂骨折）的目标造成[color=" + this.Const.UI.Color.PositiveValue + "]20%[/color]的额外伤害。",
	SteelBrow = "击中该角色头部不再造成暴击伤害，因此显著降低了受到严重头部创伤的风险。",
	Anticipation = "当被远程武器攻击时，攻击者每远离一格, 则获得[color=" + this.Const.UI.Color.PositiveValue + "] 1+ 10% 基础远程防御[/color]作为额外的远程防御，并且至少获得 [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color]点远程防御加成。",
	HoldOut = "挺住! 任何具有有限持续时间的负面状态效果（例如流血、魅惑）的持续时间都会减少到[color=" + this.Const.UI.Color.NegativeValue + "]1[/color]回合。那些效果在几个回合内逐渐减弱的状态效果（例如地精毒药）从一开始就处于最弱的状态。",
	Dodge = "快你一步！近战、远程防御增加角色当前主动值的[color=" + this.Const.UI.Color.PositiveValue + "]15%[/color]。",
	Nimble = "轻甲专精! 通过灵活地躲避或偏转打击来回避所有攻击。所受的伤害最多可以减少[color=" + this.Const.UI.Color.PositiveValue + "]60%[/color]，但在盔甲和头盔的最大疲劳值超过[color=" + this.Const.UI.Color.PositiveValue + "] 15 [/color]时会技能效果会大幅下降。你的盔甲和头盔越轻，你就越受益。\n\n\'强壮\'不影响该特性。\n\n不影响精神攻击和状态效果的伤害, 但是可以帮助避免受到它们",
	BattleForged = "重甲专精! 受到的护甲伤害会减少，减少的百分比等于盔甲和头盔当前总护甲值之和的[color=" + this.Const.UI.Color.PositiveValue + "]5%[/color]。你的盔甲和头盔越重，你的好处就越多。\n\n不影响精神攻击或状态效果的伤害，但可以帮助避免收到它们。",
	Duelist = "与你的武器融为一体，去攻击弱点! 如果副手未持有武器或者携带着可投掷的工具(如投掷网), 则可额外造成 [color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] 忽略护甲的伤害。不适用于双手武器。",
	CripplingStrikes = "致残你的敌人！近战、远程攻击造成创伤的阈值降低[color=" + this.Const.UI.Color.NegativeValue + "]33%[/color]。",
	QuickHands = "在找这个吗？在战斗中每回合第一次交换除盾牌以外的任何物品成为一个免费动作，不需要行动点数。",
	Bullseye = "射得好! 当瞄准的目标没有被清空的弹道路线（即目标被遮挡）时，受到的命中惩罚从[color=" + this.Const.UI.Color.NegativeValue + "]75%[/color]减少到[color=" + this.Const.UI.Color.NegativeValue + "]50%[/color]。",
	Ballistics = "命中率的距离惩罚每格减少[color=" + this.Const.UI.Color.NegativeValue + "]-1[/color]",
	Berserk = "哇！ 每回合第一次击杀立即恢复 [color=" + this.Const.UI.Color.PositiveValue + "]4[/color] 行动点数。 角色恢复的行动点数不能超过其最大行动点数，一次攻击击杀多名敌人也只恢复 4 行动点数",
	BattleFlow = "每回合第一次击杀会使恢复 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] 的基础最大疲劳（即在应用护甲惩罚之前的疲劳值）。",
	DevastatingStrikes = "所有武器造成的所有伤害都会增加 [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color]。 现在还有什么可以拦着你？",
	KillingFrenzy = "进入杀戮时刻！ 每次击杀后会获得增加所有伤害 [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color]的加成，持续 2 回合。再次击杀不叠加，但会刷新计时器。",
	ShieldBash = "撞退技能额外造成 [color=" + this.Const.UI.Color.DamageValue + "]10 ~ 25[/color] 点伤害（对护甲只造成 50%）和 [color=" + this.Const.UI.Color.DamageValue + "]10[/color] 点疲劳值。同时, 撞退技能的疲劳值消耗减少 10",
	Brawny = "穿着盔甲和头盔的疲劳和主动值惩罚降低[color=" + this.Const.UI.Color.NegativeValue + "]30%[/color].",
	Stalwart = "免疫位移技能。适用于诸如击退、勾拽和其他改变角色位置的技能。",
	Steadfast = "被常规攻击击中不会再导致疲劳值积累。专门针对疲劳值的攻击不受影响。",
	Taunt = "解锁“嘲讽”技能，使目标对手采取进攻行动而不是防御行动，并攻击嘲讽角色而不是另一个可能更脆弱的角色。",
	Colossus = "放马过来！生命值提高[color=" + this.Const.UI.Color.PositiveValue + "]25%[/color]，因此降低了被击中时受到严重创伤的几率。",
	ShieldExpert = "学会更好地将攻击偏向一边而不是正面阻挡。\n\n盾牌防御增加 [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color], 这也适用于盾墙技能的额外防御加成。\n\n盾牌受到的伤害减少 [color=" + this.Const.UI.Color.NegativeValue + "]50%[/color], 但至少为 1。\n\n “撞退”技能命中率提高 [color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color]。",
	NineLives = "每场战斗限一次，遭受致命伤害时，你会以少量的生命值存活下来，并治愈所有的持续伤害效果（例如流血、中毒）。当然，下一击很可能置你于死地，但直到你的下个回合，提升的防御属性会助你挺过难关。",
	BatteringRam = "免疫昏迷。",
	BagsAndBelts = "解锁两个额外的包槽以携带所有您喜爱的物品。放在袋子里的物品不再对最大疲劳值造成惩罚，除了双手武器。",
	Student = "世上无难事，只怕有心人。在战斗中获得[color=" + this.Const.UI.Color.PositiveValue + "]20%[/color]的额外经验。你的角色等级到十一级时，该特技失效并获得一个额外特技点。\n\n游玩“猎奴者”起源，你的负债者会在角色等级到七级时返还特技点。",
	Gifted = "当你天生就有天赋时，雇佣兵的生活会变得很容易。立即升级以增加此角色的属性，数值为最大掷骰数，但没有天赋加成。",
	Zweihander = "所有双手武器技能的疲劳值消耗降低 [color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color].",
	Pathfinder = "学会在复杂地形上移动。 所有地形上的移动行动点消耗减少 [color=" + this.Const.UI.Color.NegativeValue + "]1[/color](但每个单元格至少需要 2 个行动点)，疲劳值消耗减少到一半。 改变高度也不再需要消耗额外的行动点。",
	FortifiedMind = "钢铁般的意志不会轻易偏离正道。决心提高[color=" + this.Const.UI.Color.PositiveValue + "]25%[/color].",
	Captain = "领导战场上的战士, 让每个人都保持斗志。 5 格范围内的盟友将获得该角色的 [color=" + this.Const.UI.Color.PositiveValue + "]15%[/color] 的决心加成，但加成后的最大值不会超过这个角色的决心。\n\n不叠加, 范围内有多个角色具有该特权时, 取最大决心值。",
	InspiringPresence = "一个伟大的领袖会激励他的追随者去克服他们的极限。除非性格特征禁止，否则盟友会以自信士气开始每场战斗。",
	Underdog = "我已经习惯了。由于被对手包围而导致的围攻效果不再适用于该角色。如果攻击者拥有背刺特技，则该特技的效果失效，但由于被包围而导致的正常围攻效果将生效。",
	Recover = "解锁 \'恢复\' 技能，允许角色休息一回合，以减少累积疲劳值的[color=" + this.Const.UI.Color.NegativeValue + "]50%[/color].",
	Backstabber = "荣誉并不能为你赢得战斗，刺中敌人的痛处才是。在近战中，每有一个盟友围绕着你的目标并分散其注意力，你的命中率就会增加[color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] 。",
	LoneWolf = "我最好单独行动。如果在3格范围内没有盟友，获得[color=" + this.Const.UI.Color.PositiveValue + "]15%[/color]的近战技能、远程技能、近战防御、远程防御和决心的加成。",
	ReachAdvantage = "学会使用大型武器的超远射程在防止敌人近身的同时打击敌人。\n\n每一次使用双手近战武器攻击都会使你的近战防御增加[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color]，最多叠加5次，效果持续到这个角色的下一个回合。一次攻击命中多个目标可以叠加多次, 但如果你收起你的武器，将会失去该加成。",
	Overwhelm = "学会利用你的高主动，通过用你的攻击压制敌人来阻止敌人有效的攻击！每一次攻击，不管是命中还是未命中，对当前回合中在你之后行动的对手，都会造成\'压倒\'的状态效果，使近战技能和远程技能都降低 [color=" + this.Const.UI.Color.NegativeValue + "]10%[/color]。该效果在每次攻击中都会叠加，并且可以通过一次攻击同时作用于多个目标。",
	SpecBow = "精通射箭，百步穿杨。弓技能积累的疲劳值减少 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color]\n\n视野和使用弓的最大射程增加 [color=" + this.Const.UI.Color.PositiveValue + "]+1[/color].",
	SpecCrossbow = "精通弩和火器，一发破的。弩和火器技能积累的疲劳值减少 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color]\n\n弩额外造成 [color=" + this.Const.UI.Color.PositiveValue + "]20%[/color] 的忽略护甲伤害。\n\n使用火铳的“重新装填”现在只消耗 [color=" + this.Const.UI.Color.NegativeValue + "]6[/color] AP，并且可以每回合而不是隔一回合开火。",
	SpecThrowing = "精通投掷，先下手为强。投掷技能积累的疲劳值减少 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color]\n\n攻击2格距离的目标时，伤害增加 [color=" + this.Const.UI.Color.PositiveValue + "]30%[/color]\n\n攻击3格距离的目标时，伤害增加 [color=" + this.Const.UI.Color.PositiveValue + "]20%[/color]。",
	SpecAxe = "精通斧头，摧毁盾牌。斧技能积累的疲劳值减少 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color]\n\n斧技能“裂盾”造成的盾牌伤害增加 [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color]\n\n“环劈”的命中率提高 [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color]\n\n使用长斧攻击近身敌人不再有命中率惩罚。",
	SpecCleaver = "精通砍刀，造成可怕的伤口。砍刀技能积累的疲劳值减少 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color]\n\n使用砍刀和鞭子造成的每回合流血伤害分别加倍至 [color=" + this.Const.UI.Color.PositiveValue + "]10[/color] 和 [color=" + this.Const.UI.Color.PositiveValue + "]20[/color]\n\n“缴械”的命中率惩罚减半。",
	SpecDagger = "精通匕首，迅捷而致命。匕首技能积累的疲劳值减少 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color]\n\n“刺击”、“穿刺”和“致命一击”消耗的AP降低，使每回合可以额外攻击一次。",
	SpecSword = "精通剑术，利用对手的失误把握优势。剑技能积累的疲劳值减少 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color]\n\n“还击”不再有命中率惩罚。\n\n“拖割”造成伤残的阈值降低 [color=" + this.Const.UI.Color.NegativeValue + "]50%[/color]\n\n剑技能“裂盾”和“挥斩”不再有命中率惩罚，并且命中率提高 [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color]",
	SpecSpear = "精通长矛，御敌于外。矛技能积累的疲劳值减少 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color]\n\n“矛墙”不再因敌人成功进入控制区域而立即失效。此外，“矛墙”仍可主动启用，并继续对其他试图进入控制区域的敌人进行免费攻击。\n\n使用三叉矛和战叉攻击近身敌人不再有命中率惩罚。",
	SpecPolearm = "精通长柄，御敌于外。长柄技能积累的疲劳值减少 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color]\n\n长柄武器技能消耗的AP降低至 [color=" + this.Const.UI.Color.NegativeValue + "]5[/color]，并且使用长柄武器攻击近身敌人不再有命中率惩罚。",
	SpecHammer = "精通锤子，对抗重甲对手。锤技能积累的疲劳值减少 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color]\n\n“摧毁盔甲”和“粉碎盔甲”造成的护甲伤害增加 [color=" + this.Const.UI.Color.PositiveValue + "]33%[/color]\n\n“震碎”的命中率提高 [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color]\n\n使用长锤攻击近身敌人不再有命中率惩罚。",
	SpecMace = "精通骨朵，不论护甲一通暴打。骨朵技能积累的疲劳值减少 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color]\n\n如果目标不免疫，“锤倒”、“撞倒”和“击倒”有 [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] 的几率使其昏迷。\n\n使用长棍攻击近身敌人不再有命中率惩罚。",
	SpecFlail = "精通链枷，绕过对手的盾牌。链枷技能积累的疲劳值减少 [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color]\n\n\'当头一击\'和\'劈头盖脸\'无视盾牌加成。\n\n\'重磅打击\'在击中头部时忽略[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] 护甲。\n\n\'狂舞挥打\'的命中率提高[color=" + this.Const.UI.Color.PositiveValue + "]5%[/color]"
};
gt.Const.Strings.Tooltip <- {
	World = {
		Hint_FocusParty = "点击聚焦队伍",
		Hint_FocusLocation = "点击聚焦位置"
	},
	Tactical = {
		Hint_FocusCharacter = "点击聚焦角色",
		Hint_CannotChangeItemInCombat = "无法在战斗中更改",
		Hint_OnlyActiveCharacterCanChangeItemsInCombat = "只有现在轮到的角色才能更换物品"
	}
};
