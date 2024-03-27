local gt = this.getroottable();
gt.Const.FactionArchetypes <- [
	[
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Warmonger,
				this.Const.FactionTrait.ManOfThePeople
			],
			Description = "%noblehousename%家族以一个宗教团体为中心成立，教导他们对自己的同胞施以同情和关怀、面对敌人时狂热且无情。几代人以前，一次大规模的兽人入侵摧毁了家族的大部分家业，造成了直至今日仍未恢复的损失。从那时起，%noblehousename%家族开始了许多次圣战和惩罚性的远征，深入兽人的领土，但从未成功将这些绿皮真正一劳永逸地抹除。",
			Mottos = [
				"唯有美德堪称高贵",
				"捍卫受难之人",
				"热忱与荣耀",
				"愤怒中心存高贵",
				"让火焰净化一切",
				"战火铸就和平",
				"希望永存",
				"勇猛而光荣",
				"我们蔑视变卦和恐惧",
				"胜利在于真理",
				"黑暗中的光明",
				"齐心协力，众志成城"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Sheriff,
				this.Const.FactionTrait.ManOfThePeople
			],
			Description = "%noblehousename%家族秉持着公正和荣誉的高尚原则，毫无不合理的统治，他们的领地繁荣昌盛。虽然他们的声誉是温和的，但%noblehousename%的骑士久经沙场，他们的军队会凶猛打击任何威胁他们领土、手下和原则的人。许多贵族羡慕他们的财富、嘲笑他们的原则；%othernoblehouse%家族尤其对%noblehousename%家族持着或多或少的公开怨恨。",
			Mottos = [
				"为了更好地活着而活着",
				"友谊不容虚伪",
				"敢为智者",
				"勇者仁心",
				"予我以爱，必还之以花",
				"此掌为暴君之敌",
				"不要惹怒雄狮",
				"经年古树",
				"全心全意",
				"时刻警惕",
				"荣耀归于父辈",
				"美德与力量同行",
				"时刻做好准备",
				"兼济天下"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Sheriff,
				this.Const.FactionTrait.Collector
			],
			Description = "许多人都追求财富，但%noblehousename%家族的诚信商人们尤其懂得生财之道。与祖辈的名望深深绑定，他们坚持将诚实和正直作为他们的家庭价值观。",
			Mottos = [
				"理性乃人生的指南",
				"行动坚决，举止文雅",
				"让我们用行动说话",
				"奋斗不受批评阻",
				"乌云之后有晴天",
				"勇于面对困难",
				"勤奋乃富足之本"
			]
		}
	],
	[
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Warmonger,
				this.Const.FactionTrait.Tyrant
			],
			Description = "%noblehousename%家族是一支自豪而不屈的家族，有着悠久而血腥的征服家史。他们坐镇在自己%factionfortressname%的城堡中，用武力夺取自认为拥有的东西。他们与%othernoblehouse%家族之间的世仇使得两家人心头的怒火与冶炼的炉火从未熄灭。",
			Mottos = [
				"恃强自立",
				"征服忍耐者",
				"凶暴勇猛，理直气壮",
				"以家徽之名征服",
				"人死声名留",
				"绝不后退",
				"穿破箭雨，突破敌军",
				"勇猛与利刃无物可挡",
				"这是通往不朽的道路",
				"我们厉兵秣马",
				"苍鹭生而只为身居高位"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Warmonger,
				this.Const.FactionTrait.Marauder
			],
			Description = "因其残忍、暴虐和贪婪而备受鄙视，%noblehousename%家族很少与其他贵族家族交往。他们的将领和士兵以在他们的堡垒%factionfortressname%邻近袭击贸易商队、边远农场和小定居点而闻名。在%noblehousename%家族的领地上人命一文不值，许多为了赚快钱的雇佣兵在这里只能获得快速的死亡。",
			Mottos = [
				"万物终归于灰烬",
				"我们把它践踏在脚下",
				"为了我和我的人",
				"鹰不捉蝇",
				"行动胜于空谈",
				"诸神喂食乌鸦",
				"欲壑难填",
				"猎犬之子嗣于此猎食",
				"留下买路财"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Schemer,
				this.Const.FactionTrait.Tyrant
			],
			Description = "%noblehousename%家族广受憎恶，但更多的人畏惧他们。无数次大大小小的起义被烈火与长剑所镇压，%noblehousename%家族的爪牙据说充斥在每一个阴暗的角落与每一面墙背后。在他们祖传的%factionfortressname%要塞中到处都是武装警卫、警惕的战犬和规模庞大的雇佣兵团，以保护他们疑心病重的领导人。",
			Mottos = [
				"暗中之刃",
				"旧的不去，新的不来",
				"整装待发",
				"哨兵不眠",
				"武力维系和平",
				"清白如鸽",
				"目标坚定",
				"服从",
				"以法律与武力之名",
				"学会忍受必须承受的",
				"雄狮之怒，依然高贵"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Marauder,
				this.Const.FactionTrait.Tyrant
			],
			Description = "%noblehousename%以其奢华的生活方式和纵情享乐的派对而闻名。如此盛宴总得有人来为其买单，所以饿到半死不活的耕牛、空空荡荡的粮仓和绝望的镇民在%noblehousename%的治下是再正常不过的现象。尽管其他贵族都看不起这种残暴和奢侈无度，但他们同时也在渴望着被邀请参加下一次盛宴。",
			Mottos = [
				"不可征服",
				"流言蜚语止步",
				"一飞冲天",
				"凭良心而行",
				"我不屑一顾",
				"羊啊，你们只会长毛",
				"毫不手软",
				"富贵险中求",
				"谨记人固有一死"
			]
		}
	],
	[
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Schemer,
				this.Const.FactionTrait.Collector
			],
			Description = "俗话说商场如战场，而%noblehousename% 家族正是对讨价还价、锱铢必较的狡诈商法登峰造极的大师。据传言称，%noblehousename%所进行的许多利润丰厚的交易都不仅基于诚实的贸易，还包括贿赂、敲诈和欺骗。这个家族居住在%factionfortressname%华丽的地区首府中，尽管他们的财富不可估量，但他们的小气抠门也同样是出了名的。",
			Mottos = [
				"不留私心",
				"天佑勇者",
				"世界难以满足",
				"分辨诚实与有用",
				"我们的收获也会到来",
				"危难为我带来财富"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.ManOfThePeople,
				this.Const.FactionTrait.Collector
			],
			Description = "%noblehousename%家族宣称他们的渊源可以追溯到当人类首次宣称这片土地，以及第一位国王统治所有人的时代。尽管他们现在只是众多贵族家族之一，但他们引以为傲的悠久历史和不断书写历史的雄心壮志在如今仍旧存在。随着其声名和资源的日渐衰弱，据说他们正在资助各种探险活动，试图在沉没的城市和早已被遗忘的地方发掘失落已久的宝藏。",
			Mottos = [
				"精彩一生，胜似再世",
				"财富属于懂得利用它的人",
				"锁起来的东西是安全的",
				"一次即永恒",
				"审慎与衡量",
				"狂涛巨浪，能奈我何",
				"各占其份",
				"风帆与船桨",
				"敢为天下先"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Marauder,
				this.Const.FactionTrait.Schemer
			],
			Description = "绝大多数%noblehousename%家族的成员都隐居在厚厚的门和闩着的窗户后面，其中一些人多年来一直没有露面。有传言说他们高贵的血脉中流淌着疯狂与错乱的诅咒，但因为害怕他们的报复，平民中从来没有敢当众说出这样的话的。其他的贵族多数情况下都会避免与%noblehousename%家族进行接触，因为去他们那拜访的客人有可能会同时收到敞开的双臂与弩矢作为欢迎。",
			Mottos = [
				"生命中没有什么是永恒的",
				"预想终末",
				"我们不蔑视他人，我们亦无所畏惧",
				"不轻易评判",
				"世事无常",
				"各为其自",
				"变幻莫测",
				"保持警觉"
			]
		}
	]
];
gt.Const.CityStateArchetypes <- [
	{
		Traits = [
			this.Const.FactionTrait.OrientalCityState
		],
		Description = "一个富裕而独立的城邦，主要专注于贸易和获取更多财富。",
		Mottos = [
			"生活平和，生活幸福",
			"财富是我们的箭",
			"财富是我们的剑",
			"金塔立于远方",
			"礼物须有回赠",
			"有得有失"
		]
	},
	{
		Traits = [
			this.Const.FactionTrait.OrientalCityState
		],
		Description = "一个首要致力于获取知识的城邦 —— 即使这意味着要进行尸检、阅读禁书，或者与不属于这个世界的邪恶势力接触。",
		Mottos = [
			"敢为智者",
			"智慧征服命运",
			"阅读和学习",
			"智慧城堡",
			"终有所知"
		]
	},
	{
		Traits = [
			this.Const.FactionTrait.OrientalCityState
		],
		Description = "一个由无情的议会统治的城邦，他们会不择手段地获取权力。据传许多突然死亡事件都是由%citystatename%的维齐尔下令实施的暗杀。",
		Mottos = [
			"草丛中的蛇",
			"来自阴影",
			"不择手段",
			"鹰不捉蝇"
		]
	}
];
