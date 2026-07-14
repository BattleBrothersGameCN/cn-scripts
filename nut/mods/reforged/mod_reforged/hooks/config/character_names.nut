::Const.Strings.RF_BansheeNames <- [
	"西比拉",
	"埃尔斯贝丝",
	"罗赫琳",
	"薇尔达",
	"格特伦",
	"布丽达",
	"玛尔加",
	"埃尔斯温",
	"希尔达",
	"芙蕾雅",
	"梅希蒂尔德",
	"布伦希尔德",
	"库尼贡德",
	"乌尔苏拉",
	"玛格丽特",
	"古德伦",
	"伊索尔德"
];
local more = [];

foreach( n in ::Const.Strings.RF_BansheeNames )
{
	more.push("夫人" + n);
	more.push("主母" + n);
	more.push("老" + n);
	more.push("女士" + n);
}

::Const.Strings.RF_BansheeNames.extend(more);
::Const.Strings.RF_BansheeTitles <- [
	"·无人哀悼者",
	"·毁宫之妇",
	"·断首者",
	"·空心者",
	"·无坟者",
	"·寡妇",
	"·哀悼者",
	"·挽歌之妇",
	"·尖啸主母",
	"·无爱者",
	"·无誓者",
	"·蒙纱者"
];
::Const.Strings.RF_VampireLordNames <- [
	"辛费尔",
	"杜拉德尔",
	"奥伯伦",
	"莱斯特",
	"伊卡博德",
	"莫塔斯",
	"德雷文",
	"德雷甘",
	"扎迪穆斯",
	"玛拉基",
	"达沃林",
	"拉斐尔",
	"梅尔基奥尔",
	"弗拉基米尔",
	"扎罗斯",
	"俄耳甫斯"
];
::Const.Strings.RF_VampireLordTitles <- [
	"·穿刺公",
	"·不朽者",
	"·永生者",
	"·血书",
	"·不死者",
	"·猩红",
	"·天灾",
	"·梦魇",
	"·恐惧化身",
	"·魔鬼",
	"·恶鬼",
	"·恶魔",
	"·施虐者",
	"·恶煞"
];
::Const.Strings.RF_AncientDeadCommanderTitles <- [
	"·死而复生",
	"·回魂者",
	"·古人",
	"·毁灭者",
	"·使者",
	"·破土者",
	"·荣光",
	"·护卫者",
	"·荣耀",
	"·受宠者"
];
::Const.Strings.RF_ManAtArmsTitles <- [
	"%factionname%之牛",
	"%factionname%之盾",
	"%factionname%之剑",
	"%factionname%之锤",
	"%factionname%之雄",
	"·屠夫",
	"·公牛",
	"·熊",
	"·众人之傲",
	"·英雄",
	"·勇者",
	"·执钢者",
	"·兽人杀手",
	"the Greenskins\' Bane",
	"·十字军",
	"·不灭者",
	"·苦痛之刃",
	"苦涩之刃",
	"·雄狮",
	"·勇者",
	"·寒光之刃",
	"·主宰",
	"·守誓者",
	"·不败者",
	"·铁裔"
];
::Const.Strings.RF_FencerTitles <- [
	"·众人之傲",
	"·英雄",
	"·勇者",
	"·屠夫",
	"·执钢者",
	"%factionname%之剑",
	"%factionname%之雄",
	"·众人之傲",
	"·苦痛之刃",
	"苦涩之刃",
	"·狼",
	"·勇者",
	"·寒光之刃",
	"·快人一步",
	"迅刃",
	"·棘刺",
	"·穿心者",
	"·刺钎",
	"长刀",
	"·守誓者",
	"·猎鹰",
	"·秃鹰",
	"·老鹰",
	"%factionname%之刃",
	"·鸣刃"
];
::Const.Strings.RF_ZweihanderTitles <- [
	"·屠夫",
	"·公牛",
	"·熊",
	"%factionname%之牛",
	"·众人之傲",
	"·英雄",
	"·勇者",
	"·屠夫",
	"·执钢者",
	"%factionname%之盾",
	"%factionname%之剑",
	"%factionname%之雄",
	"·众人之傲",
	"·兽人杀手",
	"绿皮之灾祸",
	"·十字军",
	"·不败者",
	"·苦痛之刃",
	"苦涩之刃",
	"·雄狮",
	"·勇者",
	"·寒光之刃",
	"·主宰",
	"·守誓者",
	"·鸣刃",
	"·旋风",
	"·暴风雨",
	"寒铁",
	"·铁裔"
];
::Const.Strings.RF_DraugrNames <- [
	"斯卡恩",
	"赫罗德",
	"瓦尔",
	"凯尔德",
	"拉斯克",
	"乌尔德",
	"斯雷格",
	"莫恩",
	"格里特",
	"雅恩",
	"瓦尔克",
	"胡斯克",
	"德伦格",
	"奥姆",
	"鲁恩",
	"凯尔",
	"菲奥尔",
	"斯滕",
	"于尔",
	"克罗斯",
	"赫里姆尔",
	"巴尔",
	"斯凯尔德",
	"沃尔",
	"达格伦",
	"卡恩",
	"乌尔特",
	"雷斯",
	"布兰恩",
	"戈尔"
];
::Const.Strings.RF_DraugrTitles <- [
	"·冢缚者",
	"·未焚者",
	"·山丘守望者",
	"·石誓者",
	"·末裔",
	"·冷眼者",
	"·石冢王",
	"·无言勇士",
	"·霜缚者",
	"·寒霜之握",
	"·墓穴领主",
	"·常醒者",
	"·古墓领主",
	"·骨冕",
	"·不眠者",
	"·墓缚者",
	"·血誓者",
	"·被铭记者",
	"·不息者",
	"·石血者"
];
::Const.Strings.CharacterNames.extend([
	"昂纳尔",
	"阿拉德",
	"阿拉里克",
	"阿尔贝特",
	"阿尔布特鲁斯",
	"阿尔德温",
	"安斯加尔",
	"巴杜尔夫",
	"巴尔达里希",
	"巴尔多",
	"巴尔多温",
	"鲍德温",
	"巴拉诺尔",
	"贝蒂洛",
	"比约恩",
	"布兰多",
	"布尔夏德",
	"卡罗勒斯",
	"岑里克",
	"康拉德",
	"达格芬",
	"邓斯坦",
	"埃克哈特",
	"埃德加",
	"埃吉诺",
	"埃洛夫",
	"埃梅尔里希",
	"埃斯维希",
	"法拉蒙德",
	"法瓦尔德",
	"菲利贝尔特",
	"弗朗科",
	"弗里杜赫尔姆",
	"高弗里德",
	"高特温",
	"格尔博尔德",
	"吉尔伯特",
	"吉塞尔伯特",
	"吉斯蒙德",
	"吉斯蒙德",
	"格里姆",
	"哈杜伯特",
	"哈加诺",
	"哈罗德",
	"哈特温",
	"海德里希",
	"赫尔姆弗里德",
	"赫尔莫",
	"赫尔穆特",
	"赫尔曼",
	"库诺",
	"兰贝特",
	"兰杜尔夫",
	"兰佐",
	"莱昂弗里克",
	"莱昂纳德",
	"卢达加尔",
	"卢塔尔",
	"卢特温",
	"曼诺",
	"梅诺",
	"迈因拉德",
	"米洛",
	"诺贝特",
	"奥多",
	"奥尔维尔",
	"奥斯温",
	"丕平",
	"兰杜尔夫",
	"雷根",
	"莱纳德",
	"莱因哈德",
	"里夏德",
	"罗兰",
	"西吉玛",
	"希尔万",
	"希尔万",
	"斯文",
	"特奥",
	"特奥达尔",
	"蒂莫",
	"瓦尔德马尔",
	"韦雷蒙德",
	"瓦尔多",
	"瓦尔多马尔",
	"瓦尔特",
	"维达尔",
	"维多",
	"维甘德",
	"维哈特",
	"威尔弗雷德",
	"沃尔夫哈特",
	"乌尔弗里克"
]);
::Const.Strings.SwordmasterTitles.extend([
	"·捷豹",
	"·剑痴",
	"·剑贤",
	"·决斗者",
	"·旋风",
	"·铁雨",
	"·铁舞"
]);
::Const.Strings.CharacterNames = ::MSU.Array.uniques(::Const.Strings.CharacterNames);

