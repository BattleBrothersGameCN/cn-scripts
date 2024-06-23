local gt = this.getroottable();

if (!("World" in gt.Const))
{
	gt.Const.World <- {};
}

if (!("Location" in gt.Const.World))
{
	gt.Const.World.LocationNames <- {};
}

gt.Const.World.LocationNames.VillageWestern <- [
	"大草地",
	"麋鹿岬",
	"阴翳林",
	"古野",
	"湍流野",
	"大洪原",
	"颅骨野",
	"过风滩",
	"米纳肯",
	"硬河湾",
	"牧山甸",
	"小村滩",
	"掸子野",
	"石楠野",
	"蜿蜒原",
	"照日丘",
	"巨人野",
	"长延原",
	"汇流郊",
	"沐洗原",
	"岩洞野",
	"垦耕林",
	"参差原",
	"铁圃",
	"大圃地",
	"玛默角",
	"远攀莽",
	"石竹田",
	"隐士丘",
	"留居垦",
	"丽景丘",
	"铁石",
	"斑瑕丘",
	"矿锤坪",
	"帆扬野",
	"始坚丘",
	"丈度原",
	"河草滩",
	"芦苇丘",
	"水獭野",
	"小树海",
	"荆棘地"
];
gt.Const.World.LocationNames.CityWestern <- [
	"夜魔郊",
	"堡甸丘",
	"叠石原",
	"琐语丘",
	"榆树林",
	"荆生地",
	"铁灰岩",
	"坝郊"
];
gt.Const.World.LocationNames.GuardTower <- [
	"古老的哨塔",
	"哨塔",
	"风暴守卫之塔",
	"黑色守望之塔",
	"钢铁雄心之塔",
	"槲木之塔",
	"足峰守卫塔",
	"%randomname%的了望塔",
	"荒野哨塔",
	"石拳之塔",
	"守卫者塔楼",
	"海姆沃特哨塔",
	"古代哨塔",
	"兽人之灾哨塔"
];
gt.Const.World.LocationNames.Castle <- [
	"七峰堡",
	"克朗兰堡垒",
	"暴风堡垒",
	"伯兰堡垒",
	"海姆兰堡垒",
	"莫塔姆堡垒",
	"沃尔默堡垒",
	"号角堡",
	"瑞科马克堡垒",
	"斯塔克兰堡垒",
	"沃尔斯汀堡垒",
	"荆棘守卫堡垒",
	"克格伯堡垒"
];
gt.Const.World.LocationNames.BanditCamp <- [
	"漆黑要塞",
	"千矛营地",
	"绞刑要塞",
	"死者要塞",
	"黑色猎犬营地",
	"惊惧要塞",
	"暗影之刃营地",
	"寡妇制造者营地",
	"放逐者窝点",
	"匕首窝点",
	"谋杀者藏身地",
	"劫匪之巢",
	"无法者藏身地",
	"强盗之巢",
	"掳掠者营地",
	"抢劫者营地",
	"抢掠者营地",
	"开膛手窝点",
	"猩红剃刀营地",
	"赤红猎鹰窝点",
	"血狼府邸",
	"自由人营地",
	"血月窝点",
	"血斧营地",
	"掠袭者营地",
	"匕首尖峰藏身地",
	"青铜窝巢",
	"长匕洞穴",
	"失魂港湾",
	"放逐者藏身地",
	"土匪巢穴",
	"灰烬之颅藏身地",
	"锯齿刀锋驻扎地",
	"通缉犯退避所",
	"寒心藏身处",
	"落暮营地",
	"亚麻驻扎地",
	"被诅咒者退避所",
	"执法者的末日",
	"斩首者之巢",
	"杀人魔藏身处",
	"流浪汉营地",
	"刀锋兄弟会",
	"猩红掳掠者营地",
	"法外狂徒藏身地",
	"莽夫营地",
	"劫财者藏身地",
	"公路人的藏身处",
	"强盗之巢",
	"窃贼营地",
	"黑心窝点",
	"背叛者堡垒",
	"流放者窝点",
	"流放者的堡垒",
	"背刺者的巢穴",
	"割喉者藏身地",
	"黑杰克营地"
];
gt.Const.World.LocationNames.OrcCamp <- [
	"那拉盖什",
	"巴拉盖拉什",
	"巴拉卡拉吉姆",
	"巴拉马拉图克",
	"斯卡列巴图鲁姆",
	"奥加什莫拉特",
	"马洛克波洛特",
	"戈尔巴拉盖什",
	"鲁布洛克",
	"库拉斯托姆",
	"斯卡厘海尔登",
	"沃加什萨帕特",
	"巴拉斯卡拉波拉盖什",
	"奥巴拉克",
	"古尔加什戈尔",
	"沃加沙拉克",
	"鲁拉克巴拉特",
	"盖尔加什鲁塔克",
	"埃尔加什哈塔克",
	"哈加什噶尔",
	"沃加什波洛特",
	"莫拉特盖噶加什",
	"奥鲁特加什",
	"维克萨帕特",
	"瓦鲁克戈尔",
	"史卡斯尼克波洛特",
	"莫塔尔盖拉什",
	"沙贡维拉克",
	"沃加什哈塔克",
	"奥拉托什图鲁姆",
	"托尔波盖什",
	"托格哈特波洛克",
	"奥格沃加什",
	"古尔加拉什",
	"沃古尔波洛特",
	"格鲁什祖格布",
	"乌鲁克祖加",
	"古特波盖特",
	"古戈祖加尔",
	"达拉克戈尔",
	"波洛加库拉克",
	"扎扎鲁克",
	"伯磊克沃加什",
	"格奥鲁喀什",
	"乌鲁克赞加什",
	"布鲁卡特加什",
	"杜鲁克哈塔克"
];
gt.Const.World.LocationNames.GoblinBase <- [
	"尼克斯祖姆",
	"鲁特斯古伯",
	"菲尼斯索姆",
	"努尔沙杜斯",
	"吉罗斯古伯",
	"祖利姆巴斯",
	"索姆尼奥斯",
	"尼西斯卡多斯",
	"古伯祖加特",
	"那伽图斯",
	"拉伽尼斯",
	"沙纳拉斯",
	"诺斯奥斯",
	"西斯西斯西斯",
	"沙拉斯切奇",
	"祖罗斯切尔拉斯",
	"努尔沙拉斯",
	"哈拉兹诺斯",
	"祖格哈特索尔",
	"古比伯斯索姆",
	"维斯尼克祖姆",
	"索姆图斯",
	"格瑞斯尼克卡多斯",
	"祖加特那伽特",
	"诺兹克古伯",
	"辛赞托斯",
	"赞托斯索姆",
	"巴赞克诺斯",
	"祖塔克",
	"加达兹格拉特",
	"维尔德洛克祖姆",
	"赞塔克努尔",
	"维洛克卡祖尔",
	"那格兹诺克斯",
	"索尔卡祖姆"
];
gt.Const.World.LocationNames.Crypt <- [
	"疯王之墓",
	"被遗忘的墓穴",
	"贵族之墓",
	"山民之墓",
	"荒废的陵墓",
	"毁坏的墓穴",
	"隐秘的神殿",
	"%randomnoble%之墓",
	"死亡之门墓穴",
	"猎犬之陵墓",
	"贾菲戈之墓",
	"大先知之墓",
	"乌鸦之墓",
	"{大帝 | 厉君 | 暴君}%randomname%之墓",
	"先民之墓",
	"奥格玛之陵墓",
	"骸骨安息之处",
	"黑暗避难所",
	"最后的安息之地",
	"毁坏的神殿",
	"墓中之墓",
	"永恒之墓",
	"灰胡子之墓",
	"地狱之门陵墓",
	"绝望纪念碑",
	"空骨墓穴",
	"微笑颅骨之墓",
	"被亵渎的陵墓",
	"失落的陵墓",
	"破土而出的陵墓",
	"老国王之墓",
	"混乱陵寝",
	"苍白骸骨之墓",
	"祖先墓",
	"午夜墓穴",
	"先父之墓",
	"长老之墓",
	"守门人之墓",
	"嚎哭之墓",
	"呢喃之墓",
	"不得安息者之墓",
	"祖先之墓",
	"被诅咒的陵墓",
	"死者洞穴",
	"断骨停尸间",
	"无法安息的陵墓",
	"先王安息之地",
	"暗木陵寝",
	"荒芜的陵墓",
	"吱呀作响的陵墓",
	"被遗忘者的避难所",
	"冰冷的古坟"
];
gt.Const.World.LocationNames.MassGrave <- [
	"不归之墓",
	"最后的忠烈之墓",
	"海姆兰古战场",
	"万人坑",
	"拖骨泥潭",
	"开启的大墓地",
	"被惊扰的大墓地",
	"瘟疫坟墓",
	"古代埋骨地",
	"破土而出的墓穴",
	"堆骨之地",
	"腐朽的骸骨埋葬地",
	"古战场遗址",
	"白骨墓园",
	"被遗忘的大墓地",
	"冒险之终结",
	"最后的希望",
	"下陷的古战场",
	"%randomname%折戟之地",
	"露天大坟场",
	"挖开的骨头堆",
	"堆满尸骨的坟场",
	"简陋墓地",
	"白骨平原",
	"被毁灭的原野",
	"倾覆的大墓地",
	"被污染的古战场",
	"骸骨四散之地",
	"白骨动物园",
	"被诅咒的墓穴",
	"秃鹰的盛宴",
	"凋零的古战场",
	"末代君王终结之地",
	"被抢掠的战场",
	"骸骨堆成的小山",
	"骨架山",
	"骸骨之海"
];
gt.Const.World.LocationNames.VampireCoven <- [
	"红河庄园",
	"黑血集会处",
	"血光集会处",
	"旧主集会处",
	"古代存在之环",
	"凋亡者公爵的集会处",
	"不朽之环",
	"不死者集会处",
	"不朽者宅邸",
	"饥渴之屋",
	"午夜集会处",
	"古老统治者的陵墓",
	"古代集会处",
	"死灵学者城堡",
	"噩梦集会处",
	"血腥之环",
	"被诅咒者的厅堂",
	"黑色迷雾集会处",
	"不死者神殿",
	"黑夜子民神殿",
	"古代亡者的城堡",
	"被放逐者集会处",
	"不归者集会处",
	"无尽黑暗之环",
	"贪婪之满月",
	"食尸鬼渴望之地",
	"被遗忘者集会处",
	"噩梦宅邸",
	"伪装者集会处",
	"渴血者之家",
	"嗜血者藏身处",
	"不洁饥渴之墓",
	"飞行的亡者集会处",
	"深渊府邸",
	"黑色迷雾庄园",
	"逃避死亡者集会处",
	"不死者礼堂",
	"暮光军团之环",
	"被诅咒者的堡垒",
	"午夜之怖集会",
	"嗜血者的巢穴",
	"血族据点"
];
gt.Const.World.LocationNames.Ruins <- [
	"被烧毁的废墟",
	"崩毁的地基",
	"被遗忘的废墟",
	"摇摇欲坠的废墟",
	"被抛弃的城塞",
	"倒塌的民居",
	"废墟间的掩体",
	"被占领的废墟",
	"菲伦的废墟",
	"克根海姆废墟",
	"伯尔根的废墟",
	"倒塌的废墟",
	"被抛弃的堡垒",
	"倒塌的要塞",
	"古代遗迹",
	"风暴守卫之塔遗迹",
	"黑色守望之塔遗迹",
	"钢铁雄心之塔遗迹",
	"坚韧要塞的废墟",
	"%randomname%的了望塔",
	"石拳要塞遗址",
	"守护者城堡遗址",
	"海姆沃特要塞遗迹",
	"古代哨塔",
	"兽人之灾要塞的废墟",
	"倾斜的石屋",
	"毁坏的住宅",
	"被摧毁的要塞",
	"摇摇欲坠的防御工事",
	"被遗弃的废墟",
	"长满苔藓的废墟",
	"摇摇欲坠的掩体",
	"要塞遗迹",
	"被遗忘的要塞",
	"崩毁的要塞",
	"褪色废墟",
	"失落的要塞",
	"被抛弃的塔楼",
	"沉沦的废墟",
	"空荡荡的住宅",
	"坍塌的了望塔",
	"被夷为平地的堡垒",
	"古老遗迹",
	"翻倒的巨石",
	"坍塌的要塞",
	"沦陷的要塞",
	"支离破碎的堡垒",
	"倒塌的了望塔",
	"先祖的废墟",
	"被埋葬的住宅",
	"烂尾要塞"
];
gt.Const.World.LocationNames.BuriedCastle <- [
	"失落的宫殿",
	"被吞没的城堡",
	"沉沦的边疆总督府",
	"消逝的要塞",
	"被诅咒的城市",
	"%randomname%被掩埋的城堡",
	"被淹没的要塞",
	"被遗弃的城堡废墟",
	"黑色堡垒",
	"猩红城堡",
	"沉沦的要塞",
	"失落的王冠之城",
	"地底宫殿",
	"不洁宫殿",
	"地下避难所",
	"沉沦之王的要塞",
	"被埋葬的宫殿",
	"无光宫殿",
	"坟墓之城",
	"死亡之城",
	"失落之王的城堡",
	"亡者之城",
	"化为坟墓的都市",
	"沉沦的城市",
	"地底要塞",
	"无光堡垒",
	"地下堡垒",
	"不可触及之城",
	"沉沦的亡者之城",
	"被毁灭的城市",
	"被埋葬的城市",
	"地下宫殿",
	"地下宫殿",
	"被毁灭的失落城堡",
	"亡者摇篮",
	"呢喃的要塞",
	"沉没之城",
	"流亡要塞",
	"呢喃王子之城",
	"被埋没的城堡",
	"死亡要塞"
];
gt.Const.World.LocationNames.Hideout <- [
	"老%randomname%的小屋",
	"被遗忘的伐木工小屋",
	"护林人藏身处",
	"沉沦的小屋",
	"被遗忘的住宅",
	"被抛弃的避难所",
	"崩毁的住宅",
	"毁坏的农庄",
	"腐朽的小屋",
	"毁坏的小屋",
	"隐士小屋",
	"背刺者藏身处",
	"刀锋埋伏之处",
	"崩毁的藏身地",
	"贪婪之心的藏身处",
	"被抛弃的小屋",
	"倒塌的藏身处",
	"崩毁的伐木工小屋",
	"被放弃的避难所",
	"旅行者的休息处",
	"迷失之人的避难所",
	"摇摇欲坠的住宅",
	"被遗忘的小屋",
	"弃用农舍",
	"长满苔藓的避难所",
	"被遗忘的小屋",
	"破旧的小屋",
	"毁坏的住所",
	"失落的小屋",
	"被占领的小屋",
	"倒塌的小屋",
	"被修补过的住所",
	"伐木工的小棚屋",
	"破旧的棚屋",
	"毁坏的棚屋",
	"漏风的小屋",
	"脆弱的小屋",
	"腐朽的棚屋",
	"摇摇欲坠的农庄",
	"腐朽的避难所",
	"结构不稳的小屋",
	"简易庇护所",
	"偷猎者退避所",
	"猎人小屋",
	"摇摇欲坠的藏身处",
	"摇摇欲坠的避难所"
];
gt.Const.World.LocationNames.GreenskinCamp <- [
	"十象牙营地",
	"铁腕入侵者营地",
	"碎额者营地",
	"嗜血者营地",
	"腐朽把柄营地",
	"碎斧营地",
	"野猪颅骨营地",
	"黑森林掳掠者营地",
	"碎骨者营地",
	"切肉者营地",
	"糙斧营地",
	"开颅者营地",
	"怒号部落营地",
	"绿皮掠袭者营地",
	"食骨者营地",
	"猩红剃刀营地",
	"食人者营地",
	"火斧营地",
	"尖牙营地",
	"抢掠者基地",
	"掠袭者大本营",
	"野猪碎尸营地",
	"信使营地",
	"破墙者营地",
	"铁钳营地",
	"人类践踏者集结地",
	"十部落集结地",
	"野猪部落营地",
	"黑手部落集结地",
	"碎颅者驻扎地",
	"求战者营地",
	"猎肠者营地",
	"千牙营地"
];
gt.Const.World.LocationNames.GoblinCamp <- [
	"蓄奴者营地",
	"尖牙窝点",
	"串肉扦藏身处",
	"长矛窝点",
	"黑狼窝点",
	"尖耳藏匿处",
	"刀锋埋伏之处",
	"刃海藏匿处",
	"狼群营地",
	"被压迫者窝点",
	"绿皮灾祸营地",
	"尖刺营地",
	"伏击兵藏匿处",
	"锋刃营地",
	"箭雨营地",
	"偷袭者窝点",
	"议事营地",
	"背叛者的伏击",
	"嗤笑恶魔窝点",
	"神射手营地",
	"飞刀营地",
	"嗤笑死神营地",
	"酿毒者藏匿处",
	"残忍潜行者驻扎地",
	"阴影潜伏者营地",
	"刺客窝点",
	"议事集结地",
	"投毒者驻扎地",
	"蓄奴者大本营",
	"萨满的军营",
	"游侠的大本营"
];
gt.Const.World.LocationNames.NecromancerLair <- [
	"黑暗祭礼窝点",
	"亡灵巫师的隐藏集会所",
	"木偶大师退避所",
	"亡灵巫师藏匿处",
	"亡者洞窟",
	"被流放者窝点",
	"亡灵巢穴",
	"亡灵巫师避难所",
	"黑魔法圣殿",
	"亡灵巫师巢穴",
	"叛教者避难所",
	"异端藏匿处",
	"罪人窝点",
	"异教者隐秘之环",
	"卑鄙者退避所",
	"禁忌仪式窝点",
	"木偶大师圣殿",
	"被流放者藏匿处",
	"沉默者窝点",
	"疯狂大师的藏匿处",
	"亡灵巫师的退避所",
	"活死人居所",
	"黑暗力量之环",
	"邪教徒的隐秘大厅",
	"禁术圣殿",
	"黑魔法师退避所",
	"无名恐怖巢穴",
	"暗夜居所",
	"傀儡大师的储藏处",
	"被亵渎的神殿",
	"逆转死亡者藏匿处",
	"黑暗祭司教会",
	"不可名状之神殿",
	"叛教者退避所",
	"叛教者居所",
	"织魂者圣殿",
	"饥渴力量窝点",
	"疯狂的秘密密室",
	"收割者退避所",
	"复生者藏匿处",
	"手术家窝点"
];
gt.Const.World.LocationNames.Graveyard <- [
	"爆满的墓地",
	"偏远的墓地",
	"倾斜的墓地",
	"隐藏的墓地",
	"被抛弃的墓地",
	"古老的墓地",
	"古代墓地",
	"沉沦的墓地",
	"贫民墓地",
	"简陋墓地",
	"不得安息者的墓地",
	"吱吱作响的骸骨墓地",
	"被遗弃的墓地",
	"古代墓园",
	"被流放者墓地",
	"先祖墓地",
	"被遗弃的埋葬处",
	"破碎墓地",
	"倾覆的埋骨之地",
	"先祖的埋骨之地",
	"希望的最后休息",
	"先祖的墓地",
	"隐藏的埋葬处",
	"隐蔽的埋骨之地",
	"隐蔽墓地",
	"长满苔藓的坟墓",
	"被遗忘者的最后安息",
	"被遗弃的墓地",
	"祖先坟墓",
	"祖先的最后安息",
	"古老者墓地",
	"倾斜的墓园",
	"尖叫岩石墓地",
	"偏远的坟墓",
	"长老墓地",
	"天花受害者坟墓"
];
gt.Const.World.LocationNames.OrcCave <- [
	"尖嚎洞穴",
	"雷鸣部落藏匿处",
	"恶臭洞穴",
	"被占领的洞穴",
	"无人涉足的洞穴",
	"象牙窝点",
	"冰斧窝点",
	"血腥砍刀窝点",
	"锯牙藏匿处",
	"伊尔斯卡戈尔洞穴",
	"拷问者洞穴",
	"掠夺儿童者的洞穴",
	"黑色野猪窝点",
	"污秽洞穴",
	"碎骨者洞穴",
	"野猪洞穴",
	"绿皮窝点",
	"哀嚎洞穴",
	"抢掠者窝点",
	"食肉者洞穴",
	"颅骨碎裂者洞穴",
	"野人洞穴",
	"砍头者洞穴",
	"绿色死神洞穴",
	"格朗特洞穴",
	"兽人占据的洞穴",
	"食肉者之洞"
];
gt.Const.World.LocationNames.BarbarianShelter <- [
	"野蛮人营帐",
	"自由人藏匿处",
	"野蛮人毛皮营帐",
	"临时毛皮营帐",
	"战奴避难所",
	"部落营帐",
	"部落营地",
	"掠袭者营帐",
	"部落圆顶帐篷群",
	"自由民的圆顶帐篷群",
	"北境圆顶帐篷聚落",
	"北境营帐",
	"部落前哨",
	"部落先锋营地",
	"蛮族前哨站"
];
gt.Const.World.LocationNames.BarbarianCamp <- [
	"野蛮人大营",
	"部落大营",
	"掠夺者大本营",
	"掠袭者的圆顶帐篷群",
	"捕奴者休息处",
	"北境藏匿处",
	"临时野蛮人营地",
	"野蛮人藏匿处",
	"重兵驻守的野蛮人营地",
	"掠夺者的圆顶帐篷群",
	"宗族退避所",
	"先祖圆顶帐篷群",
	"奴隶贩子的营地"
];
gt.Const.World.LocationNames.BarbarianSanctuary <- [
	"冠军集结地",
	"古代之石",
	"野蛮人军营",
	"先祖的圆顶帐篷之城",
	"长老集合石",
	"祖先聚会",
	"野蛮人的权力之地",
	"部落勇士营地",
	"野蛮人祭祀场",
	"毛皮帐篷大营",
	"先祖营地",
	"祭祀神坛",
	"先祖祭坛",
	"加强版野蛮人小屋"
];
gt.Const.World.LocationNames.NomadTents <- [
	"游牧小屋",
	"沙漠帐篷",
	"游牧帐篷",
	"隐秘的帐篷",
	"游牧民藏身处",
	"稍纵即逝的营地",
	"飞行帐篷",
	"游牧者庇护所",
	"移动帐篷",
	"游牧营地",
	"自由者帐篷",
	"金色帐篷",
	"深红色帐篷",
	"炽热的庇护所",
	"流浪帐篷",
	"用沙子覆盖的帐篷"
];
gt.Const.World.LocationNames.HiddenCamp <- [
	"游牧民藏身处",
	"游牧者隐居地",
	"隐蔽营地",
	"游牧营地",
	"临时营地",
	"旅行者营地",
	"沙漠避难所",
	"岩石间的掩体",
	"沙漠掠袭者前哨站",
	"自由漫游者营地",
	"游牧退避所",
	"沙漠天灾营",
	"掠袭者避难所",
	"红沙营地",
	"烧沙营地",
	"白沙营地",
	"自由灵魂营地",
	"金日藏身处",
	"流沙藏身处",
	"沙漠掠袭者营地"
];
gt.Const.World.LocationNames.NomadTentCity <- [
	"游牧城市",
	"帐篷之城",
	"晨光营地",
	"沙漠勇士帐篷城",
	"游荡的城市",
	"烈日营地",
	"游牧仲裁院",
	"游荡的王国",
	"死亡绿洲营地",
	"金沙城"
];
gt.Const.World.LocationNames.AncientRuins <- [
	"帝国遗迹",
	"久远的遗迹",
	"沉没的废墟",
	"吞没的废墟",
	"满是灰尘的墙壁",
	"被沙土覆盖的遗迹",
	"沙化废墟",
	"漂白石头",
	"烧焦的废墟",
	"古代遗迹",
	"毁坏的帝国城墙",
	"古老遗迹",
	"覆沙废墟",
	"倾倒的砂石",
	"消失的石头",
	"古代残片",
	"吞噬定居点",
	"被掩埋的壁堆",
	"沙子下面的墙"
];