foreach( characterName in ::Const.Strings.CharacterNames )
{
	::Const.Strings.KnightNames.push("爵士" + characterName);
}

::Const.Strings.KnightNames = ::MSU.Array.uniques(::Const.Strings.KnightNames);
::Const.Strings.RF_KnightAnointedNames <- ::Const.Strings.KnightNames.map(function ( name )
{
	return ::String.replace(name, "Sir", "Lord");
});
::MSU.Array.removeByValue(::Const.Strings.BanditLeaderNames, "强盗男爵");
::MSU.Array.removeByValue(::Const.Strings.SwordmasterTitles, "·剑客");
::MSU.Array.removeByValue(::Const.Strings.SwordmasterTitles, "刀锋舞者");
::Const.Strings.SouthernNames.extend([
	"阿迪勒",
	"阿基勒",
	"阿克拉姆",
	"阿明",
	"安瓦尔",
	"阿西姆",
	"巴德尔",
	"巴希尔",
	"法哈德",
	"费萨尔",
	"法里德",
	"加桑",
	"哈比卜",
	"哈迪",
	"哈基姆",
	"哈里斯",
	"伊德里斯",
	"伊桑",
	"伊马德",
	"伊姆兰",
	"伊斯哈格",
	"贾法尔",
	"贾迈勒",
	"吉布里勒",
	"卡里姆",
	"哈立德",
	"哈里勒",
	"拉提夫",
	"莱斯",
	"马赫迪",
	"马希尔",
	"马尔万",
	"穆尼尔",
	"纳迪尔",
	"纳吉布",
	"纳吉",
	"纳瓦夫",
	"卡迪尔",
	"卡西姆",
	"凯斯",
	"拉菲克",
	"萨阿德",
	"萨夫万",
	"萨拉赫",
	"萨利姆",
	"萨米尔",
	"苏海勒",
	"塔利布",
	"塔比特",
	"瓦希德",
	"瓦卡斯",
	"亚西尔",
	"扎法尔",
	"宰德",
	"齐山",
	"齐亚德",
	"祖海尔",
	"扎希德",
	"祖拜尔"
]);
::Const.Strings.SouthernNames = ::MSU.Array.uniques(::Const.Strings.SouthernNames);

foreach( i, name in ::Const.Strings.SouthernNames )
{
	::Const.Strings.SouthernNamesLast.push("伊本·" + name);
	::Const.Strings.SouthernNamesLast.push("阿尔·" + name);
	::Const.Strings.SouthernOfficerTitles.push("阿尔·" + name);

	if (i % 3 == 0)
	{
		::Const.Strings.SouthernOfficerTitles.push("伊本·" + name);
	}

	if (i % 5 == 0)
	{
		::Const.Strings.SouthernOfficerTitles.push("阿尔·" + name + "·伊本·" + ::MSU.Array.rand(::Const.Strings.SouthernNames));
	}
}

::Const.Strings.SouthernNamesLast = ::MSU.Array.uniques(::Const.Strings.SouthernNamesLast);
::Const.Strings.SouthernOfficerTitles = ::MSU.Array.uniques(::Const.Strings.SouthernOfficerTitles);
